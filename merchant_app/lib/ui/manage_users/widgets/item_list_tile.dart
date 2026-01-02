import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/icons/right_indicator.dart';

import '../../../app/theme/applied_system/applied_surface.dart';
import '../../../app/theme/applied_system/applied_text_icon.dart';

class ItemListTile extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget trailingIcon;
  final TextStyle? titleTextStyle;
  final Color? backgroundColor;
  final bool displayTrailingIcon;

  const ItemListTile({
    Key? key,
    required this.title,
    this.onTap,
    this.leading,
    this.backgroundColor,
    this.subtitle,
    this.titleTextStyle,
    this.trailingIcon = const ArrowForward(),
    this.displayTrailingIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tileColor = Theme.of(context).extension<AppliedSurface>()?.primary;
    final titleColor = Theme.of(context).extension<AppliedTextIcon>()?.primary;
    final subTitleColor = Theme.of(
      context,
    ).extension<AppliedTextIcon>()?.secondary;
    return ListTile(
      tileColor: tileColor,
      leading: leading,
      title: context.labelSmall(
        title,
        color: titleColor,
        alignLeft: true,
        isBold: true,
      ),
      subtitle: subtitle != null
          ? context.labelXSmall(
              subtitle!,
              color: subTitleColor,
              alignLeft: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            )
          : null,
      trailing: displayTrailingIcon ? trailingIcon : null,
      onTap: onTap,
    );
  }
}
