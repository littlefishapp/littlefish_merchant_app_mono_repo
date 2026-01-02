// flutter imports
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';

// project imports
import 'package:littlefish_merchant/app/theme/typography.dart';

class InfoSummaryRow extends StatelessWidget {
  final String _leading, _trailing;
  final EdgeInsetsGeometry? _padding, _margin;
  final TextStyle? _leadingTextStyle, _trailingTextStyle;
  final Color? _trailingColor;

  const InfoSummaryRow({
    super.key,
    required String leading,
    required String trailing,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    TextStyle? leadingTextStyle,
    TextStyle? trailingTextStyle,
    Color? trailingColor,
  }) : _leading = leading,
       _trailing = trailing,
       _margin = margin,
       _padding = padding,
       _leadingTextStyle = leadingTextStyle,
       _trailingTextStyle = trailingTextStyle,
       _trailingColor = trailingColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: _margin,
      padding: _padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _getText(
              text: _leading,
              context: context,
              style: _leadingTextStyle,
              alignLeft: true,
            ),
          ),
          Expanded(
            child: _getText(
              text: _trailing,
              context: context,
              style: _trailingTextStyle,
              alignRight: true,
              textColor: _trailingColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getText({
    required String text,
    required BuildContext context,
    TextStyle? style,
    bool alignLeft = false,
    bool alignRight = false,
    Color? textColor,
  }) {
    if (style != null) {
      return Align(
        alignment: alignLeft
            ? Alignment.centerLeft
            : alignRight
            ? Alignment.centerRight
            : Alignment.center,
        child: Text(text, style: style),
      );
    } else {
      return textColor != null
          ? context.labelSmall(
              text,
              color: textColor,
              alignLeft: alignLeft,
              alignRight: alignRight,
              isBold: true,
            )
          : context.paragraphMedium(
              text,
              color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
              alignLeft: alignLeft,
              alignRight: alignRight,
            );
    }
  }
}
