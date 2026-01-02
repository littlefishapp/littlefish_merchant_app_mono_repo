// remove ignore_for_file: use_build_context_synchronously

// flutter imports
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core_utils/error/models/error_codes/transaction_error_codes.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_quick_action.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund.dart';

// project imports
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_actions.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_receipt_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/ui/sales/pages/void_payment_page.dart';
import 'package:littlefish_merchant/ui/sales/widgets/customer_summary_card.dart';
import 'package:littlefish_merchant/ui/sales/widgets/payment_summary_card.dart';
import 'package:littlefish_merchant/ui/sales/widgets/refund_summary_card.dart';
import 'package:littlefish_merchant/ui/sales/widgets/transaction_summary_card.dart';
import '../../../app/app.dart';
import '../../../environment/environment_config.dart';
import '../../../models/customers/customer.dart';
import '../../../redux/sales/sales_actions.dart';
import '../../../shared/constants/permission_name_constants.dart';
import '../../business/expenses/pages/refund_page.dart';
import '../../business/expenses/refund_utilities.dart';
import '../../../common/presentaion/components/app_progress_indicator.dart';
import '../view_models.dart';

class TransactionPage extends StatefulWidget {
  final dynamic transaction;

  final CheckoutTransaction? printTransaction;

  const TransactionPage({
    Key? key,
    required this.transaction,
    this.printTransaction,
  }) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  late final DateTime? dateUpdated;
  late final DateTime? dateCreated;
  late final String? status;
  late final String? transactionNumber;
  late final String? sellerName;
  late final String? paymentType;
  late final double? checkoutTotal;
  late final bool? isWithdrawal;
  late final double? withdrawalAmount;
  late final double? cashbackAmount;
  late final double? amountTendered;
  late final double? totalRefund;
  late final String? cardType;
  late final String? paymentStatus;
  late final int? batchNo;
  late final String? authResponse;
  late final String? authResponseCode;
  late final String? entry;
  late final String? traceID;
  late final String? terminalIdPOS;
  late final String? customerName;
  late final String? customerMobile;
  late final String? customerEmail;
  late final String? providerReferenceNumber;

  @override
  void initState() {
    super.initState();
    _mapTransactionData();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SalesVM>(
      converter: (store) => SalesVM.fromStore(store),
      builder: (ctx, vm) {
        return Container(
          constraints: const BoxConstraints.expand(height: 640, width: 480),
          child: AppSimpleAppScaffold(
            isEmbedded: EnvironmentProvider.instance.isLargeDisplay,
            body: vm.isLoading!
                ? const AppProgressIndicator()
                : layout(context, vm),
            title: widget.transaction is CheckoutTransaction
                ? widget.transaction!.pendingSync!
                      ? "Transaction ${TextFormatter.toShortDate(dateTime: widget.transaction!.dateCreated, format: "dd MMM")}"
                      : "Transaction #${widget.transaction!.transactionNumber?.floor() ?? ""}"
                : "Refund #${widget.transaction!.transactionNumber?.floor() ?? ""}",
            displayAppBar: true,
            footerActions: [bottomButtons(context, vm)],
          ),
        );
      },
    );
  }

