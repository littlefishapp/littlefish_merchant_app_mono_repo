import 'package:littlefish_merchant/app/theme/design_system/design_system.dart';

import '../../app/theme/applied_system/applied_button.dart';
import '../theme_from_ld_theme.dart';

class AppliedButtonFromDesignConfig {
  AppliedButton buildFrom(DesignSystem designSystem) {
    final themeFromLDTheme = FromLDTheme(designSystem: designSystem);

    var primaryTheme = designSystem.appliedTheme.buttonPrimary;
    final primaryDefault = themeFromLDTheme.getColor(primaryTheme.defaults);
    final primaryActive = themeFromLDTheme.getColor(primaryTheme.active);
    final primaryDisabled = themeFromLDTheme.getColor(primaryTheme.disabled);
    final primaryHover = themeFromLDTheme.getColor(primaryTheme.hover);
    final primaryTertiary = themeFromLDTheme.getColor(primaryTheme.tertiary);

    var dangerTheme = designSystem.appliedTheme.buttonDanger;
    final dangerActive = themeFromLDTheme.getColor(dangerTheme.active);
    final dangerDefault = themeFromLDTheme.getColor(dangerTheme.defaults);
    final dangerDisabled = themeFromLDTheme.getColor(dangerTheme.disabled);
    final dangerHover = themeFromLDTheme.getColor(dangerTheme.hover);
    final dangerTertiary = themeFromLDTheme.getColor(dangerTheme.tertiary);

    var neutralTheme = designSystem.appliedTheme.buttonNeutral;
    final neutralActive = themeFromLDTheme.getColor(neutralTheme.active);
    final neutralDefault = themeFromLDTheme.getColor(neutralTheme.defaults);
    final neutralDisabled = themeFromLDTheme.getColor(neutralTheme.disabled);
    final neutralHover = themeFromLDTheme.getColor(neutralTheme.hover);
    final neutralTertiary = themeFromLDTheme.getColor(neutralTheme.tertiary);

    final appliedButton = AppliedButton(
      primaryDefault: primaryDefault,
      primaryActive: primaryActive,
      primaryDisabled: primaryDisabled,
      primaryHover: primaryHover,
      primaryTertiary: primaryTertiary,
      dangerActive: dangerActive,
      dangerDefault: dangerDefault,
      dangerDisabled: dangerDisabled,
      dangerHover: dangerHover,
      dangerTertiary: dangerTertiary,
      neutralActive: neutralActive,
      neutralDefault: neutralDefault,
      neutralDisabled: neutralDisabled,
      neutralHover: neutralHover,
      neutralTertiary: neutralTertiary,
    );
    return appliedButton;
  }
}
