import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:littlefish_core/auth/models/authentication_result.dart';
import 'package:littlefish_core/business/models/business.dart';
import 'package:littlefish_core/business/models/business_user.dart';
import 'package:littlefish_core_utils/httpErrors/models/api_error.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/models/security/verification.dart';
import 'package:littlefish_merchant/services/api_authentication_service.dart';
import 'package:littlefish_merchant/services/permission_service.dart';
import 'package:littlefish_merchant/ui/online_store/shared/routes/custom_route.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/ui/security/login/login_page.dart';

// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/settings/accounts/linked_account.dart';
import 'package:littlefish_merchant/models/staff/employee.dart';
import 'package:littlefish_merchant/models/store/business_profile.dart';
import 'package:littlefish_merchant/models/store/business_type.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/app_settings/app_settings_actions.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/services/business_service.dart';
import 'package:littlefish_merchant/services/settings_service.dart';
import 'package:littlefish_merchant/ui/business/employees/pages/employee_page.dart';
import 'package:littlefish_merchant/ui/business/profile/pages/business_profile_page.dart';
import 'package:littlefish_merchant/ui/business/users/pages/user_page.dart';
import 'package:littlefish_merchant/ui/home/home_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:uuid/uuid.dart';

import '../../app/app.dart';
import '../../tools/file_manager.dart';
import '../../ui/security/login/splash_page.dart';
import '../../models/permissions/business_user_role.dart';

BusinessService? service;

ThunkAction<AppState> loadBusinessProfile({
  bool refresh = false,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      String? businessId;

      if (store.state.businessState.types == null ||
          store.state.businessState.types!.isEmpty) {
        store.dispatch(SetBusinessStateLoadingAction(true));

        try {
          var result = await service!.getBusinessTypes();
          store.dispatch(BusinessTypesLoadedAction(result));
        } catch (e) {
          store.dispatch(BusinessProfileLoadFailure(e.toString()));
        }
      }

      if (refresh || store.state.businessState.profile == null) {
        store.dispatch(SetBusinessStateLoadingAction(true));

        try {
          var result = await service!.getBusinessProfile();

          businessId = result?.parentId;
          store.dispatch(BusinessProfileLoadedAction(result));

          if (businessId != null) {
            var result = await service!.getBusinessVerificationStatus(
              businessId,
            );
            if (result != null) {
              store.dispatch(SetVerificationStatusAction(result));
            }
          }

          store.dispatch(SetBusinessStateLoadingAction(false));

          completer?.complete();
        } catch (e) {
          store.dispatch(BusinessProfileLoadFailure(e.toString()));
          store.dispatch(SetBusinessStateLoadingAction(false));

          completer?.completeError(e);
        }
      }

      store.dispatch(SetBusinessStateLoadingAction(false));
    });
  };
}

ThunkAction<AppState> setBusinessVerificationStatus(
  BuildContext context,
  Verification verificationStatus, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      try {
        String? businessId = store.state.businessId;

        if (businessId != null) {
          service!.setBusinessVerificationStatus(
            businessId,
            verificationStatus,
          );
          store.dispatch(SetVerificationStatusAction(verificationStatus));
        }

        completer?.complete();
      } catch (e) {
        store.dispatch(BusinessProfileLoadFailure(e.toString()));
        store.dispatch(SetBusinessStateLoadingAction(false));
        completer?.completeError(e, StackTrace.current);
      }
    });
  };
}

ThunkAction<AppState> getVerificationStatus({
  BuildContext? context,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      try {
        String? businessId = store.state.businessId;

        if (businessId != null) {
          Verification? vs = await service!.getBusinessVerificationStatus(
            businessId,
          );
          store.dispatch(SetVerificationStatusAction(vs));
        }

        completer?.complete();
      } catch (e) {
        store.dispatch(BusinessProfileLoadFailure(e.toString()));
        store.dispatch(SetBusinessStateLoadingAction(false));
        completer?.completeError(e, StackTrace.current);
      }
    });
  };
}

