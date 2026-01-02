import 'package:flutter/foundation.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_merchant/app/app.dart' show core;
import 'package:littlefish_merchant/features/initial_pages/data/data_source/landing_data_source.dart';
import 'package:littlefish_merchant/features/initial_pages/data/data_source/loading_data_source.dart';
import 'package:littlefish_merchant/features/initial_pages/data/data_source/login_data_source.dart';
import 'package:littlefish_merchant/features/initial_pages/data/models/initial_template_model.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/entities/initial_template_entity.dart';

class InitialTemplateDataSource {
  InitialTemplateEntity getInitialTemplateConfiguration() {
    final ConfigService configService = core.get<ConfigService>();
    var layoutOptions = configService.getObjectValue(
      key: 'ui_template_global',
      defaultValue: {},
    );
    debugPrint(
      '#### Templates InitialTemplateConfiguration ld '
      'rxd : ${!layoutOptions.isEmpty}',
    );

    if (layoutOptions.isEmpty) {
      // use this default value to test templates
      layoutOptions = getDefaultMap('default');
    }

    final entity = InitialTemplateModel().fromJson(layoutOptions);
    return entity;
  }
}

Map<String, dynamic> getDefaultMap(String flavor) {
  if (flavor == 'decorated') {
    return {
      'landing': landingDecoratedBanner,
      'initial': '',
      'loading': loadingDecoratedBanner,
      'login': loginDecoratedBannerWelcome,
    };
  }

  if (flavor == 'template2') {
    return {
      'landing': landingNeutralBannerNoWelcome,
      'initial': '',
      'loading': loadingNeutralBanner,
      'login': loginNeutralStandardBanner,
    };
  }

  if (flavor == 'template3') {
    return {
      'landing': landingNeutralLogoNoWelcome,
      'initial': '',
      'loading': loadingNeutralLogo,
      'login': loginNeutralLogo,
    };
  }

  if (flavor == 'template4') {
    //absa
    return {
      'landing': landingNeutralBanner,
      'initial': '',
      'loading': loadingNeutralLogo,
      'login': loggingNeutralBannerWelcome,
    };
  }

  return {
    'landing': landingNeutralBanner,
    'initial': '',
    'loading': loadingNeutralLogo,
    'login': loginNeutralStandardBanner,
  };
}
