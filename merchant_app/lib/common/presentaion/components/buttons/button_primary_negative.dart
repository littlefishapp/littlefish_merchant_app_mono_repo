import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';

// TODO(lampian): rework to ensure null onTap  is the disabled
class ButtonPrimaryNegative extends StatelessWidget {
  final Function(BuildContext context)? onTap;
  final String text;
  final bool disabled;
  final bool upperCase;
  final Color? textColor, buttonColor;
  final IconData? icon;
  final double radius, elevation;
  final bool expand;

  /// widgetOnBrandedSurface = true shows onPrimary coloured button on Primary canvas
  /// widgetOnBrandedSurface = fasle shows primary coloured button on non primary canvas
  final bool widgetOnBrandedSurface;

  const ButtonPrimaryNegative({
    Key? key,
    this.onTap,
    required this.text,
    this.textColor,
    this.buttonColor,
    this.radius = 6.0,
    this.elevation = 2.0,
    this.icon,
    this.disabled = false,
    this.upperCase = true,
    this.widgetOnBrandedSurface = false,
    this.expand = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var backgroundColor = Theme.of(context).colorScheme.error;
    var foregroundColor = Theme.of(context).colorScheme.onPrimary;
    var disabledBackgroundColor = Theme.of(
      context,
    ).colorScheme.error.withOpacity(0.40);
    var disabledForegroundColor = Theme.of(
      context,
    ).colorScheme.onError.withOpacity(1.0);
    if (widgetOnBrandedSurface) {
      backgroundColor = Theme.of(context).colorScheme.onError;
      foregroundColor = Theme.of(context).colorScheme.error;
      disabledBackgroundColor = Theme.of(
        context,
      ).colorScheme.onError.withOpacity(1.0);
      disabledForegroundColor = Theme.of(
        context,
      ).colorScheme.error.withOpacity(0.40);
    }

    final textUsed = TextFormatter.formatStringFromFontCasing(text);

    return expand
        ? SizedBox(
            width: double.infinity,
            child: elevatedButton(
              backgroundColor,
              foregroundColor,
              disabledBackgroundColor,
              disabledForegroundColor,
              context,
              textUsed,
            ),
          )
        : elevatedButton(
            backgroundColor,
            foregroundColor,
            disabledBackgroundColor,
            disabledForegroundColor,
            context,
            textUsed,
          );
  }

  ElevatedButton elevatedButton(
    Color backgroundColor,
    Color foregroundColor,
    Color disabledBackgroundColor,
    Color disabledForegroundColor,
    BuildContext context,
    String textUsed,
  ) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      elevation: elevation,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      disabledBackgroundColor: disabledBackgroundColor,
      disabledForegroundColor: disabledForegroundColor,
      padding: EdgeInsets.zero,
    ),

    onPressed: disabled
        ? null
        : () => onTap == null
              ? showComingSoon(
                  context: context,
                  description: 'Button: $textUsed',
                )
              : onTap!(context),
    child: icon == null
        ? context.button01x16B(
            upperCase ? textUsed.toUpperCase() : textUsed,
            color: textColor ?? foregroundColor,
          )
        : textUsed.isEmpty
        ? Icon(icon)
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: context.button01x16B(
                  textUsed,
                  color: textColor ?? foregroundColor,
                ),
              ),
              if (textUsed.isNotEmpty) const SizedBox(width: 8),
              Icon(icon, color: Theme.of(context).colorScheme.onError),
            ],
          ),
  );
}