ThunkAction<AppState> editBusinessProfile(BuildContext context) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      if (store.state.isLargeDisplay ?? false) {
        showPopupDialog(
          context: context,
          content: const BusinessProfilePage(embedded: true),
        );
      } else {
        Navigator.of(context).pushNamed(BusinessProfilePage.route);
      }
    });
  };
}

ThunkAction<AppState> registerBusiness(
  BusinessProfile? value, {
  Completer? completer,
  bool useCustomRoute = false,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      if (value!.countryCode == null || value.countryCode!.isEmpty) {
        value.countryCode = store.state.userCountryCode;
      }

      store.dispatch(SetBusinessStateLoadingAction(true));

      await service!
          .registerBusiness(value)
          .catchError((e) {
            store.dispatch(BusinessProfileLoadFailure(e.toString()));
            store.dispatch(SetBusinessStateLoadingAction(false));
            completer?.completeError(e, StackTrace.current);
            return null;
          })
          .then((result) async {
            if (result != null) {
              var apiAuthenticationService = ApiAuthenticationService(
                baseUrl:
                    store.state.environmentState.environmentConfig!.baseUrl,
                token: store.state.authState.token,
                store: store,
              );
              AuthenticationResult? authResult;

              try {
                // this now may throw ApiErrorException
                authResult = await apiAuthenticationService.verifyUser(
                  store.state.currentUser,
                  store.state.authState.token,
                );

                //here we would've loaded the business details, if there are any
                store.dispatch(SetBusinessListAction(authResult?.businesses));

                if (authResult!.businesses != null &&
                    authResult.businesses!.isNotEmpty) {
                  store.dispatch(
                    SetSelectedBusinessAction(authResult.businesses?.first),
                    // this might be wrong as we are always fetching the first one, which only works when user is logging in for the first time, at this point we want to remember the previously selected store.
                  );

                  store.dispatch(
                    SetBusinessPermissionsListAction(authResult.businessUsers),
                  );

                  store.dispatch(
                    SetUserAccessPermissions(store.state.permissions),
                  );
                }
              } on ApiErrorException catch (e) {
                // structured error from backend
                store.dispatch(BusinessProfileLoadFailure(e.error.userMessage));
                reportCheckedError(e, trace: StackTrace.current);
                completer?.completeError(e);
                store.dispatch(SetBusinessStateLoadingAction(false));
                return;
              } catch (e, st) {
                // old generic fallback
                store.dispatch(BusinessProfileLoadFailure(e.toString()));
                reportCheckedError(e, trace: st);
                completer?.completeError(e, st);
                store.dispatch(SetBusinessStateLoadingAction(false));
                return;
              }

              store.dispatch(BusinessProfileLoadedAction(result));

              store.dispatch(SetBusinessStateLoadingAction(false));

              completer?.complete();

              await Navigator.of(
                globalNavigatorKey.currentContext!,
              ).push(CustomRoute(builder: (context) => const LoginPage()));
            }
          });
    });
  };
}

// ThunkAction<AppState> joinBusiness(
//   String value, {
//   Completer completer,
// }) {
//   return (Store<AppState> store) async {
//     Future(() async {
//       _initializeService(store);

//       store.dispatch(SetBusinessStateLoadingAction(true));

//       bool hasError = false;

//       await service.joinBusiness(value).catchError((e) {
//         store.dispatch(BusinessProfileLoadFailure(e.toString()));
//         store.dispatch(SetBusinessStateLoadingAction(false));

//         hasError = true;
//         if (completer != null && !completer.isCompleted)
//           completer?.completeError(e, StackTrace.current);
//       }).then((result) async {
//         if (result != null) {
//           var authService = AuthenticationService(
//             baseUrl: store.state.environmentState.environmentConfig.baseUrl,
//           );

//           await authService
//               .verifyUser(store.state.currentUser, store.state.authState.token)
//               .then((verifiedResult) {
//             //here we would've loaded the business details, if there are any
//             store.dispatch(
//               SetBusinessListAction(verifiedResult?.businesses),
//             );

