import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/square_icon_button_secondary.dart';

class FooterButtonsIconPrimary extends StatelessWidget {
  final String primaryButtonText;
  final IconData secondaryButtonIcon;
  final Function(BuildContext)? onPrimaryButtonPressed;
  final Function(BuildContext)? onSecondaryButtonPressed;
  final bool allSecondaryControls;
  final bool primaryEnabled;
  final bool secondaryEnabled;
  final String? semanticsIdentifier;
  final String? semanticsLabel;

  const FooterButtonsIconPrimary({
    Key? key,
    required this.primaryButtonText,
    this.onSecondaryButtonPressed,
    required this.secondaryButtonIcon,
    this.onPrimaryButtonPressed,
    this.allSecondaryControls = false,
    this.semanticsIdentifier,
    this.semanticsLabel,
    this.primaryEnabled = true,
    this.secondaryEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: SquareIconButtonSecondary(
            semanticsIdentifier: semanticsIdentifier,
            semanticsLabel: semanticsLabel,
            icon: secondaryButtonIcon,
            onPressed: onSecondaryButtonPressed ?? (ctx) {},
            disabled: !secondaryEnabled,
          ),
        ),
        const SizedBox(width: 6),
        if (allSecondaryControls)
          Expanded(
            flex: 10,
            child: ButtonSecondary(
              text: primaryButtonText,
              widgetOnBrandedSurface: false,
              onTap: onPrimaryButtonPressed,
              disabled: !primaryEnabled,
            ),
          )
        else
          Expanded(
            flex: 10,
            child: ButtonPrimary(
              text: primaryButtonText,
              widgetOnBrandedSurface: false,
              onTap: onPrimaryButtonPressed,
              disabled: !primaryEnabled,
            ),
          ),
      ],
    );
  }
}
