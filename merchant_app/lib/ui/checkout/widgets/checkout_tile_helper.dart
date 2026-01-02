import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

import '../../../app/theme/applied_system/applied_text_icon.dart';

class CheckoutTileHelper {
  static Widget buildTitle({
    required BuildContext context,
    required String title,
  }) {
    final appliedTextIconTheme = Theme.of(context).extension<AppliedTextIcon>();
    return context.labelSmall(
      title.length < 25 ? title : '${title.substring(0, 20)}...',
      color: appliedTextIconTheme?.primary,
      alignLeft: true,
      isBold: true,
      overflow: TextOverflow.ellipsis,
    );
  }

  static Widget buildTrailText({
    required BuildContext context,
    required String trailText,
  }) {
    final appliedTextIconTheme = Theme.of(context).extension<AppliedTextIcon>();
    final textColor = appliedTextIconTheme?.primary ?? Colors.red;
    return context.labelXSmall(
      trailText,
      color: textColor,
      alignRight: true,
      overflow: TextOverflow.ellipsis,
    );
  }
}
