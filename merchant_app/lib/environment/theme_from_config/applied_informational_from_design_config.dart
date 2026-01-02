import 'package:littlefish_merchant/app/theme/design_system/design_system.dart';

import '../../app/theme/applied_system/applied_informational.dart';
import '../theme_from_ld_theme.dart';

class AppliedInformationalFromDesignConfig {
  AppliedInformational buildFrom(DesignSystem designSystem) {
    final themeFromLDTheme = FromLDTheme(designSystem: designSystem);

    var defaultTheme = designSystem.appliedTheme.informationalDefault;
    final defaultIcon = themeFromLDTheme.getColor(defaultTheme.icon);
    final defaultText = themeFromLDTheme.getColor(defaultTheme.text);
    final defaultBorder = themeFromLDTheme.getColor(defaultTheme.border);
    final defaultSurface = themeFromLDTheme.getColor(defaultTheme.surface);

    var successTheme = designSystem.appliedTheme.informationalSuccess;
    final successIcon = themeFromLDTheme.getColor(successTheme.icon);
    final successText = themeFromLDTheme.getColor(successTheme.text);
    final successBorder = themeFromLDTheme.getColor(successTheme.border);
    final successSurface = themeFromLDTheme.getColor(successTheme.surface);

    var warningTheme = designSystem.appliedTheme.informationalWarning;
    final warningIcon = themeFromLDTheme.getColor(warningTheme.icon);
    final warningText = themeFromLDTheme.getColor(warningTheme.text);
    final warningBorder = themeFromLDTheme.getColor(warningTheme.border);
    final warningSurface = themeFromLDTheme.getColor(warningTheme.surface);

    var errorTheme = designSystem.appliedTheme.informationalError;
    final errorIcon = themeFromLDTheme.getColor(errorTheme.icon);
    final errorText = themeFromLDTheme.getColor(errorTheme.text);
    final errorBorder = themeFromLDTheme.getColor(errorTheme.border);
    final errorSurface = themeFromLDTheme.getColor(errorTheme.surface);

    var neutralTheme = designSystem.appliedTheme.informationalNeutral;
    final neutralIcon = themeFromLDTheme.getColor(neutralTheme.icon);
    final neutralText = themeFromLDTheme.getColor(neutralTheme.text);
    final neutralBorder = themeFromLDTheme.getColor(neutralTheme.border);
    final neutralSurface = themeFromLDTheme.getColor(neutralTheme.surface);

    final appliedButton = AppliedInformational(
      defaultIcon: defaultIcon,
      defaultText: defaultText,
      defaultBorder: defaultBorder,
      defaultSurface: defaultSurface,
      successIcon: successIcon,
      successText: successText,
      successBorder: successBorder,
      successSurface: successSurface,
      warningIcon: warningIcon,
      warningText: warningText,
      warningBorder: warningBorder,
      warningSurface: warningSurface,
      errorIcon: errorIcon,
      errorText: errorText,
      errorBorder: errorBorder,
      errorSurface: errorSurface,
      neutralIcon: neutralIcon,
      neutralText: neutralText,
      neutralBorder: neutralBorder,
      neutralSurface: neutralSurface,
    );
    return appliedButton;
  }
}
