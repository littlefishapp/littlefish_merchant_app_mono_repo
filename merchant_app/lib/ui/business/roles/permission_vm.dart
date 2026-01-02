// Flutter imports:
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';
import 'package:littlefish_merchant/models/permissions/business_role.dart';
import 'package:littlefish_merchant/models/permissions/permission.dart';
import 'package:littlefish_merchant/models/permissions/permission_group.dart';
import 'package:littlefish_merchant/redux/permission/permission_action.dart';
import 'package:littlefish_merchant/redux/permission/permission_state.dart';

class PermissionVM
    extends StoreCollectionViewModel<Permission?, PermissionState> {
  PermissionVM.fromStore(Store<AppState> store) : super.fromStore(store);

  List<BusinessRole>? businessRoles;

  List<Permission>? userPermissions;

  List<PermissionGroup>? permissionGroups;

  BusinessRole? currentBusinessRole;

  Function(BusinessRole)? upsertBusinessRole;

  Function(BusinessRole)? deleteBusinessRole;

  Function(BusinessRole)? setCurrentBusinessRole;

  Function(BusinessRole)? updateBusinessRole;

  Function(List<String?>, bool)? updateBusinessRolePermissions;

  late Function() fetchBusinessRoles;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.permissionState;
    items = state!.permissions;
    businessRoles = state!.roles;
    permissionGroups = state!.permissionGroups;
    userPermissions = state!.userPermissions;
    currentBusinessRole = state!.currentBusinessRole;
    isNew = state!.isNew;

    onRefresh = () => store.dispatch(initializePermissionState(refresh: true));
    deleteBusinessRole = (role) {
      Completer? completer = snackBarCompleter(
        globalNavigatorKey.currentContext!,
        'Role deleted successfully.',
      );
      store.dispatch(removeBusinessRole(role: role, completer: completer));
    };
    updateBusinessRolePermissions = (permission, isAdd) {
      store.dispatch(UpdateRolePermissionsAction(permission, isAdd));
    };
    upsertBusinessRole = (role) {
      String message = isNew ?? true
          ? 'Role created successfully.'
          : 'Role updated successfully.';
      Completer? completer = snackBarCompleter(
        globalNavigatorKey.currentContext!,
        message,
      );
      store.dispatch(
        addorUpdateBusinessRole(
          role: role,
          isNew: isNew!,
          completer: completer,
        ),
      );
    };
    updateBusinessRole = (role) {};
    setCurrentBusinessRole = (role) {
      store.dispatch(
        SetCurrentBusinessRoleAction(role, role.id == null ? true : false),
      );
    };
    isLoading = state!.isLoading;
    hasError = state!.hasError;

    fetchBusinessRoles = () {
      Completer? completer = snackBarCompleter(
        globalNavigatorKey.currentContext!,
        'Roles loaded successfully.',
      );
      store.dispatch(getBusinessRoles(completer: completer));
    };
  }
}
