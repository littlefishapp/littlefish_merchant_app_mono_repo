import 'package:littlefish_merchant/app/theme/design_system/design_system.dart';

import '../../app/theme/applied_system/applied_surface.dart';
import '../theme_from_ld_theme.dart';

class AppliedSurfaceFromDesignConfig {
  AppliedSurface buildFrom(DesignSystem designSystem) {
    final themeFromLDTheme = FromLDTheme(designSystem: designSystem);

    var theme = designSystem.appliedSurface;
    final primary = themeFromLDTheme.getColor(theme.primary);
    final primaryHeader = themeFromLDTheme.getColor(theme.primaryHeader);
    final secondary = themeFromLDTheme.getColor(theme.secondary);
    final contrast = themeFromLDTheme.getColor(theme.contrast);

    final heavyContrast = themeFromLDTheme.getColor(theme.heavyContrast);
    final inverse = themeFromLDTheme.getColor(theme.inverse);
    final brand = themeFromLDTheme.getColor(theme.brand);
    final brandSubtitle = themeFromLDTheme.getColor(theme.brandSubtitle);

    final success = themeFromLDTheme.getColor(theme.success);
    final successSubtitle = themeFromLDTheme.getColor(theme.successSubtitle);
    final successEmphasized = themeFromLDTheme.getColor(
      theme.successEmphasized,
    );

    final warning = themeFromLDTheme.getColor(theme.warning);
    final warningSubtitle = themeFromLDTheme.getColor(theme.warningSubtitle);
    final warningEmphasized = themeFromLDTheme.getColor(theme.warningSubtitle);

    final error = themeFromLDTheme.getColor(theme.error);
    final errorSubtitle = themeFromLDTheme.getColor(theme.errorSubtitle);
    final errorEmphasized = themeFromLDTheme.getColor(theme.errorEmphasized);

    final positive = themeFromLDTheme.getColor(theme.positive);
    final positiveSubtitle = themeFromLDTheme.getColor(theme.positiveSubtitle);
    final positiveEmphasized = themeFromLDTheme.getColor(
      theme.positiveEmphasized,
    );

    final appliedSurface = AppliedSurface(
      primary: primary,
      primaryHeader: primaryHeader,
      secondary: secondary,
      contrast: contrast,
      heavyContrast: heavyContrast,
      inverse: inverse,
      brand: brand,
      brandSubTitle: brandSubtitle,
      success: success,
      successSubTitle: successSubtitle,
      successEmphasized: successEmphasized,
      warning: warning,
      warningSubTitle: warningSubtitle,
      warningEmphasized: warningEmphasized,
      errorSubTitle: errorSubtitle,
      error: error,
      errorEmphasized: errorEmphasized,
      positive: positive,
      positiveEmphasized: positiveEmphasized,
      positiveSubTitle: positiveSubtitle,
    );
    return appliedSurface;
  }
}
