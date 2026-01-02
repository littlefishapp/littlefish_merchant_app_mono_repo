// File: landing_data_source.dart
import 'package:flutter/foundation.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_merchant/app/app.dart' show core;
import 'package:littlefish_merchant/features/initial_pages/data/data_source/banner_data_source.dart';
import 'package:littlefish_merchant/features/initial_pages/data/data_source/logo_data_source.dart';
import 'package:littlefish_merchant/features/initial_pages/data/data_source/terms_and_conditions_data_source.dart';
import 'package:littlefish_merchant/features/initial_pages/data/data_source/welcome_data_source.dart';
import 'package:littlefish_merchant/features/initial_pages/data/models/landing_model.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/entities/landing_entity.dart';

const String landingDecoratedBanner = 'landingDecoratedBanner';
const String landingNeutralBanner = 'landingNeutralBanner';
const String landingNeutralBannerSmall = 'landingNeutralBannerSmall';
const String landingNeutralLogoNoWelcome = 'landingNeutralLogoNoWelcome';
const String landingNeutralBannerNoWelcome = 'landingNeutralBannerNoWelcome';

class LandingDataSource {
  LandingEntity getLandingConfiguration({String templateKey = ''}) {
    final ConfigService configService = core.get<ConfigService>();
    var layoutOptions = configService.getObjectValue(
      key: 'ui_template_landing',
      defaultValue: {},
    );

    debugPrint(
      '#### Templates LandingConfiguration         ld '
      'rxd : ${!layoutOptions.isEmpty} ',
    );

    if (layoutOptions.isEmpty) {
      layoutOptions = defaultThemes;
    }

    final keyToUse = templateKey.isNotEmpty
        ? templateKey
        : landingDecoratedBanner;
    final keyExists = layoutOptions.containsKey(keyToUse);
    if (!keyExists) {
      debugPrint(
        '#### Templates LandingConfigurationSettings: Key $keyToUse not found',
      );
      return LandingEntity();
    }

    final layoutMap = layoutOptions[keyToUse] ?? {};
    final entity = LandingModel().fromJson(layoutMap);

    return entity;
  }
}

const Map<String, Map<String, dynamic>> defaultThemes = {
  landingDecoratedBanner: {
    'components': {
      'banner': standardBanner,
      'termsAndConditions': termsAndConditionsSpecific,
      'welcome': landingWelcome,
      'loginControl': 'default',
    },
    'loginControlText': 'SIGN IN',
    'bannerOnLeftSide': true,
    'useReverseColours': true,
    'decorationenabled': true,
    'termsAndConditionEnabled': true,
    'largeDisplayBannerRatio': 0.5,
    'createAccountText': 'CREATE ACCOUNT',
    'welcomeEnabled': true,
    'alignTop': true,
  },
  landingNeutralBanner: {
    'components': {
      'banner': standardLogo,
      'termsAndConditions': 'none',
      'welcome': landingWelcome,
      'loginControl': 'default',
    },
    'loginControlText': 'LOG IN',
    'bannerOnLeftSide': true,
    'useReverseColours': false,
    'decorationenabled': false,
    'termsAndConditionEnabled': false,
    'largeDisplayBannerRatio': 0,
    'createAccountText': 'REGISTER',
    'welcomeEnabled': true,
    'alignTop': false,
  },
  landingNeutralBannerSmall: {
    'components': {
      'banner': 'none',
      'termsAndConditions': 'none',
      'welcome': landingWelcome,
      'loginControl': 'default',
    },
    'loginControlText': 'LOG IN',
    'bannerOnLeftSide': true,
    'useReverseColours': false,
    'decorationenabled': false,
    'termsAndConditionEnabled': false,
    'largeDisplayBannerRatio': 0,
    'createAccountText': 'REGISTER',
    'welcomeEnabled': true,
    'alignTop': true,
  },
  landingNeutralLogoNoWelcome: {
    'components': {
      'banner': standardLogo,
      'termsAndConditions': 'none',
      'welcome': 'none',
      'loginControl': 'default',
    },
    'loginControlText': 'LOG IN',
    'bannerOnLeftSide': true,
    'useReverseColours': false,
    'decorationenabled': false,
    'termsAndConditionEnabled': false,
    'largeDisplayBannerRatio': 0.6,
    'createAccountText': 'CREATE ACCOUNT',
    'welcomeEnabled': false,
    'alignTop': true,
  },
  landingNeutralBannerNoWelcome: {
    'components': {
      'banner': standardBanner,
      'termsAndConditions': 'none',
      'welcome': 'none',
      'loginControl': 'default',
    },
    'loginControlText': 'LOG IN',
    'bannerOnLeftSide': false,
    'useReverseColours': false,
    'decorationenabled': false,
    'termsAndConditionEnabled': false,
    'largeDisplayBannerRatio': 0.6,
    'createAccountText': 'CREATE ACCOUNT',
    'welcomeEnabled': false,
    'alignTop': true,
  },
};
