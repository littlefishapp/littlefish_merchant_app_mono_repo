import 'package:littlefish_merchant/app/theme/design_system/design_system.dart';

import '../../app/theme/applied_system/applied_form_control.dart';
import '../theme_from_ld_theme.dart';

class AppliedFormControlFromDesignConfig {
  AppliedFormControl buildFrom(DesignSystem designSystem) {
    final themeFromLDTheme = FromLDTheme(designSystem: designSystem);

    var theme = designSystem.appliedTheme.formControl;
    final active = themeFromLDTheme.getColor(theme.active);
    final inactive = themeFromLDTheme.getColor(theme.inactive);
    final activeForeground = themeFromLDTheme.getColor(theme.activeForeground);
    final inactiveForeground = themeFromLDTheme.getColor(
      theme.inactiveForeground,
    );
    final colorBackground = themeFromLDTheme.getColor(theme.colourBg);
    final foregroundOnColorBackground = themeFromLDTheme.getColor(
      theme.fgOnColourBg,
    );

    final appliedFormControl = AppliedFormControl(
      active: active,
      inactive: inactive,
      activeForeground: activeForeground,
      inactiveForeground: inactiveForeground,
      colorBackground: colorBackground,
      foregroundOnColorBackground: foregroundOnColorBackground,
    );
    return appliedFormControl;
  }
}
