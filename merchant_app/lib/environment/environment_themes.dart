import 'package:flutter/material.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_merchant/app/theme/app_theme_data.dart';
import 'package:littlefish_merchant/app/theme/button_style_data.dart';
import 'package:littlefish_merchant/app/theme/design_system/design_system.dart';
import 'package:littlefish_merchant/app/theme/modal_theme_config.dart';
import 'package:littlefish_merchant/app/theme/typography_data.dart';
import 'package:littlefish_merchant/environment/default_design_system.dart';
import 'package:littlefish_merchant/environment/fnb_default_design_system.dart';
import 'package:littlefish_merchant/environment/theme_from_config/applied_border_from_design_config.dart';
import 'package:littlefish_merchant/environment/theme_from_config/applied_button_from_design_config.dart';
import 'package:littlefish_merchant/environment/theme_from_config/applied_form_input_from_design_config.dart';
import 'package:littlefish_merchant/environment/theme_from_config/applied_informational_from_design_config.dart';
import 'package:littlefish_merchant/environment/theme_from_config/applied_navigation_from_design_config.dart';
import 'package:littlefish_merchant/environment/theme_from_config/applied_surface_from_design_config.dart';
import 'package:littlefish_merchant/environment/theme_from_config/applied_text_icon_from_design_config.dart';
import 'package:littlefish_merchant/injector.dart';

import 'absa_default_design_system.dart';
import 'environment_config.dart';
import 'sandbox_design_system.dart';
import 'sbsa_default_design_system.dart';
import 'theme_from_config/applied_form_control_from_design_config.dart';

class EnvironmentThemes {
  static LoggerService get logger =>
      LittleFishCore.instance.get<LoggerService>();
  List<AppThemeData> fromFeatureFlags() {
    final core = LittleFishCore.instance;
    final ConfigService configService = core.get<ConfigService>();

    final ffConfig = configService.getObjectValue(
      key: 'config_settings_theme',
      defaultValue: {'key': 'value'},
    );

    getLaunchDarklyConfigInfo(ffConfig);

    final themeData = getFeatureFlagParamaters(ffConfig);

    return themeData;
  }

  void getLaunchDarklyConfigInfo(ffMap) {
    if (ffMap is Map && ffMap.containsKey('config_info')) {
      final configInfo = ffMap['config_info'];
      var created = 'no creation date';
      var usecase = 'no use case found';

      if (configInfo is Map && configInfo.containsKey('created')) {
        created = configInfo['created'];
      }

      if (configInfo is Map && configInfo.containsKey('usecase')) {
        usecase = configInfo['usecase'];
      }

      logger.debug(
        'environment.themes',
        'Config info - Use case: $usecase, Created: $created',
      );
    } else {
      logger.debug('environment.themes', 'Config info not found');
    }
  }

  List<AppThemeData> getFeatureFlagParamaters(ffMap) {
    var list = <AppThemeData>[];
    if (ffMap is Map) {
      var typographyItems = <TypographyData>[];
      if (ffMap.containsKey('typography_v2')) {
        final val = ffMap['typography_v2'];
        if (val is List) {
          typographyItems = getTypographyDataV2(jsonList: val);
        }
      }

      var buttonStyle = const ButtonStyleData();
      if (ffMap.containsKey('buttonStyle')) {
        final val = ffMap['buttonStyle'];
        if (val is Map) {
          buttonStyle = getButtonStyleData(jsonMap: val);
        }
      }

      if (ffMap.containsKey('dark')) {
        final darkMap = ffMap['dark'];
        final darkThemData = getDarkThemeData(darkMap, typographyItems);
        final extendedDarkThemeData = darkThemData.copyWith(
          buttonStyleData: buttonStyle,
        );
        list.add(extendedDarkThemeData);
      }

      if (ffMap.containsKey('light')) {
        final lightMap = ffMap['light'];
        final lightThemeData = getLightThemeData(lightMap, typographyItems);
        final extendedLightThemeData = lightThemeData.copyWith(
          buttonStyleData: buttonStyle,
        );
        list.add(extendedLightThemeData);
      }
    }
    return list;
  }

  AppThemeData getDarkThemeData(
    Map<String, dynamic> map,
    List<TypographyData> typographyData,
  ) {
    final dataSet = getThemeDataFromJson(
      map: map,
      type: ThemeDataType.dark,
      typographyData: typographyData,
    );
    return dataSet;
  }

