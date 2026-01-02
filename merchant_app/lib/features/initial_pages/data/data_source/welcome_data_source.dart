// File: welcom_data_source.dart
import 'package:flutter/foundation.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_merchant/features/initial_pages/data/models/welcome_model.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/entities/welcome_entity.dart';

import '../../../../app/app.dart';

const String landingWelcome = 'landingWelcome';
const String loginWelcome = 'loginWelcome';
const String loginSmallWelcome = 'loginSmallWelcome';

class WelcomeDataSource {
  WelcomeEntity getWelcomeConfiguration(String templateKey) {
    final ConfigService configService = core.get<ConfigService>();
    var layout = configService.getObjectValue(
      key: 'ui_template_welcome',
      defaultValue: {},
    );
    debugPrint(
      '#### Templates WelcomeConfigurationSettings ld '
      'rdx : ${!layout.isEmpty} ',
    );

    if (layout.isEmpty) {
      // use this default value to test templates
      layout = getDefaultMap('default');
    }

    final keyToUse = templateKey.isNotEmpty ? templateKey : landingWelcome;
    final keyExists = layout.containsKey(keyToUse);
    if (!keyExists) {
      debugPrint('#### WelcomeConfigurationSettings: Key $keyToUse not found');
      return WelcomeEntity();
    }

    final layoutMap = layout[keyToUse] ?? {};
    final entity = WelcomeModel().fromJson(layoutMap);
    return entity;
  }
}

/// Do not remove this until testing completed
Map<String, dynamic> getDefaultMap(String key) {
  if (key == 'sbsa') {
    return {
      landingWelcome: {
        'inverseColour': 'true',
        'topRow': ['Welcome to'],
        'topWeight': ['normal'],
        'topSize': 'large',
        'middleRow': ['Simply', 'BLU'],
        'middleWeight': ['normal', 'bold'],
        'middleSize': 'xlarge',
        'bottomRow': [],
        'bottomWeight': [],
        'bottomSize': 'medium',
        'componentPadding': ['32', '0.0', '32', '0.0'],
      },
      loginWelcome: {
        'inverseColour': 'true',
        'topRow': ['Welcome to'],
        'topWeight': ['normal'],
        'topSize': 'large',
        'middleRow': ['Simply', 'BLU'],
        'middleWeight': ['normal', 'bold'],
        'middleSize': 'xLarge',
        'bottomRow': [],
        'bottomWeight': [],
        'bottomSize': 'medium',
        'componentPadding': ['32', '0.0', '32', '0.0'],
      },
      loginSmallWelcome: {
        'inverseColour': 'true',
        'topRow': ['Welcome to'],
        'topWeight': ['normal'],
        'topSize': 'large',
        'middleRow': ['Simply', 'BLU'],
        'middleWeight': ['normal', 'bold'],
        'middleSize': 'xLarge',
        'bottomRow': [],
        'bottomWeight': [],
        'bottomSize': 'medium',
        'componentPadding': ['8', '0.0', '8', '0.0'],
      },
    };
  }

  if (key == 'absa') {
    return {
      landingWelcome: {
        'inverseColour': 'false',
        'topRow': ['Welcome to'],
        'topWeight': ['normal'],
        'topSize': 'medium',
        'middleRow': ['ShopRed'],
        'middleWeight': ['bold'],
        'middleSize': 'xxLarge',
        'bottomRow': [],
        'bottomWeight': [],
        'bottomSize': 'medium',
        'componentPadding': ['32', '0.0', '32', '0.0'],
      },
      loginWelcome: {
        'inverseColour': 'false',
        'topRow': ['Welcome!'],
        'topWeight': ['bold'],
        'topSize': 'large',
        'middleRow': [
          'Log in using the credentials that have been provided to you.',
        ],
        'middleWeight': [],
        'middleSize': 'normal',
        'bottomRow': [],
        'bottomWeight': [],
        'bottomSize': 'medium',
        'componentPadding': ['80', '64', '32', '64'],
      },
      loginSmallWelcome: {
        'inverseColour': 'false',
        'topRow': ['Welcome!'],
        'topWeight': ['bold'],
        'topSize': 'large',
        'middleRow': [
          'Log in using the credentials that have been provided to you.',
        ],
        'middleWeight': [],
        'middleSize': 'normal',
        'bottomRow': [],
        'bottomWeight': [],
        'bottomSize': 'medium',
        'componentPadding': ['8', '64', '8', '64'],
      },
    };
  }

  if (key == 'fnb') {
    return {
      landingWelcome: {
        'inverseColour': 'false',
        'topRow': ['Welcome to'],
        'topWeight': ['normal'],
        'topSize': 'medium',
        'middleRow': ['FNB'],
        'middleWeight': ['bold'],
        'middleSize': 'xxLarge',
        'bottomRow': [],
        'bottomWeight': [],
        'bottomSize': 'medium',
        'componentPadding': ['32', '0.0', '32', '0.0'],
      },
      loginWelcome: {
        'inverseColour': 'false',
        'topRow': ['Welcome!'],
        'topWeight': ['bold'],
        'topSize': 'large',
        'middleRow': [],
        'middleWeight': [],
        'middleSize': 'normal',
        'bottomRow': [],
        'bottomWeight': [],
        'bottomSize': 'medium',
        'componentPadding': ['80', '64', '32', '64'],
      },
      loginSmallWelcome: {
        'inverseColour': 'false',
        'topRow': ['Welcome!'],
        'topWeight': ['bold'],
        'topSize': 'large',
        'middleRow': [
          'Log in using the credentials that have been provided to you.',
        ],
        'middleWeight': [],
        'middleSize': 'normal',
        'bottomRow': [],
        'bottomWeight': [],
        'bottomSize': 'medium',
        'componentPadding': ['8', '64', '8', '64'],
      },
    };
  }

  return {
    landingWelcome: {
      'inverseColour': 'false',
      'topRow': ['Welcome to'],
      'topWeight': ['normal'],
      'topSize': 'large',
      'middleRow': ['Littlefish'],
      'middleWeight': ['normal'],
      'middleSize': 'xlarge',
      'bottomRow': [],
      'bottomWeight': [],
      'bottomSize': 'medium',
      'componentPadding': ['0.0', '0.0', '64', '0.0'],
    },
    loginWelcome: {
      'inverseColour': 'false',
      'topRow': ['Welcome to'],
      'topWeight': ['normal'],
      'topSize': 'large',
      'middleRow': ['Littlefish'],
      'middleWeight': ['normal'],
      'middleSize': 'xLarge',
      'bottomRow': [],
      'bottomWeight': [],
      'bottomSize': 'medium',
      'componentPadding': ['32', '0.0', '32', '0.0'],
    },
    loginSmallWelcome: {
      'inverseColour': 'true',
      'topRow': ['Welcome to'],
      'topWeight': ['normal'],
      'topSize': 'large',
      'middleRow': ['Littlefish'],
      'middleWeight': ['normal'],
      'middleSize': 'xLarge',
      'bottomRow': [],
      'bottomWeight': [],
      'bottomSize': 'medium',
      'componentPadding': ['8', '0.0', '8', '0.0'],
    },
  };
}
