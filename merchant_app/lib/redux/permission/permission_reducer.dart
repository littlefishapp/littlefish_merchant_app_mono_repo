import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/redux/permission/permission_action.dart';
import 'package:littlefish_merchant/redux/permission/permission_state.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

final permissionReducer = combineReducers<PermissionState>([
  TypedReducer<PermissionState, PermissionStateLoadingAction>(
    onSetLoading,
  ).call,
  TypedReducer<PermissionState, PermissionLoadedAction>(
    onPermissionsLoaded,
  ).call,
  TypedReducer<PermissionState, PermissionGroupLoadedAction>(
    onPermissionGroupsLoaded,
  ).call,
  TypedReducer<PermissionState, RoleLoadedAction>(onRolesLoaded).call,
  TypedReducer<PermissionState, UserPermissionLoadedAction>(
    onUserPermissionsLoaded,
  ).call,
  TypedReducer<PermissionState, PermissionStateFailureAction>(onFailure).call,
  TypedReducer<PermissionState, ResetUserPermissionLoadedAction>(
    onResetUserPermissionsLoaded,
  ).call,
  TypedReducer<PermissionState, SetCurrentBusinessRoleAction>(
    onSetCurrentBusinessRole,
  ).call,
  TypedReducer<PermissionState, UpdateRolePermissionsAction>(
    onUpdateRolePermissions,
  ).call,
  TypedReducer<PermissionState, AddorUpdateBusinessRole>(
    onAddorUpdateBusinessRole,
  ).call,
  TypedReducer<PermissionState, DeleteBusinessRole>(onDeleteBusinessRole).call,
  TypedReducer<PermissionState, SignoutAction>(onClearState).call,
  TypedReducer<PermissionState, ClearUserPermissionsAction>(
    onClearUserPermissions,
  ).call,
]);

PermissionState onClearState(PermissionState state, SignoutAction action) =>
    state.rebuild((b) {
      b.isLoading = false;
      b.hasError = false;
      b.errorMessage = null;
      b.currentBusinessRole = null;
      b.userPermissions = null;
      b.roles = null;
      b.permissionGroups = null;
    });

PermissionState onSetLoading(
  PermissionState state,
  PermissionStateLoadingAction action,
) => state.rebuild((b) => b.isLoading = action.value);

PermissionState onUpdateRolePermissions(
  PermissionState state,
  UpdateRolePermissionsAction action,
) => state.rebuild((b) {
  List<String> nonNullPermissionIds = action.value
      .where((id) => id != null)
      .cast<String>()
      .toList();
  if (action.isAdd) {
    b.currentBusinessRole!.permissions!.addAll(nonNullPermissionIds);
    b.currentBusinessRole!.permissions = b.currentBusinessRole!.permissions!
        .toSet()
        .toList();
  } else {
    b.currentBusinessRole!.permissions!.removeWhere(
      (element) => nonNullPermissionIds.contains(element),
    );
  }
});

PermissionState onSetCurrentBusinessRole(
  PermissionState state,
  SetCurrentBusinessRoleAction action,
) => state.rebuild((b) {
  b.currentBusinessRole = action.value;
  b.isNew = action.isNew;
});

PermissionState onAddorUpdateBusinessRole(
  PermissionState state,
  AddorUpdateBusinessRole action,
) => state.rebuild((b) {
  var roleIndex = b.roles!.indexWhere((p) => p.id == action.value.id);
  if (roleIndex >= 0) {
    b.roles![roleIndex] = action.value;
  } else {
    b.roles!.add(action.value);
  }
});

PermissionState onDeleteBusinessRole(
  PermissionState state,
  DeleteBusinessRole action,
) => state.rebuild(
  (b) => b.roles!.removeWhere((role) => role.id == action.value.id),
);

PermissionState onPermissionsLoaded(
  PermissionState state,
  PermissionLoadedAction action,
) => state.rebuild((b) => b.permissions = action.value);

PermissionState onPermissionGroupsLoaded(
  PermissionState state,
  PermissionGroupLoadedAction action,
) => state.rebuild((b) => b.permissionGroups = action.value);

PermissionState onUserPermissionsLoaded(
  PermissionState state,
  UserPermissionLoadedAction action,
) => state.rebuild((b) {
  b.userPermissions ??= [];
  b.userPermissions?.addAll(action.value);
  // Remove all duplicate permissions
  b.userPermissions = b.userPermissions?.toSet().toList();
});

PermissionState onClearUserPermissions(
  PermissionState state,
  ClearUserPermissionsAction action,
) => state.rebuild((b) => b.userPermissions = []);

PermissionState onRolesLoaded(PermissionState state, RoleLoadedAction action) =>
    state.rebuild((b) => b.roles = action.value);

PermissionState onFailure(
  PermissionState state,
  PermissionStateFailureAction action,
) => state.rebuild((b) {
  b.hasError = true;
  b.errorMessage = action.value;
  b.isLoading = false;
});

PermissionState onResetUserPermissionsLoaded(
  PermissionState state,
  ResetUserPermissionLoadedAction action,
) => state.rebuild((b) {
  b.userPermissions = action.value;
});
