import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_button.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';

import '../../../../app/theme/applied_system/applied_text_icon.dart';

class ButtonPrimary extends StatefulWidget {
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
  final PrimaryButtonTextSize? buttonTextSize;
  final bool? isBold;
  final bool? animate;

  /// widgetOnBrandedSurface = true shows onPrimary coloured button on Primary canvas
  /// widgetOnBrandedSurface = false shows primary coloured button on non primary canvas
  final bool widgetOnBrandedSurface;

  const ButtonPrimary({
    Key? key,
    this.onTap,
    required this.text,
    this.textColor,
    this.buttonColor,
    this.radius = -1,
    this.elevation = -1,
    this.icon,
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
    this.animate = true,
  }) : super(key: key);

  @override
  State<ButtonPrimary> createState() => _ButtonPrimaryState();
}

class _ButtonPrimaryState extends State<ButtonPrimary> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final buttonColours =
        Theme.of(context).extension<AppliedButton>() ?? const AppliedButton();
    final textIconColours =
        Theme.of(context).extension<AppliedTextIcon>() ??
        const AppliedTextIcon();

    var backgroundColor = buttonColours.primaryDefault;
    var foregroundColor = textIconColours.inversePrimary;
    var disabledBackgroundColor = buttonColours.primaryDisabled;
    var disabledForegroundColor = textIconColours.inversePrimary;

    if (widget.isNegative) {
      backgroundColor = buttonColours.dangerDefault;
      foregroundColor = textIconColours.inversePrimary;
      disabledBackgroundColor = buttonColours.dangerDisabled;
      disabledForegroundColor = textIconColours.inversePrimary;
    } else if (widget.isNeutral) {
      backgroundColor = buttonColours.neutralDefault;
      foregroundColor = textIconColours.inversePrimary;
      disabledBackgroundColor = buttonColours.neutralDisabled;
      disabledForegroundColor = textIconColours.inversePrimary;
    }

    if (widget.widgetOnBrandedSurface) {
      var oldBackGround = backgroundColor;
      backgroundColor = foregroundColor;
      foregroundColor = oldBackGround;

      var oldDisbledBackground = disabledBackgroundColor;
      disabledBackgroundColor = disabledForegroundColor.withOpacity(0.4);
      disabledForegroundColor = oldDisbledBackground.withOpacity(1.0);
    }

    final textUsed = TextFormatter.formatStringFromFontCasing(widget.text);

    return widget.expand
        ? SizedBox(
            width: double.infinity,
            child: buttonBody(
              context: context,
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              disabledBackgroundColor: disabledBackgroundColor,
              disabledForegroundColor: disabledForegroundColor,
              textUsed: textUsed,
            ),
          )
        : buttonBody(
            context: context,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            disabledBackgroundColor: disabledBackgroundColor,
            disabledForegroundColor: disabledForegroundColor,
            textUsed: textUsed,
          );
  }

  Widget buttonBody({
    required BuildContext context,
    required Color backgroundColor,
    required Color foregroundColor,
    required Color disabledBackgroundColor,
    required Color disabledForegroundColor,
    required String textUsed,
  }) {
    bool isEnabled = widget.onTap != null && !widget.disabled;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: (widget.elevation == -1)
            ? AppVariables.appDefaultElevation
            : widget.elevation,
        shape: widget.radius != -1
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppVariables.appDefaultRadius,
                ),
              )
            : null,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        disabledBackgroundColor: disabledBackgroundColor,
        disabledForegroundColor: disabledForegroundColor,
        alignment: Alignment.center,
        padding: EdgeInsets.zero,
      ),
      onPressed: isEnabled ? () => widget.onTap!(context) : null,
      child: widget.layoutVertically
          ? verticalLayout(
              context: context,
              foregroundColor: foregroundColor,
              textUsed: textUsed,
            )
          : horizontalLayout(
              context: context,
              foregroundColor: foregroundColor,
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
        Icon(widget.icon),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.center,
          child: getTextWidget(
            context,
            textUsed,
            foregroundColor,
            2,
            widget.isBold ?? true,
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
        if (widget.leftIcon != null) Icon(widget.leftIcon),
        if (widget.icon != null) Icon(widget.icon),
        if (textUsed.isNotEmpty)
          Flexible(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: getTextWidget(
                context,
                textUsed,
                foregroundColor,
                1,
                widget.isBold ?? true,
              ),
            ),
          ),
        if (widget.rightIcon != null) Icon(widget.rightIcon),
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
    switch (widget.buttonTextSize) {
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

enum PrimaryButtonTextSize { xSmall, small, medium, large }
