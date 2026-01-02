import 'package:flutter/foundation.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_merchant/app/app.dart' show core;
import 'package:littlefish_merchant/common/presentaion/components/form_fields/form_field_config/form_field_config_entity.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/form_field_config/form_field_model.dart';

const String formFieldSettingsKey = 'ui_style_form_field_settings';

class FormFieldConfigDataSource {
  FormFieldConfigEntity getConfiguration() {
    try {
      final ConfigService configService = core.get<ConfigService>();

      final Map<String, dynamic> rawConfig = configService.getObjectValue(
        key: formFieldSettingsKey,
        defaultValue: {},
      );

      debugPrint(
        '#### Templates FormFieldConfigDataSource '
        '   ld rxd : ${rawConfig.isNotEmpty}',
      );
      final configMap = rawConfig.isEmpty ? _getDefaultMap() : rawConfig;

      return FormFieldModel().fromJson(configMap);
    } catch (e) {
      return FormFieldModel().fromJson(_getDefaultMap());
    }
  }

  Map<String, dynamic> _getDefaultMap() {
    return {
      'changes': {'09 Dec 2025 07h10': 'Initial version, add hintTextStyle'},
      'hintTextStyle': 'paragraphMediumRegular',
    };
  }
}
