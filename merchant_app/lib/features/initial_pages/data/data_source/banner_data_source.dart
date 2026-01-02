import 'package:flutter/foundation.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_merchant/features/initial_pages/data/data_source/data_source_helper.dart';
import 'package:littlefish_merchant/features/initial_pages/data/models/banner_model.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/entities/banner_entity.dart';
import 'package:littlefish_merchant/app/app.dart' show core;

const standardBanner = 'standardBanner';
const smallBanner = 'smallBanner';

class BannerDataSource {
  BannerEntity getBannerConfiguration(String templateKey) {
    final ConfigService configService = core.get<ConfigService>();
    var layout = configService.getObjectValue(
      key: 'ui_template_banner',
      defaultValue: {},
    );
    debugPrint(
      '#### Templates BannerConfigurationSettings  ld '
      'rdx : ${!layout.isEmpty} ',
    );

    if (layout.isEmpty) {
      // use this default value to test templates
      layout = getDefaultMap('default');
    }

    final keyToUse = templateKey.isNotEmpty ? templateKey : standardBanner;
    final foundKey = findClosestKey(layout, keyToUse);

    if (foundKey.isEmpty) {
      debugPrint(
        '#### Templates BannerConfigurationSettings: No suitable key found for $keyToUse',
      );
      // Fallback to the original keyToUse to see if it exists, otherwise it will fail gracefully.
      if (layout.containsKey(keyToUse)) {
        final layoutMap = layout[keyToUse] ?? {};
        return BannerModel().fromJson(layoutMap);
      }
      return BannerEntity();
    }

    final layoutMap = layout[foundKey] ?? {};
    final entity = BannerModel().fromJson(layoutMap);
    return entity;
  }
}

Map<String, dynamic> getDefaultMap(String key) {
  if (key == 'sbsa') {
    return {
      standardBanner: {
        'showVersion': 'true',
        'centreBanner': 'true',
        'leftPadding': '0.0',
        'topPadding': '24.0',
        'bottomPadding': '12.0',
        'rightPadding': '0.0',
        'height': '154.0',
        'width': '80.0',
        'useHeight': 'true',
        'useWidth': 'false',
        'inverseColour': 'true',
        'useGradient': 'false',
        'boxFit': 'fitWidth',
      },
      smallBanner: {
        'showVersion': 'true',
        'centreBanner': 'true',
        'leftPadding': '0.0',
        'topPadding': '8.0',
        'bottomPadding': '4.0',
        'rightPadding': '0.0',
        'height': '120.0',
        'width': '80.0',
        'useHeight': 'true',
        'useWidth': 'false',
        'inverseColour': 'true',
        'useGradient': 'false',
        'boxFit': 'fitWidth',
      },
    };
  }
  if (key == 'absa') {
    return {
      standardBanner: {
        'showVersion': 'false',
        'centreBanner': 'true',
        'leftPadding': '0.0',
        'topPadding': '0.0',
        'bottomPadding': '0.0',
        'rightPadding': '0.0',
        'height': '200.0',
        'width': '0.0',
        'useHeight': 'false',
        'useWidth': 'false',
        'inverseColour': 'false',
        'useGradient': 'false',
        'boxFit': 'fitWidth',
      },
      smallBanner: {
        'showVersion': 'false',
        'centreBanner': 'true',
        'leftPadding': '0.0',
        'topPadding': '0.0',
        'bottomPadding': '0.0',
        'rightPadding': '0.0',
        'height': '150.0',
        'width': '0.0',
        'useHeight': 'true',
        'useWidth': 'false',
        'inverseColour': 'false',
        'useGradient': 'false',
        'boxFit': 'fitWidth',
      },
    };
  }

  if (key == 'fnb') {
    return {
      standardBanner: {
        'showVersion': 'false',
        'centreBanner': 'true',
        'leftPadding': '0.0',
        'topPadding': '64',
        'bottomPadding': '0.0',
        'rightPadding': '0.0',
        'height': '160.0',
        'width': '0.0',
        'useHeight': 'true',
        'useWidth': 'false',
        'inverseColour': 'false',
        'useGradient': 'false',
        'boxFit': 'fitWidth',
      },
      smallBanner: {
        'showVersion': 'false',
        'centreBanner': 'true',
        'leftPadding': '0.0',
        'topPadding': '0.0',
        'bottomPadding': '0.0',
        'rightPadding': '0.0',
        'height': '150.0',
        'width': '0.0',
        'useHeight': 'true',
        'useWidth': 'false',
        'inverseColour': 'false',
        'useGradient': 'false',
        'boxFit': 'fitWidth',
      },
    };
  }

  if (key == 'faded') {
    return {
      standardBanner: {
        'showVersion': 'true',
        'centreBanner': 'true',
        'leftPadding': '0.0',
        'topPadding': '32',
        'bottomPadding': '0.0',
        'rightPadding': '0.0',
        'height': '200.0',
        'width': '200',
        'useHeight': 'false',
        'useWidth': 'false',
        'inverseColour': 'false',
        'useGradient': 'true',
        'boxFit': 'fitWidth',
      },
      smallBanner: {
        'showVersion': 'false',
        'centreBanner': 'true',
        'leftPadding': '0.0',
        'topPadding': '0.0',
        'bottomPadding': '0.0',
        'rightPadding': '0.0',
        'height': '150.0',
        'width': '0.0',
        'useHeight': 'true',
        'useWidth': 'false',
        'inverseColour': 'false',
        'useGradient': 'false',
        'boxFit': 'fitWidth',
      },
    };
  }

  return {
    standardBanner: {
      'showVersion': 'true',
      'centreBanner': 'true',
      'leftPadding': '0.0',
      'topPadding': '64',
      'bottomPadding': '0.0',
      'rightPadding': '0.0',
      'height': '200.0',
      'width': '0.0',
      'useHeight': 'false',
      'useWidth': 'false',
      'inverseColour': 'false',
      'useGradient': 'false',
      'boxFit': 'fitWidth',
    },
    smallBanner: {
      'showVersion': 'false',
      'centreBanner': 'true',
      'leftPadding': '0.0',
      'topPadding': '0.0',
      'bottomPadding': '0.0',
      'rightPadding': '0.0',
      'height': '150.0',
      'width': '0.0',
      'useHeight': 'true',
      'useWidth': 'false',
      'inverseColour': 'false',
      'useGradient': 'false',
      'boxFit': 'fitWidth',
    },
  };
}
