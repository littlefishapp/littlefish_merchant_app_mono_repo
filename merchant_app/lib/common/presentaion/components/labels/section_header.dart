import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

import '../../../../app/theme/applied_system/applied_text_icon.dart';

class SectionHeader extends StatelessWidget {
  final String text;
  final double? horizontalPadding;
  const SectionHeader(this.text, {Key? key, this.horizontalPadding})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
        horizontal: (horizontalPadding ?? 0),
        vertical: 16,
      ),
      child: context.headingXSmall(
        text,
        color: Theme.of(context).extension<AppliedTextIcon>()?.emphasized,
        isBold: true,
      ),
    );
  }
}
