import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/form_field_config/form_field_config.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../app/theme/applied_system/applied_surface.dart';
import '../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../injector.dart';

class PasswordFormField extends StatefulWidget {
  final String? hintText, labelText, initialValue;
  final bool autoValidate;
  final Function(String? value) onSaveValue;
  final Function(String value)? onFieldSubmitted;
  final Function(String value)? onChanged;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction inputAction;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final bool isRequired;
  final PasswordPolicies policies;
  final TextEditingController? controller;
  final bool enabled;
  final Color? textColor;
  final Color? iconColor;
  final Color? hintColor;
  final Color? errorColor;
  final bool useOutlineStyling;
  final OutlineInputBorder? outLineInputBorderStyle;
  final OutlineInputBorder? focusOutLineInputBorderStyle;

  /// widgetOnBrandedSurface = true shows onPrimary coloured button on Primary canvas
  /// widgetOnBrandedSurface = fasle shows primary coloured button on non primary canvas
  final bool widgetOnBrandedSurface;

  const PasswordFormField({
    required Key key,
    required this.onSaveValue,
    required this.hintText,
    required this.labelText,
    this.inputAction = TextInputAction.done,
    this.suffixIcon,
    this.prefixIcon,
    this.onFieldSubmitted,
    this.focusNode,
    this.nextFocusNode,
    this.autoValidate = false,
    this.initialValue,
    this.isRequired = true,
    this.controller,
    this.enabled = true,
    required this.policies,
    this.useOutlineStyling = false,
    this.textColor,
    this.iconColor,
    this.hintColor,
    this.errorColor,
    this.outLineInputBorderStyle,
    this.focusOutLineInputBorderStyle,
    this.widgetOnBrandedSurface = false,
    this.onChanged,
  }) : super(key: key);

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  late TextEditingController controller;
  late String initialValue;

  bool showValue = false;

