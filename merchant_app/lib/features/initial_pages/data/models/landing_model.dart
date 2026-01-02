// File: landing_model.dart
import 'package:littlefish_merchant/features/initial_pages/domain/entities/landing_entity.dart';

class LandingModel {
  LandingEntity fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic value) {
      if (value is bool) return value;
      if (value is String) {
        return value.toLowerCase() == 'true';
      }
      return true; // default fallback matching entity defaults
    }

    String parseString(dynamic value) {
      if (value is String) return value;
      return '';
    }

    double parseDouble(dynamic value) {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    Map<String, String> parseComponents(dynamic value) {
      if (value is Map<String, dynamic>) {
        return value.map((key, val) => MapEntry(key, val.toString()));
      }
      return {};
    }

    return LandingEntity(
      decorationEnabled: parseBool(json['decorationenabled']),
      loginControlText: parseString(json['loginControlText']),
      useReverseColours: parseBool(json['useReverseColours']),
      createAccountText: parseString(json['createAccountText']),
      largeDisplayBannerRatio: parseDouble(json['largeDisplayBannerRatio']),
      bannerOnLeftSide: parseBool(json['bannerOnLeftSide']),
      bannerComponent: parseString(json['components']?['banner']),
      termsAndConditionsComponent: parseString(
        json['components']?['termsAndConditions'],
      ),
      welcomeComponent: parseString(json['components']?['welcome']),
      loginControlComponent: parseString(json['components']?['loginControl']),
      alignTop: parseBool(json['alignTop']),
    );
  }

  Map<String, dynamic> toJson(LandingEntity entity) {
    return {
      'decorationenabled': entity.decorationEnabled,
      'loginControlText': entity.loginControlText,
      'useReverseColours': entity.useReverseColours,
      'createAccountText': entity.createAccountText,
      'largeDisplayBannerRatio': entity.largeDisplayBannerRatio,
      'bannerOnLeftSide': entity.bannerOnLeftSide,
      'alignTop': entity.alignTop,
      'components': {
        'banner': entity.bannerComponent,
        'termsAndConditions': entity.termsAndConditionsComponent,
        'welcome': entity.welcomeComponent,
        'loginControl': entity.loginControlComponent,
      },
    };
  }
}