//             if (verifiedResult.businesses != null &&
//                 verifiedResult.businesses.length > 0) {
//               store.dispatch(
//                 SetSelectedBusinessAction(verifiedResult?.businesses?.first),
//               );

//               store.dispatch(SetBusinessPermissionsListAction(
//                   verifiedResult?.permissions));

//               store.dispatch(SetUserAccessPermissions(store.state.permissions));
//             }
//           });

//           if (!hasError) {
//             store.dispatch(loadBusinessProfile());

//             store.dispatch(SetBusinessStateLoadingAction(false));

//             if (completer != null && !completer.isCompleted)
//               completer?.complete();

//             Catcher2.navigatorKey.currentState.pushNamedAndRemoveUntil(
//               SplashPage.route,
//               ModalRoute.withName(SplashPage.route),
//             );
//           }
//         } else {
//           store.dispatch(SetBusinessStateLoadingAction(false));

//           if (completer != null && !completer.isCompleted)
//             completer
//                 ?.completeError(Exception("Invite code provided is not valid"));
//         }
//       });
//     });
//   };
// }

ThunkAction<AppState> updateBusinessProfile(
  BusinessProfile? value, {
  Completer? completer,
  bool navigateToHome = true,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        _initializeService(store);
        store.dispatch(SetBusinessStateLoadingAction(true));

        var result = await service!.updateBusinessProfile(value!);

        store.dispatch(BusinessProfileLoadedAction(result));
        store.dispatch(SetBusinessStateLoadingAction(false));
        completer?.complete();

        if (navigateToHome) {
          await Navigator.pushNamedAndRemoveUntil(
            globalNavigatorKey.currentContext!,
            HomePage.route,
            (route) => false,
          );
        }
      } catch (e) {
        store.dispatch(BusinessProfileLoadFailure(e.toString()));
        store.dispatch(SetBusinessStateLoadingAction(false));
        completer?.completeError(e, StackTrace.current);
      }
    });
  };
}

ThunkAction<AppState> loadBusinessTypes() {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      if (store.state.businessState.types == null ||
          store.state.businessState.types!.isEmpty) {
        store.dispatch(SetBusinessStateLoadingAction(true));

        await service!
            .getBusinessTypes()
            .catchError((e) {
              store.dispatch(BusinessProfileLoadFailure(e.toString()));
              store.dispatch(SetBusinessStateLoadingAction(false));
              return <BusinessType>[];
            })
            .then((result) {
              store.dispatch(BusinessTypesLoadedAction(result));
              store.dispatch(SetBusinessStateLoadingAction(false));
            });
      }
    });
  };
}

//Employees
ThunkAction<AppState> getEmployees({bool refresh = false}) {
  return (Store<AppState> store) async {
    Future(() async {
      // _initializeService(store);

      var state = store.state.businessState;
      var businessService = BusinessService.fromStore(store);
      //pull from cache
      if (!refresh && (state.employees?.length ?? 0) > 0) {
        store.dispatch(SetBusinessStateLoadingAction(false));
        return;
      }

      store.dispatch(SetBusinessStateLoadingAction(true));

      await businessService
          .getEmployees()
          .catchError((e) {
            store.dispatch(BusinessProfileLoadFailure(e.toString()));
            store.dispatch(SetBusinessStateLoadingAction(false));
            return <Employee>[];
          })
          .then((result) {
            store.dispatch(EmployeesLoadedAction(result));
            store.dispatch(SetBusinessStateLoadingAction(false));
          });
    });
  };
}

