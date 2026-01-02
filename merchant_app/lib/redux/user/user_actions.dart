// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:geolocator/geolocator.dart';
import 'package:littlefish_auth/littlefish_auth_manager.dart';
import 'package:littlefish_core/auth/models/auth_user.dart';
import 'package:littlefish_core/business/models/business_user.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_merchant/ui/online_store/services/littlefish/littlefish_firestore.dart';
import 'package:quiver/strings.dart';

// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/security/user/user_profile.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/redux/business/business_actions.dart';
import 'package:littlefish_merchant/redux/user/user_state.dart';
import 'package:littlefish_merchant/services/user_profile_service.dart';
import 'package:littlefish_merchant/tools/exceptions/common_exceptions.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/profile/user/pages/user_profile_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';

import 'package:uuid/uuid.dart';

import '../../features/ecommerce_shared/models/internationalization/country_codes.dart'
    as iso_models;
import '../../features/ecommerce_shared/models/points/user_points.dart';
import '../../features/ecommerce_shared/models/user/user.dart';
import '../../models/permissions/business_user_role.dart';
import '../../services/permission_service.dart';
import '../../ui/online_store/common/constants/event_code_constants.dart';

late UserProfileService service;

ThunkAction<AppState> loadUserProfile({bool refresh = false}) {
  return (Store<AppState> store) async {
    Future(() async {
      service = UserProfileService(
        store: store,
        baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
        token: store.state.authState.token,
      );

      if (refresh || store.state.userState.profile == null) {
        store.dispatch(SetUserStateLoadingAction(true));

        await service
            .getUserProfile()
            .catchError((e) {
              store.dispatch(UserProfileLoadFailure(e.toString()));
              return null;
            })
            .then((result) {
              store.dispatch(UserProfileLoadedAction(result));
            });
      }
      return;
    });
  };
}

ThunkAction<AppState> editUserProfile(BuildContext context) {
  return (Store<AppState> store) async {
    Future(() async {
      if (store.state.isLargeDisplay ?? false) {
        showPopupDialog(context: context, content: const UserProfilePage());
      } else {
        Navigator.of(context).pushNamed(UserProfilePage.route);
      }
    });
  };
}

ThunkAction<AppState> updateUserProfile(
  UserProfile? value, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      service = UserProfileService(
        store: store,
        baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
        token: store.state.authState.token,
      );

      //logger.debug(this,'something is happening!');

      store.dispatch(SetUserStateLoadingAction(true));

      await service
          .updateUserProfile(value!)
          .catchError((e) {
            store.dispatch(UserProfileLoadFailure(e.toString()));
            store.dispatch(SetUserStateLoadingAction(false));
            completer?.completeError(e);
            return UserProfile();
          })
          .then((result) {
            store.dispatch(UserProfileLoadedAction(result));

            store.dispatch(SetUserStateLoadingAction(false));
            completer?.complete();
          });

      return;
    });
  };
}

ThunkAction<AppState> addStoreUser(
  String username,
  String password,
  UserProfile profile,
  UserPermissions permissions, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(SetUserStateLoadingAction(true));
      service = UserProfileService(
        store: store,
        baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
        token: store.state.authState.token,
        businessId: store.state.currentBusinessId,
      );

      try {
        store.dispatch(SetAuthLoadingAction(true));

        var authUser = await authManager.signUpWithEmailAndPassword(
          email: username,
          password: password,
        ); // registerWithSeperate

        profile.userId = authUser.uid;

        profile.countryCode ??= 'ZA';
        try {
          var res = await service.addStoreUser(username, profile, permissions);

          store.dispatch(BusinessUsersUpdateAction(res, ChangeType.added));
          store.dispatch(SetUserStateLoadingAction(false));

          completer?.complete();
        } catch (e) {
          store.dispatch(UserProfileLoadFailure(e.toString()));
          store.dispatch(SetUserStateLoadingAction(false));
          completer?.completeError(e);
        }
      } catch (e) {
        String errorText = getGoogleAuthError((e as dynamic)['code']);

        reportCheckedError(e, trace: StackTrace.current);
        // break;
        // }
        store.dispatch(SetUserStateLoadingAction(false));

        completer?.completeError(ManagedException(message: errorText));
      }

      return;
    });
  };
}

