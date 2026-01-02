import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/lf_app_themes.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/modal_builder_implementations/default_modal_builder/default_action_modal_builder.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';

import '../../../../../widgets/littlefish_feature_widgets/lib/injector.dart';
import 'app_theme_data.dart';

enum AppThemeType { none, light, dark }

class ThemeFactory {
  ThemeData getTheme({
    required BuildContext context,
    required AppThemeType theme,
    required String language,
    required List<AppThemeData> appThemeDataList,
  }) {
    ThemeData themeToUse;
    var appThemeData = AppThemeData();

    switch (theme) {
      case AppThemeType.light:
        appThemeData = appThemeDataList.firstWhere(
          (e) => e.themeType == ThemeDataType.light,
          orElse: () => AppThemeData(),
        );

        themeToUse = buildLightThemeLF(
          context: context,
          language: language,
          appThemeData: appThemeData,
        );

        break;

      case AppThemeType.dark:
        appThemeData = appThemeDataList.firstWhere(
          (e) => e.themeType == ThemeDataType.dark,
          orElse: () => AppThemeData(),
        );

        themeToUse = buildDarkThemeLF(
          context: context,
          language: language,
          appThemeData: appThemeData,
        );

        break;
      default:
        appThemeData = AppThemeData();
        themeToUse = buildLightThemeLF(
          context: context,
          language: language,
          appThemeData: AppThemeData(),
        );
    }
    logger.debug('app.theme.factory', 'Registering theme to use');
    if (getIt.isRegistered<AppThemeData>()) {
      logger.debug('app.theme.factory', 'Theme data already registered');
    } else {
      getIt.registerSingleton<AppThemeData>(appThemeData);
    }

    if (!getIt.isRegistered<ModalService>()) {
      final modalService = ModalService(
        actionModalBuilder: DefaultActionModalBuilder(),
        modalThemeConfig: appThemeData.modalThemeConfig,
      );
      getIt.registerSingleton<ModalService>(modalService);
    }
    return themeToUse;
  }
}
