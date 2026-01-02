import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/domain/usecases/square_button_config.dart';
import '../../../../app/theme/applied_system/applied_button.dart';
import '../../../../app/theme/applied_system/applied_surface.dart';

class SquareIconButtonSecondary extends StatelessWidget {
  final Function(BuildContext) onPressed;
  final IconData? icon;
  final String? iconPath;
  final bool disabled;

  final bool isNegative;
  final bool isNeutral;
  final bool widgetOnBrandedSurface;

  final String? semanticsIdentifier;
  final String? semanticsLabel;

  const SquareIconButtonSecondary({
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
    final surfaceColours =
        Theme.of(context).extension<AppliedSurface>() ?? const AppliedSurface();

    // Establish Base Colors
    var backgroundColor = Colors.transparent;
    var foregroundColor = buttonColours.primaryDefault;
    var disabledForegroundColor = buttonColours.primaryDisabled;

    // Handle Variants
    if (isNegative) {
      foregroundColor = buttonColours.dangerDefault;
      disabledForegroundColor = buttonColours.dangerDisabled;
    } else if (isNeutral) {
      foregroundColor = buttonColours.neutralDefault;
      disabledForegroundColor = buttonColours.neutralDisabled;
    }

    // Handle Branded Surface Override
    if (widgetOnBrandedSurface) {
      foregroundColor = surfaceColours.primary;
      disabledForegroundColor = surfaceColours.secondary;
    }

    // Determine final color based on state
    final effectiveColor = disabled ? disabledForegroundColor : foregroundColor;

    var iconSize = config.iconSize;

    final effectiveBorderRadius = BorderRadius.circular(
      AppVariables.appDefaultRadius,
    );

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: iconSize + 8,
        minHeight: iconSize + 8,
        maxWidth: 48,
        maxHeight: 48,
      ),
      child: Ink(
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: effectiveBorderRadius,
            side: BorderSide(
              color: effectiveColor,
              style: BorderStyle.solid,
              width: 1,
            ),
          ),
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
                  ? Icon(icon, color: effectiveColor, size: iconSize)
                  : ImageIcon(
                      AssetImage(iconPath!),
                      color: effectiveColor,
                      size: iconSize,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
