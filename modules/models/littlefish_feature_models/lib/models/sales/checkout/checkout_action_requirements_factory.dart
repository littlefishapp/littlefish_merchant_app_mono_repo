import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/sales/checkout/cashback_requirements.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_action_requirements.dart';
import 'package:littlefish_merchant/models/sales/checkout/withdraw_requirements.dart';

class CheckoutActionRequirementsFactory {
  static CheckoutActionRequirements createRequirements(
    CheckoutActionType actionType, {
    num? minAmount,
    num? maxAmount,
  }) {
    switch (actionType) {
      case CheckoutActionType.cashback:
        return CashbackRequirements(
          minAmount: minAmount?.toDouble(),
          maxAmount: maxAmount?.toDouble(),
        );
      case CheckoutActionType.withdrawal:
        return WithdrawRequirements(
          minAmount: minAmount?.toDouble(),
          maxAmount: maxAmount?.toDouble(),
        );
      default:
        return CashbackRequirements(
          minAmount: minAmount?.toDouble(),
          maxAmount: maxAmount?.toDouble(),
        );
    }
  }
}
