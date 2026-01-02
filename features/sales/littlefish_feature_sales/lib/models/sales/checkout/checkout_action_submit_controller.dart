import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_actions.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_withdrawal_payment_page.dart';

class CheckoutActionSubmit {
  static void submit(
    CheckoutActionType actionType,
    CheckoutVM vm,
    BuildContext context,
    Decimal amount,
  ) {
    switch (actionType) {
      case CheckoutActionType.withdrawal:
        submitWithdrawal(vm, context, amount);
        break;
      case CheckoutActionType.cashback:
        submitCashback(vm, context, amount);
        break;
    }
  }

  static void submitWithdrawal(
    CheckoutVM vm,
    BuildContext context,
    Decimal amount,
  ) {
    if (!AppVariables.isPosPaymentGatewayRegistered ||
        AppVariables.isMobileWithoutSoftPos) {
      showMessageDialog(
        context,
        'Withdrawals require the card payment method, your device does not support this method of payment.',
        LittleFishIcons.error,
      );
      return;
    }

    vm.onClear();
    vm.store?.dispatch(CheckoutSetWithdrawalAmountAction(amount));
    Navigator.of(context).push(
      CustomRoute(
        maintainState: false,
        builder: (BuildContext context) {
          return CheckoutWithdrawPaymentPage(
            withdrawalAmount: amount,
            parentContext: context,
          );
        },
      ),
    );
  }

  static void submitCashback(
    CheckoutVM vm,
    BuildContext context,
    Decimal amount,
  ) {
    if (!AppVariables.isPosPaymentGatewayRegistered ||
        AppVariables.isMobileWithoutSoftPos) {
      showMessageDialog(
        context,
        'Cashbacks require the card payment method, your device does not support this method of payment.',
        LittleFishIcons.error,
      );
      return;
    }
    vm.store?.dispatch(CheckoutSetCashbackAmountAction(amount));
    Navigator.of(context).pop();
  }
}
