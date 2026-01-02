// File: loading_data_source.dart
import 'package:flutter/foundation.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_merchant/app/app.dart' show core;
import 'package:littlefish_merchant/features/initial_pages/data/data_source/banner_data_source.dart';
import 'package:littlefish_merchant/features/initial_pages/data/data_source/data_source_helper.dart';
import 'package:littlefish_merchant/features/initial_pages/data/data_source/logo_data_source.dart';
import 'package:littlefish_merchant/features/initial_pages/data/models/loading_model.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/entities/loading_entity.dart';

const String loadingNeutralLogo = 'loadingNeutralLogo';
const String loadingDecoratedBanner = 'loadingDecoratedBanner';
const String loadingNeutralBanner = 'loadingNeutralBanner';

class LoadingDataSource {
  LoadingEntity getLoadingConfiguration({String templateKey = ''}) {
    final ConfigService configService = core.get<ConfigService>();
    var layoutOptions = configService.getObjectValue(
      key: 'ui_template_loading',
      defaultValue: {},
    );

    debugPrint(
      '#### Templates LoadingConfigurationSettings ld '
      'rxd : ${!layoutOptions.isEmpty} ',
    );

    if (layoutOptions.isEmpty) {
      layoutOptions = defaultThemes;
    }

    final keyToUse = templateKey.isNotEmpty
        ? templateKey
        : loadingNeutralBanner;
    final foundKey = findClosestKey(layoutOptions, keyToUse);

    if (foundKey.isEmpty) {
      debugPrint(
        '#### Templates LoadingConfigurationSettings: Key $keyToUse not found',
      );
      // Fallback to the original keyToUse to see if it exists, otherwise it will fail gracefully.
      if (layoutOptions.containsKey(keyToUse)) {
        final layoutMap = layoutOptions[keyToUse] ?? {};
        return LoadingModel().fromJson(layoutMap);
      }
      return LoadingEntity();
    }

    final layoutMap = layoutOptions[keyToUse] ?? {};
    final entity = LoadingModel().fromJson(layoutMap);
    return entity;
  }
}

const Map<String, Map<String, dynamic>> defaultThemes = {
  loadingDecoratedBanner: {
    'components': {
      'banner': standardBanner,
      'termsAndConditions': 'none',
      'welcome': 'none',
      'progress': 'default',
    },
    'bannerOnLeftSide': true,
    'decorationEnabled': true,
    'largeDisplayBannerRatio': 0,
    'loadingText': 'Loading...',
    'useReverseColours': true,
    'alignTop': true,
  },
  loadingNeutralLogo: {
    'components': {
      'banner': standardLogo,
      'termsAndConditions': 'none',
      'welcome': 'none',
      'progress': 'default',
    },
    'bannerOnLeftSide': true,
    'decorationEnabled': false,
    'largeDisplayBannerRatio': 0.5,
    'loadingText': 'Loading...',
    'useReverseColours': false,
    'alignTop': true,
  },
  loadingNeutralBanner: {
    'components': {
      'banner': standardBanner,
      'termsAndConditions': 'none',
      'welcome': 'none',
      'progress': 'default',
    },
    'bannerOnLeftSide': false,
    'decorationEnabled': false,
    'largeDisplayBannerRatio': 0.5,
    'loadingText': 'Loading...',
    'useReverseColours': false,
    'alignTop': true,
  },
};
