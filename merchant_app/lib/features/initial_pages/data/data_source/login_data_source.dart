// File: login_data_source.dart
import 'package:flutter/foundation.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_merchant/app/app.dart' show core;
import 'package:littlefish_merchant/features/initial_pages/data/data_source/data_source_helper.dart';
import 'package:littlefish_merchant/features/initial_pages/data/data_source/welcome_data_source.dart';
import 'package:littlefish_merchant/features/initial_pages/data/models/login_model.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/entities/login_entity.dart';

const String loginNeutralStandardBanner = 'loginNeutralStandardBanner';
const String loginDecoratedStandardBanner = 'loginDecoratedStandardBanner';
const String loginDecoratedBannerWelcome =
    'loginDecoratedStandardBannerWelcome';
const String loginNeutralLogo = 'loginNeutralLogo';
const String loggingNeutralLogoWelcome = 'loggingNeutralLogoWelcome';
const String loggingNeutralBannerWelcome = 'loggingNeutralBannerWelcome';

class LoginDataSource {
  LoginEntity getLoginConfiguration({String keyToUse = ''}) {
    final ConfigService configService = core.get<ConfigService>();
    var layout = configService.getObjectValue(
      key: 'ui_template_login',
      defaultValue: {},
    );

    debugPrint(
      '#### Templates LoginConfigurationSettings.  ld '
      'rdx : ${!layout.isEmpty} ',
    );

    if (layout.isEmpty) {
      layout = defaultThemes();
    }

    final foundKey = findClosestKey(layout, keyToUse);

    if (foundKey.isEmpty) {
      debugPrint('#### LoginConfigurationSettings: Key $keyToUse not found');
      if (layout.containsKey(keyToUse)) {
        final layoutMap = layout[keyToUse] ?? {};
        return LoginModel().fromJson(layoutMap);
      }
      return LoginEntity();
    }

    final layoutMap = layout[keyToUse] ?? {};
    final entity = LoginModel().fromJson(layoutMap);
    return entity;
  }
}

Map<String, Map<String, dynamic>> defaultThemes() {
  return {
    loginDecoratedBannerWelcome: {
      'name': 'Decorated Banner Login Welcome',
      'showBannerOnKeyboardVisible': false,
      'showWelcomeOnKeyboardVisible': false,
      'bannerOnLeftSide': true,
      'decorationenabled': true,
      'largeDisplayBannerRatio': 0.5,
      'loginControlOnBrandedSurface': true,
      'loginControlDisplayText': 'SIGN IN',
      'navBackEnablediOS': true,
      'navBackEnabledAndroid': false,
      'navBackEnabledStack': false,
      'navBackText': 'Not registered? Return to previous page',
      'alignTop': true,
      'components': {
        'banner': loginDecoratedStandardBanner,
        'termsAndConditions': 'none',
        'welcome': loginWelcome,
        'loginControl': 'default',
      },
    },
    loginNeutralStandardBanner: {
      'name': 'Neutral Standard Banner Login',
      'showBannerOnKeyboardVisible': false,
      'showWelcomeOnKeyboardVisible': false,
      'bannerOnLeftSide': true,
      'decorationenabled': false,
      'largeDisplayBannerRatio': 0.6,
      'loginControlOnBrandedSurface': false,
      'loginControlDisplayText': 'LOG IN',
      'navBackEnablediOS': true,
      'navBackEnabledAndroid': false,
      'navBackEnabledStack': true,
      'navBackText': 'Not registered? Return to previous page',
      'alignTop': true,
      'components': {
        'banner': loginNeutralStandardBanner,
        'termsAndConditions': 'none',
        'welcome': 'none',
        'loginControl': 'default',
      },
    },
    loginNeutralLogo: {
      'showBannerOnKeyboardVisible': false,
      'showWelcomeOnKeyboardVisible': false,
      'bannerOnLeftSide': true,
      'decorationenabled': false,
      'largeDisplayBannerRatio': 0.4,
      'loginControlOnBrandedSurface': false,
      'loginControlDisplayText': 'LOG IN',
      'navBackEnablediOS': true,
      'navBackEnabledAndroid': false,
      'navBackEnabledStack': false,
      'navBackText': 'Not registered? Return to previous page',
      'alignTop': false,
      'components': {
        'banner': loginNeutralLogo,
        'termsAndConditions': 'none',
        'welcome': 'none',
        'loginControl': 'default',
      },
    },
    loggingNeutralBannerWelcome: {
      'showBannerOnKeyboardVisible': false,
      'showWelcomeOnKeyboardVisible': false,
      'bannerOnLeftSide': true,
      'decorationenabled': false,
      'largeDisplayBannerRatio': 0.4,
      'loginControlOnBrandedSurface': false,
      'loginControlDisplayText': 'LOG IN',
      'navBackEnablediOS': true,
      'navBackEnabledAndroid': false,
      'navBackEnabledStack': false,
      'navBackText': 'Not registered? Return to previous page',
      'alignTop': false,
      'components': {
        'banner': loginNeutralStandardBanner,
        'termsAndConditions': 'none',
        'welcome': loginWelcome,
        'loginControl': 'default',
      },
    },
  };
}
