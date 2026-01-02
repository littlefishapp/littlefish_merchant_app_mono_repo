import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/domain/usecases/square_button_config.dart';
import '../../../../app/theme/applied_system/applied_button.dart';
import '../../../../app/theme/applied_system/applied_text_icon.dart';

class SquareIconButtonPrimary extends StatelessWidget {
  final Function(BuildContext) onPressed;
  final IconData? icon;
  final String? iconPath;

  final bool disabled;

  final bool isNegative;
  final bool isNeutral;
  final bool widgetOnBrandedSurface;

  final String? semanticsIdentifier;
  final String? semanticsLabel;

  const SquareIconButtonPrimary({
    Key? key,
    required this.onPressed,
    this.disabled = false,
    this.icon,
    this.iconPath,
    this.isNegative = false,
    this.isNeutral = false,
    this.widgetOnBrandedSurface = false,
    this.semanticsIdentifier = 'defaultSemanticsIdentifier',
    this.semanticsLabel = 'defaultSemanticsLabel',
  }) : assert(
         iconPath == null || icon == null,
         'Both iconPath and icon cannot be empty',
       ),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    final config =
        AppVariables.store?.state.squareButtonConfig ??
        SquareButtonConfig().config;

    final buttonColours =
        Theme.of(context).extension<AppliedButton>() ?? const AppliedButton();
    final textIconColours =
        Theme.of(context).extension<AppliedTextIcon>() ??
        const AppliedTextIcon();

    // Establish Base Colors
    var backgroundColor = buttonColours.primaryDefault;
    var foregroundColor = textIconColours.inversePrimary;
    var disabledBackgroundColor = buttonColours.primaryDisabled;
    var disabledForegroundColor = textIconColours.inversePrimary;

    // Handle Variants
    if (isNegative) {
      backgroundColor = buttonColours.dangerDefault;
      disabledBackgroundColor = buttonColours.dangerDisabled;
    } else if (isNeutral) {
      backgroundColor = buttonColours.neutralDefault;
      disabledBackgroundColor = buttonColours.neutralDisabled;
    }

    // Handle Branded Surface Override
    if (widgetOnBrandedSurface) {
      var oldBackGround = backgroundColor;
      backgroundColor = foregroundColor;
      foregroundColor = oldBackGround;

      var oldDisabledBackground = disabledBackgroundColor;
      disabledBackgroundColor = disabledForegroundColor.withAlpha(40);
      disabledForegroundColor = oldDisabledBackground.withAlpha(100);
    }

    // Determine final colors based on state
    final effectiveBackgroundColor = disabled
        ? disabledBackgroundColor
        : backgroundColor;
    final effectiveForegroundColor = disabled
        ? disabledForegroundColor
        : foregroundColor;

    final effectiveBorderRadius = BorderRadius.circular(
      AppVariables.appDefaultRadius,
    );

    var iconSize = config.iconSize;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: iconSize + 8,
        minHeight: iconSize + 8,
        maxWidth: 48,
        maxHeight: 48,
      ),
      child: Ink(
        decoration: ShapeDecoration(
          color: effectiveBackgroundColor,
          shape: RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
        ),
        child: InkWell(
          borderRadius: effectiveBorderRadius,
          onTap: disabled ? null : () => onPressed(context),
          child: Semantics(
            identifier: semanticsIdentifier ?? 'defaultSemanticsIdentifier',
            label: semanticsLabel ?? 'defaultSemanticsLabel',
            button: true,
            enabled: !disabled,
            child: Center(
              child: iconPath == null
                  ? Icon(icon, color: effectiveForegroundColor, size: iconSize)
                  : ImageIcon(
                      AssetImage(iconPath!),
                      color: effectiveForegroundColor,
                      size: iconSize,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
