// removed ignore: depend_on_referenced_packages
//Flutter imports
import 'dart:async';
//package imports
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:collection/collection.dart' show IterableExtension;
//project imports
import 'package:littlefish_merchant/models/permissions/business_role.dart';
import 'package:littlefish_merchant/models/permissions/business_user_role.dart';
import 'package:littlefish_merchant/models/permissions/permission.dart';
import 'package:littlefish_merchant/models/permissions/permission_and_permission_group.dart';
import 'package:littlefish_merchant/models/permissions/permission_group.dart';
import 'package:littlefish_merchant/redux/permission/permission_state.dart';
import 'package:littlefish_merchant/services/permission_service.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';

late PermissionService permissionService;

ThunkAction<AppState> initializePermissionState({
  bool refresh = false,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      var permissionState = store.state.permissionState;

      if (!refresh &&
          (permissionState.permissions?.length ?? 0) > 0 &&
          (permissionState.permissionGroups?.length ?? 0) > 0 &&
          (permissionState.roles?.length ?? 0) > 0) {
        completer?.complete();
        return;
      }

      store.dispatch(PermissionStateLoadingAction(true));

      await permissionService
          .getPermissionsAndPermissionGroups()
          .catchError((e) {
            reportCheckedError(e, trace: StackTrace.current);
            store.dispatch(PermissionStateFailureAction(e.toString()));
            return PermissionAndPermissionGroup();
          })
          .then((result) {
            store.dispatch(
              PermissionLoadedAction(result.permissions ?? <Permission>[]),
            );
            store.dispatch(
              PermissionGroupLoadedAction(
                result.permissionGroups ?? <PermissionGroup>[],
              ),
            );
          });

      await permissionService
          .getBusinessRoles(includeSystemRoles: true)
          .catchError((e) {
            reportCheckedError(e, trace: StackTrace.current);
            store.dispatch(PermissionStateFailureAction(e.toString()));
            return <BusinessRole>[];
          })
          .then((result) {
            store.dispatch(RoleLoadedAction(result ?? <BusinessRole>[]));
          });

      try {
        List<Permission> currentStatePermissions =
            store.state.permissionState.permissions ?? [];
        store.dispatch(const ClearUserPermissionsAction());
        for (BusinessUserRole userRole
            in store.state.userState.userBusinessRoles!) {
          List<Permission> permissions = _getPermissionsByRole(
            store.state.permissionState,
            userRole.roleId!,
          );
          store.dispatch(UserPermissionLoadedAction(permissions));
        }
        List<Permission> permissionsAfterUpdate =
            store.state.permissionState.permissions ?? [];
        if (permissionsAfterUpdate.isEmpty &&
            currentStatePermissions.isNotEmpty) {
          store.dispatch(UserPermissionLoadedAction(currentStatePermissions));
        }
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        store.dispatch(PermissionStateFailureAction(e.toString()));
        completer?.completeError(e);
      }

      store.dispatch(PermissionStateLoadingAction(false));
      completer?.complete();
    });
  };
}

ThunkAction<AppState> getBusinessRoles({Completer? completer}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);
      try {
        store.dispatch(PermissionStateLoadingAction(true));
        var result = await permissionService.getBusinessRoles(
          includeSystemRoles: true,
        );
        store.dispatch(RoleLoadedAction(result ?? <BusinessRole>[]));
        store.dispatch(PermissionStateLoadingAction(false));
        completer?.complete();
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        store.dispatch(PermissionStateFailureAction(e.toString()));
        store.dispatch(PermissionStateLoadingAction(false));
        completer?.completeError(e);
      }
    });
  };
}

ThunkAction<AppState> updateUserPermissionsByRoleId(
  String roleId, {
  bool refresh = false,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      Completer initializePermissionCompleter = Completer();
      initializePermissionState(completer: initializePermissionCompleter);
      await initializePermissionCompleter.future;
      try {
        store.dispatch(PermissionStateLoadingAction(true));
        List<Permission> permissions = _getPermissionsByRole(
          store.state.permissionState,
          roleId,
        );
        store.dispatch(ResetUserPermissionLoadedAction(permissions));
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        store.dispatch(PermissionStateFailureAction(e.toString()));
        store.dispatch(PermissionStateLoadingAction(false));
        completer?.completeError(e);
      }
      if (completer != null) {
        completer.complete();
      }
      store.dispatch(PermissionStateLoadingAction(false));
    });
  };
}

