import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/form_field_config/form_field_config.dart';
import 'package:littlefish_merchant/models/shared/form_field.dart'
    as form_field_config;
import 'package:littlefish_merchant/models/enums.dart' as model_form_field;

import 'package:quiver/strings.dart';

import '../../../../app/theme/applied_system/applied_surface.dart';
import '../../../../app/theme/applied_system/applied_text_icon.dart';
import '../app_progress_indicator.dart';

enum FieldType { string, number }

class ConfigurableFormField extends StatefulWidget {
  final form_field_config.FormField formFieldConfig;
  final bool useOutlineStyling;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  final Function(String value)? onChanged;
  final Function(String value)? onFieldSubmitted;
  final Function(String? value) onSaveValue;

  const ConfigurableFormField({
    Key? key,
    required this.formFieldConfig,
    required this.onSaveValue,
    this.controller,
    this.focusNode,
    this.nextFocusNode,
    this.onChanged,
    this.onFieldSubmitted,
    this.useOutlineStyling = true,
  }) : super(key: key);

  @override
  State<ConfigurableFormField> createState() => _ConfigurableFormFieldState();
}

class _ConfigurableFormFieldState extends State<ConfigurableFormField> {
  TextEditingController? controller;
  FocusNode? _focusNode;
  final bool _isLoading = false;

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController();
    controller!.text = (isNotBlank(widget.formFieldConfig.value)
        ? widget.formFieldConfig.value
        : widget.formFieldConfig.defaultValue ?? '')!;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode?.addListener(_handleFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    _focusNode!.removeListener(_handleFocusChange);
    _focusNode!.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!_focusNode!.hasFocus) {
      if (null != widget.onFieldSubmitted) {
        widget.onFieldSubmitted!(controller!.text);
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
    final isFilled = !widget.useOutlineStyling;
    final fillColor = surfaceColors.primary;
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

    return widget.formFieldConfig.isHidden
        ? const SizedBox.shrink()
        : _isLoading
        ? const AppProgressIndicator()
        : TextFormField(
            enabled: !widget.formFieldConfig.isDisabled,
            controller: controller,
            maxLength: 10,
            key: ValueKey(widget.formFieldConfig.fieldId),
            style: textStyle,
            cursorColor: textColor,
            cursorErrorColor: errorColor,
            obscureText:
                widget.formFieldConfig.fieldType ==
                    model_form_field.FieldType.string &&
                widget.formFieldConfig.regex == null,
            decoration: InputDecoration(
              border: border,
              enabledBorder: enabledBorder,
              focusedBorder: focussedBorder,
              disabledBorder: disabledBorder,
              errorBorder: errorBorder,
              isDense: true,
              fillColor: fillColor,
              filled: isFilled,
              labelStyle: labelStyle,
              labelText: widget.formFieldConfig.isRequired!
                  ? '${widget.formFieldConfig.displayName} *'
                  : widget.formFieldConfig.displayName,
              hintStyle: hintStyle,
              hintText: widget.formFieldConfig.description,
              errorStyle: errorStyle,
            ),
            keyboardType:
                widget.formFieldConfig.fieldType ==
                    model_form_field.FieldType.integer
                ? TextInputType.number
                : TextInputType.text,
            validator: (value) {
              if (isBlank(value)) {
                if (widget.formFieldConfig.isRequired!) {
                  return 'Please enter a value for ${widget.formFieldConfig.displayName}';
                }
                return null;
              }

              int? minLength = int.tryParse(
                widget.formFieldConfig.minLength ?? '',
              );
              if (minLength != null && value!.length < minLength) {
                return 'Value is too short for ${widget.formFieldConfig.displayName}';
              }

              int? maxLength = int.tryParse(
                widget.formFieldConfig.maxLength ?? '',
              );
              if (maxLength != null && value!.length > maxLength) {
                return 'Value is too long for ${widget.formFieldConfig.displayName}';
              }

              if (widget.formFieldConfig.regex != null &&
                  !RegExp(widget.formFieldConfig.regex!).hasMatch(value!)) {
                return widget.formFieldConfig.regexMessage ??
                    'Value does not match the required pattern for ${widget.formFieldConfig.displayName}';
              }

              return null;
            },
            onChanged: (value) {
              if (widget.onChanged != null) widget.onChanged!(value);
            },
            onFieldSubmitted: (value) {
              if (widget.onFieldSubmitted != null) {
                widget.onFieldSubmitted!(value);

                if (widget.nextFocusNode != null) {
                  FocusScope.of(context).requestFocus(widget.nextFocusNode);
                }
              }
            },
            onSaved: (value) {
              widget.onSaveValue(value);
            },
          );
  }
}
