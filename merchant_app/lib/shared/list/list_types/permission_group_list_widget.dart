//flutter imports
import 'package:flutter/material.dart';
//project imports
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/controls/control_check_box.dart';
import 'package:littlefish_merchant/models/permissions/permission.dart';
import 'package:littlefish_merchant/models/permissions/permission_group.dart';
import 'package:littlefish_merchant/ui/business/roles/permission_vm.dart';
import 'package:littlefish_merchant/ui/business/roles/role_tools.dart';
import 'package:littlefish_merchant/ui/business/roles/widgets/permissions_list_view.dart';

import '../../../app/theme/applied_system/applied_surface.dart';
import '../../../app/theme/applied_system/applied_text_icon.dart';

class PermissionGroupListWidget extends StatefulWidget {
  final List<PermissionGroup?> permissionGroups;
  final PermissionVM vm;

  const PermissionGroupListWidget({
    Key? key,
    required this.vm,
    required this.permissionGroups,
  }) : super(key: key);

  @override
  State<PermissionGroupListWidget> createState() =>
      _PermissionGroupListWidgetState();
}

class _PermissionGroupListWidgetState extends State<PermissionGroupListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).extension<AppliedSurface>()?.primary,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext ctx, int index) {
          List<Permission?> permissions = widget.vm.items!
              .where(
                (element) =>
                    element!.permissionGroupId ==
                    widget.permissionGroups[index]!.id,
              )
              .toList();

          List<String?> permissionIds = permissions
              .map((permission) => permission!.id)
              .toList();
          if (widget.vm.currentBusinessRole?.systemRole == false) {
            if (widget.permissionGroups[index]!.name == 'Users and Roles') {
              return const SizedBox.shrink();
            }
          }

          return ExpansionTile(
            title: context.paragraphMedium(
              widget.permissionGroups[index]!.name ?? '',
              color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
              alignLeft: true,
              isSemiBold: true,
            ),
            subtitle: context.paragraphSmall(
              widget.permissionGroups[index]!.description ?? '',
              color: Theme.of(
                context,
              ).extension<AppliedTextIcon>()?.secondary.withOpacity(0.5),
              alignLeft: true,
            ),
            leading: ControlCheckBox(
              partial:
                  checkAllPermissionsSelected(widget.vm, permissionIds) ==
                  false,
              isSelected: checkPermissions(widget.vm, permissionIds),
              onChanged: (bool value) {
                if (widget.vm.currentBusinessRole?.systemRole == false) {
                  widget.vm.updateBusinessRolePermissions!(
                    permissionIds,
                    value,
                  );
                }
              },
            ),
            iconColor: Theme.of(
              context,
            ).extension<AppliedTextIcon>()?.secondary,
            children: [
              PermissionListView(
                permissions: widget.vm.items!,
                permissionGroupId: widget.permissionGroups[index]!.id,
                vm: widget.vm,
              ),
            ],
          );
        },
        itemCount: widget.permissionGroups.length,
      ),
    );
  }
}