ThunkAction<AppState> updateOrSaveEmployee(
  Employee? employee, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        _initializeService(store);

        store.dispatch(SetBusinessStateLoadingAction(true));

        var businessService = BusinessService.fromStore(store);

        var result = await businessService.updateOrSaveEmployee(employee!);

        store.dispatch(EmployeeChangedAction(result, ChangeType.updated));

        if (completer != null && !completer.isCompleted) completer.complete();
      } catch (e) {
        store.dispatch(BusinessProfileLoadFailure(e.toString()));

        //notify the error if there is a completer present
        completer?.completeError(e, StackTrace.current);
      } finally {
        store.dispatch(SetBusinessStateLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> removeEmployee(
  Employee? employee, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      // _initializeService(store);

      try {
        store.dispatch(SetBusinessStateLoadingAction(true));
        var businessService = BusinessService.fromStore(store);
        await businessService.removeEmployee(employee!);

        store.dispatch(
          EmployeeChangedAction(
            employee,
            ChangeType.removed,
            completer: completer,
          ),
        );

        if (completer != null && !completer.isCompleted) completer.complete();
      } catch (e) {
        store.dispatch(BusinessProfileLoadFailure(e.toString()));
        store.dispatch(SetBusinessStateLoadingAction(false));

        //notify the error if there is a completer present
        completer?.completeError(e, StackTrace.current);
      } finally {
        store.dispatch(SetBusinessStateLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> setUIEmployee(Employee employee, {bool isNew = false}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(SetBusinessStateLoadingAction(true));
      if (isNew) {
        store.dispatch(EmployeeCreateAction());
      } else {
        store.dispatch(EmployeeSelectAction(employee));
      }
      store.dispatch(SetBusinessStateLoadingAction(false));
    });
  };
}

ThunkAction<AppState> createEmployee(BuildContext context) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(EmployeeCreateAction());

      if (store.state.isLargeDisplay ?? false) {
        showPopupDialog(
          context: context,
          content: const EmployeePage(embedded: true),
        );
      } else {
        Navigator.of(context).pushNamed(EmployeePage.route);
      }
    });
  };
}

ThunkAction<AppState> editEmployee(BuildContext context, Employee employee) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(EmployeeSelectAction(employee));

      if (store.state.isLargeDisplay ?? false) {
        // showPopupDialog(
        //   context: context,
        //   content: EmployeePage(
        //     embedded: true,
        //   ),
        // );
      } else {
        Navigator.of(context).pushNamed(EmployeePage.route);
      }
    });
  };
}

//Business Users
ThunkAction<AppState> getUsers({bool refresh = false}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      var state = store.state.businessState;

      //pull from cache
      if (!refresh && (state.users?.length ?? 0) > 0) {
        store.dispatch(SetBusinessStateLoadingAction(false));
        return;
      }

      store.dispatch(SetBusinessStateLoadingAction(true));

      await service!
          .getUsers()
          .catchError((e) {
            store.dispatch(BusinessProfileLoadFailure(e.toString()));
            store.dispatch(SetBusinessStateLoadingAction(false));
            return <BusinessUser>[];
          })
          .then((result) {
            store.dispatch(BusinessUsersLoadedAction(result));
            store.dispatch(SetBusinessStateLoadingAction(false));
          });

      final permissionService = PermissionService.fromStore(store);

      await permissionService
          .getBusinessUserRolesByBusiness(businessId: state.businessId)
          .catchError((e) {
            store.dispatch(SetUsersBusinessRolesFailure(e.toString()));
            store.dispatch(SetBusinessStateLoadingAction(false));
            return <BusinessUserRole>[];
          })
          .then((value) {
            store.dispatch(SetUsersBusinessRoles(value));
            store.dispatch(SetBusinessStateLoadingAction(false));
          });
    });
  };
}

ThunkAction<AppState> updateOrSaveUser(
  BusinessUser? user, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(SetBusinessStateLoadingAction(true));

      await service!
          .addOrUpdateUser(user!)
          .catchError((e) {
            store.dispatch(BusinessProfileLoadFailure(e.toString()));
            store.dispatch(SetBusinessStateLoadingAction(false));

            //notify the error if there is a completer present
            completer?.completeError(e, StackTrace.current);
            return BusinessUser();
          })
          .then((result) {
            store.dispatch(
              BusinessUserChangedAction(result, ChangeType.updated),
            );
            store.dispatch(SetBusinessStateLoadingAction(false));
            if (completer != null && !completer.isCompleted)
              completer.complete();
          });
    });
  };
}

