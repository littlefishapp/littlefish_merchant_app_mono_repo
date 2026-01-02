// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/ensure_visible_focused.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/form_field_config/form_field_config.dart';

import '../../../../../widgets/app/theme/applied_system/applied_surface.dart';
import '../../../../../widgets/app/theme/applied_system/applied_text_icon.dart';

class StringFormField extends StatefulWidget {
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
  final double? iconSize;
  final bool isRequired;
  final bool obsecureText;
  final int? maxLength;
  final int minLength;
  final int minLines;
  final bool enforceMaxLength;
  final TextAlign textAlign;
  final TextEditingController? controller;
  final TextCapitalization? textCapitalization;
  final int maxLines;
  final bool useOutlineStyling;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final OutlineInputBorder? outLineInputBorderStyle;
  final OutlineInputBorder? focusOutLineInputBorderStyle;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final Function(String? value)? asyncValidator;
  final TextInputType? textInputType;
  final bool? enabled;
  final bool useRegex;
  final RegExp? customerRegex;
  final String? Function(String?)? validator;

  const StringFormField({
    Key? key,
    required this.onSaveValue,
    required this.hintText,
    required this.labelText,
    this.inputAction = TextInputAction.done,
    this.textCapitalization = TextCapitalization.sentences,
    this.textAlign = TextAlign.left,
    this.suffixIcon,
    this.prefixIcon,
    this.iconSize,
    this.onFieldSubmitted,
    this.onChanged,
    this.focusNode,
    this.nextFocusNode,
    this.autoValidate = false,
    this.initialValue,
    this.isRequired = true,
    this.obsecureText = false,
    this.maxLength,
    this.minLength = 0,
    this.enforceMaxLength = false,
    this.controller,
    this.minLines = 1,
    this.enabled = true,
    this.useOutlineStyling = false,
    this.asyncValidator,
    this.maxLines = 1,
    this.hintStyle,
    this.textStyle,
    this.labelStyle,
    this.outLineInputBorderStyle,
    this.focusOutLineInputBorderStyle,
    this.floatingLabelBehavior,
    this.textInputType,
    this.useRegex = true,
    this.customerRegex,
    this.validator,
  }) : super(key: key);

  @override
  State<StringFormField> createState() => _StringFormFieldState();
}

class _StringFormFieldState extends State<StringFormField> {
  bool _isLoading = false;
  late TextEditingController controller;
  late String initialValue;

  FocusNode? _focusNode;

  late RegExp _regex;

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController();
    initialValue = widget.initialValue ?? '';
    controller.text = initialValue;
    _regex = widget.customerRegex ?? RegExp(r'^[a-zA-Z0-9 @_\-.,]*$');
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
    if (!(_focusNode?.hasFocus ?? true)) {
      if (null != widget.onFieldSubmitted) {
        widget.onFieldSubmitted!(controller.text);
      }
    }
  }

  @override
  void didUpdateWidget(StringFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null &&
        (widget.controller != oldWidget.controller)) {
      controller = widget.controller ?? TextEditingController();
      _focusNode = widget.focusNode ?? FocusNode();
    }

    if (widget.initialValue != oldWidget.initialValue) {
      controller = TextEditingController(text: widget.initialValue ?? '');
      _focusNode = widget.focusNode ?? FocusNode();
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
    final isFilled = !widget.useOutlineStyling;
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
        ? widget.outLineInputBorderStyle ?? context.inputBorderEnabled()
        : context.inputBorderUnderlineEnabled;

    final border = widget.useOutlineStyling
        ? widget.outLineInputBorderStyle ?? context.inputBorderEnabled()
        : context.inputBorderUnderlineEnabled;

    final focussedBorder = widget.useOutlineStyling
        ? widget.focusOutLineInputBorderStyle ?? context.inputBorderFocus()
        : context.inputBorderUnderlineEnabled;

    final disabledBorder = widget.useOutlineStyling
        ? context.inputBorderDisabled()
        : context.inputBorderUnderlineDisabled;

    final errorBorder = widget.useOutlineStyling
        ? context.inputBorderError()
        : context.inputBorderUnderlineError;

    return EnsureVisibleWhenFocused(
      focusNode: _focusNode ?? FocusNode(),
      child: TextFormField(
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        key: widget.key,
        enabled: _isLoading ? false : widget.enabled,
        style: textStyle,
        cursorColor: textColor,
        cursorErrorColor: errorColor,
        controller: controller,
        focusNode: _focusNode,
        maxLength: widget.maxLength,
        textAlign: widget.textAlign,
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.sentences,
        obscureText: widget.obsecureText,
        decoration: InputDecoration(
          border: border,
          enabledBorder: enabledBorder,
          focusedBorder: focussedBorder,
          disabledBorder: disabledBorder,
          errorBorder: errorBorder,
          isDense: true,
          fillColor: fillColor,
          filled: isFilled,
          errorMaxLines: 1,
          errorStyle: errorStyle,
          counter: const SizedBox(height: 0.0),
          prefixIconColor: iconColor,
          suffixIconColor: iconColor,
          suffixIcon: _isLoading
              ? const AppProgressIndicator()
              : (widget.suffixIcon != null
                    ? Icon(widget.suffixIcon, size: widget.iconSize)
                    : null),
          prefixIcon: _isLoading
              ? const AppProgressIndicator()
              : (widget.prefixIcon != null
                    ? Icon(widget.prefixIcon, size: widget.iconSize)
                    : null),
          labelText: widget.isRequired
              ? '${widget.labelText} *'
              : widget.labelText,
          labelStyle: labelStyle,
          alignLabelWithHint: true,
          floatingLabelBehavior: widget.floatingLabelBehavior,
          hintText: widget.hintText,
          hintStyle: hintStyle,
        ),
        enableInteractiveSelection: true,
        keyboardType:
            widget.textInputType ??
            (widget.maxLines <= 1
                ? TextInputType.text
                : TextInputType.multiline),
        textInputAction: widget.inputAction,
        onFieldSubmitted: (value) {
          if (null != widget.onFieldSubmitted) {
            widget.onFieldSubmitted!(value);
            if (widget.nextFocusNode != null) {
              FocusScope.of(context).requestFocus(widget.nextFocusNode);
            }
          }
        },
        onChanged: (value) {
          if (null != widget.onChanged) widget.onChanged!(value);
        },
        readOnly: !widget.enabled!,
        validator: (value) {
          if (widget.validator != null) {
            return widget.validator!(value);
          }

          if (!validateValue(value)) {
            return 'Please enter a valid value for ${widget.labelText}';
          }

          if (widget.asyncValidator != null) return asyncValidation(value);

          return null;
        },
        onSaved: (value) {
          String? trimmedValue = value?.trim();
          if (validateValue(value)) {
            widget.onSaveValue(trimmedValue);
          }
        },
      ),
    );
  }

  String? asyncValidation(String? value) {
    setState(() {
      _isLoading = true;
    });

    try {
      var result = widget.asyncValidator!(value);
      return result;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
    }

    return null;
  }

  bool validateValue(String? value) {
    String thisValue = (value ?? '').trim();

    if (widget.isRequired) {
      if (thisValue.isEmpty) {
        return false;
      }

      int minLength = widget.minLength <= 0 ? 2 : widget.minLength;

      if (thisValue.length < minLength) {
        return false;
      }
    }

    if (widget.useRegex && !_regex.hasMatch(thisValue)) {
      return false;
    }

    return true;
  }
}
