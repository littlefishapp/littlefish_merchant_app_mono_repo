import 'package:littlefish_merchant/app/theme/design_system/design_system.dart';

import '../../app/theme/applied_system/applied_border.dart';
import '../theme_from_ld_theme.dart';

class AppliedBorderFromDesignConfig {
  AppliedBorder buildFrom(DesignSystem designSystem) {
    final themeFromLDTheme = FromLDTheme(designSystem: designSystem);

    var theme = designSystem.appliedBorder;
    final primary = themeFromLDTheme.getColor(theme.primary);
    final emphasized = themeFromLDTheme.getColor(theme.emphasized);
    final disabled = themeFromLDTheme.getColor(theme.disabled);
    final inversePrimary = themeFromLDTheme.getColor(theme.inversePrimary);

    final inverseEmphasized = themeFromLDTheme.getColor(
      theme.inverseEmphasized,
    );
    final inverseDisabled = themeFromLDTheme.getColor(theme.inverseDisabled);
    final error = themeFromLDTheme.getColor(theme.error);
    final warning = themeFromLDTheme.getColor(theme.warning);
    final success = themeFromLDTheme.getColor(theme.success);
    final brand = themeFromLDTheme.getColor(theme.brand);

    final appliedSurface = AppliedBorder(
      primary: primary,
      emphasized: emphasized,
      disabled: disabled,
      inversePrimary: inversePrimary,
      inverseEmphasized: inverseEmphasized,
      inverseDisabled: inverseDisabled,
      brand: brand,
      success: success,
      warning: warning,
      error: error,
    );
    return appliedSurface;
  }
}
