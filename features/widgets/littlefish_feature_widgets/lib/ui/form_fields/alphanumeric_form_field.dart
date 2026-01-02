// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/form_field_config/form_field_config.dart';

import '../../../../app/theme/applied_system/applied_surface.dart';
import '../../../../app/theme/applied_system/applied_text_icon.dart';

class AlphaNumericFormField extends StatefulWidget {
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
  final int? maxLength;
  final int minLength;
  final bool enforceMaxLength;
  final TextEditingController? controller;
  final bool useOutlineStyling;
  final bool? isDense;

  final int maxLines;
  //return a future to this method always
  final Function(String value)? asyncValidator;
  final TextAlign? textAlign;

  final bool enabled;

  const AlphaNumericFormField({
    required Key key,
    required this.onSaveValue,
    required this.hintText,
    required this.labelText,
    this.inputAction = TextInputAction.none,
    this.suffixIcon,
    this.prefixIcon,
    this.onFieldSubmitted,
    this.onChanged,
    this.focusNode,
    this.nextFocusNode,
    this.autoValidate = false,
    this.initialValue,
    this.isRequired = true,
    this.maxLength,
    this.minLength = 0,
    this.enforceMaxLength = false,
    this.controller,
    this.enabled = true,
    this.asyncValidator,
    this.maxLines = 1,
    this.textAlign,
    this.isDense,
    this.useOutlineStyling = false,
  }) : super(key: key);

  @override
  State<AlphaNumericFormField> createState() => _AlphaNumericFormFieldState();
}

class _AlphaNumericFormFieldState extends State<AlphaNumericFormField> {
  final bool _isLoading = false;

  late TextEditingController controller;
  late String initialValue;
  FocusNode? _focusNode;

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController();
    initialValue = widget.initialValue ?? '';
    controller.text = initialValue;
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
  void didUpdateWidget(AlphaNumericFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null &&
        (widget.controller != oldWidget.controller)) {
      controller = widget.controller ?? TextEditingController();
    }

    if (widget.initialValue != oldWidget.initialValue) {
      controller = TextEditingController(text: widget.initialValue ?? '');
    }

    if (oldWidget.controller == null) {
      return;
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
      enabled: _isLoading ? false : widget.enabled,
      controller: controller,
      focusNode: widget.focusNode,
      style: textStyle,
      minLines: 1,
      maxLines: widget.maxLines,
      key: widget.key,
      maxLengthEnforcement: widget.enforceMaxLength
          ? MaxLengthEnforcement.enforced
          : null,
      textAlign: widget.textAlign ?? TextAlign.start,
      maxLength: widget.maxLength,
      textCapitalization: TextCapitalization.none,
      decoration: InputDecoration(
        border: border,
        enabledBorder: enabledBorder,
        focusedBorder: focussedBorder,
        disabledBorder: disabledBorder,
        errorBorder: errorBorder,
        isDense: true,
        fillColor: fillColor,
        filled: true,
        counter: const SizedBox(height: 0.0),
        prefixIconColor: iconColor,
        prefixIcon: (widget.prefixIcon != null
            ? Icon(widget.prefixIcon)
            : null),
        suffixIconColor: iconColor,
        suffixIcon: (widget.suffixIcon != null
            ? Icon(widget.suffixIcon)
            : null),
        labelStyle: labelStyle,
        labelText: widget.isRequired
            ? '${widget.labelText} *'
            : widget.labelText,
        alignLabelWithHint: true,
        hintStyle: hintStyle,
        hintText: widget.hintText,
      ),
      inputFormatters: [
        UppercaseInputFormatter(),
        FilteringTextInputFormatter.allow(RegExp('[\\da-zA-Z0-9-_]+')),
      ],
      enableInteractiveSelection: true,
      keyboardType: TextInputType.text,
      textInputAction: widget.inputAction,
      onFieldSubmitted: (value) {
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
          return 'Please enter a valid value for ${widget.labelText}';
        }

        return null;
      },
      onSaved: (value) {
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

    if (widget.minLength > 0) {
      return value.length >= widget.minLength;
    }

    return true;
  }
}

class UppercaseInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
