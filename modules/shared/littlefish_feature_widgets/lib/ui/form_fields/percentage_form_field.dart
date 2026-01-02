// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/form_field_config/form_field_config.dart';

// Project imports:
import 'package:littlefish_merchant/tools/textformatter.dart';

import '../../../../../widgets/app/theme/applied_system/applied_surface.dart';
import '../../../../../widgets/app/theme/applied_system/applied_text_icon.dart';

class PercentageFormField extends StatefulWidget {
  final String hintText, labelText;
  final double? initialValue;
  final bool autoValidate;
  final Function(double) onSaveValue;
  final Function(double)? onFieldSubmitted;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction inputAction;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final bool isRequired;
  final bool useOutlineStyling;
  final TextEditingController? controller;

  final bool enabled;

  const PercentageFormField({
    required Key key,
    required this.onSaveValue,
    required this.hintText,
    required this.labelText,
    this.inputAction = TextInputAction.next,
    this.isRequired = false,
    this.focusNode,
    this.nextFocusNode,
    this.controller,
    this.suffixIcon,
    this.prefixIcon,
    this.onFieldSubmitted,
    this.autoValidate = false,
    this.initialValue,
    this.enabled = true,
    this.useOutlineStyling = false,
  }) : super(key: key);

  @override
  State<PercentageFormField> createState() => _PercentageFormFieldState();
}

class _PercentageFormFieldState extends State<PercentageFormField> {
  String? displayValue;
  String? fieldValue;
  TextEditingController? _controller;
  FocusNode? _focusNode;

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    displayValue = (widget.initialValue ?? '').toString();
    _controller?.text = displayValue ?? '';
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode?.addListener(_handleFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _focusNode!.removeListener(_handleFocusChange);
    _focusNode!.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!(_focusNode?.hasFocus ?? true)) {
      if (null != widget.onFieldSubmitted) {
        if (validateValue(_controller?.text)) {
          widget.onFieldSubmitted!(double.parse(_controller?.text ?? '0'));
        }
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
    final fillColor = surfaceColors.primary;
    final iconColor = textIconColours.primary;
    final textColor = textIconColours.emphasized;
    final hintColor = textIconColours.deEmphasized;
    final labelColor = textIconColours.secondary;
    final errorColor = textIconColours.error;

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
        ? context.inputBorderEnabled()
        : context.inputBorderUnderlineEnabled;

    final border = widget.useOutlineStyling
        ? context.inputBorderEnabled()
        : context.inputBorderUnderlineEnabled;

    final focussedBorder = widget.useOutlineStyling
        ? context.inputBorderFocus()
        : context.inputBorderUnderlineEnabled;

    final disabledBorder = widget.useOutlineStyling
        ? context.inputBorderDisabled()
        : context.inputBorderUnderlineDisabled;

    final errorBorder = widget.useOutlineStyling
        ? context.inputBorderError()
        : context.inputBorderUnderlineError;

    return TextFormField(
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      style: textStyle,
      cursorColor: textColor,
      cursorErrorColor: errorColor,
      strutStyle: StrutStyle.fromTextStyle(textStyle),
      key: widget.key,
      initialValue: displayValue,
      decoration: InputDecoration(
        border: border,
        enabledBorder: enabledBorder,
        focusedBorder: focussedBorder,
        disabledBorder: disabledBorder,
        errorBorder: errorBorder,
        isDense: true,
        filled: true,
        fillColor: fillColor,
        errorStyle: errorStyle,
        suffixIconColor: iconColor,
        prefixIconColor: iconColor,
        suffixIcon: (widget.suffixIcon != null
            ? Icon(widget.suffixIcon)
            : null),
        prefixIcon: (widget.prefixIcon != null
            ? Icon(widget.prefixIcon)
            : null),
        labelStyle: labelStyle,
        labelText: widget.isRequired
            ? '${widget.labelText} *'
            : widget.labelText,
        alignLabelWithHint: true,
        hintStyle: hintStyle,
        hintText: widget.hintText,
      ),
      enableInteractiveSelection: true,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp('[a-zA-z]')),
        FilteringTextInputFormatter.deny(RegExp('\\s')),
        FilteringTextInputFormatter.allow(RegExp('[\\d.]')),
      ],
      keyboardType: TextInputType.number,
      textInputAction: widget.inputAction,
      onFieldSubmitted: (value) {
        fieldValue = value;
        if (null != widget.onFieldSubmitted) {
          widget.onFieldSubmitted!(double.parse(value));

          if (widget.nextFocusNode != null) {
            FocusScope.of(context).requestFocus(widget.nextFocusNode);
          }
        }
      },
      validator: (value) {
        fieldValue = value;

        if (!validateValue(value)) {
          return 'Please enter a valid value for ${widget.labelText}';
        }

        var thisValue = double.parse(value!);

        if (thisValue > 100) {
          return 'Amount cannot be greater than 100';
        } else if (thisValue <= 0) {
          return 'Amount must be greater than 0';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        //we must validate the amount first as it should never save a bad amount.
        if (validateValue(value)) {
          widget.onSaveValue(double.parse(value!));
        }
      },
    );
  }

  bool validateValue(String? value) {
    if ((value == null || value.isEmpty) && widget.isRequired) return false;

    //here we need to define the pattern
    var regexPattern = '[\\d.]';

    RegExp expression = RegExp(regexPattern);
    var isValid = expression.hasMatch(value!);

    if (isValid && widget.isRequired) return double.parse(value) > 0;
    return isValid;
  }

  String? getDisplayValue(String value) {
    if (validateValue(value)) {
      var parsedValue = double.tryParse(value);
      displayValue = TextFormatter.toStringCurrency(
        parsedValue,
        currencyCode: '',
      );
      return displayValue;
    }
    return value;
  }
}
