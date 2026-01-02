import 'package:flutter/material.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';

class ReceiptButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function onPressed;

  final double? buttonHeight;
  final double? buttonWidth;
  final double? iconSize;
  final double? fontSize;
  final double? buttonOpacity;
  final double? buttonTextGap;
  final double? buttonPadding;
  final Color? buttonColor;
  final Color? textColor;
  final Color? iconColor;
  final Color? backgroundColor;
  final FontWeight? fontWeight;

  const ReceiptButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.buttonHeight = 48.0,
    this.buttonWidth = 48.0,
    this.iconSize = 24.0,
    this.fontSize = 12.0,
    this.buttonColor,
    this.textColor,
    this.iconColor,
    this.buttonTextGap = 8.0,
    this.buttonPadding = 8.0,
    this.buttonOpacity = 1.0,
    this.fontWeight = FontWeight.w500,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textUsed = TextFormatter.formatStringFromFontCasing(label);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: Colors.transparent,
          width: buttonWidth,
          height: buttonHeight,
          child: ElevatedButton(
            onPressed: onPressed as void Function(),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  backgroundColor ?? Theme.of(context).colorScheme.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              disabledBackgroundColor: Theme.of(context).colorScheme.secondary,
              padding: EdgeInsets.zero,
              elevation: 0,
            ),
            child: Icon(
              icon,
              color: iconColor ?? Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        SizedBox(height: buttonTextGap),
        Text(
          textUsed,
          style: TextStyle(
            color: textColor ?? Theme.of(context).colorScheme.secondary,
            fontSize: fontSize ?? 14.0,
            fontWeight: fontWeight ?? FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
