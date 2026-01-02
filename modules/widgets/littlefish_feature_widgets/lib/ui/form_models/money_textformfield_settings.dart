// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import 'package:littlefish_merchant/common/presentaion/components/form_models/appearance_settings.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_models/money_format_settings.dart';

class MoneyTextFormFieldSettings {
  MoneyTextFormFieldSettings({
    this.controller,
    this.validator,
    this.inputFormatters,
    this.onChanged,
    this.moneyFormatSettings,
    this.appearanceSettings,
    this.enabled = true,
    this.isRequired = false,
    this.onFieldSubmitted,
    this.onSaveValue,
    this.useOutlineStyling,
    this.prefixIcon,
    this.suffixIcon,
    this.enabledShowExtra,
    this.enableCustomKeypad,
    this.customKeypadHeading,
  });

  TextEditingController? controller;

  FormFieldValidator<String>? validator;

  Function(double value)? onSaveValue;

  Function(double)? onFieldSubmitted;

  List<TextInputFormatter>? inputFormatters;

  Function(double value)? onChanged;

  MoneyFormatSettings? moneyFormatSettings;

  AppearanceSettings? appearanceSettings;

  bool? useOutlineStyling;

  bool? enableCustomKeypad;

  bool? enabledShowExtra;

  IconData? suffixIcon;

  IconData? prefixIcon;

  bool? enabled;

  bool isRequired;

  String? customKeypadHeading;

  MoneyTextFormFieldSettings copyWith({
    TextEditingController? controller,
    FormFieldValidator<String>? validator,
    List<TextInputFormatter>? inputFormatters,
    Function(double value)? onChanged,
    MoneyFormatSettings? moneyFormatSettings,
    AppearanceSettings? appearanceSettings,
    bool? enabled,
    bool? isRequired,
    bool? enableCustomKeypad,
    String? customKeypadHeading,
    Function(double)? onFieldSubmitted,
    Function(double value)? onSaveValue,
    bool? useOutlineStyling,
    IconData? suffixIcon,
    IconData? prefixIcon,
    bool? enabledShowExtra,
  }) => MoneyTextFormFieldSettings()
    ..controller = controller ?? this.controller
    ..validator = validator ?? this.validator
    ..inputFormatters = inputFormatters ?? this.inputFormatters
    ..onChanged = onChanged ?? this.onChanged
    ..customKeypadHeading = customKeypadHeading ?? this.customKeypadHeading
    ..moneyFormatSettings = moneyFormatSettings ?? this.moneyFormatSettings
    ..appearanceSettings = appearanceSettings ?? this.appearanceSettings
    ..enabled = enabled ?? this.enabled
    ..enableCustomKeypad = enableCustomKeypad ?? this.enableCustomKeypad
    ..isRequired = isRequired ?? this.isRequired
    ..onFieldSubmitted = onFieldSubmitted ?? this.onFieldSubmitted
    ..onSaveValue = onSaveValue ?? this.onSaveValue
    ..useOutlineStyling = useOutlineStyling ?? this.useOutlineStyling
    ..suffixIcon = suffixIcon ?? this.suffixIcon
    ..prefixIcon = prefixIcon ?? this.prefixIcon
    ..enabledShowExtra = enabledShowExtra ?? this.enabledShowExtra;
}
