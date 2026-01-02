import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/features/pos/presentation/pages/pos_print_page.dart';
import 'package:littlefish_merchant/features/sell/presentation/components/transaction_receipt_buttons.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund_item.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/billing/billing_helpers.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_email_receipt_page.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_sms_receipt_page.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/print_vm.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/checkout_receipt.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/ui/sales/pages/refund_email_receipt_page.dart';
import 'package:littlefish_merchant/ui/sales/pages/refund_sms_receipt_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CheckoutReceiptPage extends StatefulWidget {
  final dynamic transaction;
  final CheckoutTransaction? printTransaction;
  final bool isEmbedded;
  final bool isReprint;
  const CheckoutReceiptPage({
    Key? key,
    required this.transaction,
    this.printTransaction,
    this.isEmbedded = false,
    this.isReprint = false,
  }) : super(key: key);

  @override
  State<CheckoutReceiptPage> createState() => _CheckoutReceiptPageState();
}

class _CheckoutReceiptPageState extends State<CheckoutReceiptPage> {
  late String transactionType;
  late dynamic transaction;

  @override
  void initState() {
    super.initState();
    _determineTransactionType();
    transaction = widget.transaction;
  }

  void _determineTransactionType() {
    if (widget.transaction is CheckoutTransaction) {
      transactionType = 'Transaction';
    } else if (widget.transaction is Refund) {
      transactionType = 'Refund';
    } else {
      transactionType = 'unknown';
    }
  }

  bool _canPrint() {
    var testResult =
        (transaction is CheckoutTransaction && !transaction.isQuickRefund ||
            transaction is Refund) &&
        AppVariables.isPOSBuild;
    return testResult && AppVariables.hasPrinter;
  }

  bool _canEmail() {
    return transaction is CheckoutTransaction && !transaction.isQuickRefund ||
        transaction is Refund && transaction.customerMobile != null;
  }

  bool _canSms() {
    return transaction is CheckoutTransaction && !transaction.isQuickRefund ||
        transaction is Refund && transaction.customerMobile != null;
  }

  @override
  Widget build(BuildContext context) {
    return AppSimpleAppScaffold(
      title: '$transactionType Receipt',
      isEmbedded: widget.isEmbedded,
      body: CheckoutReceipt(
        transaction: widget.transaction,
        isReprint: widget.isReprint,
        onEvent: (value) {},
      ),
      footerActions: [_receiptButtons(context)],
    );
  }

  Widget _receiptButtons(BuildContext context) {
    return TransactionReceiptButtons(
      showPrintButton: _canPrint(),
      showEmailButton: _canEmail(),
      showSmsButton: _canSms(),
      onPrintTap: () async {
        _print(context);
      },
      onSmsTap: _canSms()
          ? () {
              _sms(context);
            }
          : () {
              showMessageDialog(
                context,
                'Cannot send receipt, no customer information available',
                MdiIcons.alertCircle,
              );
            },
      onEmailTap: _canEmail()
          ? () {
              _email(context);
            }
          : () {
              showMessageDialog(
                context,
                'Cannot send receipt, no customer information available',
                MdiIcons.alertCircle,
              );
            },
    );
  }

  Refund? _tryGetQuickRefund(CheckoutTransaction transaction) {
    if (!transaction.isQuickRefund) {
      return null;
    }
    var refund = transaction.refunds!.firstWhere(
      (refund) => refund.isQuickRefund,
    );
    refund.items?.add(_createQuickRefundItem(refund));
    return refund;
  }

  RefundItem _createQuickRefundItem(Refund refund) {
    return RefundItem(
      checkoutCartItemId: '',
      displayName: refund.description,
      quantity: 1,
      itemValue: refund.totalRefund,
    );
  }

  void _print(BuildContext context) {
    if (cardPaymentRegistered == CardPaymentRegistered.pos) {
      if (transaction is CheckoutTransaction) {
        if (transaction?.isQuickRefund ?? false) {
          transaction?.totalValue = transaction?.totalRefund;
          transaction?.amountTendered = transaction?.totalRefund;
        }

        var quickRefund = _tryGetQuickRefund(transaction!);
        showPopupDialog(
          context: context,
          content: PosPrintPage(
            transaction,
            quickRefund,
            isRefund: false,
            parentContext: context,
            isReprint: true,
          ),
        ).then((result) {});
      } else if (transaction is Refund) {
        showPopupDialog(
          context: context,
          content: PosPrintPage(
            widget.printTransaction,
            transaction,
            isRefund: true,
            parentContext: context,
            isReprint: true,
          ),
        ).then((result) {});
      }
    } else {
      final printVM = PrintVM.fromStore(StoreProvider.of<AppState>(context));
      printVM.setReceipt(transaction);
      printVM.debugPrint(context);
    }
  }

  void _sms(BuildContext context) {
    if (AppVariables.hasInternet) {
      if (isNotPremium(cleanString('sms_receipt'))) {
        showPopupDialog(
          defaultPadding: false,
          context: context,
          content: billingNavigationHelper(isModal: true),
        );
      } else {
        if (transaction is CheckoutTransaction) {
          showPopupDialog(
            height: 288,
            context: context,
            content: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CheckoutSMSReceiptPage(
                mobileNumber: transaction.customerMobile,
                customerName: transaction.customerName,
                transaction: transaction,
                isRefund: false,
              ),
            ),
          );
        } else if (transaction is Refund) {
          showPopupDialog(
            height: 288,
            context: context,
            content: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: RefundSMSReceiptPage(
                mobileNumber: transaction!.customerMobile,
                customerName: transaction!.customerName != null
                    ? '${transaction!.customerName}'
                    : 'Customer',
                refund: transaction,
              ),
            ),
          );
        }
      }
    } else {
      showMessageDialog(
        context,
        'Please go online to use this feature',
        MdiIcons.wifi,
      );
    }
  }

  void _email(BuildContext context) {
    if (AppVariables.hasInternet) {
      if (isNotPremium(cleanString('email_receipt'))) {
        showPopupDialog(
          defaultPadding: false,
          context: context,
          content: billingNavigationHelper(isModal: true),
        );
      } else {
        if (transaction is CheckoutTransaction) {
          showPopupDialog(
            height: 288,
            context: context,
            content: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: CheckoutEmailReceiptPage(
                emailAddress: transaction.customerEmail,
                customerName: transaction.customerName,
                transaction: transaction,
              ),
            ),
          );
        } else if (transaction is Refund) {
          showPopupDialog(
            height: 288,
            context: context,
            content: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: RefundEmailReceiptPage(
                emailAddress: transaction!.customerEmail,
                customerName: transaction!.customerName != null
                    ? '${transaction!.customerName}'
                    : 'Customer',
                refund: transaction,
              ),
            ),
          );
        }
      }
    } else {
      showMessageDialog(
        context,
        'Please go online to use this feature',
        MdiIcons.wifi,
      );
    }
  }
}
