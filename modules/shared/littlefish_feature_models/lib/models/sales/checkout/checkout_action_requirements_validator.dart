import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_action_requirements.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';

class CheckoutActionRequirementsValidator {
  static AmountValidationResult validateAmount(
    CheckoutActionRequirements requirements,
    num? amount,
  ) {
    if (requirements.isRequired && amount == null) {
      return AmountValidationResult.amountRequired;
    }
    if (amount != null) {
      if (requirements.minAmount != null && amount < requirements.minAmount!) {
        return AmountValidationResult.amountTooLittle;
      }
      if (requirements.maxAmount != null && amount > requirements.maxAmount!) {
        return AmountValidationResult.amountTooMuch;
      }
    }
    return AmountValidationResult.success;
  }

  static String validationMessage(
    AmountValidationResult result,
    CheckoutActionRequirements requirements,
  ) {
    String minAmount = TextFormatter.toStringCurrency(
      requirements.minAmount?.toDouble() ?? 0,
    );
    String maxAmount = TextFormatter.toStringCurrency(
      requirements.maxAmount?.toDouble() ?? double.infinity,
    );

    switch (result) {
      case AmountValidationResult.success:
        return 'Validation successful.';
      case AmountValidationResult.amountTooLittle:
        return 'The amount must be\n greater than $minAmount.';
      case AmountValidationResult.amountTooMuch:
        return 'The amount must be\n less than $maxAmount.';
      case AmountValidationResult.amountRequired:
        return 'An amount is required.';
      default:
        return 'Unknown validation error.';
    }
  }
}
