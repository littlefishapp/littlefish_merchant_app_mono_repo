// Flutter imports:

import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/features/sell/presentation/components/transaction_receipt_buttons.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/presentation/components/transaction_info_item.dart';
import 'package:littlefish_merchant/ui/checkout/sell_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quiver/strings.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/models/security/user/user_profile.dart';
import 'package:littlefish_merchant/models/store/business_profile.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/billing/billing_helpers.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_email_receipt_page.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_sms_receipt_page.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/print_vm.dart';
import 'package:littlefish_merchant/ui/home/home_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/text_tag.dart';

import '../../../features/pos/presentation/pages/pos_print_page.dart';
import '../../../models/sales/checkout/checkout_refund_item.dart';

class CheckoutReceipt extends StatelessWidget {
  final dynamic transaction;
  final PrintVM? printVM;
  final Function(String)? onEvent;

  final bool isReprint;

  const CheckoutReceipt({
    Key? key,
    required this.transaction,
    this.onEvent,
    this.printVM,
    this.isReprint = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ReceiptViewModel>(
      converter: (Store<AppState> store) {
        if (transaction is CheckoutTransaction) {
          return ReceiptViewModel.fromStore(store, transaction);
        }
        return ReceiptViewModel.fromStore(store, null);
      },
      builder: (BuildContext context, ReceiptViewModel vm) {
        return Container(
          padding: const EdgeInsets.only(top: 32, left: 32, right: 32),
          child: Column(
            children: [
              Flexible(
                flex: 10,
                child: ListView(
                  children: <Widget>[
                    cartSummary(context),
                    if (transaction is CheckoutTransaction &&
                        (transaction.itemCount ?? 0) > 0)
                      _itemSummary(context),
                    if (transaction is Refund &&
                        (transaction.items?.isNotEmpty ?? false))
                      _itemSummary(context),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _receiptButtons(BuildContext context, ReceiptViewModel vm) {
    return TransactionReceiptButtons(
      showPrintButton:
          AppVariables.hasPrinter &&
          cardPaymentRegistered == CardPaymentRegistered.pos,
      onPrintTap: () async {
        _print(context, vm);
      },
      onSmsTap: () {
        _sms(context, vm);
      },
      onEmailTap: () {
        _email(context, vm);
      },
    );
  }

  _print(BuildContext context, ReceiptViewModel vm) {
    if (transaction?.isQuickRefund ?? false) {
      transaction?.totalValue = transaction?.totalRefund;
      transaction?.amountTendered = transaction?.totalRefund;
    }

    if (AppVariables.hasPrinter &&
        cardPaymentRegistered == CardPaymentRegistered.pos) {
      var quickRefund = _tryGetQuickRefund(transaction!);
      showPopupDialog(
        context: context,
        content: PosPrintPage(
          transaction,
          quickRefund,
          isRefund: quickRefund != null,
          parentContext: context,
          isReprint: true,
        ),
      ).then((result) {});
    } else {
      final printVM = PrintVM.fromStore(StoreProvider.of<AppState>(context));
      printVM.setReceipt(transaction);
      printVM.debugPrint(context);
    }
  }

  _sms(BuildContext context, ReceiptViewModel vm) {
    if (vm.store!.state.hasInternet!) {
      if (isNotPremium(cleanString('sms_receipt'))) {
        showPopupDialog(
          defaultPadding: false,
          context: context,
          content: billingNavigationHelper(isModal: true),
        );
      } else {
        showPopupDialog(
          height: 280,
          context: context,
          content: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: CheckoutSMSReceiptPage(
              mobileNumber: vm.transaction!.customerMobile,
              customerName: vm.transaction!.customerName,
              transaction: vm.transaction,
            ),
          ),
        );
      }
    } else {
      showMessageDialog(
        context,
        'Please go online to use this feature',
        MdiIcons.wifi,
      );
    }
  }

  _email(BuildContext context, ReceiptViewModel vm) {
    if (vm.store!.state.hasInternet!) {
      if (isNotPremium(cleanString('email_receipt'))) {
        showPopupDialog(
          defaultPadding: false,
          context: context,
          content: billingNavigationHelper(isModal: true),
        );
      } else {
        showPopupDialog(
          height: 280,
          context: context,
          content: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: CheckoutEmailReceiptPage(
              emailAddress: vm.transaction!.customerEmail,
              customerName: vm.transaction!.customerName,
              transaction: vm.transaction,
            ),
          ),
        );
      }
    } else {
      showMessageDialog(
        context,
        'Please go online to use this feature',
        MdiIcons.wifi,
      );
    }
  }

  SizedBox newSale(context) => SizedBox(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ButtonSecondary(
        text: 'NEW SALE',
        onTap: (context) => Navigator.of(context).pushNamedAndRemoveUntil(
          SellPage.route,
          ModalRoute.withName(HomePage.route),
        ),
        // Navigator.of(context).pushNamedAndRemoveUntil(
        //   CheckoutPage.route,
        //   ModalRoute.withName(HomePage.route),
        // ),
      ),
    ),
  );

  Container receiptNumberRow(context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 8),
    alignment: Alignment.center,
    child: DecoratedText(
      'RECEIPT #${transaction?.transactionNumber?.floor() ?? 0}',
      alignment: Alignment.center,
      fontWeight: FontWeight.bold,
      fontSize: 20,
      textColor: Theme.of(context).colorScheme.secondary,
    ),
  );

  Container leftRow(context, String value) => Container(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    alignment: Alignment.centerRight,
    child: DecoratedText(
      value,
      alignment: Alignment.centerLeft,
      fontWeight: FontWeight.bold,
      fontSize: 12,
      textColor: Theme.of(context).colorScheme.secondary,
    ),
  );

  Container rightAlignItem(
    context,
    String value, {
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.bold,
  }) => Container(
    padding: const EdgeInsets.symmetric(vertical: 8),
    alignment: Alignment.centerRight,
    child: DecoratedText(
      value,
      alignment: Alignment.centerRight,
      fontWeight: fontWeight,
      fontSize: fontSize,
      textColor: Theme.of(context).colorScheme.secondary,
    ),
  );

  Widget _itemSummary(BuildContext context) => Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: context.labelLarge(
          'Item Summary:',
          isBold: true,
          alignLeft: true,
        ),
      ),
      transactionList(context),
    ],
  );

  Widget transactionList(BuildContext context) {
    if (transaction!.isQuickRefund) {
      return quickRefundDescriptionTile(context);
    }

    return ListView.separated(
      padding: const EdgeInsets.only(top: 8),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        var item;
        var quantity;
        var description;
        var value;

        if (transaction is CheckoutTransaction) {
          item = (transaction as CheckoutTransaction).items![index];
          quantity = item.quantity;
          description = item.description;
          value = item.value;
        } else if (transaction is Refund) {
          item = (transaction as Refund).items![index];
          quantity = item.quantity;
          description = item.displayName;
          value = item.itemValue;
        }

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          leading: ListLeadingTextTile(text: '${quantity.round()} x'),
          tileColor: Theme.of(context).colorScheme.background,
          dense: true,
          title: context.paragraphMedium('$description', alignLeft: true),
          trailing: context.paragraphMedium(
            TextFormatter.toStringCurrency(value, currencyCode: ''),
            color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
            isSemiBold: false,
          ),
        );
      },
      itemCount: transaction is CheckoutTransaction
          ? (transaction as CheckoutTransaction).itemCount!
          : (transaction as Refund).items!.length,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox.shrink(),
    );
  }

  Widget quickRefundDescriptionTile(BuildContext context) {
    int quickRefundIndex = transaction!.refunds!.indexWhere(
      (refund) => refund.isQuickRefund,
    );
    Refund refund = transaction!.refunds![quickRefundIndex];
    String refundDescription = getQuickRefundDescription(refund);
    return ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      dense: true,
      title: Text('1 x $refundDescription'),
      trailing: TextTag(
        displayText: TextFormatter.toStringCurrency(
          refund.totalRefund,
          currencyCode: '',
        ),
      ),
    );
  }