  Widget layout(context, SalesVM vm) => SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TransactionSummaryCard(
            dateUpdated: dateUpdated,
            dateCreated: dateCreated,
            status: status ?? 'N/A',
            transactionNumber: transactionNumber ?? 'N/A',
            sellerName: sellerName ?? 'N/A',
            paymentType: paymentType ?? 'N/A',
            checkoutTotal: checkoutTotal ?? 0.0,
            isWithdrawal: isWithdrawal ?? false,
            withdrawalAmount: withdrawalAmount ?? 0.0,
            cashbackAmount: cashbackAmount ?? 0.0,
            amountTendered: amountTendered ?? 0.0,
            totalRefund: totalRefund ?? 0.0,
            providerReferenceNumber: providerReferenceNumber ?? 'N/A',
          ),
          PaymentSummaryCard(
            paymentType: paymentType ?? 'N/A',
            cardType: cardType,
            paymentStatus: paymentStatus ?? 'N/A',
            batchNo: batchNo,
            authResponse: authResponse,
            authResponseCode: authResponseCode,
            entry: entry,
            traceID: traceID,
            terminalIdPOS: terminalIdPOS,
          ),
          CustomerSummaryCard(
            customerEmail: customerEmail ?? 'N/A',
            customerMobile: customerMobile ?? 'N/A',
            customerName: customerName ?? 'N/A',
          ),
          if (widget.transaction is CheckoutTransaction)
            if ((widget.transaction as CheckoutTransaction).isRefunded)
              RefundSummaryCard(
                refunds: widget.transaction is CheckoutTransaction
                    ? widget.transaction!.refunds ?? []
                    : [],
                transaction: widget.transaction,
              ),
        ],
      ),
    ),
  );

  Widget bottomButtons(BuildContext context, SalesVM vm) {
    return Visibility(
      visible:
          !(widget.transaction!.deleted ?? false) &&
          (((widget.transaction is CheckoutTransaction) &&
                  !widget.transaction.isQuickRefund) ||
              (widget.transaction is Refund)),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ButtonQuickAction(
              icon: Icons.receipt,
              title: 'View Receipt',
              onTap: () {
                if (EnvironmentProvider.instance.isLargeDisplay!) {
                  showPopupDialog(
                    context: context,
                    content: CheckoutReceiptPage(
                      transaction: widget.transaction,
                      isEmbedded: true,
                      isReprint: true,
                    ),
                    width: MediaQuery.of(context).size.width / 2,
                  );
                } else {
                  Navigator.of(context).push(
                    CustomRoute(
                      builder: (ctx) => CheckoutReceiptPage(
                        transaction: widget.transaction,
                        printTransaction: (widget.transaction is Refund)
                            ? widget.printTransaction
                            : null,
                        isReprint: true,
                      ),
                    ),
                  );
                }
              },
            ),
            if (_isMakeRefundButtonEnabled())
              ButtonQuickAction(
                icon: Icons.currency_exchange_outlined,
                title: 'Refund Sale',
                onTap: () async {
                  if (!widget.transaction!.isFullyRefunded) {
                    await _handleRefundSale(context, vm);
                  } else {
                    showMessageDialog(
                      context,
                      'Transaction fully refunded.',
                      LittleFishIcons.warning,
                    );
                  }
                },
              ),
            // if (_isVoidsaleButtonEnabled()) ...[
            //   const SizedBox(width: 4),
            //   if (!(widget.transaction?.status == 'cancelled' ||
            //       widget.transaction?.status == 'refunded'))
            //     Expanded(
            //       child: SizedBox(
            //         height: _buttonHeight,
            //         child: ButtonSecondary(
            //           text: 'Void Sale',
            //           onTap: (c) async {
            //             var result =
            //                 await getIt<ModalService>().showActionModal(
            //               context: context,
            //               title: 'Void Sale',
            //               description:
            //                   'Are you sure you want to void this sale?'
            //                   'This action can not be undone.'
            //                   '\n\nThis action will return the products and remove any '
            //                   'recorded payments. You will still be able to see the '
            //                   'details of the sale once it has been voided. This '
            //                   'can not be undone.',
            //               acceptText: 'Void sale',
            //               cancelText: 'Do not void',
            //             );

            //             if (result ?? false) {
            //               await _handleSaleVoid(context, vm);
            //             }
            //           },
            //         ),
            //       ),
            //     ),
            // ],
          ],
        ),
      ),
    );
  }

  Future<void> _handleRefundSale(BuildContext context, SalesVM vm) async {
    try {
      if (widget.transaction is! CheckoutTransaction) return;
      vm.store!.dispatch(SetSalesLoadingStateAction(true));

      if (widget.transaction == null) return;

      final itemInfoList = await fetchAllData(
        store: vm.store!,
        transaction: widget.transaction!,
      );

      // initialise new refund object
      vm.store?.dispatch(
        initialiseCurrentRefund(transaction: widget.transaction!),
      );
      // get customer information for the transaction
      if (widget.transaction?.customerId != null) {
        vm.store?.dispatch(
          getAndSetCustomerByID(customerId: widget.transaction!.customerId!),
        );
      }

      if (itemInfoList.length != widget.transaction!.itemCount) {
        throw Exception('Failed fetching transaction information.');
      }

      Navigator.push(
        context,
        CustomRoute(
          builder: (BuildContext ctx) => RefundPage(
            transaction: widget.transaction!,
            itemInfoList: itemInfoList,
          ),
        ),
      );

      vm.store!.dispatch(SetSalesLoadingStateAction(false));
    } catch (e) {
      vm.store!.dispatch(SetSalesLoadingStateAction(false));
      showErrorDialog(
        context,
        TransactionErrorCodes.failedFetchingTransactionInformation,
      );
    }
  }

  Future<void> _handleSaleVoid(BuildContext context, SalesVM vm) async {
    if (widget.transaction is! CheckoutTransaction) return;
    if (widget.transaction?.customerId != null) {
      Customer? customer = vm.store!.state.customerstate.getCustomerById(
        id: widget.transaction!.customerId!,
      );
      if (customer != null) {
        vm.setCustomer(customer);
      }
    } else {
      vm.clearCustomer();
    }

    Navigator.of(context).push(
      CustomRoute(
        builder: (BuildContext context) =>
            (VoidPaymentMethodPage(transaction: widget.transaction!)),
      ),
    );
  }

  refundCardCheck({
    required BuildContext context,
    required CheckoutTransaction transaction,
    required result,
  }) async {
    processResult(result: result, transaction: transaction, context: context);
  }

  processResult({
    required result,
    required BuildContext context,
    required CheckoutTransaction transaction,
    Completer? completer,
  }) {
    if (result!) {
      StoreProvider.of<AppState>(context).dispatch(
        cancelSale(
          context,
          transaction,
          completer:
              completer ??
              snackBarCompleter(context, 'Sale cancelled', shouldPop: true),
        ),
      );
    }
  }

  bool _isMakeRefundButtonEnabled() {
    if (widget.transaction is! CheckoutTransaction) return false;
    final state = AppVariables.store!.state;
    final sellNowModuleDisabled = state.enableNewSale == EnableOption.disabled;
    if (sellNowModuleDisabled) {
      return false;
    }
    return !widget.transaction!.isQuickRefund &&
        !widget.transaction!.isFullyRefunded &&
        !widget.transaction!.isWithdrawal;
  }

  bool _isVoidsaleButtonEnabled() {
    var state = AppVariables.store!.state;
    // TODO(lampian): reuse for v1 or v2 as needed
    var voidSaleDisabled = state.enableVoidSale == EnableOption.disabled;
    if (voidSaleDisabled) {
      return false;
    }
    return (isZeroOrNull(widget.transaction!.withdrawalAmount) &&
        userHasPermission(allowVoidSale));
  }

  void _mapTransactionData() {
    if (widget.transaction is CheckoutTransaction) {
      final transaction = widget.transaction as CheckoutTransaction;
      dateUpdated = transaction.dateUpdated;
      dateCreated = transaction.dateCreated;
      status = transaction.status;
      transactionNumber = (transaction.transactionNumber ?? 0).toStringAsFixed(
        0,
      );
      sellerName = transaction.sellerName;
      paymentType = transaction.paymentType?.name ?? 'N/A';
      checkoutTotal = transaction.checkoutTotal;
      isWithdrawal = transaction.isWithdrawal;
      withdrawalAmount = transaction.withdrawalAmount;
      cashbackAmount = transaction.cashbackAmount;
      amountTendered = transaction.amountTendered;
      totalRefund = transaction.totalRefund;
      cardType = transaction.cardType;
      paymentStatus = transaction.status;
      batchNo = transaction.batchNo;
      authResponse = transaction.authResponse;
      authResponseCode = transaction.authResponseCode;
      entry = transaction.entry;
      traceID = transaction.traceID;
      terminalIdPOS = transaction.terminalId ?? transaction.terminalIdPOS;
      customerName = transaction.customerName;
      customerMobile = transaction.customerMobile;
      customerEmail = transaction.customerEmail;
      providerReferenceNumber =
          transaction.paymentType?.providerPaymentReference;
    } else if (widget.transaction is Refund) {
      final refund = widget.transaction as Refund;
      dateUpdated = refund.dateUpdated;
      dateCreated = refund.dateCreated;
      status = refund.transactionStatus;
      transactionNumber = (refund.transactionNumber ?? 0).toStringAsFixed(0);
      sellerName = refund.sellerName;
      paymentType = refund.paymentType?.name ?? 'N/A';
      checkoutTotal = refund.totalRefund;
      isWithdrawal = false;
      withdrawalAmount = null;
      cashbackAmount = null;
      amountTendered = null;
      totalRefund = refund.totalRefund;
      cardType = refund.cardType;
      paymentStatus = refund.status;
      batchNo = refund.batchNo;
      authResponse = refund.authResponse;
      authResponseCode = refund.authResponseCode;
      entry = refund.entry;
      traceID = refund.traceID;
      terminalIdPOS = refund.terminalIdPOS;
      customerName = refund.customerName;
      customerMobile = refund.customerMobile;
      customerEmail = refund.customerEmail;
      providerReferenceNumber = refund.paymentType?.providerPaymentReference;
    }
  }
}
