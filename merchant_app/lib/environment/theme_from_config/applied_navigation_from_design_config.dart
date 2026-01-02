import 'package:littlefish_merchant/app/theme/design_system/design_system.dart';

import '../../app/theme/applied_system/applied_navigation.dart';
import '../theme_from_ld_theme.dart';

class AppliedNavigationFromDesignConfig {
  AppliedNavigation buildFrom(DesignSystem designSystem) {
    final themeFromLDTheme = FromLDTheme(designSystem: designSystem);

    var theme = designSystem.appliedTheme.navigation;
    final defaultIcon = themeFromLDTheme.getColor(theme.defaultIcon);
    final defaultText = themeFromLDTheme.getColor(theme.defaultText);
    final activeIcon = themeFromLDTheme.getColor(theme.activeIcon);
    final activeText = themeFromLDTheme.getColor(theme.activeText);
    final defaultBackground = themeFromLDTheme.getColor(
      theme.defaultBackground,
    );
    final activeBackground = themeFromLDTheme.getColor(theme.activeBackground);

    final appliedFormControl = AppliedNavigation(
      defaultIcon: defaultIcon,
      defaultText: defaultText,
      activeIcon: activeIcon,
      activeText: activeText,
      defaultBackground: defaultBackground,
      activeBackground: activeBackground,
    );
    return appliedFormControl;
  }
}