  AppThemeData getLightThemeData(
    Map<String, dynamic> map,
    List<TypographyData> typographyData,
  ) {
    final dataSet = getThemeDataFromJson(
      map: map,
      type: ThemeDataType.light,
      typographyData: typographyData,
    );
    return dataSet;
  }

  AppThemeData getThemeDataFromJson({
    required Map<String, dynamic> map,
    required ThemeDataType type,
    required List<TypographyData> typographyData,
  }) {
    logger.debug('environment.themes', 'Processing theme data from JSON');
    final t0 = DateTime.now();

    var background = Colors.transparent;
    if (map.containsKey('background')) {
      final val = map['background'];
      if (val is String) {
        final intVal = int.tryParse(val) ?? 0;
        background = Color(intVal);
      }
    }

    var error = Colors.transparent;
    if (map.containsKey('error')) {
      final val = map['error'];
      if (val is String) {
        final intVal = int.tryParse(val) ?? 0;
        error = Color(intVal);
      }
    }

    var onBackground = Colors.transparent;
    if (map.containsKey('onBackground')) {
      final val = map['onBackground'];
      if (val is String) {
        final intVal = int.tryParse(val) ?? 0;
        onBackground = Color(intVal);
      }
    }

    var onError = Colors.transparent;
    if (map.containsKey('onError')) {
      final val = map['onError'];
      if (val is String) {
        final intVal = int.tryParse(val) ?? 0;
        onError = Color(intVal);
      }
    }

    var onPrimary = Colors.transparent;
    if (map.containsKey('onPrimary')) {
      final val = map['onPrimary'];
      if (val is String) {
        final intVal = int.tryParse(val) ?? 0;
        onPrimary = Color(intVal);
      }
    }

    var onSecondary = Colors.transparent;
    if (map.containsKey('onSecondary')) {
      final val = map['onSecondary'];
      if (val is String) {
        final intVal = int.tryParse(val) ?? 0;
        onSecondary = Color(intVal);
      }
    }

    var onTertiary = Colors.transparent;
    if (map.containsKey('onTertiary')) {
      final val = map['onTertiary'];
      if (val is String) {
        final intVal = int.tryParse(val) ?? 0;
        onTertiary = Color(intVal);
      }
    }

    var primary = Colors.transparent;
    if (map.containsKey('primary')) {
      final val = map['primary'];
      if (val is String) {
        final intVal = int.tryParse(val) ?? 0;
        primary = Color(intVal);
      }
    }

    var secondary = Colors.transparent;
    if (map.containsKey('secondary')) {
      final val = map['secondary'];
      if (val is String) {
        final intVal = int.tryParse(val) ?? 0;
        secondary = Color(intVal);
      }
    }

    var tertiary = Colors.transparent;
    if (map.containsKey('tertiary')) {
      final val = map['tertiary'];
      if (val is String) {
        final intVal = int.tryParse(val) ?? 0;
        tertiary = Color(intVal);
      }
    }

    var appNeutral = Colors.transparent;
    if (map.containsKey('appNeutral')) {
      final val = map['appNeutral'];
      if (val is String) {
        final intVal = int.tryParse(val) ?? 0;
        appNeutral = Color(intVal);
      }
    }

    var appNeutralDeEmphasized1 = Colors.transparent;
    if (map.containsKey('appNeutralDeEmphasized1')) {
      final val = map['appNeutralDeEmphasized1'];
      if (val is String) {
        final intVal = int.tryParse(val) ?? 0;
        appNeutralDeEmphasized1 = Color(intVal);
      }
    }

    var appSuccess = Colors.transparent;
    if (map.containsKey('appSuccess')) {
      final val = map['appSuccess'];
      if (val is String) {
        final intVal = int.tryParse(val) ?? 0;
        appSuccess = Color(intVal);
      }
    }

    var appWarning = Colors.transparent;
    if (map.containsKey('appWarning')) {
      final val = map['appWarning'];
      if (val is String) {
        final intVal = int.tryParse(val) ?? 0;
        appWarning = Color(intVal);
      }
    }
    var appError = Colors.transparent;
    if (map.containsKey('appError')) {
      final val = map['appError'];
      if (val is String) {
        final intVal = int.tryParse(val) ?? 0;
        appError = Color(intVal);
      }
    }
    var appPrimary = Colors.transparent;
    if (map.containsKey('appPrimary')) {
      final val = map['appPrimary'];
      if (val is String) {
        final intVal = int.tryParse(val) ?? 0;
        appPrimary = Color(intVal);
      }
    }

    var appOnNeutral = Colors.transparent;
    if (map.containsKey('appOnNeutral')) {
      final val = map['appOnNeutral'];
      if (val is String) {
        final intVal = int.tryParse(val) ?? 0;
        appOnNeutral = Color(intVal);
      }
    }

    var appOnSuccess = Colors.transparent;
    if (map.containsKey('appOnSuccess')) {
      final val = map['appOnSuccess'];
      if (val is String) {
        final intVal = int.tryParse(val) ?? 0;
        appOnSuccess = Color(intVal);
      }
    }

    var appOnWarning = Colors.transparent;
    if (map.containsKey('appOnWarning')) {
      final val = map['appOnWarning'];
      if (val is String) {
        final intVal = int.tryParse(val) ?? 0;
        appOnWarning = Color(intVal);
      }
    }
    var appOnError = Colors.transparent;
    if (map.containsKey('appOnError')) {
      final val = map['appOnError'];
      if (val is String) {
        final intVal = int.tryParse(val) ?? 0;
        appOnError = Color(intVal);
      }
    }
    var appOnPrimary = Colors.transparent;
    if (map.containsKey('appOnPrimary')) {
      final val = map['appOnPrimary'];
      if (val is String) {
        final intVal = int.tryParse(val) ?? 0;
        appOnPrimary = Color(intVal);
      }
    }

    //TODO(Michael): Pull from remote feature flags
    // defaultConfig.modalThemeConfig = const ModalThemeConfig();
    bool enableVerticalActions = false;
    bool enableIconBackground = false;
    if (map.containsKey('modal')) {
      final modalMap = map['modal'];
      if (modalMap is Map) {
        if (modalMap.containsKey('enableVerticalActions')) {
          enableVerticalActions = EnvironmentConfig.jsonToBool(
            modalMap['enableVerticalActions'],
          );
        }
      }
      if (modalMap is Map) {
        if (modalMap.containsKey('enableIconBackground')) {
          enableIconBackground = EnvironmentConfig.jsonToBool(
            modalMap['enableIconBackground'],
          );
        }
      }
    }
    final modalThemeConfig = ModalThemeConfig(
      enableIconBackground: enableIconBackground,
      enableVerticalActions: enableVerticalActions,
    );

    var useGradient = false;
    Color gradientStart = Colors.white;
    Color gradientEnd = Colors.white;
    Color appBarBackground = Colors.white;
    var enableSurfaceTint = false;
    var appBarElevation = 0.0;
    if (map.containsKey('appBar')) {
      final appBarMap = map['appBar'];
      if (appBarMap is Map) {
        if (appBarMap.containsKey('useGradient')) {
          final useGradientValue = appBarMap['useGradient'];
          if (useGradientValue is bool) {
            useGradient = useGradientValue;
          } else if (useGradientValue is String) {
            useGradient = useGradientValue.toLowerCase().contains('true')
                ? true
                : false;
          }
        }

        if (useGradient && appBarMap.containsKey('gradientStart')) {
          final val = appBarMap['gradientStart'];
          if (val is String) {
            final intVal = int.tryParse(val) ?? 0;
            gradientStart = Color(intVal);
          }
        }

        if (useGradient && appBarMap.containsKey('gradientEnd')) {
          final val = appBarMap['gradientEnd'];
          if (val is String) {
            final intVal = int.tryParse(val) ?? 0;
            gradientEnd = Color(intVal);
          }
        }

        if (!useGradient && appBarMap.containsKey('background')) {
          final val = appBarMap['background'];
          if (val is String) {
            final intVal = int.tryParse(val) ?? 0;
            appBarBackground = Color(intVal);
          }
        }

        if (!useGradient && appBarMap.containsKey('enableSurfaceTint')) {
          final enableSurfaceTintValue = appBarMap['enableSurfaceTint'];
          if (enableSurfaceTintValue is bool) {
            enableSurfaceTint = enableSurfaceTintValue;
          } else if (enableSurfaceTintValue is String) {
            enableSurfaceTint =
                enableSurfaceTintValue.toLowerCase().contains('true')
                ? true
                : false;
          }
        }

        if (appBarMap.containsKey('elevation')) {
          final val = appBarMap['elevation'];
          if (val is double) {
            appBarElevation = val;
          } else if (val is int) {
            appBarElevation = val.toDouble();
          } else if (val is String) {
            appBarElevation = double.tryParse(val) ?? 0.0;
          }
        }
      }
    }

    late DesignSystem designSystem;
    if (map.containsKey('primitive')) {
      debugPrint('### env theme $type use design system from LD not default');
      logger.debug(
        'environment.environment_themes',
        '### env theme $type use design system from LD not default',
      );
      designSystem = DesignSystem.fromJson(map);
    } else {
      debugPrint('### env theme $type use default design system and not LD');
      logger.debug(
        'environment.environment_themes',
        '### env theme $type use default design system and not LD',
      );
      if (isSBSA) {
        designSystem = DesignSystem.fromJson(sbsaDefaultDesignSystem);
      } else if (isABSA) {
        designSystem = DesignSystem.fromJson(absaDefaultDesignSystem);
      } else if (isFNB) {
        designSystem = DesignSystem.fromJson(fnbDefaultDesignSystem);
      } else if (isSandbox) {
        designSystem = DesignSystem.fromJson(sandBoxDefaultDesignSystem);
      } else {
        designSystem = DesignSystem.fromJson(defaultDesignSystem);
      }
    }

    final appThemeData = AppThemeData(
      background: background,
      error: error,
      themeType: type,
      onBackground: onBackground,
      onError: onError,
      onPrimary: onPrimary,
      onSecondary: onSecondary,
      onTertiary: onTertiary,
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      typography: typographyData,
      appBarBackground: appBarBackground,
      enableSurfaceTint: enableSurfaceTint,
      gradientEnd: gradientEnd,
      gradientStart: gradientStart,
      useGradient: useGradient,
      appError: appError,
      appNeutral: appNeutral,
      appNeutralDeEmphasized1: appNeutralDeEmphasized1,
      appPrimary: appPrimary,
      appSuccess: appSuccess,
      appWarning: appWarning,
      appOnNeutral: appOnNeutral,
      appOnPrimary: appOnPrimary,
      appOnSuccess: appOnSuccess,
      appOnWarning: appOnWarning,
      appOnError: appOnError,
      appliedButton: AppliedButtonFromDesignConfig().buildFrom(designSystem),
      appliedFormControl: AppliedFormControlFromDesignConfig().buildFrom(
        designSystem,
      ),
      appliedFormInput: AppliedFormInputFromDesignConfig().buildFrom(
        designSystem,
      ),
      appliedNavigation: AppliedNavigationFromDesignConfig().buildFrom(
        designSystem,
      ),
      appliedInformational: AppliedInformationalFromDesignConfig().buildFrom(
        designSystem,
      ),
      appliedTextIcon: AppliedTextIconFromDesignConfig().buildFrom(
        designSystem,
      ),
      appliedSurface: AppliedSurfaceFromDesignConfig().buildFrom(designSystem),
      appliedBorder: AppliedBorderFromDesignConfig().buildFrom(designSystem),
      modalThemeConfig: modalThemeConfig,
      appBarElevation: appBarElevation,
    );

    logger.debug(
      'environment.environment_themes',
      '### getThemeDataFromJson exit ${DateTime.now().difference(t0)}',
    );
    return appThemeData;
  }

