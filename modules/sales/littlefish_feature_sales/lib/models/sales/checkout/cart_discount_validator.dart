import 'package:littlefish_merchant/models/sales/checkout/checkout_discount.dart';

class DiscountValidator {
  static DiscountValidationResults validateDiscount({
    required double totalBeforeDiscount,
    required CheckoutDiscount discount,
  }) {
    double finalTotalAfterDiscount = getFinalTotal(
      totalBeforeDiscount,
      discount,
    );

    if (discount.value == null ||
        discount.isNew == null ||
        discount.value == null) {
      return DiscountValidationResults.nullValues;
    }

    if (discount.type == DiscountType.percentage) {
      if (discount.value! < (discount.minValue ?? 0)) {
        return DiscountValidationResults.valueTooLow;
      }
      if (discount.value! > (discount.maxValue ?? 100)) {
        return DiscountValidationResults.valueTooHigh;
      }
    }

    if (totalBeforeDiscount == 0) return DiscountValidationResults.cartEmpty;
    if (finalTotalAfterDiscount < 0) {
      return DiscountValidationResults.discountTooLarge;
    }
    if (discount.value! < 0) {
      return DiscountValidationResults.invalidDiscountPercentage;
    }
    if (finalTotalAfterDiscount >= 0) return DiscountValidationResults.success;
    return DiscountValidationResults.unexpectedBug;
  }

  static String getValidationMessage(DiscountValidationResults result) {
    switch (result) {
      case DiscountValidationResults.discountTooLarge:
        return 'Discount larger than cart amount, please enter a smaller discount.';
      case DiscountValidationResults.invalidDiscountPercentage:
        return 'Discount percentage is invalid, please enter a valid discount.';
      case DiscountValidationResults.cartEmpty:
        return 'Cart is empty, please add products to your cart before applying a discount.';
      case DiscountValidationResults.success:
        return 'Success!';
      case DiscountValidationResults.valueTooLow:
        return 'Value entered is too low, please select a higher value.';
      case DiscountValidationResults.valueTooHigh:
        return 'Value entered is too high, please enter a lower value.';
      case DiscountValidationResults.nullValues:
        return 'One or more values were not specified, please add a discount type and amount.';
      case DiscountValidationResults.unexpectedBug:
        return 'Unable to apply discount. Please verify the discount code and try again.';
      default:
        return 'Unable to validate discount. Please check your connection and try again.';
    }
  }

  static double getFinalTotal(
    double totalBeforeDiscount,
    CheckoutDiscount discount,
  ) {
    discount.value ??= 0;

    if (discount.type == DiscountType.fixedAmount) {
      return totalBeforeDiscount - discount.value!;
    } else {
      return totalBeforeDiscount -
          totalBeforeDiscount * (discount.value! / 100);
    }
  }
}

enum DiscountValidationResults {
  discountTooLarge,
  invalidDiscountPercentage,
  success,
  unexpectedBug,
  cartEmpty,
  valueTooLow,
  valueTooHigh,
  nullValues,
}