ThunkAction<AppState> updateOrSaveUserWithRole(
  BusinessUser? user,
  BusinessUserRole? userRole, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(SetBusinessStateLoadingAction(true));

      await service!
          .addOrUpdateUser(user!)
          .catchError((e) {
            store.dispatch(BusinessProfileLoadFailure(e.toString()));
            store.dispatch(SetBusinessStateLoadingAction(false));

            //notify the error if there is a completer present
            completer?.completeError(e, StackTrace.current);
            return BusinessUser();
          })
          .then((result) async {
            store.dispatch(
              BusinessUserChangedAction(result, ChangeType.updated),
            );

            final permissionService = PermissionService.fromStore(store);

            List<BusinessUserRole> roles = [];
            if (userRole != null) {
              roles.add(userRole);
            }

            if (roles.isNotEmpty && user.uid != null) {
              await permissionService
                  .updateBusinessUserRoles(
                    userId: user.uid!,
                    userRoles: roles,
                    businessId: user.businessId,
                  )
                  .catchError((e) {
                    store.dispatch(
                      UpdateUsersBusinessRolesFailure(e.toString()),
                    );
                    store.dispatch(SetBusinessStateLoadingAction(false));

                    //notify the error if there is a completer present
                    completer?.completeError(e, StackTrace.current);
                    return null;
                  })
                  .then((value) {
                    store.dispatch(
                      UpdateUsersBusinessRoles(
                        newBusinessRole: userRole,
                        oldRoleId: userRole?.id,
                      ),
                    );
                    store.dispatch(SetBusinessStateLoadingAction(false));
                    if (completer != null && !completer.isCompleted) {
                      completer.complete();
                    }
                  });
            } else {
              store.dispatch(
                BusinessProfileLoadFailure(
                  'Failed to assign Role to user, no user identification or role to assign.',
                ),
              );
              store.dispatch(SetBusinessStateLoadingAction(false));

              //notify the error if there is a completer present
              completer?.completeError(
                'Failed to assign Role to user, no user identification or role to assign.',
              );
              return BusinessUser();
            }
          });
    });
  };
}

ThunkAction<AppState> removeUser(BusinessUser? user, {Completer? completer}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(SetBusinessStateLoadingAction(true));

      await service!
          .removeUser(user!)
          .catchError((e) {
            store.dispatch(BusinessProfileLoadFailure(e.toString()));
            store.dispatch(SetBusinessStateLoadingAction(false));

            //notify the error if there is a completer present
            completer?.completeError(e, StackTrace.current);
            return false;
          })
          .then((result) async {
            if (result) {
              store.dispatch(
                BusinessUserChangedAction(user, ChangeType.removed),
              );
              store.dispatch(SetBusinessStateLoadingAction(false));
              if (completer != null && !completer.isCompleted)
                completer.complete();
            }
          });
    });
  };
}

