// remove ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/redux/app/utils/setting_up_text_helper.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/redux/app/app_actions.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/offline/offline_page.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';

import '../../../bootstrap.dart';
import '../../security/login/landing_page.dart';
import '../../online_store/tools.dart';
import '../../security/login/login_intro_page.dart';

class SplashPageViewModel {
  SplashPageViewModel();

  factory SplashPageViewModel.fromStore(Store<AppState> store) =>
      SplashPageViewModel()..store = store;

  late Store<AppState> store;

  String? message;

  String? backgroundImage;

  Future<void> populate({bool refresh = false, BuildContext? context}) async {
    bool? enableWelcomeIntro = await getKeyFromPrefsBool('enableWelcomePage');
    try {
      if (enableWelcomeIntro != null) {
        store.dispatch(
          appInitialize(
            countryCode: null,
            completer: navigateCompleter(
              globalNavigatorKey.currentContext!,
              LoginIntroPage.route,
              onFailedRoute: OfflinePage.route,
            ),
          ),
        );
      } else {
        store.dispatch(
          appInitialize(
            countryCode: null,
            completer: navigateCompleter(
              globalNavigatorKey.currentContext!,
              LoginIntroPage.route,
              onFailedRoute: OfflinePage.route,
            ),
          ),
        );
      }

      message = 'Get ready to sell!';
    } catch (e) {
      reportCheckedError(e, trace: StackTrace.current);

      if (context != null) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(LandingPage.route, (route) => false);
        showMessageDialog(
          context,
          'Error setting up account, please try again.',
          LittleFishIcons.error,
        );
      }
    }

    return;
  }

  String getSettingUpText() {
    String? stateSettingUpText = store.state.uiState.settingUpText;
    if (stateSettingUpText == null || stateSettingUpText.isEmpty) {
      return SettingUpTextHelper.defaultText;
    } else {
      return stateSettingUpText;
    }
  }
}
