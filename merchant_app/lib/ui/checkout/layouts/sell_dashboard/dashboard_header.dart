import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/app_bar_data_set.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/ui/checkout/layouts/sell_dashboard/dash_board_header_info.dart';

class DashboardHeader extends StatelessWidget {
  final DashBoardHeaderInfo info;
  final void Function()? onTap;
  final Widget? additional;
  const DashboardHeader({
    super.key,
    this.additional,
    this.onTap,
    this.info = const DashBoardHeaderInfo(),
  });

  @override
  Widget build(BuildContext context) {
    return headerWidget(context);
  }

  Widget headerWidget(BuildContext context) {
    var fillColorUsed = Theme.of(context).extension<AppliedSurface>()!.primary;
    var inkColorUsed = Theme.of(context).extension<AppliedTextIcon>()!.primary;
    if (info.tileFormat == 'filled') {
      fillColorUsed = getIt.get<AppBarDataSet>().appBarGradientEnd;
      inkColorUsed = Theme.of(
        context,
      ).extension<AppliedTextIcon>()!.inversePrimary;
    }
    return Container(
      color: fillColorUsed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (info.introText.isNotEmpty)
            context.labelSmall(info.introText, color: inkColorUsed),
          const SizedBox(height: 8),
          if (info.titleNormal.isNotEmpty || info.titleBold.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                context.headingSmall(info.titleNormal, color: inkColorUsed),
                context.headingSmall(
                  info.titleBold,
                  color: inkColorUsed,
                  isBold: true,
                ),
              ],
            ),
          if (info.subtitle.isNotEmpty)
            context.labelSmall(
              info.subtitle,
              color: inkColorUsed,
              isBold: true,
            ),
          if (info.subtitle2Left.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                context.labelSmall(
                  info.subtitle2Left,
                  color: inkColorUsed,
                  isLight: true,
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: onTap,
                  child: context.labelSmall(
                    '- ${info.subtitle2Right}',
                    color: inkColorUsed,
                    isBold: true,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
