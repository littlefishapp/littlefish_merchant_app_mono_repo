import 'package:littlefish_merchant/app/theme/design_system/design_system.dart';

import '../../app/theme/applied_system/applied_form_input.dart';
import '../theme_from_ld_theme.dart';

class AppliedFormInputFromDesignConfig {
  AppliedFormInput buildFrom(DesignSystem designSystem) {
    final themeFromLDTheme = FromLDTheme(designSystem: designSystem);

    var theme = designSystem.appliedTheme.formInput;
    final borderDefault = themeFromLDTheme.getColor(theme.borderDefault);
    final borderFocused = themeFromLDTheme.getColor(theme.borderFocused);
    final borderDisabled = themeFromLDTheme.getColor(theme.borderDisabled);
    final borderInverseDefault = themeFromLDTheme.getColor(
      theme.borderInverseDefault,
    );
    final borderInverseFocused = themeFromLDTheme.getColor(
      theme.borderInverseFocused,
    );
    final borderInverseDisabled = themeFromLDTheme.getColor(
      theme.borderInverseDisabled,
    );
    final textDefault = themeFromLDTheme.getColor(theme.textDefault);
    final textPlaceholder = themeFromLDTheme.getColor(theme.textPlaceholder);
    final textDisabled = themeFromLDTheme.getColor(theme.textDisabled);
    final inverseTextDefault = themeFromLDTheme.getColor(
      theme.inverseTextDefault,
    );
    final inverseTextPlaceholder = themeFromLDTheme.getColor(
      theme.inverseTextPlaceholder,
    );
    final inverseTextDisabled = themeFromLDTheme.getColor(
      theme.inverseTextDisabled,
    );

    final appliedFormInput = AppliedFormInput(
      borderDefault: borderDefault,
      borderFocused: borderFocused,
      borderDisabled: borderDisabled,
      borderInverseDefault: borderInverseDefault,
      borderInverseFocused: borderInverseFocused,
      borderInverseDisabled: borderInverseDisabled,
      textDefault: textDefault,
      textPlaceholder: textPlaceholder,
      textDisabled: textDisabled,
      inverseTextDefault: inverseTextDefault,
      inverseTextPlaceholder: inverseTextPlaceholder,
      inverseTextDisabled: inverseTextDisabled,
    );
    return appliedFormInput;
  }
}
