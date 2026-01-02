import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/dropdown_form_field.dart';

class TextAndDropdownFieldRow extends StatelessWidget {
  const TextAndDropdownFieldRow({
    super.key,
    required this.leading,
    required this.initialValue,
    required this.values,
    required this.onChanged,
    this.hintText,
    this.labelText,
  });

  final String leading;
  final dynamic initialValue;
  final String? hintText, labelText;
  final Function(dynamic value) onChanged;
  final List<DropDownValue> values;

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
            child: DropdownFormField(
              useOutlineStyling: true,
              hintText: hintText ?? '',
              labelText: labelText ?? '',
              key: Key('TextAndDropdownFieldRow-$key'),
              values: values,
              initialValue: initialValue,
              onSaveValue: onChanged,
              onFieldSubmitted: onChanged,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
