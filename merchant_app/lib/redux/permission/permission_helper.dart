//Project Imports
import 'package:littlefish_merchant/models/permissions/business_role.dart';
import 'package:littlefish_merchant/models/permissions/permission.dart';
import 'package:littlefish_merchant/redux/permission/permission_state.dart';

class PermissionHelper {
  static List<Permission> getPermissionsByRole(
    PermissionState state,
    String roleId,
  ) {
    List<String> permissionIds = getPermissionIdsByRoleId(state, roleId);
    List<Permission> permissions = getPermissionsByID(state, permissionIds);
    return permissions;
  }

  static List<String> getPermissionIdsByRoleId(
    PermissionState state,
    String roleId,
  ) {
    BusinessRole role = state.roles!.firstWhere(
      (element) => element.id == roleId,
    );
    return role.permissions ?? <String>[];
  }

  static List<Permission> getPermissionsByID(
    PermissionState state,
    List<String> permissionIds,
  ) {
    List<Permission> permissions = [];
    for (String permissionId in permissionIds) {
      permissions.add(
        state.permissions!.firstWhere((element) => element.id == permissionId),
      );
    }
    return permissions;
  }
}
