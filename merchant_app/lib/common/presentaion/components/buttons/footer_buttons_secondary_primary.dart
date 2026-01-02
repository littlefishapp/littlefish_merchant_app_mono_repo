import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';

class FooterButtonsSecondaryPrimary extends StatelessWidget {
  final String primaryButtonText;
  final String secondaryButtonText;
  final Function(BuildContext)? onPrimaryButtonPressed;
  final Function(BuildContext)? onSecondaryButtonPressed;
  final bool useTabletConfig;
  final bool primaryButtonDisabled;

  const FooterButtonsSecondaryPrimary({
    Key? key,
    required this.primaryButtonText,
    this.onSecondaryButtonPressed,
    required this.secondaryButtonText,
    this.onPrimaryButtonPressed,
    this.useTabletConfig = false,
    this.primaryButtonDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        if (!useTabletConfig) ...[
          Expanded(
            child: ButtonSecondary(
              disabled: onSecondaryButtonPressed == null,
              text: secondaryButtonText,
              onTap: onSecondaryButtonPressed,
            ),
          ),
          const SizedBox(width: 8),
        ],
        if (useTabletConfig)
          Expanded(
            child: ButtonSecondary(
              disabled: onPrimaryButtonPressed == null,
              text: primaryButtonText,
              onTap: onPrimaryButtonPressed,
            ),
          )
        else
          Expanded(
            child: ButtonPrimary(
              disabled: onPrimaryButtonPressed == null || primaryButtonDisabled,
              text: primaryButtonText,
              onTap: onPrimaryButtonPressed,
            ),
          ),
      ],
    );
  }
}
