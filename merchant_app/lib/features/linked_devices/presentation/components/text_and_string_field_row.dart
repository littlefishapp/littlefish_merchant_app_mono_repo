import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';

class TextAndStringFieldRow extends StatelessWidget {
  const TextAndStringFieldRow({
    super.key,
    required this.leading,
    required this.initialValue,
    required this.onSave,
    this.hintText,
    this.labelText,
    this.onChanged,
    this.onFieldSubmitted,
  });

  final String leading;
  final String initialValue;
  final String? hintText, labelText;
  final Function(String? value) onSave;
  final Function(String value)? onChanged, onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: context.labelSmall(
              leading,
              alignLeft: true,
              color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
            ),
          ),
          Expanded(
            child: StringFormField(
              initialValue: initialValue,
              onSaveValue: onSave,
              hintText: hintText,
              labelText: labelText,
              onChanged: onChanged,
              useOutlineStyling: true,
              onFieldSubmitted: onFieldSubmitted,
            ),
          ),
        ],
      ),
    );
  }
}
