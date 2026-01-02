import 'dart:async';

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/form_field_config/form_field_config.dart';
import 'package:quiver/strings.dart';

import '../../../../app/theme/applied_system/applied_surface.dart';
import '../../../../app/theme/applied_system/applied_text_icon.dart';

class SearchTextField extends StatefulWidget {
  final void Function(String input) onChanged;
  final void Function(String input)? onFieldSubmitted;
  final void Function() onClear;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final String hintText;
  final String? initialValue;
  final String? labelText;
  final bool enableTimer;
  final bool useOutlineStyling;
  final bool enabled;

  const SearchTextField({
    Key? key,
    required this.onChanged,
    this.onFieldSubmitted,
    required this.onClear,
    this.hintText = 'Search',
    this.controller,
    this.focusNode,
    this.nextFocusNode,
    this.keyboardType,
    this.enableTimer = false,
    this.initialValue,
    this.useOutlineStyling = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.labelText,
  }) : super(key: key);

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  Timer? _timer;
  late TextEditingController controller;

  FocusNode? _focusNode;
  @override
  void initState() {
    controller = widget.controller ?? TextEditingController();
    controller.text = widget.initialValue ?? '';
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

    final textStyle = context.styleParagraphMediumRegular!.copyWith(
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
        ? context.inputNoBorderSides()
        : context.inputNoBorderSides();

    final border = widget.useOutlineStyling
        ? context.inputBorderEnabled()
        : context.inputNoBorderSides();

    final focussedBorder = widget.useOutlineStyling
        ? context.inputBorderFocus()
        : context.inputNoBorderSides();

    final disabledBorder = widget.useOutlineStyling
        ? context.inputBorderDisabled()
        : context.inputNoBorderSides();

    final errorBorder = widget.useOutlineStyling
        ? context.inputBorderError()
        : context.inputBorderUnderlineError;

    return TextFormField(
      enabled: widget.enabled,
      controller: controller,
      focusNode: _focusNode,
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
        errorMaxLines: 1,
        errorStyle: errorStyle,
        prefixIconColor: iconColor,
        prefixIcon: widget.suffixIcon != null
            ? Icon(widget.prefixIcon)
            : const Icon(Icons.search),
        suffixIconColor: iconColor,
        suffixIcon: widget.suffixIcon == null
            ? Visibility(
                visible: isNotBlank(controller.text),
                child: InkWell(
                  onTap: () {
                    controller.clear();
                    widget.onClear();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.cancel_outlined),
                  ),
                ),
              )
            : null,
        labelText: widget.labelText,
        labelStyle: labelStyle,
        alignLabelWithHint: true,
        hintText: widget.hintText,
        hintStyle: hintStyle,
      ),
      onChanged: (text) {
        if (widget.enableTimer == false) {
          widget.onChanged(text);
          return;
        }

        if (_timer?.isActive ?? false) {
          _timer?.cancel();
        }
        _timer = Timer(
          const Duration(seconds: 1),
          () => widget.onChanged(text),
        );
      },
      onFieldSubmitted: (value) {
        if (null != widget.onFieldSubmitted) {
          widget.onFieldSubmitted!(value);

          if (widget.nextFocusNode != null) {
            FocusScope.of(context).requestFocus(widget.nextFocusNode);
          }
        }
      },
      keyboardType: widget.keyboardType,
    );
  }
}
