// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/money_text_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_models/appearance_settings.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_models/money_display_format.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_models/money_format_settings.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_models/money_textformfield_settings.dart';
import 'package:littlefish_merchant/common/presentaion/components/ensure_visible_focused.dart';

class CurrencyFormField extends StatefulWidget {
  final String? hintText, labelText;
  final double? initialValue;
  final bool autoValidate;
  final String? customKeypadHeading;
  final Function(double) onSaveValue;
  final Function(double)? onChanged;
  final Function(double)? onFieldSubmitted;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction inputAction;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final bool isRequired;
  final bool? enabled;
  final TextEditingController? controller;
  final bool useOutlineStyling;
  final bool enableCustomKeypad;
  final TextStyle? labelStyle;
  final TextStyle? inputStyle;
  final TextStyle? formattedStyle;
  final TextStyle? errorStyle;
  final String? Function(String?)? validator;

  final bool? showExtra;

  const CurrencyFormField({
    required Key key,
    this.onChanged,
    required this.onSaveValue,
    required this.hintText,
    required this.labelText,
    this.customKeypadHeading,
    this.inputAction = TextInputAction.done,
    this.isRequired = false,
    this.suffixIcon,
    this.prefixIcon,
    this.onFieldSubmitted,
    this.enableCustomKeypad = false,
    this.focusNode,
    this.nextFocusNode,
    this.autoValidate = false,
    this.initialValue,
    this.controller,
    this.useOutlineStyling = false,
    this.enabled = true,
    this.showExtra = true,
    this.labelStyle,
    this.inputStyle,
    this.formattedStyle,
    this.errorStyle,
    this.validator,
  }) : super(key: key);

  @override
  State<CurrencyFormField> createState() => _CurrencyFormFieldState();
}

class _CurrencyFormFieldState extends State<CurrencyFormField> {
  String? displayValue;
  late double initialValue;
  late TextEditingController controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController();
    initialValue = widget.initialValue ?? 0.0;
    controller.text = initialValue.toString();
    displayValue = initialValue.toString();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
    super.initState();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      if (null != widget.onFieldSubmitted) {
        if (validateValue(controller.text)) {
          widget.onFieldSubmitted!(double.parse(controller.text));
        }
      }
    }
  }

  @override
  void didUpdateWidget(CurrencyFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != null) {
      if (controller.text != widget.initialValue.toString()) {
        controller.text = widget.initialValue.toString();
      }
    }

    if (widget.initialValue != oldWidget.initialValue) {
      controller.text = widget.initialValue?.toString() ?? '0.00';
    }

    if (oldWidget.controller == null) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var localeState = StoreProvider.of<AppState>(context).state.localeState;

    return EnsureVisibleWhenFocused(
      focusNode: _focusNode,
      child: MoneyTextFormField(
        settings: MoneyTextFormFieldSettings(
          validator: widget.validator,
          customKeypadHeading: widget.customKeypadHeading,
          enableCustomKeypad: widget.enableCustomKeypad,
          enabledShowExtra: widget.showExtra,
          suffixIcon: widget.suffixIcon,
          prefixIcon: widget.prefixIcon,
          useOutlineStyling: widget.useOutlineStyling,
          controller: controller,
          onFieldSubmitted: widget.onFieldSubmitted,
          onSaveValue: widget.onSaveValue,
          onChanged: widget.onChanged,
          appearanceSettings: AppearanceSettings(
            labelText: widget.labelText,
            hintText: widget.hintText,
            icon: widget.suffixIcon == null ? null : Icon(widget.suffixIcon),
            focusNode: _focusNode,
            key: widget.key,
            textInputAction: widget.inputAction,
            labelStyle: widget.labelStyle,
            inputStyle:
                widget.inputStyle ??
                Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
            formattedStyle: widget.errorStyle,
            errorStyle: widget.errorStyle,
          ),
          enabled: widget.enabled,
          isRequired: widget.isRequired,
          moneyFormatSettings: MoneyFormatSettings(
            amount: widget.initialValue,
            currencySymbol: localeState.currencyCode,
            decimalSeparator: '.',
            displayFormat: MoneyDisplayFormat.symbolOnLeft,
            fractionDigits: 2,
            thousandSeparator: ',',
          ),
        ),
      ),
    );
  }

  bool validateValue(String? value) {
    if ((value == null || value.isEmpty) && widget.isRequired) {
      return false;
    }

    //here we need to define the pattern
    var regexPattern = '[\\d.]';

    RegExp expression = RegExp(regexPattern);
    var isValid = expression.hasMatch(value!);

    if (isValid && widget.isRequired) return double.parse(value) > 0;
    return isValid;
  }
}
