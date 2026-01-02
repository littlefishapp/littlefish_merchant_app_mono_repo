import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

import '../../../../app/theme/applied_system/applied_text_icon.dart';

class SummaryHeader extends StatelessWidget {
  const SummaryHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: context.headingXSmall(
          'Summary',
          color: Theme.of(context).extension<AppliedTextIcon>()?.emphasized,
          isBold: true,
          alignLeft: true,
        ),
      ),
    );
  }
}
