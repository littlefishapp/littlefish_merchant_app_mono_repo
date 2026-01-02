import 'package:littlefish_merchant/app/theme/design_system/design_system.dart';

import '../../app/theme/applied_system/applied_text_icon.dart';
import '../theme_from_ld_theme.dart';

class AppliedTextIconFromDesignConfig {
  AppliedTextIcon buildFrom(DesignSystem designSystem) {
    final themeFromLDTheme = FromLDTheme(designSystem: designSystem);

    var theme = designSystem.appliedTextAndIcons;
    final primary = themeFromLDTheme.getColor(theme.primary);
    final primaryHeader = themeFromLDTheme.getColor(theme.primaryHeader);
    final secondary = themeFromLDTheme.getColor(theme.secondary);
    final emphasized = themeFromLDTheme.getColor(theme.emphasized);

    final deEmphasized = themeFromLDTheme.getColor(theme.deEmphasized);
    final disabled = themeFromLDTheme.getColor(theme.disabled);
    final inversePrimary = themeFromLDTheme.getColor(theme.inversePrimary);
    final inverseSecondary = themeFromLDTheme.getColor(theme.inverseSecondary);

    final inverseEmphasized = themeFromLDTheme.getColor(
      theme.inverseEmphasized,
    );
    final inverseDeEmphasized = themeFromLDTheme.getColor(
      theme.inverseDeEmphasized,
    );
    final inverseDisabled = themeFromLDTheme.getColor(theme.inverseDisabled);
    final brand = themeFromLDTheme.getColor(theme.brand);

    final success = themeFromLDTheme.getColor(theme.success);
    final successAlt = themeFromLDTheme.getColor(theme.successAlt);
    final error = themeFromLDTheme.getColor(theme.error);
    final errorAlt = themeFromLDTheme.getColor(theme.errorAlt);

    final accent = themeFromLDTheme.getColor(theme.accent);
    final accentAlt = themeFromLDTheme.getColor(theme.accentAlt);
    final warning = themeFromLDTheme.getColor(theme.warning);
    final warningAlt = themeFromLDTheme.getColor(theme.warningAlt);
    final positive = themeFromLDTheme.getColor(theme.positive);
    final positiveAlt = themeFromLDTheme.getColor(theme.positiveAlt);

    final appliedButton = AppliedTextIcon(
      primary: primary,
      primaryHeader: primaryHeader,
      secondary: secondary,
      emphasized: emphasized,
      deEmphasized: deEmphasized,
      disabled: disabled,
      inversePrimary: inversePrimary,
      inverseSecondary: inverseSecondary,
      inverseEmphasized: inverseEmphasized,
      inverseDeEmphasized: inverseDeEmphasized,
      inverseDisabled: inverseDisabled,
      brand: brand,
      success: success,
      successAlt: successAlt,
      error: error,
      errorAlt: errorAlt,
      accent: accent,
      accentAlt: accentAlt,
      warning: warning,
      warningAlt: warningAlt,
      positive: positive,
      positiveAlt: positiveAlt,
    );
    return appliedButton;
  }
}
