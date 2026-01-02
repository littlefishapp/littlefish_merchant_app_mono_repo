import 'package:flutter/material.dart';
import '../../../app/theme/applied_system/applied_text_icon.dart';

class DecoratedText extends StatelessWidget {
  final String? displayText;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Alignment alignment;
  final Color? textColor;
  final TextDecoration decoration;
  final TextDecorationStyle? decorationStyle;
  final int? maxLines;

  const DecoratedText(
    this.displayText, {
    Key? key,
    this.fontWeight = FontWeight.normal,
    this.fontSize = 12.0,
    this.alignment = Alignment.topLeft,
    this.textColor,
    this.decoration = TextDecoration.none,
    this.decorationStyle,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      child: Text(
        displayText!,
        style: TextStyle(
          color:
              textColor ??
              Theme.of(context).extension<AppliedTextIcon>()?.emphasized,
          //fontFamily: UIStateData.primaryFontFamily,
          fontStyle: FontStyle.normal,
          fontWeight: fontWeight,
          fontSize: fontSize,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines,
      ),
    );
  }
}
