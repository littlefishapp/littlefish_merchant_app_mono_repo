import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

class HeadingText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final double fontSize;
  final Color colour;

  const HeadingText({
    Key? key,
    required this.text,
    this.fontSize = 16,
    this.textStyle,
    this.padding,
    this.colour = const Color(0xFF1F1F21),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(top: 16, bottom: 8),
      child: context.labelSmall(text, alignLeft: true),
    );
  }
}

class DescriptionText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;

  const DescriptionText({
    Key? key,
    required this.text,
    this.textStyle,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: context.body02x14R(
        text,
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
      ),
    );
  }
}

class PageNumberText extends StatelessWidget {
  final int pageNumber;
  final int totalNumPages;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;

  const PageNumberText({
    Key? key,
    required this.pageNumber,
    required this.totalNumPages,
    this.textStyle,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        '$pageNumber/$totalNumPages',
        textAlign: TextAlign.left,
        style:
            textStyle ??
            TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSecondary,
              //fontFamily: UIStateData.primaryFontFamily,
            ),
      ),
    );
  }
}
