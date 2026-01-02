// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/form_field_config/form_field_config.dart';
import 'package:littlefish_merchant/tools/extensions/extensions.dart';

import '../../../../../widgets/app/theme/applied_system/applied_text_icon.dart';

class DecimalFormField extends StatefulWidget {
  final String hintText, labelText;
  final double? initialValue;
  final bool autoValidate;
  final Function(double) onSaveValue;
  final Function(double)? onFieldSubmitted;
  final Function(double)? onChanged;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction inputAction;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final bool enabled;
  final bool isRequired;
  final Color? color;
  final TextEditingController? controller;
  final OutlineInputBorder? outLineInputBorderStyle;
  final OutlineInputBorder? focusOutLineInputBorderStyle;
  final bool useOutlineStyling;

  const DecimalFormField({
    required Key key,
    required this.onSaveValue,
    required this.hintText,
    required this.labelText,
    this.onChanged,
    this.controller,
    this.isRequired = false,
    this.inputAction = TextInputAction.done,
    this.suffixIcon,
    this.prefixIcon,
    this.onFieldSubmitted,
    this.focusNode,
    this.nextFocusNode,
    this.autoValidate = false,
    this.initialValue,
    this.enabled = true,
    this.outLineInputBorderStyle,
    this.focusOutLineInputBorderStyle,
    this.color,
    this.useOutlineStyling = false,
  }) : super(key: key);

  @override
  State<DecimalFormField> createState() => _DecimalFormFieldState();
}

class _DecimalFormFieldState extends State<DecimalFormField> {
  late double initialValue;
  late TextEditingController controller;

  FocusNode? _focusNode;

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController();
    initialValue =
        widget.initialValue ?? double.tryParse(controller.text) ?? 0.0;
    controller.text = initialValue > 0
        ? formatDecimalString(initialValue.toString())
        : '';
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode?.addListener(_handleFocusChange);
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: controller.value.text.length,
    );
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
        controller.text = formatDecimalString((controller.text).toString());
        widget.onFieldSubmitted!(formatDecimal(controller.text)!);
      }
    } else {
      controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: controller.value.text.length,
      );
    }
  }

  @override
  void didUpdateWidget(DecimalFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null &&
        (widget.controller != oldWidget.controller)) {
      controller = widget.controller ?? TextEditingController();
    }

    if (widget.initialValue != oldWidget.initialValue) {
      controller = TextEditingController(
        text: formatDecimalString(widget.initialValue.toString()),
      );
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
      controller: controller,
      style: textStyle,
      enabled: widget.enabled,
      key: widget.key,
      focusNode: widget.focusNode,
      textAlign: TextAlign.end,
      decoration: InputDecoration(
        filled: isFilled,
        fillColor: fillColor,
        border: border,
        enabledBorder: enabledBorder,
        focusedBorder: focussedBorder,
        disabledBorder: disabledBorder,
        errorBorder: errorBorder,
        labelStyle: labelStyle,
        errorStyle: errorStyle,

        suffixIconColor: iconColor,
        suffixIcon: widget.suffixIcon != null ? Icon(widget.suffixIcon) : null,
        prefixIconColor: iconColor,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        labelText: widget.isRequired
            ? '${widget.labelText} *'
            : widget.labelText,
        alignLabelWithHint: true,
        hintStyle: hintStyle,
        hintText: widget.hintText,
      ),
      enableInteractiveSelection: true,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]')),
        MaxNumberLimiter(),
        _DotLimiter(),

        // FilteringTextInputFormatter.allow(
        //   RegExp("[\\d]"),
        // ),
      ],
      keyboardType: TextInputType.number,
      textInputAction: widget.inputAction,
      onChanged: (value) {
        if (widget.onChanged != null) {
          if (value.contains('.')) {
            if (value.split('.')[1].length > 2) {
              controller.text = formatDecimal(value).toString();
            }
          }
          widget.onChanged!(formatDecimal(value) ?? 0);
        }
      },
      onFieldSubmitted: (value) {
        if (null != widget.onFieldSubmitted && validateValue(value)) {
          controller.text = formatDecimalString(value);
          widget.onFieldSubmitted!(formatDecimal(formatDecimalString(value))!);
          if (widget.nextFocusNode != null) {
            FocusScope.of(context).requestFocus(widget.nextFocusNode);
          }
        }
      },
      validator: (value) {
        if (!validateValue(value)) {
          return 'Please enter a valid value for ${widget.labelText}';
        }
        return null;
      },
      onSaved: (value) {
        if (validateValue(value)) {
          widget.onSaveValue(double.parse(value!));
        }
      },
    );
  }

  bool validateValue(String? value) {
    if (value == null || value.isEmpty) return false;

    var regexPattern = '[\\d.]';

    RegExp expression = RegExp(regexPattern);
    return expression.hasMatch(value);
  }
}

double? formatDecimal(String text) {
  double? value = double.tryParse(text);
  return value?.truncateToDecimalPlaces(2);
}

String formatDecimalString(String text) {
  if (text.contains('.')) {
    int diff = 2 - text.split('.')[1].length;
    text = text.padRight(text.length + diff, '0');
  } else {
    text = '$text.00';
  }
  return text;
}

class _DotLimiter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.contains('.') &&
        oldValue.text != newValue.text &&
        newValue.text.split('.').length > 2) {
      return oldValue;
    }
    return newValue;
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
      return double.parse(newValue.text).round() > maxNumber
          ? oldValue
          : newValue;
    } on Exception catch (_) {
      return newValue;
    }
  }
}
