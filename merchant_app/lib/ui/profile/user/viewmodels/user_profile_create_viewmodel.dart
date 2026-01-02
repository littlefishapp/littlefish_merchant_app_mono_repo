// removed ignore: depend_on_referenced_packages

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:littlefish_core/auth/services/auth_service.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/services/user_profile_service.dart';
import 'package:littlefish_merchant/ui/business/profile/pages/business_profile_create_page.dart';
import 'package:littlefish_merchant/ui/online_store/shared/routes/custom_route.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/models/security/user/user_profile.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/user/user_actions.dart';
import 'package:littlefish_merchant/redux/user/user_state.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

import '../../../security/login/splash_page.dart';

class UserProfileVM extends StoreItemViewModel<UserProfile?, UserState> {
  UserProfileVM.fromStore(Store<AppState> store) : super.fromStore(store);

  late Function(BuildContext ctx) onUpdateProfile;
  late Function(BuildContext ctx) onLogout;
  late Function(UserProfile? profile, BuildContext ctx, String? route)
  onUpsertProfile;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    state = store.state.userState;
    this.store = store;

    isLoading = state!.isLoading;
    hasError = state!.hasError;
    item = state!.profile;
    errorMessage = state!.errorMessage;

    onUpdateProfile = (ctx) {
      if (key != null && key!.currentState!.validate()) {
        key!.currentState!.save();

        store.dispatch(
          updateUserProfile(
            item,
            completer: snackBarCompleter(
              ctx,
              'Your profile has updated successfully',
              shouldPop: false,
            ),
          ),
        );
      }
    };

    onLogout = (ctx) {
      store.dispatch(signOut(reason: 'user-logoff'));
    };

    onUpsertProfile = (item, ctx, route) async {
      if (key != null && key!.currentState!.validate()) {
        key!.currentState!.save();
        bool canUpdate = false;

        Completer completer = Completer();

        // Validate account is created

        try {
          UserProfileService userProfileService = UserProfileService(
            store: store,
            baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
            token: store.state.authState.token,
            businessId: store.state.currentBusinessId,
          );
          var result = await userProfileService.getUserProfile();
          if (result != null) {
            canUpdate = true;
          }
        } catch (e) {
          canUpdate = false;
        }

        if (this.item?.prefix == null) this.item?.prefix = '';
        if (this.item?.gender == null) this.item?.gender = Gender.notSpecified;

        if (canUpdate) {
          store.dispatch(updateUserProfile(this.item, completer: completer));
        } else {
          store.dispatch(createUserProfile(this.item, completer: completer));
        }

        await completer.future.catchError((error) async {
          await showMessageDialog(
            globalNavigatorKey.currentContext!,
            error.toString(),
            LittleFishIcons.error,
          );
          return;
        });

        if ((store.state.businessState.profile == null ||
            !store.state.businessState.profile!.validate())) {
          await Navigator.of(ctx).push(
            CustomRoute(
              builder: (context) => const BusinessProfileCreatePage(),
            ),
          );
        } else {
          await Navigator.pushNamedAndRemoveUntil(
            globalNavigatorKey.currentContext!,
            SplashPage.route,
            ModalRoute.withName(SplashPage.route),
          );
        }
      }
    };

    onAdd = (item, ctx) {
      if (key != null && key!.currentState!.validate()) {
        key!.currentState!.save();
        if (this.item?.prefix == null) this.item?.prefix = '';
        if (this.item?.gender == null) this.item?.gender = Gender.notSpecified;
        if (state!.profile != null &&
            AppVariables.store!.state.enableSignupActivation!) {
          store.dispatch(
            updateUserProfile(
              this.item,
              completer: navigateCompleter(ctx!, SplashPage.route),
            ),
          );
          return;
        }
        store.dispatch(
          createUserProfile(
            this.item,
            completer: navigateCompleter(ctx!, SplashPage.route),
          ),
        );
      }
    };
  }
}