ThunkAction<AppState> addorUpdateBusinessRole({
  required BusinessRole role,
  required bool isNew,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);
      try {
        store.dispatch(PermissionStateLoadingAction(true));
        if (isNew) {
          var result = await permissionService.createBusinessRoles(
            roles: [role],
          );
          if (result != null) {
            store.dispatch(AddorUpdateBusinessRole(result[0]));
          }
        } else {
          var result = await permissionService.updateBusinessRoles(
            roles: [role],
          );
          if (result != null) {
            store.dispatch(AddorUpdateBusinessRole(result[0]));
          }
        }
        completer?.complete();
        store.dispatch(PermissionStateLoadingAction(false));
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        store.dispatch(PermissionStateFailureAction(e.toString()));
        store.dispatch(PermissionStateLoadingAction(false));
        completer?.completeError(e);
      }
    });
  };
}

ThunkAction<AppState> removeBusinessRole({
  required BusinessRole role,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);
      try {
        store.dispatch(PermissionStateLoadingAction(true));
        var result = await permissionService.deleteBusinessRoles(
          roleIds: [role.id!],
        );
        if (result != null) {
          store.dispatch(DeleteBusinessRole(result[0]));
        }
        completer?.complete();
        store.dispatch(PermissionStateLoadingAction(false));
      } catch (e) {
        store.dispatch(PermissionStateLoadingAction(false));
        reportCheckedError(e, trace: StackTrace.current);
        completer?.completeError(e);
        store.dispatch(PermissionStateFailureAction(e.toString()));
      }
    });
  };
}

_initializeService(Store<AppState> store) {
  permissionService = PermissionService(
    store: store,
    baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
    token: store.state.authState.token,
    businessId: store.state.currentBusinessId,
  );
}

List<Permission> _getPermissionsByRole(PermissionState state, String roleId) {
  List<String> permissionIds = _getPermissionIdsByRoleId(state, roleId);
  List<Permission> permissions = _getPermissionsByID(state, permissionIds);
  return permissions;
}

List<String> _getPermissionIdsByRoleId(PermissionState state, String roleId) {
  BusinessRole role = state.roles!.firstWhere(
    (element) => element.id == roleId,
  );
  return role.permissions ?? <String>[];
}

List<Permission> _getPermissionsByID(
  PermissionState state,
  List<String> permissionIds,
) {
  List<Permission> permissions = [];
  for (String permissionId in permissionIds) {
    Permission? permission = state.permissions!.firstWhereOrNull(
      (element) => element.id == permissionId,
    );

    if (permission != null) {
      permissions.add(permission);
    }
  }
  return permissions;
}

class PermissionStateLoadingAction {
  bool value;

  PermissionStateLoadingAction(this.value);
}

class PermissionLoadedAction {
  List<Permission> value;

  PermissionLoadedAction(this.value);
}

class UserPermissionLoadedAction {
  List<Permission> value;

  UserPermissionLoadedAction(this.value);
}

class PermissionGroupLoadedAction {
  List<PermissionGroup> value;

  PermissionGroupLoadedAction(this.value);
}

class UpdateRolePermissionsAction {
  List<String?> value;
  bool isAdd;
  UpdateRolePermissionsAction(this.value, this.isAdd);
}

class RoleLoadedAction {
  List<BusinessRole> value;

  RoleLoadedAction(this.value);
}

class PermissionStateFailureAction {
  String value;

  PermissionStateFailureAction(this.value);
}

class ResetUserPermissionLoadedAction {
  List<Permission> value;

  ResetUserPermissionLoadedAction(this.value);
}

class SetCurrentBusinessRoleAction {
  BusinessRole value;
  bool isNew;
  SetCurrentBusinessRoleAction(this.value, this.isNew);
}

class AddorUpdateBusinessRole {
  BusinessRole value;
  AddorUpdateBusinessRole(this.value);
}

class DeleteBusinessRole {
  BusinessRole value;
  DeleteBusinessRole(this.value);
}

class ClearUserPermissionsAction {
  const ClearUserPermissionsAction();
}
