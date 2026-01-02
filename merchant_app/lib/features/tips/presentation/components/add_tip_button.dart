import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_tip.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_tip_validator.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

class AddTipButton extends StatelessWidget {
  final double totalBeforeTip;
  final CheckoutTip tip;
  const AddTipButton({super.key, required this.tip, this.totalBeforeTip = 0});

  @override
  Widget build(BuildContext context) {
    return ButtonPrimary(
      text: 'Add Tip',
      upperCase: false,
      disabled: isZeroOrNull(tip.value),
      buttonColor: Theme.of(context).colorScheme.secondary,
      onTap: (context) => _onTap(context),
    );
  }

  void _onTap(BuildContext context) {
    CheckoutTipValidationResults validationResult =
        CheckoutTipValidator.validateTip(
          totalBeforeTip: totalBeforeTip,
          tip: tip,
        );

    if (validationResult != CheckoutTipValidationResults.success) {
      showMessageDialog(
        context,
        CheckoutTipValidator.getValidationMessage(validationResult),
        LittleFishIcons.error,
      );
      return;
    }

    tip.isNew = true;
    Navigator.of(context).pop(tip);
  }
}