ThunkAction<AppState> removeUserWithRole(
  BusinessUser? user, {
  BusinessUserRole? userRole,
  Completer? completer,
  bool refreshOnceComplete = false,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(SetBusinessStateLoadingAction(true));

      await service!
          .removeUser(user!)
          .catchError((e) {
            store.dispatch(BusinessProfileLoadFailure(e.toString()));
            store.dispatch(SetBusinessStateLoadingAction(false));
            completer?.completeError(e, StackTrace.current);
            return false;
          })
          .then((result) async {
            if (result) {
              store.dispatch(
                BusinessUserChangedAction(user, ChangeType.removed),
              );
              if (completer != null && !completer.isCompleted)
                completer.complete();
            }
          });

      final permissionService = PermissionService.fromStore(store);

      if (userRole != null && user.uid != null) {
        await permissionService
            .deleteBusinessUserRoles(
              userId: user.uid!,
              userRoleIds: [userRole.id!],
            )
            .catchError((e) {
              store.dispatch(UpdateUsersBusinessRolesFailure(e.toString()));
              reportCheckedError(e, trace: StackTrace.current);
              completer?.completeError(e, StackTrace.current);
              store.dispatch(SetBusinessStateLoadingAction(false));
              return null;
            })
            .then((value) {
              store.dispatch(RemoveFromUsersBusinessRoles(value));
              store.dispatch(SetBusinessStateLoadingAction(false));
            });
      }

      if (refreshOnceComplete) {
        store.dispatch(getUsers(refresh: true));
      } else {
        store.dispatch(SetBusinessStateLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> setUIUser(BusinessUser user, {bool isNew = false}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(SetBusinessStateLoadingAction(true));
      if (isNew) {
        store.dispatch(BusinessUserCreateAction());
      } else {
        store.dispatch(BusinessUserSelectedAction(user));
      }

      store.dispatch(SetBusinessStateLoadingAction(false));
    });
  };
}

ThunkAction<AppState> editUser(BusinessUser user) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);
      store.dispatch(BusinessUserSelectedAction(user));
      Navigator.pushNamed(globalNavigatorKey.currentContext!, UserPage.route);
    });
  };
}

ThunkAction<AppState> createUser(BuildContext context) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(BusinessUserCreateAction());

      if (store.state.isLargeDisplay == true) {
        final screenWidth = MediaQuery.of(context).size.width;
        const maxMobileWidth = 414.0;
        final constrainedWidth = (screenWidth * 0.3).clamp(
          300.0,
          maxMobileWidth,
        );

        showPopupDialog(
          context: context,
          content: Center(
            child: SizedBox(
              width: constrainedWidth,
              child: const UserPage(embedded: true),
            ),
          ),
        );
      } else {
        Navigator.pushNamed(globalNavigatorKey.currentContext!, UserPage.route);
      }
    });
  };
}

ThunkAction<AppState> setStoreCredit(
  StoreCreditSettings? creditSettings, {
  required bool? enabled,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        SettingsService service = SettingsService(
          store: store,
          baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
          businessId: store.state.currentBusinessId,
          token: store.state.authState.token,
        );

        store.dispatch(AppSettingsSetLoadingAction(true));
        await service.setStoreCredit(creditSettings!);

        store.dispatch(SetStoreCreditEnabledAction(creditSettings));
        store.dispatch(
          setPaymentType(enabled: creditSettings.enabled, name: 'credit'),
        );
        completer?.complete();
      } catch (e) {
        store.dispatch(BusinessProfileLoadFailure(e.toString()));
        completer?.completeError(e);
      } finally {
        store.dispatch(AppSettingsSetLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> disableStoreCredit(
  StoreCreditSettings? creditSettings, {
  required bool? enabled,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        store.dispatch(AppSettingsSetLoadingAction(true));

        SettingsService service = SettingsService(
          store: store,
          baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
          businessId: store.state.currentBusinessId,
          token: store.state.authState.token,
        );

        var value = await service.disableStoreCredit(creditSettings);

        if (value != null) {
          store.dispatch(SetStoreCreditEnabledAction(creditSettings));
          store.dispatch(
            setPaymentType(enabled: creditSettings!.enabled, name: 'credit'),
          );
          completer?.complete();
        }
      } catch (e) {
        store.dispatch(BusinessProfileLoadFailure(e.toString()));
        completer?.completeError(e);
      } finally {
        store.dispatch(AppSettingsSetLoadingAction(false));
      }
    });
  };
}

BusinessService? _initializeService(Store<AppState> store) {
  service = BusinessService(
    store: store,
    baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
    token: store.state.authState.token,
    businessId: store.state.currentBusinessId,
  );

  return service;
}

