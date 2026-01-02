// removed ignore: depend_on_referenced_packages

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:littlefish_core/business/models/business_user.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/handlers/interfaces/permission_handler.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/models/security/user/user_profile.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/business/business_actions.dart';
import 'package:littlefish_merchant/redux/business/business_state.dart';
import 'package:littlefish_merchant/redux/user/user_actions.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

import '../../../common/presentaion/components/dialogs/services/modal_service.dart';
import '../../../injector.dart';
import '../../../models/enums.dart';
import '../../../models/permissions/business_role.dart';
import '../../../models/permissions/business_user_role.dart';

class UsersListVM
    extends StoreCollectionViewModel<BusinessUser?, BusinessState> {
  UsersListVM.fromStore(Store<AppState> store) : super.fromStore(store);

  List<BusinessUserRole>? userBusinessRoles;

  Function(BusinessUser? user)? getRole;

  Function(BusinessUser? user)? getUserRole;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.businessState;
    items = state!.users;
    selectedItem = store.state.businessUserUIState?.item?.item;
    isNew = store.state.businessUserUIState?.item?.isNew;

    onSetSelected = (item) => store.dispatch(BusinessUserSelectedAction(item));

    onAdd = (item, ctx) => store.dispatch(updateOrSaveUser(item));
    onRemove = (item, ctx) => store.dispatch(removeUser(item));
    onRefresh = () => store.dispatch(getUsers(refresh: true));

    isLoading = state!.isLoading;
    hasError = state!.hasError;

    userBusinessRoles = state?.usersBusinessRoles;
    errorMessage = state?.errorMessage;

    getRole = (user) {
      if (user == null) {
        return null;
      }

      final bool userHasRole =
          userBusinessRoles
              ?.where((element) => element.businessUserId == user.uid)
              .isNotEmpty ??
          false;
      if (userHasRole) {
        final String? roleId = userBusinessRoles!
            .where((element) => element.businessUserId == user.uid)
            .toList()[0]
            .roleId;

        final bool roleIsAvailable =
            store.state.permissionState.roles
                ?.where((element) => element.id == roleId)
                .isNotEmpty ??
            false;

        if (roleIsAvailable == false) {
          return null;
        }

        return roleId != null
            ? store.state.permissionState.roles?.firstWhere(
                (element) => element.id == roleId,
              )
            : null;
      }
    };

    getUserRole = (user) {
      if (user == null) {
        return null;
      }

      final bool hasRole =
          userBusinessRoles
              ?.where((element) => element.businessUserId == user.uid)
              .isNotEmpty ??
          false;
      if (hasRole) {
        return userBusinessRoles!
            .where((element) => element.businessUserId == user.uid)
            .toList()[0];
      }
    };
  }
}

class UserVM extends StoreItemViewModel<BusinessUser?, BusinessState> {
  UserVM.fromStore(Store<AppState> store) : super.fromStore(store);

  Function? onShareLink;
  late Function addNewStoreUser;

  String? businessName;

  BusinessUserRole? currentRole;

  List<BusinessRole>? getBusinessRoles;

  VoidCallback? getUserCallback;
  late List<BusinessUser> businessUsers;

  Function(String)? resetPassword;

  Function(BusinessUserRole?)? _updateLoggedInUsersPermissions;

  Function({
    required BusinessUser user,
    required BuildContext ctx,
    BusinessUserRole? role,
    Completer? completer,
  })?
  updateStoreUserWithRole;

  Function({
    required String username,
    required String businessRoleId,
    required UserProfile profile,
    required UserPermissions permission,
    required BuildContext ctx,
    BusinessUserRole? role,
    Completer? completer,
  })?
  addNewStoreUserWithRole;

  late Function(BusinessUser? user, {BusinessUserRole? userRole})
  deleteUserWithRole;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.businessState;
    hasError = state?.hasError;
    item = store.state.businessUserUIState?.item?.item;
    isNew = store.state.businessUserUIState?.item?.isNew;
    isLoading = store.state.userState.isLoading ?? false;
    businessName = store.state.businessState.profile?.name ?? '';
    businessUsers =
        store.state.businessState.users?.whereType<BusinessUser>().toList() ??
        [];

    onAdd = (item, ctx) {
      if (key?.currentState?.validate() ?? false) {
        key!.currentState!.save();
        store.dispatch(
          updateOrSaveUser(
            item,
            completer: snackBarCompleter(
              ctx!,
              '${item!.firstName} saved successfully!',
              shouldPop: !EnvironmentProvider.instance.isLargeDisplay!,
            ),
          ),
        );
      }
    };