  ButtonStyleData getButtonStyleData({required Map jsonMap}) {
    var radius = 0.0;
    var width = 0.0;
    if (jsonMap is Map<String, dynamic>) {
      if (jsonMap.containsKey('shape')) {
        final shapeMap = jsonMap['shape'];
        if (shapeMap is Map<String, dynamic>) {
          if (shapeMap.containsKey('side_width')) {
            final val = shapeMap['side_width'];
            if (val is double) {
              width = val;
            } else if (val is int) {
              width = val.toDouble();
            }
          }
          if (shapeMap.containsKey('borderRadius')) {
            final val = shapeMap['borderRadius'];
            if (val is double) {
              radius = val;
            } else if (val is int) {
              radius = val.toDouble();
            }
          }
        }
      }
    }
    return ButtonStyleData(radius: radius, width: width);
  }

  List<TypographyData> getTypographyDataV2({required List jsonList}) {
    final typographList = <TypographyData>[];
    for (final item in jsonList) {
      if (item is Map<String, dynamic>) {
        String itemType = '';
        if (item.containsKey('itemType')) {
          final key = item['itemType'];
          if (key is String) {
            itemType = key;
          }
        }

        FontWeight bold = FontWeight.w700;
        if (item.containsKey('bold')) {
          final key = item['bold'];
          if (key is String) {
            bold = getFontWeightFromString(key);
          }
        }

        FontWeight semiBold = FontWeight.w600;
        if (item.containsKey('semiBold')) {
          final key = item['semiBold'];
          if (key is String) {
            semiBold = getFontWeightFromString(key);
          }
        }

        FontWeight regular = FontWeight.w400;
        if (item.containsKey('light')) {
          final key = item['light'];
          if (key is String) {
            regular = getFontWeightFromString(key);
          }
        }

        FontWeight light = FontWeight.w300;
        if (item.containsKey('light')) {
          final key = item['light'];
          if (key is String) {
            light = getFontWeightFromString(key);
          }
        }

        double fontSize = 12.0;
        if (item.containsKey('fontSize')) {
          final key = item['fontSize'];
          if (key is double) {
            fontSize = key;
          } else if (key is int) {
            fontSize = key.toDouble();
          }
        }

        String fontFamily = '';
        if (item.containsKey('fontFamily')) {
          final key = item['fontFamily'];
          if (key is String) {
            fontFamily = key;
          }
        }

        String textStyle = '';
        if (item.containsKey('textStyle')) {
          final key = item['textStyle'];
          if (key is String) {
            textStyle = key;
          }
        }

        final element = TypographyData(
          bold: bold,
          light: light,
          semiBold: semiBold,
          itemType: itemType,
          fontSize: fontSize,
          textStyle: textStyle,
          regular: regular,
          fontFamily: fontFamily,
        );

        typographList.add(element);
      }
    }

    return typographList;
  }

