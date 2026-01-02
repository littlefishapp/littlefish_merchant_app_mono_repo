import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/form_field_config/form_field_config.dart';
import 'package:littlefish_merchant/models/settings/locale/country_stub.dart';
import 'package:littlefish_merchant/providers/locale_provider.dart';
import 'package:quiver/strings.dart';

import '../../../../app/theme/applied_system/applied_surface.dart';
import '../../../../app/theme/applied_system/applied_text_icon.dart';

class MobileNumberFormField extends StatefulWidget {
  final String? hintText, labelText, initialValue;
  final bool autoValidate;
  final Function(dynamic) onSaveValue;
  final Function(String?)? onFieldSubmitted;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction inputAction;
  final IconData suffixIcon;
  final bool enabled;
  final CountryStub? country;
  final TextEditingController? controller;
  final bool usePlus;
  final bool useOutlineStyling;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final OutlineInputBorder? outLineInputBorderStyle;
  final OutlineInputBorder? focusOutLineInputBorderStyle;
  final bool showSuffixIcon;

  final bool isRequired;

  const MobileNumberFormField({
    required Key key,
    required this.onSaveValue,
    required this.hintText,
    required this.labelText,
    this.country,
    this.inputAction = TextInputAction.none,
    this.onFieldSubmitted,
    this.onChanged,
    this.focusNode,
    this.nextFocusNode,
    this.autoValidate = false,
    this.initialValue,
    this.isRequired = true,
    this.enabled = true,
    this.controller,
    this.suffixIcon = Icons.phone_android,
    this.showSuffixIcon = true,
    this.usePlus = true,
    this.useOutlineStyling = false,
    this.hintStyle,
    this.textStyle,
    this.labelStyle,
    this.outLineInputBorderStyle,
    this.focusOutLineInputBorderStyle,
  }) : super(key: key);

  @override
  State<MobileNumberFormField> createState() => _MobileNumberFormFieldState();
}

