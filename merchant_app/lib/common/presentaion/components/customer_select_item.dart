// removed ignore: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:quiver/strings.dart';

class CustomerSelectItem extends StatelessWidget {
  const CustomerSelectItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.id,
    this.trailingIcon,
    required this.onTap,
    this.showCancel = false,
    this.selected = false,
    this.imageUrl = '',
    this.showTrailingIcon = true,
    this.showAdd = false,
    this.item,
  });

  final String title;
  final String subtitle;
  final Icon? trailingIcon;
  final String id;
  final Customer? item;

  final Function()? onTap;
  final bool showCancel;
  final bool showAdd;
  final bool selected;
  final String imageUrl;
  final bool showTrailingIcon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      tileColor: Theme.of(context).extension<AppliedSurface>()?.primary,
      leading: isNotBlank(item?.profileImageUri)
          ? ListLeadingImageTile(url: item?.profileImageUri)
          : Container(
              width: AppVariables.appDefaultlistItemSize,
              height: AppVariables.appDefaultlistItemSize,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).extension<AppliedSurface>()?.brandSubTitle,
                border: Border.all(color: Colors.transparent, width: 1),
                borderRadius: BorderRadius.circular(
                  AppVariables.appDefaultRadius,
                ),
              ),
              child: Center(
                child: id.isEmpty
                    ? const Icon(Icons.add)
                    : context.labelLarge(
                        (item?.displayName ?? '??')
                            .substring(0, 2)
                            .toUpperCase(),
                        isSemiBold: true,
                      ),
              ),
            ),
      title: context.labelSmall(
        title,
        isBold: true,
        alignLeft: true,
        color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
      ),
      subtitle: context.labelXSmall(
        subtitle,
        alignLeft: true,
        color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
      ),
      trailing: showTrailingIcon
          ? Icon(
              Platform.isIOS
                  ? Icons.arrow_forward_ios_outlined
                  : Icons.arrow_forward,
            )
          : const SizedBox(),
    );
  }
}
