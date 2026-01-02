//flutter imports
import 'package:flutter/material.dart';
//project imports
import 'package:littlefish_merchant/common/presentaion/components/controls/control_check_box.dart';
import 'package:littlefish_merchant/models/permissions/permission.dart';
import 'package:littlefish_merchant/shared/constants/permission_name_constants.dart';
import 'package:littlefish_merchant/ui/business/roles/permission_vm.dart';
import 'package:littlefish_merchant/ui/business/roles/role_tools.dart';
import 'package:littlefish_merchant/ui/manage_users/widgets/item_list_tile.dart';

class PermissionListWidget extends StatefulWidget {
  final List<Permission?> permissions;
  final PermissionVM vm;
  final Function(Permission, BuildContext)? onTap;
  final Function(List<Permission>?, bool?)? leadingOnTap;

  const PermissionListWidget({
    Key? key,
    required this.permissions,
    required this.vm,
    required this.onTap,
    required this.leadingOnTap,
  }) : super(key: key);

  @override
  State<PermissionListWidget> createState() => _PermissionListWidgetState();
}

class _PermissionListWidgetState extends State<PermissionListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext ctx, int index) {
          if (widget.vm.currentBusinessRole?.systemRole == false &&
              (widget.permissions[index]!.name == allowUser ||
                  widget.permissions[index]!.name == allowRole)) {
            return const SizedBox.shrink();
          }
          return ItemListTile(
            title: widget.permissions[index]!.description ?? '',
            onTap: widget.onTap != null
                ? () {
                    widget.onTap!(widget.permissions[index]!, ctx);
                  }
                : null,
            leading: ControlCheckBox(
              isSelected: checkPermissions(widget.vm, [
                widget.permissions[index]!.id!,
              ]),
              onChanged: (value) {
                if (widget.leadingOnTap != null) {
                  widget.leadingOnTap!([widget.permissions[index]!], value);
                }
              },
            ),
            trailingIcon: const SizedBox.shrink(),
          );
        },
        itemCount: widget.permissions.length,
      ),
    );
  }
}
