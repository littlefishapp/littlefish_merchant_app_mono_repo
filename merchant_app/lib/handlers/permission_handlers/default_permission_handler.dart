import 'dart:async';
import 'package:collection/collection.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';

import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/handlers/interfaces/permission_handler.dart';

import '../../models/permissions/business_user_role.dart';
import '../../models/permissions/permission.dart';
import '../../redux/permission/permission_action.dart';

class DefaultPermissionHandler implements PermissionHandler {
  DefaultPermissionHandler();

  LittleFishCore core = LittleFishCore.instance;

  LoggerService get logger => core.get<LoggerService>();

  List<Permission> _loggedInUserPermissions = [];

  List<Permission> _allPermissions = [];

  @override
  bool hasPermission(String permissionName) {
    //  return true; // TODO(lampian): use for override on permission
    if (_allPermissions.isEmpty) {
      _allPermissions = _getAllPermissionsFromState();

      if (_allPermissions.isEmpty) {
        logger.warning(this, 'Permissions warning: No permissions found');
        return false;
      }
    }

    final bool permissionExists = _allPermissions.any(
      (perm) => perm.name == permissionName,
    );

    if (!permissionExists) {
      logger.warning(
        this,
        'Permission Error: Permission with permission name $permissionName does not exist or is disabled',
      );
      return false;
    }

    final Permission permission = _allPermissions.firstWhere(
      (perm) => perm.name == permissionName,
    );

    if (_loggedInUserPermissions.isEmpty) {
      _loggedInUserPermissions = _getUserPermissionsFromState();

      if (_loggedInUserPermissions.isEmpty) {
        logger.warning(this, 'No permissions found for the logged in user');
        return false;
      }
    }

    final bool doesUserHavePermission = _loggedInUserPermissions.any(
      (perm) => perm.id == permission.id,
    );

    return doesUserHavePermission;
  }

  @override
  Future<void> populatePermissionData({roleId}) async {
    if (roleId != null) {
      Completer completer = Completer();
      AppVariables.store?.dispatch(
        updateUserPermissionsByRoleId(
          roleId,
          refresh: true,
          completer: completer,
        ),
      );

      await completer.future;
    }

    _allPermissions = _getAllPermissionsFromState();

    _loggedInUserPermissions = _getUserPermissionsFromState();
  }

  List<Permission> _getUserPermissionsFromState() {
    final userPermissions =
        AppVariables.store?.state.permissionState.userPermissions ?? [];

    return userPermissions;
  }

  List<Permission> _getAllPermissionsFromState() {
    final allPermissions =
        AppVariables.store?.state.permissionState.permissions ?? [];

    return allPermissions;
  }

  @override
  bool hasRole(String roleName) {
    BusinessUserRole? userRole =
        AppVariables.store?.state.userState.userBusinessRoles?.firstOrNull;

    if (userRole == null) {
      reportCheckedError(
        'Permission Error: User does not have the $roleName role',
      );
      return false;
    }

    return AppVariables.store?.state.permissionState.roles
            ?.where(
              (element) =>
                  element.name?.toLowerCase() == roleName.toLowerCase() &&
                  element.id == userRole.roleId,
            )
            .isNotEmpty ??
        false;
  }
}
