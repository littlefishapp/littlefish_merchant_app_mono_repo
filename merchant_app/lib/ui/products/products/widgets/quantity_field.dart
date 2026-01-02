import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/double_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/number_form_field.dart';
import 'package:littlefish_merchant/models/enums.dart';

class QuantityField extends StatelessWidget {
  final QuantityUnitType unitType;
  final double initialValue;
  final FocusNode focusNode;
  final Function(double) onChanged;
  final double textFieldWidth;

  const QuantityField({
    Key? key,
    required this.unitType,
    required this.initialValue,
    required this.onChanged,
    required this.focusNode,
    this.textFieldWidth = 96,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: unitType == QuantityUnitType.fractional
          ? DoubleFormField(
              enabled: true,
              hintText: 'Enter quantity',
              key: const Key('quantity'),
              labelText: '',
              inputAction: TextInputAction.done,
              initialValue: initialValue,
              onFieldSubmitted: (value) {
                if (value != null) {
                  onChanged(value);
                }
              },
              onSaveValue: (value) => onChanged(value),
            )
          : NumberFormField(
              enabled: true,
              hintText: 'Enter quantity',
              focusNode: focusNode,
              key: const Key('quantity'),
              labelText: '',
              inputAction: TextInputAction.done,
              initialValue: initialValue.toInt(),
              onFieldSubmitted: (value) {
                if (value != null) {
                  onChanged(value.toDouble());
                }
              },
              textFieldWidth: textFieldWidth,
              onSaveValue: (value) => onChanged(value.toDouble()),
            ),
    );
  }
}
