import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/models/shared/image_representable.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';

import '../../../../app/theme/applied_system/applied_button.dart';
import '../../../../app/theme/applied_system/applied_surface.dart';

class ButtonSecondary extends StatelessWidget {
  final Function(BuildContext context)? onTap;
  final String text;
  final bool disabled;
  final bool upperCase;
  final Color? textColor;
  final Color? buttonColor;
  final IconData? icon;
  final double radius, elevation;
  final bool expand;
  final bool layoutVertically;
  final bool isNegative;
  final bool isNeutral;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final ImageRepresentable? image;

  final PrimaryButtonTextSize? buttonTextSize;
  final bool? isBold;
  final String? semanticsIdentifier;
  final String? semanticsLabel;

  /// widgetOnBrandedSurface = true shows onPrimary coloured button on Primary canvas
  /// widgetOnBrandedSurface = false shows primary coloured button on non primary canvas
  final bool widgetOnBrandedSurface;

  const ButtonSecondary({
    Key? key,
    this.onTap,
    required this.text,
    this.textColor,
    this.buttonColor,
    this.radius = -1,
    this.elevation = 0,
    this.icon,
    this.image,
    this.disabled = false,
    this.upperCase = false,
    this.widgetOnBrandedSurface = false,
    this.expand = true,
    this.layoutVertically = false,
    this.isNegative = false,
    this.isNeutral = false,
    this.leftIcon,
    this.rightIcon,
    this.buttonTextSize = PrimaryButtonTextSize.small,
    this.isBold = true,
    this.semanticsIdentifier = 'defaultSemanticsIdentifier',
    this.semanticsLabel = 'defaultSemanticsLabel',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonColours =
        Theme.of(context).extension<AppliedButton>() ?? const AppliedButton();
    final surfaceColours =
        Theme.of(context).extension<AppliedSurface>() ?? const AppliedSurface();

    var backgroundColor = Colors.transparent;
    var foregroundColor = buttonColours.primaryDefault;
    var disabledBackgroundColor = Colors.transparent;
    var disabledForegroundColor = buttonColours.primaryDisabled;

    if (isNegative) {
      backgroundColor = Colors.transparent;
      foregroundColor = buttonColours.dangerDefault;
      disabledBackgroundColor = Colors.transparent;
      disabledForegroundColor = buttonColours.dangerDisabled;
    } else if (isNeutral) {
      backgroundColor = Colors.transparent;
      foregroundColor = buttonColours.neutralDefault;
      disabledBackgroundColor = Colors.transparent;
      disabledForegroundColor = buttonColours.neutralDisabled;
    }

    if (widgetOnBrandedSurface) {
      foregroundColor = surfaceColours.primary;
      disabledForegroundColor = surfaceColours.secondary;
    }

    final textUsed = TextFormatter.formatStringFromFontCasing(text);

    return expand
        ? SizedBox(
            width: double.infinity,
            child: buttonBody(
              context: context,
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              disabledBackgroundColor: disabledBackgroundColor,
              disabledForegroundColor: disabledForegroundColor,
              textUsed: textUsed,
              disabled: disabled,
              semanticsIdentifier:
                  semanticsIdentifier ?? 'defaultSemanticsIdentifier',
              semanticsLabel: semanticsLabel ?? 'defaultSemanticsLabel',
            ),
          )
        : buttonBody(
            context: context,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            disabledBackgroundColor: disabledBackgroundColor,
            disabledForegroundColor: disabledForegroundColor,
            textUsed: textUsed,
            disabled: disabled,
            semanticsIdentifier:
                semanticsIdentifier ?? 'defaultSemanticsIdentifier',
            semanticsLabel: semanticsLabel ?? 'defaultSemanticsLabel',
          );
  }

  Widget buttonBody({
    required BuildContext context,
    required Color backgroundColor,
    required Color foregroundColor,
    required Color disabledBackgroundColor,
    required Color disabledForegroundColor,
    required String textUsed,
    required bool disabled,
    required String semanticsIdentifier,
    required String semanticsLabel,
  }) {
    final buttonStyle = ElevatedButton.styleFrom(
      elevation: elevation,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledForegroundColor: disabledForegroundColor,
      alignment: Alignment.center,
      padding: EdgeInsets.zero,
      shape: radius != -1
          ? RoundedRectangleBorder(
              side: BorderSide(color: foregroundColor, width: 1),
              borderRadius: BorderRadius.circular(
                AppVariables.appDefaultRadius,
              ),
            )
          : null,
    );

    return ElevatedButton(
      style: buttonStyle,
      onPressed: disabled
          ? null
          : () => onTap == null
                ? showComingSoon(context: context, description: 'Button: $text')
                : onTap!(context),
      child: layoutVertically
          ? textUsed.isEmpty
                ? Semantics(
                    // add sematics if the button has got no text else if it has text that is already semantics
                    identifier: semanticsIdentifier,
                    label: semanticsLabel,
                    child: horizontalLayout(
                      context: context,
                      foregroundColor: foregroundColor,
                      textUsed: textUsed,
                    ),
                  )
                : verticalLayout(
                    context: context,
                    foregroundColor: disabled
                        ? disabledForegroundColor
                        : foregroundColor,
                    textUsed: textUsed,
                  )
          : textUsed
                .isEmpty // add sematics if the button has got no text else if it has text that is already semantics
          ? Semantics(
              identifier: semanticsIdentifier,
              label: semanticsLabel,
              child: horizontalLayout(
                context: context,
                foregroundColor: foregroundColor,
                textUsed: textUsed,
              ),
            )
          : horizontalLayout(
              context: context,
              foregroundColor: disabled
                  ? disabledForegroundColor
                  : foregroundColor,
              textUsed: textUsed,
            ),
    );
  }

  Widget verticalLayout({
    required BuildContext context,
    required Color foregroundColor,
    required String textUsed,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(icon, color: foregroundColor),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.center,
          child: getTextWidget(
            context,
            textUsed,
            foregroundColor,
            2,
            isBold ?? true,
          ),
        ),
      ],
    );
  }

  Widget horizontalLayout({
    required BuildContext context,
    required Color foregroundColor,
    required String textUsed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leftIcon != null) Icon(leftIcon, color: foregroundColor),
        if (icon != null) Icon(icon, color: foregroundColor),
        if (image != null) image!.buildWidget(colour: foregroundColor),
        if (textUsed.isNotEmpty)
          Flexible(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: getTextWidget(
                context,
                textUsed,
                foregroundColor,
                2,
                isBold ?? true,
              ),
            ),
          ),
        if (rightIcon != null) Icon(rightIcon, color: foregroundColor),
      ],
    );
  }

  Widget getTextWidget(
    BuildContext context,
    String text,
    Color? color,
    int maxLines,
    bool isBold,
  ) {
    switch (buttonTextSize) {
      case PrimaryButtonTextSize.xSmall:
        return context.paragraphXSmall(
          text,
          color: color,
          isBold: isBold,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        );
      case PrimaryButtonTextSize.small:
        return context.paragraphSmall(
          text,
          color: color,
          isBold: isBold,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      case PrimaryButtonTextSize.medium:
        return context.paragraphMedium(
          text,
          color: color,
          isBold: isBold,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        );
      case PrimaryButtonTextSize.large:
        return context.paragraphLarge(
          text,
          color: color,
          isBold: isBold,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        );
      default:
        return context.paragraphLarge(
          text,
          color: color,
          isBold: isBold,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        );
    }
  }
}
