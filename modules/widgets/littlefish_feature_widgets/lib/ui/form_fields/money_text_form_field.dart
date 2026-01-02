import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/form_field_config/form_field_config.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_models/appearance_settings.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_models/money_display_format.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_models/money_format_settings.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_models/money_textformfield_settings.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_helpers/money_formatter.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_helpers/money_formatter_output.dart';
import 'package:littlefish_merchant/common/presentaion/components/custom_keypad.dart';

import '../../../../app/theme/applied_system/applied_surface.dart';
import '../../../../app/theme/applied_system/applied_text_icon.dart';

/// Instance of [MoneyTextFormField] widget
class MoneyTextFormField extends StatefulWidget {
  /// Instance constructor
  MoneyTextFormField({
    Key? key,
    required this.settings,
    this.useOutlineStyling = true,
    this.enabled = true,
  }) : super(key: key) {
    settings
      ..moneyFormatSettings =
          settings.moneyFormatSettings ?? MoneyFormatSettings()
      ..moneyFormatSettings!.amount =
          settings.moneyFormatSettings!.amount ??
          _Utility.zeroWithFractionDigits(
            fractionDigits: settings.moneyFormatSettings!.fractionDigits,
          )
      ..appearanceSettings =
          settings.appearanceSettings ?? AppearanceSettings();
  }

  /// Configurations data for [MoneyTextFormField] parameter
  final MoneyTextFormFieldSettings settings;
  final bool useOutlineStyling;
  final bool enabled;

  @override
  State<MoneyTextFormField> createState() => _MoneyTextFormFieldState();
}

class _MoneyTextFormFieldState extends State<MoneyTextFormField> {
  MoneyFormatter _fmf = MoneyFormatter(amount: 0.0);
  late String _formattedAmount;
  bool _useInternalController = false;

  @override
  initState() {
    super.initState();

    MoneyTextFormFieldSettings ws = widget.settings;
    MoneyFormatSettings wsm = ws.moneyFormatSettings!;

    // fmf handler
    _fmf = _fmf.copyWith(
      amount: wsm.amount,
      symbol: wsm.currencySymbol,
      fractionDigits: wsm.fractionDigits,
      thousandSeparator: wsm.thousandSeparator,
      decimalSeparator: wsm.decimalSeparator,
      symbolAndNumberSeparator: wsm.symbolAndNumberSeparator,
    );

    _formattedAmount = _Utility.getFormattedAmount(wsm.displayFormat, _fmf);

    // controller handler
    if (ws.controller == null) {
      ws.controller = TextEditingController();
      _useInternalController = true;
    }

    var initialValue = '${_fmf.amount}';

    ws.controller!.text = initialValue;
    ws.controller!.addListener(_onChanged);
    ws.controller!.text = _fmf.amount > 0
        ? formatDecimalString(_fmf.amount.toString())
        : '0.00';

    // inputFormatter handler
    ws.inputFormatters ??= <TextInputFormatter>[];

    ws.inputFormatters!.insertAll(0, <TextInputFormatter>[
      FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]')),
      _DotLimiter(),
      MaxNumberLimiter(),
    ]);
  }

  @override
  dispose() {
    super.dispose();

    if (_useInternalController) widget.settings.controller!.dispose();
  }

  _onChanged() {
    MoneyTextFormFieldSettings ws = widget.settings;

    _fmf = _fmf.copyWith(
      amount: _Utility.stringToDouble(
        ws.controller!.text,
        fractionDigits: ws.moneyFormatSettings!.fractionDigits,
      ),
    );

    _formattedAmount = _Utility.getFormattedAmount(
      ws.moneyFormatSettings!.displayFormat,
      _fmf,
    );

    if (widget.settings.onChanged != null) {
      widget.settings.onChanged!(_fmf.amount);
    }

    setState(() {});
  }

  @override
  void didUpdateWidget(MoneyTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    MoneyTextFormFieldSettings ws = widget.settings;
    MoneyTextFormFieldSettings ows = oldWidget.settings;

    if (ws.controller != null && (ws.controller != ows.controller)) {
      ws.controller = ws.controller;
      ws.controller!.text = _fmf.amount > 0
          ? formatDecimalString(_fmf.amount.toString())
          : '0.00';
    }

    if (ws.moneyFormatSettings!.amount != ows.moneyFormatSettings!.amount) {
      final amount = ws.moneyFormatSettings!.amount ?? 0.0;
      ws.controller?.text = amount > 0
          ? formatDecimalString(amount.toString())
          : '0.00';
    }
  }

  @override
  Widget build(BuildContext context) {
    MoneyTextFormFieldSettings ws = widget.settings;
    AppearanceSettings appearanceSetting = ws.appearanceSettings!;

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

    return Padding(
      padding: appearanceSetting.padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: TextFormField(
              enabled: widget.enabled,
              controller: ws.controller,
              focusNode: ws.appearanceSettings!.focusNode,
              style: textStyle,
              cursorColor: textColor,
              cursorErrorColor: errorColor,
              key: ws.appearanceSettings!.key,
              readOnly: (ws.enableCustomKeypad ?? false) ? true : false,
              decoration: InputDecoration(
                border: border,
                enabledBorder: enabledBorder,
                focusedBorder: focussedBorder,
                disabledBorder: disabledBorder,
                errorBorder: errorBorder,
                isDense: true,
                fillColor: fillColor,
                filled: isFilled,
                prefixIconColor: iconColor,
                suffixIconColor: iconColor,
                prefixIcon: ws.prefixIcon != null ? Icon(ws.prefixIcon) : null,
                icon: appearanceSetting.icon,
                suffixIcon: ws.suffixIcon != null ? Icon(ws.suffixIcon) : null,
                labelStyle: labelStyle,
                labelText: widget.settings.isRequired
                    ? '${appearanceSetting.labelText} *'
                    : appearanceSetting.labelText,
                hintStyle: hintStyle,
                hintText: appearanceSetting.hintText,
                errorStyle: errorStyle,
              ),
              textInputAction:
                  ws.appearanceSettings!.textInputAction ??
                  TextInputAction.done,
              onTap: () {
                ws.enableCustomKeypad!
                    ? customAmount(ws)
                    : ws.controller!.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: ws.controller!.text.length,
                      );
              },
              onChanged: (value) {
                if (ws.onChanged != null) {
                  ws.onChanged!(double.parse(value));
                }
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]')),
                _DotLimiter(),
                MaxNumberLimiter(),
              ],
              validator: (value) {
                if (!validateValue(value)) {
                  if ((double.tryParse(value ?? '0') ?? 0) <= 0) {
                    return 'Please enter a value greater than zero';
                  }
                  return 'Please enter a valid value for ${appearanceSetting.labelText}';
                }

                if (ws.validator != null) return ws.validator!(value);

                return null;
              },
              onSaved: ws.onSaveValue == null
                  ? null
                  : (value) {
                      if (validateValue(value)) {
                        ws.onSaveValue!(double.parse(value!));
                      }
                    },
              onFieldSubmitted: ws.onFieldSubmitted == null
                  ? null
                  : (value) {
                      if (validateValue(value)) {
                        ws.controller!.text = double.parse(value) > 0
                            ? formatDecimalString(value)
                            : '0.00';
                        ws.onFieldSubmitted!(double.parse(value));
                      }
                    },
              textAlign: TextAlign.right,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
            ),
          ),
          if (widget.settings.enabledShowExtra == true)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _formattedAmount,
                  textAlign: TextAlign.right,
                  style: appearanceSetting.formattedStyle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool validateValue(String? value) {
    if ((value == null || value.isEmpty) && widget.settings.isRequired) {
      return false;
    }

    //here we need to define the pattern
    var regexPattern = '[\\d.]';

    RegExp expression = RegExp(regexPattern);
    var isValid = expression.hasMatch(value!);

    if (isValid && widget.settings.isRequired) return double.parse(value) > 0;
    return isValid;
  }

  Future<Future<double?>> customAmount(MoneyTextFormFieldSettings ws) async =>
      showModalBottomSheet<double>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (ctx) => SafeArea(
          child: SizedBox(
            height: 480,
            child: CustomKeyPad(
              onSubmit: (value, description) {
                ws.onSaveValue!(value);
                Navigator.of(context).pop();
                _fmf.amount = value;
                ws.controller!.text = value > 0
                    ? formatDecimalString(value.toString())
                    : '0.00';
              },
              heading: ws.customKeypadHeading ?? 'Amount',
              initialValue: _fmf.amount,
              onValueChanged: (_) {},
              onDescriptionChanged: (_) {},
              confirmButtonText: 'Change Amount',
              enableAppBar: false,
            ),
          ),
        ),
      );
}

