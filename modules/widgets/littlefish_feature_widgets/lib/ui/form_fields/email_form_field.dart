import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/form_field_config/form_field_config.dart';

import '../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../injector.dart';

class EmailFormField extends StatefulWidget {
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
  final int maxLines;
  final Color? textColor;
  final Color? iconColor;
  final Color? hintColor;
  final Color? borderUnderLineColour;
  final bool useOutlineStyling;
  final Color? backgroundColor;
  final OutlineInputBorder? outLineInputBorderStyle;
  final OutlineInputBorder? focusOutLineInputBorderStyle;
  //return a future to this method always
  final Function(String value)? asyncValidator;

  /// widgetOnBrandedSurface = true shows onPrimary coloured button on Primary canvas
  /// widgetOnBrandedSurface = fasle shows primary coloured button on non primary canvas
  final bool widgetOnBrandedSurface;

  final bool enabled;

  const EmailFormField({
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
    this.useOutlineStyling = true,
    this.textColor = Colors.white,
    this.iconColor,
    this.hintColor,
    this.backgroundColor,
    this.borderUnderLineColour,
    this.outLineInputBorderStyle,
    this.focusOutLineInputBorderStyle,
    this.widgetOnBrandedSurface = false,
  }) : super(key: key);

  @override
  State<EmailFormField> createState() => _EmailFormFieldState();
}

class _EmailFormFieldState extends State<EmailFormField> {
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
  void didUpdateWidget(EmailFormField oldWidget) {
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
    final isFilled = !widget.useOutlineStyling;
    var fillColor = surfaceColors.primary;
    var iconColor = textIconColours.primary;
    var textColor = textIconColours.emphasized;
    var hintColor = textIconColours.deEmphasized;
    var labelColor = textIconColours.secondary;
    final errorColor = textIconColours.error;

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
      maxLines: widget.maxLines,
      key: widget.key,
      autocorrect: false,
      enableSuggestions: false,
      enabled: _isLoading ? false : widget.enabled,
      controller: controller,
      focusNode: widget.focusNode,
      maxLengthEnforcement: widget.enforceMaxLength
          ? MaxLengthEnforcement.enforced
          : MaxLengthEnforcement.none,
      maxLength: widget.maxLength,
      textCapitalization: TextCapitalization.none,
      style: textStyle,
      cursorColor: textColor,
      cursorErrorColor: errorColor,
      decoration: InputDecoration(
        border: border,
        enabledBorder: enabledBorder,
        focusedBorder: focussedBorder,
        disabledBorder: disabledBorder,
        errorBorder: errorBorder,
        isDense: true,
        fillColor: fillColor,
        filled: isFilled,
        errorMaxLines: 3,
        errorStyle: errorStyle,
        counter: const SizedBox(height: 0.0),
        prefixIconColor: iconColor,
        prefixIcon: (widget.prefixIcon != null
            ? Icon(widget.prefixIcon)
            : null),
        suffixIconColor: iconColor,
        suffixIcon: (widget.suffixIcon != null
            ? Icon(widget.suffixIcon)
            : null),
        labelText: widget.isRequired
            ? '${widget.labelText} *'
            : widget.labelText,
        labelStyle: labelStyle,
        hintText: widget.hintText,
        alignLabelWithHint: true,
        hintStyle: hintStyle,
      ),
      inputFormatters: const [
        // EmailInputFormatter(),
        // FilteringTextInputFormatter.deny(
        //   RegExp("\\s"),
        // ),
        // FilteringTextInputFormatter.deny(
        //   RegExp("[#!^<>{}\"/|;:,~!?\$%^&*\\]\\\\()\\[¿§«»ω⊙¤°℃℉€¥£¢¡®©]"),
        // ),
        // FilteringTextInputFormatter.allow(
        //   RegExp("[#!^<>{}\"/|;:,~!?\$%^&*\\]\\\\()\\[¿§«»ω⊙¤°℃℉€¥£¢¡®©]"),
        // ),
      ],
      enableInteractiveSelection: true,
      keyboardType: TextInputType.emailAddress,
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
      onChanged: widget.onChanged,
      validator: (value) {
        if (!widget.isRequired) {
          if (value == null || value.isEmpty) return null;

          if (!validateValue(value)) {
            return '${widget.labelText} is optional and can be left blank,\notherwise please provide a valid ${widget.labelText}.';
          }
        }

        if (!validateValue(value)) {
          return 'Please enter a valid email address';
        }

        return null;
      },
      onSaved: (value) {
        String? trimmedValue = value?.trim();
        //we must validate the amount first as it should never save a bad amount.
        if (validateValue(value)) {
          widget.onSaveValue(trimmedValue);
        }
      },
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

    //email regex validation

    value = value.trim();

    // var regexp = RegExp(
    //     "^[_a-z0-9-]+(.[a-z0-9-]+)@[a-z0-9-]+(.[a-z0-9-]+)*(.[a-z]{2,4})\$");
    var regexp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
    );

    var isValid = regexp.hasMatch(value);

    return isValid;
  }
}

class EmailInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}