  List<TypographyData> getTypographyData({required List jsonList}) {
    final typographList = <TypographyData>[];
    for (final item in jsonList) {
      if (item is Map<String, dynamic>) {
        String itemType = '';
        if (item.containsKey('itemType')) {
          final key = item['itemType'];
          if (key is String) {
            itemType = key;
          }
        }

        FontWeight semiBold = FontWeight.normal;
        if (item.containsKey('semiBold')) {
          final key = item['semiBold'];
          if (key is String) {
            semiBold = getFontWeightFromString(key);
          }
        }

        FontWeight bold = FontWeight.normal;
        if (item.containsKey('bold')) {
          final key = item['bold'];
          if (key is String) {
            bold = getFontWeightFromString(key);
          }
        }

        FontWeight extraBold = FontWeight.normal;
        if (item.containsKey('extraBold')) {
          final key = item['extraBold'];
          if (key is String) {
            extraBold = getFontWeightFromString(key);
          }
        }

        double fontSize = 10.0;
        if (item.containsKey('fontSize')) {
          final key = item['fontSize'];
          if (key is double) {
            fontSize = key;
          }
        }

        String textStyle = '';
        if (item.containsKey('fontFamily')) {
          final key = item['fontFamily'];
          if (key is String) {
            textStyle = key;
          }
        }

        final element = TypographyData(
          bold: bold,
          light: extraBold,
          semiBold: semiBold,
          itemType: itemType,
          fontSize: fontSize,
          textStyle: textStyle,
        );

        typographList.add(element);
      }
    }

    return typographList;
  }

  FontWeight getFontWeightFromString(String value) {
    var fontWeight = FontWeight.normal;
    switch (value) {
      case 'w100':
        fontWeight = FontWeight.w100;
        break;
      case 'w200':
        fontWeight = FontWeight.w200;
        break;
      case 'w300':
        fontWeight = FontWeight.w300;
        break;
      case 'w400':
        fontWeight = FontWeight.w400;
        break;
      case 'w500':
        fontWeight = FontWeight.w500;
        break;
      case 'w600':
        fontWeight = FontWeight.w600;
        break;
      case 'w700':
        fontWeight = FontWeight.w700;
        break;
      case 'w800':
        fontWeight = FontWeight.w800;
        break;
      case 'w900':
        fontWeight = FontWeight.w900;
        break;
      case 'bold':
        fontWeight = FontWeight.bold;
        break;
    }

    return fontWeight;
  }
}