ThunkAction<AppState> addStoreUserWithRole(
  String username,
  UserProfile profile,
  String businessRoleId,
  UserPermissions permissions, {
  BusinessUserRole? userRole,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    String? userId;

    Future(() async {
      store.dispatch(SetUserStateLoadingAction(true));
      store.dispatch(SetAuthLoadingAction(true));
      service = UserProfileService(
        store: store,
        baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
        token: store.state.authState.token,
        businessId: store.state.currentBusinessId,
      );

      profile.countryCode ??= 'ZA';
      try {
        var res = await service.addBusinessUserNoPassword(
          username,
          profile,
          permissions,
          businessRoleId,
        );

        final businessUser = BusinessUser(
          uid: res.uid,
          username: username,
          email: profile.email,
          firstName: profile.firstName,
          lastName: profile.lastName,
          mobileNumber: profile.mobileNumber,
          permissions: permissions,
          role: UserRoleType.employee,
        );

        store.dispatch(
          BusinessUsersUpdateAction(businessUser, ChangeType.added),
        );

        userId = res.uid;

        completer?.complete();
      } catch (e) {
        store.dispatch(UserProfileLoadFailure(e.toString()));
        store.dispatch(SetUserStateLoadingAction(false));
        store.dispatch(SetAuthLoadingAction(false));
        completer?.completeError(e);
      }

      if (userRole != null && userId != null) {
        List<BusinessUserRole> roles = [];

        roles.add(userRole);

        final permissionService = PermissionService.fromStore(store);

        if (roles.isNotEmpty && userId != null) {
          await permissionService
              .updateBusinessUserRoles(
                userId: userId!,
                userRoles: roles,
                businessId: store.state.businessState.businessId,
              )
              .catchError((e) {
                store.dispatch(UpdateUsersBusinessRolesFailure(e.toString()));
                store.dispatch(SetUserStateLoadingAction(false));
                store.dispatch(
                  SetAuthLoadingAction(false),
                ); //notify the error if there is a completer present
                completer?.completeError(e, StackTrace.current);
                return null;
              })
              .then((value) {
                if (value?.isNotEmpty ?? false) {
                  final userBusinessRole = value;

                  final userRolePresent = userBusinessRole!
                      .where((element) => element.businessUserId == userId)
                      .isNotEmpty;
                  if (userRolePresent) {
                    final updatedUserRole = userBusinessRole.firstWhere(
                      (element) => element.businessUserId == userId,
                    );

                    store.dispatch(
                      UpdateUsersBusinessRoles(
                        newBusinessRole: updatedUserRole,
                        oldRoleId: updatedUserRole.id,
                      ),
                    );
                  }
                }
                store.dispatch(SetUserStateLoadingAction(false));
                store.dispatch(SetAuthLoadingAction(false));
                if (completer != null && !completer.isCompleted) {
                  completer.complete();
                }
              });
        }
      }
      return;
    });
  };
}

ThunkAction<AppState> createUserProfile(
  UserProfile? value, {
  required Completer completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      service = UserProfileService(
        store: store,
        baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
        token: store.state.authState.token,
      );

      if (value!.countryCode == null || value.countryCode!.isEmpty) {
        value.countryCode = store.state.localeState.countryCode;
      }

      store.dispatch(SetUserStateLoadingAction(true));

      try {
        var result = await service.createUserProfile(value);

        createEcomUserProfile(
          firstName: value.firstName!,
          emailAddress: value.email!,
          lastName: value.lastName!,
          mobileNumber: value.mobileNumber!,
          profileUri: store.state.currentUser?.profileImageUri ?? '',
          authUser: store.state.currentUser!,
          countryCode: iso_models.CountryCode(
            countryName: value.countryCode,
            diallingCode: store.state.localeState.dialingCode,
            continent: store.state.localeState.currentLocale?.continent ?? '',
            countryCode:
                store.state.localeState.currentLocale?.countryCode ?? '',
            currencyCode:
                store.state.localeState.currentLocale?.currencyCode ?? '',
            countryCodeFull:
                store.state.localeState.currentLocale?.currencyCode ?? '',
          ),
        );
        store.dispatch(UserProfileLoadedAction(result));
        completer.complete();
      } catch (e) {
        store.dispatch(UserProfileLoadFailure(e.toString()));
        completer.completeError(e);
      }
    });
  };
}

