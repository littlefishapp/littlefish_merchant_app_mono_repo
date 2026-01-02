//Flutter Imports

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/icons/right_indicator.dart';
//Project Imports
import 'package:littlefish_merchant/models/permissions/business_role.dart';
import 'package:littlefish_merchant/ui/business/roles/permission_vm.dart';
import 'package:littlefish_merchant/ui/manage_users/widgets/item_list_tile.dart';

class RoleListWidget extends StatelessWidget {
  final List<BusinessRole?> businessRoles;
  final PermissionVM vm;
  final Function(BusinessRole, BuildContext)? onTap;
  final Function(BusinessRole, BuildContext)? trailingOnTap;

  const RoleListWidget({
    Key? key,
    required this.businessRoles,
    required this.vm,
    required this.onTap,
    required this.trailingOnTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext ctx, int index) {
        final role = businessRoles[index];
        if (role?.systemRole == true && role?.name == 'Guest Cashier') {
          return const SizedBox();
        }

        return ItemListTile(
          title: role?.name ?? '',
          subtitle: role?.description ?? '',
          onTap: onTap != null
              ? () {
                  onTap!(businessRoles[index]!, ctx);
                }
              : null,
          leading: Container(
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
              child: context.labelLarge(
                (role?.name?.padRight(2, ' ') ?? '??')
                    .substring(0, 2)
                    .toUpperCase(),
                isSemiBold: true,
              ),
            ),
          ),
          trailingIcon: const ArrowForward(),
        );
      },
      itemCount: businessRoles.length,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 8),
    );
  }
}
