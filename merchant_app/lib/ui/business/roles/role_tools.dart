import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/models/permissions/business_role.dart';
import 'package:littlefish_merchant/ui/business/roles/permission_vm.dart';

import '../../customers/widgets/customer_list.dart';

bool checkPermissions(PermissionVM vm, List<String?> permissionIds) {
  if (permissionIds.isEmpty) {
    return false;
  }

  for (String? id in permissionIds) {
    if (!vm.currentBusinessRole!.permissions!.contains(id)) {
      return false;
    }
  }
  return true;
}

bool checkAllPermissionsSelected(PermissionVM vm, List<String?> permissionIds) {
  if (permissionIds.isEmpty) {
    return true;
  }
  int count = 0;
  for (String? id in permissionIds) {
    if (vm.currentBusinessRole!.permissions!.contains(id)) {
      count += 1;
    }
  }
  if (count < permissionIds.length && count > 0) {
    return false;
  }
  return true;
}

Builder infoAction<E>(
  PermissionVM vm,
  BuildContext context,
  BusinessRole role, {
  required Function(E, BuildContext)? onTap,
  required Function(E, BuildContext?)? trailingOnTap,
}) => Builder(
  builder: (ctx) => Padding(
    padding: const EdgeInsets.only(right: 6),
    child: DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: Icon(
          Icons.more_vert,
          color: Theme.of(context).colorScheme.primary,
        ),
        items: const [
          DropdownMenuItem(
            value: MenuItem(text: 'Edit Role'),
            child: Text('Edit Role'),
          ),
          DropdownMenuItem(
            value: MenuItem(text: 'Delete Role'),
            child: Text('Delete Role'),
          ),
        ],
        onChanged: (value) async {
          if (value == const MenuItem(text: 'Edit Role')) {
            onTap!(role as E, ctx);
          }
          if (value == const MenuItem(text: 'Delete Role')) {
            trailingOnTap!(role as E, context);
          }
        },
        dropdownStyleData: const DropdownStyleData(maxHeight: 150, width: 200),
      ),
    ),
  ),
);