ThunkAction<AppState> uploadBusinessLogo({
  required File file,
  required String? profileId,
  required BuildContext context,
  required Function(String url) onComplete,
}) {
  return (Store<AppState> store) async {
    try {
      showProgress(context: context);

      var state = store.state;
      var downloadUrl = await FileManager().uploadFile(
        file: file,
        businessId: state.businessId!,
        category: 'businesses',
        id: profileId ?? const Uuid().v4(),
        businessName: 'business-tag',
      );

      hideProgress(context);
      onComplete(downloadUrl.downloadUrl);
    } on PlatformException catch (e) {
      hideProgress(context);
      showMessageDialog(
        context,
        '${e.code}: ${e.message}',
        LittleFishIcons.warning,
      );
    } catch (e) {
      hideProgress(context);
      reportCheckedError(e, trace: StackTrace.current);
      showMessageDialog(
        context,
        'Something went wrong, please try again later',
        LittleFishIcons.error,
      );
    }
  };
}

class SetBusinessListAction {
  List<Business>? value;

  SetBusinessListAction(this.value);
}

class SetBusinessPermissionsListAction {
  List<BusinessUser>? value;

  SetBusinessPermissionsListAction(this.value);
}

class SetBusinessLinkedAccountsAction {
  List<LinkedAccount> value;
  bool toggleIsLoading;

  SetBusinessLinkedAccountsAction(this.value, {this.toggleIsLoading = false});
}

class SetBusinessSalesChannelsAction {
  List<SalesChannel> value;

  SetBusinessSalesChannelsAction(this.value);
}

class SetSelectedBusinessAction {
  Business? value;

  SetSelectedBusinessAction(this.value);
}

class SetBusinessStateLoadingAction {
  bool value;

  SetBusinessStateLoadingAction(this.value);
}

class BusinessProfileLoadFailure {
  String value;

  BusinessProfileLoadFailure(this.value);
}

class BusinessProfileLoadedAction {
  BusinessProfile? value;

  BusinessProfileLoadedAction(this.value);
}

class BusinessTypesLoadedAction {
  List<BusinessType> value;

  BusinessTypesLoadedAction(this.value);
}

class EmployeeChangedAction {
  Employee? value;

  ChangeType type;

  Completer? completer;

  EmployeeChangedAction(this.value, this.type, {this.completer});
}

class EmployeeCreateAction {}

class EmployeeEditAction {
  Employee value;

  EmployeeEditAction(this.value);
}

class EmployeeSelectAction {
  Employee value;

  EmployeeSelectAction(this.value);
}

class EmployeesLoadedAction {
  List<Employee>? value;

  EmployeesLoadedAction(this.value);
}

//Business Users
class BusinessUsersLoadedAction {
  List<BusinessUser?> value;

  BusinessUsersLoadedAction(this.value);
}

class BusinessUserChangedAction {
  BusinessUser? value;

  ChangeType type;

  BusinessUserChangedAction(this.value, this.type);
}

class BusinessUsersUpdateAction {
  BusinessUser value;

  ChangeType type;

  BusinessUsersUpdateAction(this.value, this.type);
}

class BusinessUserSelectedAction {
  BusinessUser? value;

  BusinessUserSelectedAction(this.value);
}

class BusinessUserCreateAction {}

class SetStoreCreditEnabledAction {
  StoreCreditSettings? value;

  SetStoreCreditEnabledAction(this.value);
}

class SetVerificationStatusAction {
  Verification? verificationStatus;

  SetVerificationStatusAction(this.verificationStatus);
}

class SetUsersBusinessRoles {
  List<BusinessUserRole>? userBusinessRoles;

  SetUsersBusinessRoles(this.userBusinessRoles);
}

class SetUsersBusinessRolesFailure {
  String? value;

  SetUsersBusinessRolesFailure(this.value);
}

class UpdateUsersBusinessRoles {
  String? oldRoleId;
  BusinessUserRole? newBusinessRole;

  UpdateUsersBusinessRoles({
    required this.newBusinessRole,
    required this.oldRoleId,
  });
}

class UpdateUsersBusinessRolesFailure {
  String? value;

  UpdateUsersBusinessRolesFailure(this.value);
}

class RemoveFromUsersBusinessRoles {
  List<BusinessUserRole>? userBusinessRoles;

  RemoveFromUsersBusinessRoles(this.userBusinessRoles);
}
