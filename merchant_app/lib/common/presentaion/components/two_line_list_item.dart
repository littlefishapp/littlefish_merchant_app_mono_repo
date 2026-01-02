// removed ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

class TwoLineListItem extends StatelessWidget {
  const TwoLineListItem({
    super.key,
    this.leadingIcon,
    this.title = '',
    this.subtitle = '',
    this.trailingIcon,
    this.onTap,
    this.showShevron = true,
    this.showTrailingIcon = true,
  });

  final IconData? leadingIcon;
  final String title;
  final String subtitle;
  final IconData? trailingIcon;
  final void Function()? onTap;
  final bool showShevron;
  final bool showTrailingIcon;

  @override
  Widget build(BuildContext context) {
    late IconData? trailingIconUsed;
    if (showShevron) {
      trailingIconUsed = Icons.chevron_right;
    } else {
      trailingIconUsed = trailingIcon;
    }

    return ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      dense: true,
      leading: Icon(
        leadingIcon,
        color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
      ),
      title: context.labelMedium(
        title,
        alignLeft: true,
        isBold: true,
        color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
      ),
      subtitle: context.labelSmall(
        subtitle,
        isSemiBold: false,
        color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
        alignLeft: true,
      ),
      onTap: onTap,
      trailing: Icon(
        trailingIconUsed,
        color: Theme.of(context).extension<AppliedTextIcon>()?.emphasized,
      ),
    );
  }
}
