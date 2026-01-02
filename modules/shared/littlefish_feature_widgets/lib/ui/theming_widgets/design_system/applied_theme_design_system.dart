import 'button_danger_design_system.dart';
import 'button_neutral_design_system.dart';
import 'button_primary_design_system.dart';
import 'form_control_design_system.dart';
import 'form_input_design_system.dart';
import 'informational_default_design_system.dart';
import 'informational_error_design_system.dart';
import 'informational_neutral_design_system.dart';
import 'informational_success_design_system.dart';
import 'informational_warning_design_system.dart';
import 'navigation_design_system.dart';

class AppliedThemeDesignSystem {
  final ButtonPrimaryDesignSystem buttonPrimary;
  final ButtonDangerDesignSystem buttonDanger;
  final ButtonNeutralDesignSystem buttonNeutral;
  final FormControlDesignSystem formControl;
  final FormInputDesignSystem formInput;
  final NavigationDesignSystem navigation;
  final InformationalDefaultDesignSystem informationalDefault;
  final InformationalSuccessDesignSystem informationalSuccess;
  final InformationalWarningDesignSystem informationalWarning;
  final InformationalErrorDesignSystem informationalError;
  final InformationalNeutralDesignSystem informationalNeutral;

  const AppliedThemeDesignSystem({
    this.buttonPrimary = const ButtonPrimaryDesignSystem(),
    this.buttonDanger = const ButtonDangerDesignSystem(),
    this.buttonNeutral = const ButtonNeutralDesignSystem(),
    this.formControl = const FormControlDesignSystem(),
    this.formInput = const FormInputDesignSystem(),
    this.navigation = const NavigationDesignSystem(),
    this.informationalDefault = const InformationalDefaultDesignSystem(),
    this.informationalSuccess = const InformationalSuccessDesignSystem(),
    this.informationalWarning = const InformationalWarningDesignSystem(),
    this.informationalError = const InformationalErrorDesignSystem(),
    this.informationalNeutral = const InformationalNeutralDesignSystem(),
  });

  factory AppliedThemeDesignSystem.fromJson(Map<String, dynamic> json) =>
      AppliedThemeDesignSystem(
        buttonPrimary: json['buttonPrimary'] == null
            ? const ButtonPrimaryDesignSystem()
            : ButtonPrimaryDesignSystem.fromJson(
                json['buttonPrimary'] as Map<String, dynamic>,
              ),
        buttonDanger: json['buttonDanger'] == null
            ? const ButtonDangerDesignSystem()
            : ButtonDangerDesignSystem.fromJson(
                json['buttonDanger'] as Map<String, dynamic>,
              ),
        buttonNeutral: json['buttonNeutral'] == null
            ? const ButtonNeutralDesignSystem()
            : ButtonNeutralDesignSystem.fromJson(
                json['buttonNeutral'] as Map<String, dynamic>,
              ),
        formControl: json['formControl'] == null
            ? const FormControlDesignSystem()
            : FormControlDesignSystem.fromJson(
                json['formControl'] as Map<String, dynamic>,
              ),
        formInput: json['formInput'] == null
            ? const FormInputDesignSystem()
            : FormInputDesignSystem.fromJson(
                json['formInput'] as Map<String, dynamic>,
              ),
        navigation: json['navigation'] == null
            ? const NavigationDesignSystem()
            : NavigationDesignSystem.fromJson(
                json['navigation'] as Map<String, dynamic>,
              ),
        informationalDefault: json['informationalDefault'] == null
            ? const InformationalDefaultDesignSystem()
            : InformationalDefaultDesignSystem.fromJson(
                json['informationalDefault'] as Map<String, dynamic>,
              ),
        informationalSuccess: json['informationalSuccess'] == null
            ? const InformationalSuccessDesignSystem()
            : InformationalSuccessDesignSystem.fromJson(
                json['informationalSuccess'] as Map<String, dynamic>,
              ),
        informationalWarning: json['informationalWarning'] == null
            ? const InformationalWarningDesignSystem()
            : InformationalWarningDesignSystem.fromJson(
                json['informationalWarning'] as Map<String, dynamic>,
              ),
        informationalError: json['informationalError'] == null
            ? const InformationalErrorDesignSystem()
            : InformationalErrorDesignSystem.fromJson(
                json['informationalError'] as Map<String, dynamic>,
              ),
        informationalNeutral: json['informationalNeutral'] == null
            ? const InformationalNeutralDesignSystem()
            : InformationalNeutralDesignSystem.fromJson(
                json['informationalNeutral'] as Map<String, dynamic>,
              ),
      );

  Map<String, dynamic> toJson() => {
    'buttonPrimary': buttonPrimary.toJson(),
    'buttonDanger': buttonDanger.toJson(),
    'buttonNeutral': buttonNeutral.toJson(),
    'formControl': formControl.toJson(),
    'formInput': formInput.toJson(),
    'navigation': navigation.toJson(),
    'informationalDefault': informationalDefault.toJson(),
    'informationalSuccess': informationalSuccess.toJson(),
    'informationalWarning': informationalWarning.toJson(),
    'informationalError': informationalError.toJson(),
    'informationalNeutral': informationalNeutral.toJson(),
  };
}
