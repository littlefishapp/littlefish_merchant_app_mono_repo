import 'package:flutter/material.dart';

import '../../../app/theme/applied_system/applied_text_icon.dart';

class TextTag extends StatelessWidget {
  final String displayText;
  final Color? color;
  final double? fontSize;
  final FontWeight fontWeight;
  final Alignment? alignment;
  final String? fontFamily;

  const TextTag({
    Key? key,
    required this.displayText,
    this.color,
    this.fontSize,
    this.fontWeight = FontWeight.bold,
    this.alignment,
    this.fontFamily,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color:
              Theme.of(context).extension<AppliedTextIcon>()?.primary ??
              Colors.red,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      child: Text(
        displayText.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize ?? 12.0,
          color: Theme.of(context)
              .extension<AppliedTextIcon>()
              ?.secondary, // fontFamily: fontFamily ??  UIStateData.primaryFontFamily,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
