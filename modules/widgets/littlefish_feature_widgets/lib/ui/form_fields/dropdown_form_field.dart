// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart' show IterableExtension;
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

// Project imports:
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';

import '../../../../app/theme/applied_system/applied_text_icon.dart';

class DropdownFormField extends StatefulWidget {
  final String hintText, labelText;
  final dynamic initialValue;
  final List<DropDownValue>? values;
  final bool autoValidate;
  final Function(dynamic) onSaveValue;
  final Function(dynamic)? onFieldSubmitted;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction inputAction;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final bool isRequired;
  final bool? enabled;
  final Function(dynamic)? onChanged;
  final bool useOutlineStyling;

  const DropdownFormField({
    required Key key,
    required this.onSaveValue,
    required this.hintText,
    required this.labelText,
    this.inputAction = TextInputAction.none,
    this.suffixIcon,
    this.prefixIcon,
    this.onFieldSubmitted,
    this.focusNode,
    this.nextFocusNode,
    this.autoValidate = false,
    this.initialValue,
    this.isRequired = false,
    this.enabled = true,
    this.onChanged,
    required this.values,
    this.useOutlineStyling = false,
  }) : super(key: key);

  @override
  State<DropdownFormField> createState() => _DropdownFormFieldState();
}

class _DropdownFormFieldState extends State<DropdownFormField> {
  dynamic selectedItem;

  List<DropdownMenuItem>? items;

  @override
  void initState() {
    super.initState();
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
    final hintColor = textIconColours.deEmphasized;
    final labelColor = textIconColours.secondary;
    final focusColor = Theme.of(context).extension<AppliedSurface>()?.primary;

    final hintStyle = context.styleParagraphSmallRegular!.copyWith(
      color: hintColor,
    );
    final labelStyle = context.styleParagraphSmallRegular!.copyWith(
      color: labelColor,
    );

    if (items == null || items?.length != widget.values?.length) {
      items = widget.values!.map((value) {
        return DropdownMenuItem(
          enabled: widget.enabled!,
          value: value,
          key: Key('${widget.labelText}:${value.index}'),
          child: Row(
            children: [
              if (widget.prefixIcon != null) Icon(widget.prefixIcon),
              if (widget.prefixIcon != null) const SizedBox(width: 16),
              LongText(
                value.displayValue,
                fontSize: null,
                textColor: Colors.black87,
              ),
            ],
          ),
        );
      }).toList();
    }

    if (widget.initialValue != null) {
      selectedItem = items!
          .firstWhereOrNull((x) => x.value.value == widget.initialValue)
          ?.value;

      if (selectedItem == null &&
          widget.initialValue is int &&
          widget.initialValue < items!.length &&
          widget.initialValue >= 0) {
        selectedItem = items![widget.initialValue].value;
      }
    }

    return Container(
      margin: const EdgeInsets.only(top: 2.0),
      child: DropdownButtonFormField(
        dropdownColor: Theme.of(context).extension<AppliedSurface>()?.primary,
        focusColor: focusColor,
        iconEnabledColor: iconColor,
        iconDisabledColor: iconColor.withOpacity(0.3),
        validator: (dynamic value) {
          if (widget.isRequired && (value == null || value?.value == null)) {
            return 'Please select a value for ${widget.labelText}';
          }

          return null;
        },
        key: Key(widget.labelText),
        isDense: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: fillColor,
          focusedBorder: widget.useOutlineStyling
              ? context.inputBorderFocus()
              : const UnderlineInputBorder(),
          enabledBorder: widget.useOutlineStyling
              ? context.inputBorderEnabled()
              : const UnderlineInputBorder(),
          border: widget.useOutlineStyling
              ? context.inputBorderEnabled()
              : const UnderlineInputBorder(),
          errorBorder: widget.useOutlineStyling
              ? context.inputBorderEnabled()
              : const UnderlineInputBorder(),
          enabled: widget.enabled!,
          isDense: true,
          labelStyle: labelStyle,
          labelText: widget.isRequired
              ? '${widget.labelText} *'
              : widget.labelText,
          suffixIconColor: iconColor,
          suffixIcon: widget.suffixIcon == null
              ? null
              : Icon(widget.suffixIcon),
          hintStyle: hintStyle,
          hintText: selectedItem == null ? widget.hintText : null,
        ),
        items: items,
        onSaved: (dynamic value) {
          setState(() {
            selectedItem = value;
          });

          widget.onSaveValue(value);
        },
        onChanged: (dynamic value) {
          setState(() {
            selectedItem = value;
          });

          widget.onFieldSubmitted!(value);

          if (widget.onChanged != null) widget.onChanged!(value);

          if (widget.nextFocusNode != null) {
            FocusScope.of(context).requestFocus(widget.nextFocusNode);
          }
        },
        value: selectedItem,
      ),
    );
  }
}

class DropDownValue {
  int index;

  String? displayValue;

  dynamic value;

  DropDownValue({
    required this.index,
    required this.displayValue,
    required this.value,
  });
}
