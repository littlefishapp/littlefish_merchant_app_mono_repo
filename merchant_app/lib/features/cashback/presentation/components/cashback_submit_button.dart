import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/sales/checkout/cashback_requirements.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_action_requirements_validator.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

class CashbackSubmitButton extends StatelessWidget {
  final double _amount;
  final CashbackRequirements _requirements;
  CashbackSubmitButton({
    super.key,
    double amount = 0,
    CashbackRequirements? requirements,
  }) : _amount = amount,
       _requirements = requirements ?? CashbackRequirements(minAmount: 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: ButtonPrimary(
        text: 'Apply Cashback',
        disabled: isZeroOrNull(_amount),
        upperCase: false,
        buttonColor: Theme.of(context).colorScheme.secondary,
        onTap: (context) => _onTap(context),
      ),
    );
  }

  void _onTap(BuildContext context) {
    AmountValidationResult result =
        CheckoutActionRequirementsValidator.validateAmount(
          _requirements,
          _amount,
        );
    String message = CheckoutActionRequirementsValidator.validationMessage(
      result,
      _requirements,
    );

    if (result != AmountValidationResult.success) {
      showMessageDialog(context, message, LittleFishIcons.error);
      return;
    }

    Navigator.of(context).pop(_amount);
  }
}