class _MobileNumberFormFieldState extends State<MobileNumberFormField> {
  late TextEditingController controller;
  late String initialValue;
  late CountryStub country;
  FocusNode? _focusNode;

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController();
    country = widget.country ?? CountryStub();
    initialValue = widget.country != null
        ? formatInitialValue(widget.initialValue ?? '')
        : widget.initialValue ?? '';
    controller.text = initialValue;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode?.addListener(_handleFocusChange);
    super.initState();
  }

  void _handleFocusChange() {
    if (!_focusNode!.hasFocus) {
      if (null != widget.onFieldSubmitted) {
        widget.onFieldSubmitted!(formatValue(controller.text));
      }
    }
  }

  @override
  void didUpdateWidget(MobileNumberFormField oldWidget) {
    if (widget.controller != null &&
        (widget.controller != oldWidget.controller)) {
      controller = widget.controller ?? TextEditingController();
    }

    if (widget.country != country) {
      country = widget.country ?? CountryStub();
    }

    // if (this.controller == null)
    //   this.controller = TextEditingController(
    //       text: widget.initialValue == null
    //           ? null
    //           : formatInitialValue(initialValue ?? ""));

    if (widget.initialValue != oldWidget.initialValue) {
      controller = TextEditingController(
        text: formatInitialValue(widget.initialValue ?? ''),
      );
    }

    // if (oldWidget.controller == null) {
    //   return;
    // }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    _focusNode!.removeListener(_handleFocusChange);
    _focusNode!.dispose();
    super.dispose();
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

    return TextFormField(
      controller: controller,
      cursorColor: textColor,
      cursorErrorColor: errorColor,
      style: textStyle,
      key: widget.key,
      focusNode: widget.focusNode,
      textCapitalization: TextCapitalization.none,
      maxLength: 11,
      enabled: widget.enabled,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        NumberTextInputFormatter(),
      ],
      decoration: InputDecoration(
        border: border,
        enabledBorder: enabledBorder,
        focusedBorder: focussedBorder,
        disabledBorder: disabledBorder,
        errorBorder: errorBorder,
        isDense: true,
        filled: isFilled,
        fillColor: fillColor,
        counter: const SizedBox(height: 0.0),
        suffixIconColor: iconColor,
        prefixIconColor: iconColor,
        prefixText:
            widget.country == null || widget.country!.diallingCode!.isEmpty
            ? null
            : widget.usePlus
            ? '+${widget.country!.diallingCode}\t'
            : '${widget.country!.diallingCode}\t',
        labelText: widget.isRequired
            ? '${widget.labelText} *'
            : widget.labelText,
        labelStyle: labelStyle,
        alignLabelWithHint: true,
        hintText: widget.hintText,
        hintStyle: hintStyle,
      ),
      enableInteractiveSelection: true,
      keyboardType: TextInputType.phone,
      textInputAction: widget.inputAction,
      onFieldSubmitted: (value) {
        if (null != widget.onFieldSubmitted) {
          widget.onFieldSubmitted!(formatValue(value));

          if (widget.nextFocusNode != null) {
            FocusScope.of(context).requestFocus(widget.nextFocusNode);
          }
        }
      },
      onChanged: (value) {
        if (null != widget.onChanged) {
          widget.onChanged!(formatValue(value));
        }
      },
      validator: (value) {
        if (!widget.isRequired) {
          if (isBlank(value)) return null;

          if (!validateValue(formatValue(value))) {
            return '${widget.labelText} is optional and can be left blank,\notherwise please provide a valid ${widget.labelText}.';
          }
        }

        if (!validateValue(formatValue(value))) {
          return 'Please enter a valid value for ${widget.labelText}';
        }

        return null;
      },
      onSaved: (value) {
        var formattedValue = formatValue(value);
        if (validateValue(formattedValue)) {
          widget.onSaveValue(formattedValue);
        }
      },
    );
  }

  String formatValue(String? value) {
    debugPrint('### mobile number form field format value $value');

    if (value == null || value.trim().isEmpty) {
      return '';
    }

    String adjustedValue = value.trim();

    if (adjustedValue.length > 1 && adjustedValue.startsWith('0')) {
      adjustedValue = adjustedValue.substring(1);
    }

    var mobileNumber = '';

    var country = widget.country ?? LocaleProvider.instance.currentLocale;

    if (country != null) {
      mobileNumber = '+${country.diallingCode}$adjustedValue'.trim();
    } else {
      mobileNumber = '';
    }

    mobileNumber = mobileNumber.replaceAll(RegExp(r'\s\b|\b\s\t'), '');
    return mobileNumber;
  }

  String formatInitialValue(String value) {
    if (value.isEmpty) return value;

    if (value.startsWith('+${country.diallingCode}')) {
      return value.substring('+${country.diallingCode}'.length);
    } else if (value.startsWith('0')) {
      return value.substring(1);
    } else {
      return value;
    }
  }

  bool validateValue(String? value) {
    if (value == null || value.isEmpty) {
      if (!widget.isRequired) return true;
      return false;
    }

    var requiredLength = widget.country == null
        ? 9
        : (9 + country.diallingCode!.length);

    if (value.length < requiredLength) return false;

    return true;
  }
}

class NumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    if (newTextLength >= 1) {
      newText.write('\t');
      if (newValue.selection.end >= 1) selectionIndex++;
    }
    if (newTextLength >= 3) {
      newText.write('${newValue.text.substring(0, usedSubstringIndex = 2)} ');
      if (newValue.selection.end >= 2) selectionIndex += 1;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex) {
      newText.write(newValue.text.substring(usedSubstringIndex));
    }
    //Removes Zero in front of string if there is one
    if (newValue.text.length > 1 && newValue.text.startsWith('0')) {
      newText.clear();
      newText.write(newValue.text.substring(1));
      selectionIndex = newValue.text.substring(1).length;
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
