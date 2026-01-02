// File: loading_model.dart
import 'package:littlefish_merchant/features/initial_pages/domain/entities/loading_entity.dart';

class LoadingModel {
  LoadingEntity fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic value, {bool defaultValue = false}) {
      if (value is bool) return value;
      if (value is String) {
        return value.toLowerCase() == 'true';
      }
      return defaultValue;
    }

    String parseString(dynamic value, {String defaultValue = ''}) {
      if (value is String) return value;
      return defaultValue;
    }

    double parseDouble(dynamic value, {double defaultValue = 0.0}) {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? defaultValue;
      return defaultValue;
    }

    final componentsJson = json['components'] as Map<String, dynamic>? ?? {};

    return LoadingEntity(
      loadingText: parseString(json['loadingText'], defaultValue: 'Loading...'),
      useReverseColours: parseBool(
        json['useReverseColours'],
        defaultValue: true,
      ),
      decorationEnabled: parseBool(
        json['decorationEnabled'],
        defaultValue: true,
      ),
      largeDisplayBannerRatio: parseDouble(
        json['largeDisplayBannerRatio'],
        defaultValue: 0.0,
      ),
      bannerOnLeftSide: parseBool(json['bannerOnLeftSide'], defaultValue: true),
      alignTop: parseBool(json['alignTop'], defaultValue: false),
      bannerComponent: parseString(
        componentsJson['banner'],
        defaultValue: 'standardBanner',
      ),
      termsAndConditionsComponent: parseString(
        componentsJson['termsAndConditions'],
        defaultValue: 'none',
      ),
      welcomeComponent: parseString(
        componentsJson['welcome'],
        defaultValue: 'none',
      ),
      progressComponent: parseString(
        componentsJson['progress'],
        defaultValue: 'default',
      ),
    );
  }

  Map<String, dynamic> toJson(LoadingEntity entity) {
    return {
      'components': {
        'banner': entity.bannerComponent,
        'termsAndConditions': entity.termsAndConditionsComponent,
        'welcome': entity.welcomeComponent,
        'progress': entity.progressComponent,
      },
      'bannerOnLeftSide': entity.bannerOnLeftSide,
      'decorationEnabled': entity.decorationEnabled,
      'largeDisplayBannerRatio': entity.largeDisplayBannerRatio,
      'loadingText': entity.loadingText,
      'useReverseColours': entity.useReverseColours,
      'alignTop': entity.alignTop,
    };
  }
}