  String getQuickRefundDescription(Refund refund) {
    if (isNotBlank(refund.description)) return refund.description!;
    if (isNotBlank(refund.displayName)) return refund.displayName!;
    return 'Quick Refund';
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

  cartSummary(BuildContext context) {
    final double totalValue = transaction is CheckoutTransaction
        ? transaction.totalValue ?? 0
        : (transaction is Refund ? transaction.totalRefund ?? 0 : 0);
    final double totalDiscount = transaction is CheckoutTransaction
        ? transaction.totalDiscount ?? 0
        : 0;
    final cashbackAmount = transaction is CheckoutTransaction
        ? transaction.cashbackAmount ?? 0
        : 0;
    final tipAmount = transaction is CheckoutTransaction
        ? transaction.tipAmount ?? 0
        : 0;
    final totalTax = transaction is CheckoutTransaction
        ? transaction.totalTax ?? 0
        : 0;
    final checkoutTotal = transaction is CheckoutTransaction
        ? transaction.checkoutTotal ?? 0
        : 0;
    final amountTendered = transaction is CheckoutTransaction
        ? transaction.amountTendered ?? 0
        : 0;
    final amountChange = transaction is CheckoutTransaction
        ? transaction.amountChange ?? 0
        : 0;
    final totalRefund = transaction is CheckoutTransaction
        ? transaction.totalRefund ?? 0
        : (transaction is Refund ? transaction.totalRefund ?? 0 : 0);

    return Container(
      color: Colors.white,
      alignment: Alignment.centerRight,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            alignment: Alignment.centerLeft,
            child: context.labelLarge(
              'Cart Summary:',
              isBold: true,
              alignLeft: true,
            ),
          ),
          if (totalValue > 0)
            TransactionInfoItem(
              title:
                  'Sub-Total${AppVariables.store!.state.appSettingsState.salesTax?.enabled ?? false ? ' (incl tax):' : ':'}',
              value: TextFormatter.toStringCurrency(totalValue),
            ),
          if (totalDiscount > 0)
            TransactionInfoItem(
              title: 'Discount',
              value: TextFormatter.toStringCurrency(totalDiscount),
            ),
          if (cashbackAmount > 0)
            TransactionInfoItem(
              title: 'CashBack',
              value: TextFormatter.toStringCurrency(cashbackAmount),
            ),
          if (tipAmount > 0)
            TransactionInfoItem(
              title: 'Tip',
              value: TextFormatter.toStringCurrency(tipAmount),
            ),
          if (totalTax > 0)
            TransactionInfoItem(
              title:
                  'Tax${AppVariables.store!.state.appSettingsState.salesTax?.enabled ?? false ? ' (incl tax):' : ':'}',
              value: TextFormatter.toStringCurrency(totalTax),
            ),
          if (checkoutTotal > 0)
            TransactionInfoItem(
              title: transaction?.isWithdrawal == true
                  ? 'Cash Withdrawal'
                  : 'Total Value${AppVariables.store!.state.appSettingsState.salesTax?.enabled ?? false ? ' (incl tax):' : ':'}',
              value: TextFormatter.toStringCurrency(checkoutTotal),
              isBold: true,
            ),
          if (amountTendered > 0)
            TransactionInfoItem(
              title: 'Amout Paid',
              value: TextFormatter.toStringCurrency(amountTendered),
            ),
          if (amountChange > 0 && transaction?.isWithdrawal != true)
            TransactionInfoItem(
              title: 'Change',
              value: TextFormatter.toStringCurrency(amountChange),
            ),
          if (totalRefund > 0)
            TransactionInfoItem(
              title: transaction?.isQuickRefund == true
                  ? 'Quick Refund'
                  : 'Total Refunded',
              value: TextFormatter.toStringCurrency(totalRefund),
            ),
        ],
      ),
    );
  }
}

class ReceiptViewModel {
  Function(CheckoutTransaction transaction)? onPrint;
  Function(CheckoutTransaction transaction)? onEmail;
  Function(CheckoutTransaction transaction)? onSMS;
  CheckoutTransaction? transaction;

  BusinessProfile? businessProfile;

  UserProfile? userProfile;

  bool? hasPrinter;

  double? lastTransactionNumber;

  Store<AppState>? store;

  bool get isPosDevice {
    if (store == null) {
      return false;
    }

    return store!.state.appSettingsState.isPOSBuild;
  }

  ReceiptViewModel.fromStore(
    Store<AppState> storeValue,
    CheckoutTransaction? transactionValue,
  ) {
    store = storeValue;
    transaction = transactionValue;
    hasPrinter = AppVariables.hasPrinter;
    businessProfile = storeValue.state.businessState.profile;
    userProfile = storeValue.state.userState.profile;

    onEmail = (trx) {};

    lastTransactionNumber =
        storeValue.state.checkoutState.lastTransactionNumber;
  }
}
