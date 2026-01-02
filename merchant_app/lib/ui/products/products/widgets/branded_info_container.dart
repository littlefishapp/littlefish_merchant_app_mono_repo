import 'package:flutter/material.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

class BrandedInfoContainer extends StatelessWidget {
  final String title;
  final String description;
  final IconData? icon;
  const BrandedInfoContainer({
    super.key,
    required this.title,
    required this.description,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final iconData = icon ?? LittleFishIcons.info;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).extension<AppliedSurface>()?.positiveSubTitle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              Theme.of(context).extension<AppliedTextIcon>()?.brand ??
              Colors.green.shade300,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            iconData,
            color: Theme.of(context).extension<AppliedTextIcon>()?.brand,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                context.labelXSmall(
                  title,
                  color: Theme.of(context).extension<AppliedTextIcon>()?.brand,
                  isBold: true,
                ),
                const SizedBox(height: 2),
                context.paragraphSmall(
                  description,
                  color: Theme.of(context).extension<AppliedTextIcon>()?.brand,
                  alignLeft: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
