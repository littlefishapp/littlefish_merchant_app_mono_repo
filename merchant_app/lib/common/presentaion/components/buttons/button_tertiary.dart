import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';

import '../../../../app/theme/applied_system/applied_button.dart';
import '../icons/error_icon.dart';

class ButtonTertiary extends StatelessWidget {
  final Function(BuildContext context)? onTap;
  final String text;
  final bool disabled;
  final bool upperCase;
  final Color? textColor;
  final Color? buttonColor;
  final dynamic icon;
  final double radius, elevation;
  final bool isExpanded;
  final bool layoutVertically;
  final bool isNegative;
  final bool isNeutral;
  final dynamic leftIcon;
  final dynamic rightIcon;

  const ButtonTertiary({
    super.key,
    this.onTap,
    required this.text,
    this.textColor,
    this.buttonColor,
    this.radius = 6.0,
    this.elevation = 0,
    this.icon,
    this.disabled = false,
    this.upperCase = false,
    this.isExpanded = false,
    this.layoutVertically = false,
    this.isNegative = false,
    this.isNeutral = false,
    this.leftIcon,
    this.rightIcon,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColours =
        Theme.of(context).extension<AppliedButton>() ?? const AppliedButton();

    var backgroundColor = buttonColours.primaryTertiary;
    var foregroundColor = buttonColours.primaryDefault;
    var disabledBackgroundColor = buttonColours.primaryTertiary;
    var disabledForegroundColor = buttonColours.primaryDisabled;

    if (isNegative) {
      backgroundColor = buttonColours.dangerTertiary;
      foregroundColor = buttonColours.dangerDefault;
      disabledBackgroundColor = buttonColours.dangerTertiary;
      disabledForegroundColor = buttonColours.dangerDisabled;
    } else if (isNeutral) {
      backgroundColor = buttonColours.neutralTertiary;
      foregroundColor = buttonColours.neutralDefault;
      disabledBackgroundColor = buttonColours.neutralTertiary;
      disabledForegroundColor = buttonColours.neutralDisabled;
    }

    final textUsed = TextFormatter.formatStringFromFontCasing(text);

    return isExpanded
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: const BorderSide(color: Colors.transparent, width: 1),
        ),
        disabledBackgroundColor: disabledBackgroundColor,
        disabledForegroundColor: disabledForegroundColor,
        alignment: Alignment.center,
        padding: EdgeInsets.zero,
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
        Icon(icon, color: foregroundColor),
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
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leftIcon != null) _buildIcon(context, leftIcon, foregroundColor),
        if (icon != null) _buildIcon(context, icon, foregroundColor),
        if (textUsed.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: context.paragraphLarge(
              textUsed,
              color: foregroundColor,
              isBold: true,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (rightIcon != null) _buildIcon(context, rightIcon, foregroundColor),
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
      iconWidget = ImageIcon(AssetImage(iconData), size: 24, color: iconColor);
    } else {
      iconWidget = ErrorIcon(color: iconColor);
    }

    return iconWidget;
  }
}