class MaxNumberLimiter extends TextInputFormatter {
  int maxNumber = 100000000;
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

String formatDecimalString(String text) {
  if (text.contains('.')) {
    int diff = 2 - text.split('.')[1].length;
    text = text.padRight(text.length + diff, '0');
  } else {
    text = '$text.00';
  }
  return text;
}

/// An utility instance
class _Utility {
  /// return Zero with spesific fraction digits length
  static double zeroWithFractionDigits({int fractionDigits = 2}) {
    return double.parse(0.toStringAsFixed(fractionDigits));
  }

  /// Convert string to double with spesific fraction digits length
  static double stringToDouble(String value, {int fractionDigits = 2}) {
    if (value.isEmpty) {
      return zeroWithFractionDigits(fractionDigits: fractionDigits);
    }

    double result;

    try {
      result = double.parse(value);
    } catch (e) {
      result = zeroWithFractionDigits(fractionDigits: fractionDigits);
    }

    return result;
  }

  /// Return formatted type based on [displayFormat]
  static String getFormattedAmount(
    MoneyDisplayFormat displayFormat,
    MoneyFormatter fmf,
  ) {
    MoneyFormatterOutput? fo = fmf.output;
    switch (displayFormat) {
      case MoneyDisplayFormat.compactSymbolOnLeft:
        return fo!.compactSymbolOnLeft;
      case MoneyDisplayFormat.compactSymbolOnRight:
        return fo!.compactSymbolOnRight;
      case MoneyDisplayFormat.compactNonSymbol:
        return fo!.compactNonSymbol;
      case MoneyDisplayFormat.symbolOnLeft:
        return fo!.symbolOnLeft;
      case MoneyDisplayFormat.symbolOnRight:
        return fo!.symbolOnRight;
      default:
        return fo!.nonSymbol;
    }
  }
}