  FocusNode? _focusNode;

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController();
    initialValue = widget.initialValue ?? '';
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode?.addListener(_handleFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _focusNode!.removeListener(_handleFocusChange);
    _focusNode!.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!_focusNode!.hasFocus) {
      if (null != widget.onFieldSubmitted) {
        widget.onFieldSubmitted!(controller.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textIconColours =
        Theme.of(context).extension<AppliedTextIcon>() ??
        const AppliedTextIcon();
    final surfaceColors =
        Theme.of(context).extension<AppliedSurface>() ?? const AppliedSurface();
    var isFilled = !widget.useOutlineStyling;
    var fillColor = surfaceColors.primary;
    var iconColor = textIconColours.primary;
    var textColor = textIconColours.emphasized;
    var hintColor = textIconColours.deEmphasized;
    var labelColor = textIconColours.secondary;
    var errorColor = textIconColours.error;

    if (widget.widgetOnBrandedSurface) {
      fillColor = Colors.transparent;
      iconColor = textIconColours.inversePrimary;
      textColor = textIconColours.inverseEmphasized;
      hintColor = textIconColours.inverseDeEmphasized;
      labelColor = textIconColours.inverseSecondary;
    }

    final textStyle = context.styleParagraphSmallRegular!.copyWith(
      color: textColor,
    );

    final config =
        AppVariables.store?.state.formFieldConfig ?? FormFieldConfig().config;
    final baseHintStyle =
        context.getTextStyle(config.hintTextStyle) ??
        context.styleParagraphSmallRegular;
    final hintStyle = baseHintStyle!.copyWith(color: hintColor);

    final labelStyle = baseHintStyle.copyWith(color: labelColor);
    final errorStyle = context.styleBody03x12R!.copyWith(color: errorColor);

    final enabledBorder = widget.useOutlineStyling
        ? widget.outLineInputBorderStyle ??
              context.inputBorderEnabled(inverse: widget.widgetOnBrandedSurface)
        : context.inputBorderUnderlineEnabled;

    final border = widget.useOutlineStyling
        ? widget.outLineInputBorderStyle ??
              context.inputBorderEnabled(inverse: widget.widgetOnBrandedSurface)
        : context.inputBorderUnderlineEnabled;

    final focussedBorder = widget.useOutlineStyling
        ? widget.focusOutLineInputBorderStyle ??
              context.inputBorderFocus(inverse: widget.widgetOnBrandedSurface)
        : context.inputBorderUnderlineEnabled;

    final disabledBorder = widget.useOutlineStyling
        ? context.inputBorderDisabled(inverse: widget.widgetOnBrandedSurface)
        : context.inputBorderUnderlineDisabled;

    final errorBorder = widget.useOutlineStyling
        ? context.inputBorderError(inverse: widget.widgetOnBrandedSurface)
        : context.inputBorderUnderlineError;

    return TextFormField(
      minLines: 1,
      key: widget.key,
      enabled: widget.enabled,
      controller: controller,
      focusNode: widget.focusNode,
      textCapitalization: TextCapitalization.none,
      obscureText: !showValue,
      style: textStyle,
      cursorColor: textColor,
      cursorErrorColor: errorColor,
      decoration: InputDecoration(
        border: border,
        enabledBorder: enabledBorder,
        focusedBorder: focussedBorder,
        disabledBorder: disabledBorder,
        isDense: true,
        fillColor: fillColor,
        filled: isFilled,
        errorBorder: errorBorder,
        errorMaxLines: 5,
        errorStyle: errorStyle,
        counter: const SizedBox(height: 0.0),
        prefixIconColor: iconColor,
        prefixIcon: (widget.prefixIcon != null
            ? Icon(widget.prefixIcon)
            : null),
        suffixIconColor: iconColor,
        suffixIcon: (widget.suffixIcon != null
            ? showValue
                  ? IconButton(
                      tooltip: 'Hide Password',
                      icon: Icon(MdiIcons.eye),
                      onPressed: () {
                        showValue = false;
                        if (mounted) setState(() {});
                      },
                    )
                  : IconButton(
                      tooltip: 'Show Password',
                      icon: Icon(MdiIcons.eyeOff),
                      onPressed: () {
                        showValue = true;
                        if (mounted) setState(() {});
                      },
                    )
            : null),
        labelText: widget.isRequired
            ? '${widget.labelText} *'
            : widget.labelText,
        labelStyle: labelStyle,
        alignLabelWithHint: true,
        hintText: widget.hintText,
        hintStyle: hintStyle,
      ),
      enableInteractiveSelection: true,
      keyboardType: TextInputType.text,
      textInputAction: widget.inputAction,
      onFieldSubmitted: (value) async {
        if (null != widget.onFieldSubmitted) {
          widget.onFieldSubmitted!(value);

          if (widget.nextFocusNode != null) {
            FocusScope.of(context).requestFocus(widget.nextFocusNode);
          }
        }
      },
      readOnly: !widget.enabled,
      validator: (value) {
        if (!validateValue(value)) {
          return 'Please enter a valid password';
        }

        return widget.policies.validatePassword(value);
      },
      onSaved: (value) async {
        //we must validate the amount first as it should never save a bad amount.
        if (validateValue(value)) {
          widget.onSaveValue(value);
        }
      },
      onChanged: widget.onChanged,
    );
  }

  bool validateValue(String? value) {
    if (value == null || value.isEmpty) {
      if (!widget.isRequired) return true;
      return false;
    }

    return true;
  }
}

class PasswordPolicies {
  List<PasswordPolicy> policies = [];

  String? validatePassword(String? password) {
    String? result;

    for (var p in policies) {
      var validationResult = p.validate(password);

      if (validationResult != null && validationResult.isNotEmpty) {
        if (result == null) {
          result = validationResult;
        } else {
          result = '$result\n$validationResult';
        }
      }
    }

    return result;
  }

  void addPolicy(PasswordPolicy policy) {
    if (policies.isEmpty) {
      policies = [policy];
      return;
    }

    if (policies.any((p) => p.policyType == policy.policyType)) {
      var index = policies.indexWhere((p) => p.policyType == policy.policyType);

      policies[index] = policy;
    } else {
      policies.add(policy);
    }
  }

  void removePolicy(PasswordPolicy policy) {
    if (policies.isEmpty) {
      return;
    }

    if (policies.any((p) => p.policyType == policy.policyType)) {
      policies.removeWhere((p) => p.policyType == policy.policyType);
    }
  }
}

class PasswordPolicy {
  PasswordPolicy({
    required this.displayName,
    required this.policyType,
    required this.value,
  });

  PolicyType policyType;

  String displayName;

  int value;

  String? validate(String? password) {
    switch (policyType) {
      case PolicyType.specialCharacters:
        return RegExp(
              '[!^<>{}"/|;:.,~!?@#\$%^=&*\\]\\\\()\\[¿§«»ω⊙¤°℃℉€¥£¢¡®©_+]',
            ).hasMatch(password!)
            ? null
            : 'Password must have $value or more special characters (i.e. !,@,\$)';
      case PolicyType.upperCaseCharacters:
        return RegExp('[A-Z]').hasMatch(password!)
            ? null
            : 'Password must have $value or more upper case characters (i.e. A to Z)';
      case PolicyType.lowerCaseCharacters:
        return RegExp('[a-z]').hasMatch(password!)
            ? null
            : 'Password must have $value or more lower case characters (i.e. a to z)';
      case PolicyType.digits:
        return RegExp('[0-9]').hasMatch(password!)
            ? null
            : 'Password must have $value or more digits (i.e. 0 to 9)';
      case PolicyType.minLength:
        return (password ?? '').length < value
            ? 'Password must be $value characters or longer'
            : null;
      default:
        return null;
    }
  }

  @override
  String toString() {
    switch (policyType) {
      case PolicyType.specialCharacters:
        return '$value or more, special characters i.e. #\$%^&*';
      case PolicyType.upperCaseCharacters:
        return '$value or more, upper case chararcters i.e.ABCDE';
      case PolicyType.lowerCaseCharacters:
        return '$value or more, lower case chararcters i.e.abcde';
      case PolicyType.digits:
        return '$value or more, numbers i.e.12345';
      case PolicyType.minLength:
        return 'Minimum Length of $value characters';
      default:
        return 'Password Policy';
    }
  }
}

enum PolicyType {
  specialCharacters,
  upperCaseCharacters,
  lowerCaseCharacters,
  digits,
  minLength,
}
