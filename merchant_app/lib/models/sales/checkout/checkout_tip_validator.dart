import 'package:littlefish_merchant/models/sales/checkout/checkout_tip.dart';

class CheckoutTipValidator {
  static CheckoutTipValidationResults validateTip(
  // ignore: require_trailing_commas
  {required double totalBeforeTip, required CheckoutTip tip}) {
    double finalTotalAfterTip = getFinalTotal(totalBeforeTip, tip);

    if (tip.value == null || tip.isNew == null || tip.value == null) {
      return CheckoutTipValidationResults.nullValues;
    }

    if (tip.minValue != null && tip.value! < tip.minValue!) {
      return CheckoutTipValidationResults.valueTooLow;
    }

    if (tip.maxValue != null && tip.value! > tip.maxValue!) {
      return CheckoutTipValidationResults.valueTooHigh;
    }

    if (totalBeforeTip == 0) return CheckoutTipValidationResults.cartEmpty;
    if (finalTotalAfterTip >= 0) return CheckoutTipValidationResults.success;
    return CheckoutTipValidationResults.unexpectedBug;
  }

  static String getValidationMessage(CheckoutTipValidationResults result) {
    switch (result) {
      case CheckoutTipValidationResults.invalidTipPercentage:
        return 'Tip percentage is invalid, please enter a valid percentage.';
      case CheckoutTipValidationResults.cartEmpty:
        return 'Cart is empty, please add products to your cart before applying a tip.';
      case CheckoutTipValidationResults.success:
        return 'Success!';
      case CheckoutTipValidationResults.valueTooLow:
        return 'Value entered is too low, please select a higher value.';
      case CheckoutTipValidationResults.valueTooHigh:
        return 'Value entered is too high, please enter a lower value.';
      case CheckoutTipValidationResults.nullValues:
        return 'One or more values were not specified, please add a tip type and amount.';
      case CheckoutTipValidationResults.unexpectedBug:
        return 'Unable to process tip amount. Please verify the amount and try again.';
      default:
        return 'Unable to validate tip. Please check your connection and try again.';
    }
  }

  static double getFinalTotal(double totalBeforeTip, CheckoutTip tip) {
    tip.value ??= 0;

    if (tip.type == TipType.fixedAmount) {
      return totalBeforeTip + tip.value!;
    } else {
      return totalBeforeTip + totalBeforeTip * (tip.value! / 100);
    }
  }

  static double getTipAmount(double totalBeforeTip, CheckoutTip? tip) {
    if (tip == null) return 0;
    tip.value ??= 0;

    if (tip.type == TipType.fixedAmount) {
      return tip.value!;
    } else {
      return totalBeforeTip * (tip.value! / 100);
    }
  }

  static double getAmountBeforeTip(double totalAfterTip, CheckoutTip tip) {
    tip.value ??= 0;

    if (tip.type == TipType.fixedAmount) {
      return tip.value!;
    } else {
      return totalAfterTip / (1 + (tip.value! / 100));
    }
  }
}

enum CheckoutTipValidationResults {
  invalidTipPercentage,
  success,
  unexpectedBug,
  cartEmpty,
  valueTooLow,
  valueTooHigh,
  nullValues,
}
