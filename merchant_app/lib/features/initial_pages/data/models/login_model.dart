// File: login_model.dart
import 'package:littlefish_merchant/features/initial_pages/domain/entities/login_entity.dart';

class LoginModel {
  LoginEntity fromJson(Map<String, dynamic> json) {
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

    return LoginEntity(
      decorationEnabled: parseBool(
        json['decorationenabled'],
        defaultValue: true,
      ),
      showBannerOnKeyboardVisible: parseBool(
        json['showBannerOnKeyboardVisible'],
        defaultValue: true,
      ),
      showWelcomeOnKeyboardVisible: parseBool(
        json['showWelcomeOnKeyboardVisible'],
        defaultValue: true,
      ),
      loginControlDisplayText: parseString(
        json['loginControlDisplayText'],
        defaultValue: '',
      ),
      loginControlOnBrandedSurface: parseBool(
        json['loginControlOnBrandedSurface'],
        defaultValue: false,
      ),
      largeDisplayBannerRatio: parseDouble(
        json['largeDisplayBannerRatio'],
        defaultValue: 0.0,
      ),
      bannerOnLeftSide: parseBool(json['bannerOnLeftSide'], defaultValue: true),
      navBackEnablediOS: parseBool(
        json['navBackEnablediOS'],
        defaultValue: false,
      ),
      navBackEnabledAndroid: parseBool(
        json['navBackEnabledAndroid'],
        defaultValue: false,
      ),
      navBackEnabledStack: parseBool(
        json['navBackEnabledStack'],
        defaultValue: false,
      ),
      navBackText: parseString(json['navBackText'], defaultValue: ''),
      alignTop: parseBool(json['alignTop'], defaultValue: false),
      bannerComponent: parseString(componentsJson['banner'], defaultValue: ''),
      termsAndConditionsComponent: parseString(
        componentsJson['termsAndConditions'],
        defaultValue: '',
      ),
      welcomeComponent: parseString(
        componentsJson['welcome'],
        defaultValue: '',
      ),
    );
  }

  Map<String, dynamic> toJson(LoginEntity entity) {
    return {
      'decorationenabled': entity.decorationEnabled,
      'showBannerOnKeyboardVisible': entity.showBannerOnKeyboardVisible,
      'showWelcomeOnKeyboardVisible': entity.showWelcomeOnKeyboardVisible,
      'loginControlDisplayText': entity.loginControlDisplayText,
      'loginControlOnBrandedSurface': entity.loginControlOnBrandedSurface,
      'largeDisplayBannerRatio': entity.largeDisplayBannerRatio,
      'bannerOnLeftSide': entity.bannerOnLeftSide,
      'navBackEnablediOS': entity.navBackEnablediOS,
      'navBackEnabledAndroid': entity.navBackEnabledAndroid,
      'navBackEnabledStack': entity.navBackEnabledStack,
      'navBackText': entity.navBackText,
      'alignTop': entity.alignTop,
      'components': {
        'banner': entity.bannerComponent,
        'termsAndConditions': entity.termsAndConditionsComponent,
        'welcome': entity.welcomeComponent,
        // Assuming 'loginControl' is not part of LoginEntity, it's a fixed value or from elsewhere
        // 'loginControl': 'default',
      },
    };
  }
}