Future<dynamic> createEcomUserProfile({
  required String firstName,
  required String lastName,
  required String emailAddress, //email address
  required String mobileNumber,
  required String profileUri,
  required AuthUser authUser,
  required iso_models.CountryCode countryCode,
}) async {
  LittlefishAuthManager authManager = LittlefishAuthManager.instance;

  var currentUser = authManager.user;
  var firestoreService = FirestoreService();

  if (currentUser == null) {
    throw ManagedException(message: 'Please login to create profile');
  }

  //this is the user profile
  var user = User.fromAuthUser(authUser)
    ..countryCode = countryCode.countryCode
    ..countryData = countryCode;

  user.firstName = firstName;
  user.mobileNumber = mobileNumber;
  user.lastName = lastName;

  if (isBlank(user.username)) {
    user.username = authUser.email;
  }

  user.accountType = UserAccountType.individual;
  user.profileImageUri = profileUri;
  user.linkedAccounts = [];
  user.gallery = [];

  var data = await (readFileAsJson(
    filePath: 'assets/data/user_scorecard.json',
  ));

  var scoreCard = UserScoreCard.fromJson(data!);

  user.userScoreCard = scoreCard.levels!.first;
  user.level = 1;
  user.score = 0;

  // Leave alone
  // TODO: This should be moved to its own package
  await firestoreService.saveUser(user);

  await setupUserGoals(user);

  return user;
}

Future<Map<String, dynamic>?> readFileAsJson({required String filePath}) async {
  var content = await readAssetFile(filePath: filePath);

  return jsonDecode(content);
}

Future<String> readAssetFile({required String filePath}) async {
  final ByteData data = await rootBundle.load(filePath);
  String content = utf8.decode(data.buffer.asUint8List());

  return content;
}

Future<void> setupUserGoals(User user) async {
  var data = await readFileAsJson(filePath: 'assets/data/user_scorecard.json');

  var scoreCard = UserScoreCard.fromJson(data!);

  if (scoreCard.goals != null) {
    for (final g in scoreCard.goals!) {
      await user.goalsCollection!
          .doc(g.goalId)
          .set(
            UserGoal(
              currentCount: g.goalId == EventCodeConstants.registerEvent
                  ? 1
                  : 0,
              dateCreated: DateTime.now(),
              description: g.description,
              eventId: g.eventId,
              eventQty: g.qty!.toDouble(),
              goalId: g.goalId,
              id: g.goalId,
              name: g.name,
            ).toJson(),
          );
    }
  }

  var e = scoreCard.events?.firstWhere(
    (e) => e.eventId == EventCodeConstants.registerEvent,
  );

  if (e != null) {
    var point = UserPointEvent(
      description: e.description,
      eventDate: DateTime.now(),
      eventType: e.eventId,
      id: const Uuid().v4(),
      points: e.value,
      userId: user.id,
    );

    await user.scoreEventsCollection!
        .doc('${e.eventId}:${point.id}')
        .set(point.toJson());
  }
}

ThunkAction<AppState> changeUserViewMode(
  UserViewingMode mode, {
  required Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      if (store.state.canChangeViewMode!) {
        //change the viewing mode
        store.dispatch(SetUserViewingModeAction(mode));

        //change the permissions / access manager layout
        store.dispatch(RebuildAccessManagerAction());

        //trigger the complete action
        completer?.complete();
      } else {
        completer?.completeError(
          ManagedException(
            message: 'You do not have access to change the view',
          ),
        );
      }
    });
  };
}

class SetIsGuestUserAction {
  bool value;

  SetIsGuestUserAction(this.value);
}

class SetUserStateLoadingAction {
  bool value;

  SetUserStateLoadingAction(this.value);
}

class UserProfileLoadFailure {
  String value;

  UserProfileLoadFailure(this.value);
}

class UserProfileLoadedAction {
  UserProfile? value;

  UserProfileLoadedAction(this.value);
}

class UserProfileRolesLoadFailure {
  String value;

  UserProfileRolesLoadFailure(this.value);
}

class UserProfileRolesLoadedAction {
  List<BusinessUserRole>? value;

  UserProfileRolesLoadedAction(this.value);
}

class SetUserLocationAction {
  Position value;

  SetUserLocationAction(this.value);
}

class SetUserViewingModeAction {
  UserViewingMode value;

  bool canChangeView;

  SetUserViewingModeAction(this.value, {this.canChangeView = true});
}