    deleteUserWithRole = (user, {userRole}) {
      store.dispatch(
        removeUserWithRole(
          user,
          userRole: userRole,
          completer: snackBarCompleter(
            globalNavigatorKey.currentContext!,
            'Deleted ${user?.firstName} successfully!',
          ),
        ),
      );
    };

    onRemove = (item, ctx) => store.dispatch(
      removeUser(
        item,
        completer: snackBarCompleter(
          ctx,
          '${item!.firstName} was removed',
          shouldPop: !EnvironmentProvider.instance.isLargeDisplay!,
        ),
      ),
    );

    onShareLink = () async {};

    addNewStoreUser =
        (
          String username,
          String password,
          UserProfile profile,
          UserPermissions permission,
          BuildContext ctx,
        ) {
          store.dispatch(
            addStoreUser(
              username,
              password,
              profile,
              permission,
              completer: snackBarCompleter(
                ctx,
                '${profile.firstName} saved successfully!',
                shouldPop: !EnvironmentProvider.instance.isLargeDisplay!,
              ),
            ),
          );
        };

    addNewStoreUserWithRole =
        ({
          required String username,
          required String businessRoleId,
          required UserProfile profile,
          required UserPermissions permission,
          required BuildContext ctx,
          BusinessUserRole? role,
          Completer? completer,
        }) async {
          try {
            store.dispatch(
              addStoreUserWithRole(
                username,
                profile,
                businessRoleId,
                permission,
                userRole: role,
                completer: completer,
              ),
            );

            await completer?.future;

            if (ctx.mounted) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                final modalService = getIt<ModalService>();
                await modalService.showActionModal(
                  context: ctx,
                  title: 'Successfully Invited',
                  description:
                      '${profile.firstName} has been invited successfully',
                  acceptText: 'Done',
                  showCancelButton: false,
                  status: StatusType.success,
                  onTap: (context) {
                    Navigator.of(context).pop();
                  },
                );
              });
            }
          } catch (e) {
            store.dispatch(SetAuthLoadingAction(false));
            store.dispatch(SetUserStateLoadingAction(false));
            await completer?.future;
            if (context!.mounted) {
              if (ctx.mounted) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  final modalService = getIt<ModalService>();
                  await modalService.showActionModal(
                    context: ctx,
                    title: 'Error',
                    description: 'Something went wrong, please try again.',
                    acceptText: 'Ok',
                    showCancelButton: false,
                    status: StatusType.destructive,
                    onTap: (context) {
                      Navigator.of(context).pop();
                    },
                  );
                });
              }
              if (ctx.mounted) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  final modalService = getIt<ModalService>();
                  await modalService.showActionModal(
                    context: ctx,
                    title: 'Error',
                    description: 'Something went wrong, please try again.',
                    acceptText: 'Ok',
                    showCancelButton: false,
                    status: StatusType.destructive,
                    onTap: (context) {
                      Navigator.of(context).pop();
                    },
                  );
                });
              }
            }
          }

          if (_updateLoggedInUsersPermissions != null) {
            _updateLoggedInUsersPermissions!(role);
          }
        };

    updateStoreUserWithRole =
        ({
          required BusinessUser user,
          required BuildContext ctx,
          BusinessUserRole? role,
          Completer? completer,
        }) async {
          store.dispatch(
            updateOrSaveUserWithRole(
              user,
              role,
              completer:
                  completer ??
                  snackBarCompleter(
                    ctx,
                    '${user.firstName} saved successfully!',
                    shouldPop: !EnvironmentProvider.instance.isLargeDisplay!,
                  ),
            ),
          );

          await completer?.future;

          if (_updateLoggedInUsersPermissions != null) {
            _updateLoggedInUsersPermissions!(role);
          }
        };

    resetPassword = (String email) async {
      try {
        await authManager.sendPasswordResetEmail(email: email);
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        rethrow;
      }
    };

    _updateLoggedInUsersPermissions = (userRole) {
      final loggedInUserId = store.state.userProfile?.userId;

      if (loggedInUserId != null && userRole?.businessUserId != null) {
        if ((loggedInUserId == userRole!.businessUserId) &&
            getIt.isRegistered<PermissionHandler>()) {
          getIt.get<PermissionHandler>().populatePermissionData(
            roleId: userRole.roleId,
          );
        }
      }
    };

    getBusinessRoles = store.state.permissionState.roles;

    getUserCallback = () => store.dispatch(getUsers());
  }
}
