import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

class LongText extends StatelessWidget {
  final String? displayText;
  final FontWeight? fontWeight;
  final double? fontSize;
  final TextAlign alignment;
  final Color? textColor;
  final int maxLines;

  const LongText(
    this.displayText, {
    Key? key,
    this.fontWeight = FontWeight.normal,
    this.fontSize = 12,
    this.alignment = TextAlign.start,
    this.textColor = Colors.grey,
    this.maxLines = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return context.labelXSmall(
      displayText ?? '',
      maxLines: maxLines,
      alignLeft: true,
      overflow: TextOverflow.ellipsis,
    );
  }
}
