// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

// Project imports:
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/common/presentaion/components/ensure_visible_focused.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

import '../../../../app/theme/applied_system/applied_surface.dart';
import '../../../../app/theme/applied_system/applied_text_icon.dart';

class DateSelectFormField extends StatefulWidget {
  final String? hintText, labelText, initialValue;
  final bool autoValidate;
  final Function(DateTime value) onSaveValue;
  final Function(DateTime value)? onFieldSubmitted;
  final DateTime firstDate;
  final DateTime lastDate;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction inputAction;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final bool isRequired;
  final bool obsecureText;
  final int? maxLength;
  final int minLength;
  final bool enforceMaxLength;
  final TextEditingController? controller;
  final int maxLines;
  final DateTime? initialDate;
  final bool useOutlineStyling;
  //return a future to this method always
  final Function(String? value)? asyncValidator;
  final bool? isDense;
  final Color fillColor;
  final InputBorder? enableBorder, disableBorder, focusBorder;

  final bool enabled;

  const DateSelectFormField({
    required Key key,
    required this.onSaveValue,
    required this.hintText,
    required this.labelText,
    required this.firstDate,
    required this.lastDate,
    required this.initialDate,
    this.inputAction = TextInputAction.done,
    this.suffixIcon,
    this.prefixIcon,
    this.onFieldSubmitted,
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
    this.enabled = true,
    this.asyncValidator,
    this.maxLines = 1,
    this.useOutlineStyling = false,
    this.isDense,
    this.fillColor = Colors.white,
    this.enableBorder,
    this.focusBorder,
    this.disableBorder,
  }) : super(key: key);

  @override
  State<DateSelectFormField> createState() => _DateSelectFormFieldState();
}

class _DateSelectFormFieldState extends State<DateSelectFormField> {
  bool _isLoading = false;
  late TextEditingController controller;
  late String initialValue;
  DateTime? initialDate;
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
        widget.onFieldSubmitted!(DateTime.parse(controller.text));
      }
    }
  }

  @override
  void didUpdateWidget(DateSelectFormField oldWidget) {
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
    final fillColor = surfaceColors.primary;
    final iconColor = textIconColours.primary;
    final textColor = textIconColours.emphasized;
    final hintColor = textIconColours.deEmphasized;
    final labelColor = textIconColours.secondary;
    final errorColor = textIconColours.error;

    final textStyle = context.styleParagraphSmallRegular!.copyWith(
      color: textColor,
    );
    final hintStyle = context.styleParagraphSmallRegular!.copyWith(
      color: hintColor,
    );
    final labelStyle = context.styleParagraphSmallRegular!.copyWith(
      color: labelColor,
    );
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

    return EnsureVisibleWhenFocused(
      focusNode: _focusNode,
      child: TextFormField(
        enabled: widget.enabled,
        controller: controller,
        focusNode: _focusNode,
        style: textStyle,
        cursorColor: textColor,
        cursorErrorColor: errorColor,
        minLines: 1,
        maxLines: widget.maxLines,
        key: widget.key,
        decoration: InputDecoration(
          border: border,
          enabledBorder: enabledBorder,
          focusedBorder: focussedBorder,
          disabledBorder: disabledBorder,
          errorBorder: errorBorder,
          isDense: true,
          fillColor: fillColor,
          filled: isFilled,
          errorStyle: errorStyle,
          counter: const SizedBox(height: 0.0),
          suffixIconColor: iconColor,
          prefixIconColor: iconColor,
          suffixIcon: _isLoading
              ? const AppProgressIndicator()
              : (widget.suffixIcon != null ? Icon(widget.suffixIcon) : null),
          prefixIcon: _isLoading
              ? const AppProgressIndicator()
              : (widget.prefixIcon != null ? Icon(widget.prefixIcon) : null),
          labelStyle: labelStyle,
          labelText: widget.isRequired
              ? '${widget.labelText} *'
              : widget.labelText,
          alignLabelWithHint: true,
          hintStyle: hintStyle,
          hintText: widget.hintText,
        ),
        enableInteractiveSelection: true,
        keyboardType: TextInputType.text,
        textInputAction: widget.inputAction,
        onTap: () async {
          await showDatePicker(
            context: context,
            initialDate: !widget.initialDate!.isBefore(widget.lastDate)
                ? widget.lastDate
                : widget.initialDate!,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            builder: (context, child) {
              return child!;
            },
          ).then((result) {
            if (result != null) {
              widget.onFieldSubmitted!(result);
              if (mounted) {
                setState(() {
                  controller.text = TextFormatter.toShortDate(dateTime: result);
                });
              }
            }
          });
        },
        onFieldSubmitted: (value) {
          if (null != widget.onFieldSubmitted) {
            widget.onFieldSubmitted!(DateTime.parse(value));

            if (widget.nextFocusNode != null) {
              FocusScope.of(context).requestFocus(widget.nextFocusNode);
            }
          }

          if (mounted) setState(() {});
        },
        readOnly: true,
        validator: (value) {
          if (!validateValue(value)) {
            return 'Please enter a valid value for ${widget.labelText}';
          }

          if (widget.asyncValidator != null) {
            return asyncValidation(value) as String?;
          }

          return null;
        },
        onSaved: (value) {
          //we must validate the amount first as it should never save a bad amount.
          if (validateValue(value)) {
            widget.onSaveValue(DateTime.parse(value!));
          }
        },
      ),
    );
  }

  Future asyncValidation(String? value) async {
    setState(() {
      _isLoading = true;
    });

    try {
      var result = await widget.asyncValidator!(value);
      return result;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
    }
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
