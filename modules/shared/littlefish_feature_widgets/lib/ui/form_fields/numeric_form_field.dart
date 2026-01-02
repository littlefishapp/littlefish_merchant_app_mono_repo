import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/form_field_config/form_field_config.dart';

import '../../../../../widgets/app/theme/applied_system/applied_surface.dart';
import '../../../../../widgets/app/theme/applied_system/applied_text_icon.dart';

class NumericFormField extends StatefulWidget {
  final String hintText, labelText;
  final String? validationErrorMessage;
  final int? initialValue;
  final bool autoValidate;
  final Function(int) onSaveValue;
  final Function(int)? onFieldSubmitted;
  final Function(int)? onChanged;

  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final int? maxLength;
  final bool maxLengthEnforced;
  final TextInputAction inputAction;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final bool enabled;
  final bool isRequired;
  final Color? color;
  final TextEditingController? controller;
  final bool useOutlineStyling;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final bool showTextLengthCounter;
  final bool isDense;

  final FormFieldValidator<int>? validator;

  const NumericFormField({
    required Key key,
    required this.onSaveValue,
    required this.hintText,
    required this.labelText,
    this.validationErrorMessage,
    this.isRequired = false,
    this.inputAction = TextInputAction.done,
    this.suffixIcon,
    this.prefixIcon,
    this.onFieldSubmitted,
    this.onChanged,
    this.focusNode,
    this.nextFocusNode,
    this.autoValidate = false,
    this.initialValue,
    this.enabled = true,
    this.color,
    this.validator,
    this.controller,
    this.isDense = false,
    this.maxLength,
    this.maxLengthEnforced = false,
    this.showTextLengthCounter = true,
    this.useOutlineStyling = false,
    this.hintStyle,
    this.textStyle,
    this.labelStyle,
  }) : super(key: key);

  @override
  State<NumericFormField> createState() => _NumericFormFieldState();
}

class _NumericFormFieldState extends State<NumericFormField> {
  late int initialValue;
  late TextEditingController controller;
  FocusNode? _focusNode;

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController();
    initialValue = widget.initialValue ?? 0;
    controller.text = initialValue.toString();
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
      if (null != widget.onFieldSubmitted && validateValue(controller.text)) {
        widget.onFieldSubmitted!(int.parse(controller.text));
      }
    }
  }

  @override
  void didUpdateWidget(NumericFormField oldWidget) {
    if (widget.controller != null &&
        (widget.controller != oldWidget.controller)) {
      controller = widget.controller ?? TextEditingController();
    }

    if (widget.initialValue != oldWidget.initialValue) {
      controller = TextEditingController(text: widget.initialValue.toString());
    }

    if (oldWidget.controller == null) {
      return;
    }
    super.didUpdateWidget(oldWidget);
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
      controller: controller,
      focusNode: widget.focusNode,
      style: textStyle,
      cursorColor: textColor,
      cursorErrorColor: errorColor,
      key: widget.key,
      maxLength: widget.maxLength,
      maxLengthEnforcement: widget.maxLengthEnforced
          ? MaxLengthEnforcement.enforced
          : MaxLengthEnforcement.none,
      textAlign: TextAlign.end,
      decoration: InputDecoration(
        border: border,
        enabledBorder: enabledBorder,
        focusedBorder: focussedBorder,
        disabledBorder: disabledBorder,
        errorBorder: errorBorder,
        isDense: widget.isDense,
        fillColor: fillColor,
        filled: true,
        errorStyle: errorStyle,
        prefixIconColor: iconColor,
        suffixIconColor: iconColor,
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
        hintText: widget.hintText,
        hintStyle: hintStyle,
        counter: !widget.showTextLengthCounter ? const Offstage() : null,
      ),
      enableInteractiveSelection: true,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp('[^0-9]')),
        MaxNumberLimiter(),
      ],
      keyboardType: TextInputType.number,
      textInputAction: widget.inputAction,
      onFieldSubmitted: (value) {
        if (null != widget.onFieldSubmitted && validateValue(value)) {
          widget.onFieldSubmitted!(int.parse(value));

          if (widget.nextFocusNode != null) {
            FocusScope.of(context).requestFocus(widget.nextFocusNode);
          }
        }
      },
      onChanged: (value) {
        int valueAsInt = int.tryParse(value) ?? 0;
        if (widget.onChanged != null) widget.onChanged!(valueAsInt);
      },
      validator: (value) {
        int val = int.tryParse(value ?? '') ?? 0;

        if (val == 0 && widget.isRequired) {
          return widget.validationErrorMessage ??
              'Please enter a valid value for ${widget.labelText}';
        }

        if (!validateValue(value)) {
          return 'Please enter a valid value for ${widget.labelText}';
        }

        if (widget.validator != null) {
          return widget.validator!(val);
        }

        return null;
      },
      onSaved: (value) {
        if (validateValue(value)) {
          widget.onSaveValue(int.parse(value!));
        }
      },
    );
  }

  bool validateValue(String? value) {
    if (value == null || value.isEmpty) return false;

    //here we need to define the pattern
    var regexPattern = '[\\d]';

    RegExp expression = RegExp(regexPattern);
    return expression.hasMatch(value);
  }
}

class MaxNumberLimiter extends TextInputFormatter {
  int maxNumber = 50000000;
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    try {
      return int.parse(newValue.text) > maxNumber ? oldValue : newValue;
    } on Exception catch (_) {
      return newValue;
    }
  }
}
