import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/models/assets/app_assets.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';

import '../../../../app/theme/applied_system/applied_button.dart';
import '../../../../app/theme/applied_system/applied_surface.dart';
import '../icons/error_icon.dart';

class ButtonText extends StatelessWidget {
  final Function(BuildContext context)? onTap;
  final String text;
  final bool disabled;
  final bool upperCase;
  final Color? textColor;
  final dynamic icon;
  final double radius, elevation;
  final bool expand;
  final bool layoutVertically;
  final bool isNegative;
  final bool isNeutral;
  final dynamic leftIcon;
  final dynamic rightIcon;
  final bool widgetOnBrandedSurface;

  const ButtonText({
    Key? key,
    this.onTap,
    required this.text,
    this.textColor,
    this.radius = 6.0,
    this.elevation = 0,
    this.icon,
    this.disabled = false,
    this.upperCase = false,
    this.widgetOnBrandedSurface = false,
    this.expand = false,
    this.layoutVertically = false,
    this.isNegative = false,
    this.isNeutral = false,
    this.leftIcon,
    this.rightIcon,
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
      disabledForegroundColor = buttonColours.dangerDisabled;
    }

    if (widgetOnBrandedSurface) {
      foregroundColor = surfaceColours.primary;
      disabledForegroundColor = surfaceColours.secondary;
    }

    final textUsed = TextFormatter.formatStringFromFontCasing(text);

    return expand
        ? Expanded(
            child: buttonBody(
              context: context,
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              disabledBackgroundColor: disabledBackgroundColor,
              disabledForegroundColor: disabledForegroundColor,
              textUsed: textUsed,
              disabled: disabled,
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
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: elevation,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        disabledBackgroundColor: disabledBackgroundColor,
        disabledForegroundColor: disabledForegroundColor,
        alignment: Alignment.center,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      onPressed: disabled
          ? null
          : () => onTap == null
                ? showComingSoon(context: context, description: 'Button: $text')
                : onTap!(context),
      child: layoutVertically
          ? verticalLayout(
              context: context,
              foregroundColor: disabled
                  ? disabledForegroundColor
                  : foregroundColor,
              textUsed: textUsed,
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
        Center(child: Icon(icon, color: foregroundColor)),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.center,
          child: context.paragraphLarge(
            textUsed,
            color: foregroundColor,
            isBold: true,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
        if (leftIcon != null) _buildIcon(context, icon, foregroundColor),
        if (icon != null) _buildIcon(context, icon, foregroundColor),
        if (textUsed.isNotEmpty)
          Flexible(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: context.paragraphLarge(
                textUsed,
                color: foregroundColor,
                isBold: true,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        if (rightIcon != null) _buildIcon(context, icon, foregroundColor),
      ],
    );
  }

  Widget _buildIcon(BuildContext context, dynamic iconData, Color iconColor) {
    Widget iconWidget = const SizedBox.shrink();
    if (iconData is IconData) {
      iconWidget = Icon(iconData, color: iconColor);
    } else if (iconData is String && iconData.contains('.svg')) {
      iconWidget = SvgPicture.asset(
        iconData,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      );
    } else if (iconData is String && iconData.contains('.png')) {
      iconWidget = ImageIcon(
        const AssetImage(AppAssets.barcodeScannerPng),
        size: 24,
        color: iconColor,
      );
    } else {
      iconWidget = ErrorIcon(color: iconColor);
    }

    return iconWidget;
  }
}
