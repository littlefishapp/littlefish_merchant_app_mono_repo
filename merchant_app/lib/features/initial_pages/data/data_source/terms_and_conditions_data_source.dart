// lib/features/initial_pages/data/data_source/terms_and_conditions_data_source.dart
import 'package:flutter/foundation.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/features/initial_pages/data/data_source/data_source_helper.dart';
import 'package:littlefish_merchant/features/initial_pages/data/models/terms_and_conditions_model.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/entities/terms_and_conditions_entity.dart';

const String termsAndConditionsDefault = 'termsAndConditionsDefault';
const String termsAndConditionsSpecific = 'termsAndConditionsSpecific';

class TermsAndConditionsDataSource {
  TermsAndConditionsEntity getConfiguration({String templateKey = ''}) {
    final ConfigService config = core.get<ConfigService>();
    var layout = config.getObjectValue(
      key: 'ui_template_terms_and_conditions',
      defaultValue: {},
    );

    debugPrint(
      '#### Templates TermsAndConditions'
      '           ld rxd : ${layout.isEmpty}',
    );

    if (layout.isEmpty) {
      layout = _defaultMap('default');
    }

    final keyToUse = templateKey.isNotEmpty
        ? templateKey
        : termsAndConditionsDefault;
    final foundKey = findClosestKey(layout, keyToUse);

    if (foundKey.isEmpty) {
      debugPrint('#### Templates TermsAndConditions: Key $keyToUse not found');
      if (layout.containsKey(keyToUse)) {
        final layoutMap = layout[keyToUse] ?? {};
        return TermsAndConditionsModel().fromJson(layoutMap);
      }
      return TermsAndConditionsEntity();
    }

    final layoutMap = layout[foundKey] ?? {};
    final entity = TermsAndConditionsModel().fromJson(layoutMap);
    return entity;
  }

  Map<String, dynamic> _defaultMap(String key) {
    if (key == 'sbsa') {
      return {
        termsAndConditionsSpecific: {
          'inverseColour': 'true',
          'prefixTexts': ['By signing in, I agree to the', '\u00A0'],
          'linkText': 'T&Cs',
          'url': 'https://sbsa.co.za/terms-and-conditions',
          'title': 'Terms and Conditions',
          'isAsset': 'true',
        },
        termsAndConditionsDefault: {
          'inverseColour': 'false',
          'prefixTexts': ['By signing in, I agree to the '],
          'linkText': 'T&Cs',
          'url': 'https://example.com/terms',
          'title': 'Terms and Conditions',
          'isAsset': 'false',
        },
      };
    }

    return {
      termsAndConditionsSpecific: {
        'inverseColour': 'false',
        'prefixTexts': [''],
        'linkText': '',
        'url': '',
        'title': '',
        'isAsset': 'false',
      },
      termsAndConditionsDefault: {
        'inverseColour': 'false',
        'prefixTexts': ['By signing in, I agree to the '],
        'linkText': 'T&Cs',
        'url': 'https://example.com/terms',
        'title': 'Terms and Conditions',
        'isAsset': 'false',
      },
    };
  }
}
