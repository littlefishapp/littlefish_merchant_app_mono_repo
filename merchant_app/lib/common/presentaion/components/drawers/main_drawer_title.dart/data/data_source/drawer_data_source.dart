// File: drawer_title_data_source.dart
import 'package:flutter/foundation.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_merchant/app/app.dart' show core;
import 'package:littlefish_merchant/common/presentaion/components/drawers/main_drawer_title.dart/data/models/drawer_title_model.dart';
import 'package:littlefish_merchant/common/presentaion/components/drawers/main_drawer_title.dart/domain/entity/drawer_title_entity.dart';

const String mainDrawerTitle = 'mainDrawerTitle';

class DrawerTitleDataSource {
  DrawerTitleEntity getDrawerTitleConfiguration() {
    final ConfigService configService = core.get<ConfigService>();
    var layout = configService.getObjectValue(
      key: 'ui_template_drawer_title',
      defaultValue: {},
    );

    debugPrint(
      '#### Templates DrawerTitleConfiguration '
      '    ld rxd : ${!layout.isEmpty}',
    );
    if (layout.isEmpty) {
      // use this default value to test configurations
      layout = getDefaultMap('default');
    }

    final keyToUse = mainDrawerTitle;
    final keyExists = layout.containsKey(keyToUse);
    if (!keyExists) {
      debugPrint('#### DrawerTitleConfiguration: Key $keyToUse not found');
      return DrawerTitleEntity();
    }

    final layoutMap = layout[keyToUse] ?? {};
    final entity = DrawerTitleModel().fromJson(layoutMap);
    return entity;
  }
}

/// Do not remove this until testing completed
Map<String, dynamic> getDefaultMap(String key) {
  if (key == 'sbsa') {
    return {
      mainDrawerTitle: {
        'inverseColour': 'true',
        'texts': ['Simply', 'BLU'],
        'textSizes': ['large', 'large'],
        'textWeights': ['normal', 'bold'],
        'showIcon': 'true',
        'useAssetLogo': 'true',
        'padding': ['0.0', '0.0', '8.0', '0'],
      },
    };
  }

  if (key == 'absa') {
    return {
      mainDrawerTitle: {
        'inverseColour': 'false',
        'texts': ['ShopRed'],
        'textSizes': ['medium'],
        'textWeights': ['normal'],
        'showIcon': 'false',
        'useAssetLogo': 'false',
        'padding': ['0.0', '0.0', '0.0', '0.0'],
      },
    };
  }

  if (key == 'fnb') {
    return {
      mainDrawerTitle: {
        'inverseColour': 'true',
        'texts': ['Welcome to FNB'],
        'textSizes': ['medium'],
        'textWeights': ['normal'],
        'showIcon': 'false',
        'useAssetLogo': 'true',
        'padding': ['0.0', '0.0', '0.0', '0.0'],
      },
    };
  }

  return {
    mainDrawerTitle: {
      'inverseColour': 'false',
      'texts': ['Welcome'],
      'textSizes': ['medium'],
      'textWeights': ['normal'],
      'showIcon': 'false',
      'useAssetLogo': 'false',
      'padding': ['0.0', '0.0', '0.0', '0.0'],
    },
  };
}
