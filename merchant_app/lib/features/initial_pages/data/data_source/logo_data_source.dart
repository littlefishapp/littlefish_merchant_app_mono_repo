import 'package:flutter/foundation.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_merchant/features/initial_pages/data/data_source/data_source_helper.dart';
import 'package:littlefish_merchant/features/initial_pages/data/models/logo_model.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/entities/logo_entity.dart';

import '../../../../app/app.dart';

const standardLogo = 'standardLogo';
const smallLogo = 'smallLogo';

class LogoDataSource {
  LogoEntity getLogoConfiguration(String keyToUse) {
    final ConfigService configService = core.get<ConfigService>();
    var layout = configService.getObjectValue(
      key: 'ui_template_logo',
      defaultValue: {},
    );

    debugPrint(
      '#### Templates LogoConfigurationSettings    ld '
      'rdx : ${!layout.isEmpty} ',
    );

    if (layout.isEmpty) {
      // use this default value to test templates
      layout = getDefaultMap('default');
    }

    final foundKey = findClosestKey(layout, keyToUse);

    if (foundKey.isEmpty) {
      debugPrint('#### LogoConfigurationSettings: Key $keyToUse not found');
      // Fallback to the original keyToUse to see if it exists, otherwise it will fail gracefully.
      if (layout.containsKey(keyToUse)) {
        final layoutMap = layout[keyToUse] ?? {};
        return LogoModel().fromJson(layoutMap);
      }
      return LogoEntity();
    }

    final layoutMap = layout[keyToUse] ?? {};

    final entity = LogoModel().fromJson(layoutMap);
    return entity;
  }
}

Map<String, dynamic> getDefaultMap(String key) {
  if (key == 'sbsa') {
    return {
      standardLogo: {
        'showVersion': 'true',
        'centreLogo': 'true',
        'leftPadding': '0.0',
        'topPadding': '32.0',
        'bottomPadding': '12.0',
        'rightPadding': '0.0',
        'height': '154.0',
        'width': '80.0',
        'useHeight': 'true',
        'useWidth': 'false',
        'inverseColour': 'true',
        'boxFit': 'contain',
      },
      smallLogo: {
        'showVersion': 'true',
        'centreLogo': 'true',
        'leftPadding': '0.0',
        'topPadding': '16.0',
        'bottomPadding': '16.0',
        'rightPadding': '0.0',
        'height': '80.0',
        'width': '80.0',
        'useHeight': 'true',
        'useWidth': 'false',
        'inverseColour': 'true',
        'boxFit': 'contain',
      },
    };
  }

  if (key == 'absa') {
    return {
      standardLogo: {
        'showVersion': 'false',
        'centreLogo': 'true',
        'leftPadding': '0.0',
        'topPadding': '170',
        'bottomPadding': '80',
        'rightPadding': '0.0',
        'height': '112',
        'width': '112',
        'useHeight': 'true',
        'useWidth': 'true',
        'inverseColour': 'false',
        'boxFit': 'contain',
      },
      smallLogo: {
        'showVersion': 'false',
        'centreLogo': 'true',
        'leftPadding': '0.0',
        'topPadding': '16',
        'bottomPadding': '16',
        'rightPadding': '0.0',
        'height': '112',
        'width': '112',
        'useHeight': 'true',
        'useWidth': 'true',
        'inverseColour': 'false',
        'boxFit': 'contain',
      },
    };
  }

  if (key == 'fnb') {
    return {
      standardLogo: {
        'showVersion': 'false',
        'centreLogo': 'true',
        'leftPadding': '0.0',
        'topPadding': '146',
        'bottomPadding': '270',
        'rightPadding': '0.0',
        'height': '112',
        'width': '112',
        'useHeight': 'true',
        'useWidth': 'true',
        'inverseColour': 'false',
        'boxFit': 'contain',
      },
      smallLogo: {
        'showVersion': 'false',
        'centreLogo': 'true',
        'leftPadding': '0.0',
        'topPadding': '16',
        'bottomPadding': '16',
        'rightPadding': '0.0',
        'height': '112',
        'width': '112',
        'useHeight': 'true',
        'useWidth': 'true',
        'inverseColour': 'false',
        'boxFit': 'contain',
      },
    };
  }

  if (key == 'lf') {
    return {
      standardLogo: {
        'showVersion': 'false',
        'centreLogo': 'true',
        'leftPadding': '0.0',
        'topPadding': '150',
        'bottomPadding': '40',
        'rightPadding': '0.0',
        'height': '112',
        'width': '112',
        'useHeight': 'true',
        'useWidth': 'false',
        'inverseColour': 'false',
        'boxFit': 'fitWidth',
      },
      smallLogo: {
        'showVersion': 'false',
        'centreLogo': 'true',
        'leftPadding': '0.0',
        'topPadding': '16',
        'bottomPadding': '16',
        'rightPadding': '0.0',
        'height': '112',
        'width': '112',
        'useHeight': 'true',
        'useWidth': 'true',
        'inverseColour': 'false',
        'boxFit': 'contain',
      },
    };
  }

  return {
    standardLogo: {
      'showVersion': 'true',
      'centreLogo': 'true',
      'leftPadding': '0.0',
      'topPadding': '32.0',
      'bottomPadding': '12.0',
      'rightPadding': '0.0',
      'height': '154.0',
      'width': '80.0',
      'useHeight': 'true',
      'useWidth': 'false',
      'inverseColour': 'false',
      'boxFit': 'contain',
    },
    smallLogo: {
      'showVersion': 'true',
      'centreLogo': 'true',
      'leftPadding': '0.0',
      'topPadding': '16.0',
      'bottomPadding': '16.0',
      'rightPadding': '0.0',
      'height': '80.0',
      'width': '80.0',
      'useHeight': 'true',
      'useWidth': 'false',
      'inverseColour': 'false',
      'boxFit': 'contain',
    },
  };
}
