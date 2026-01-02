import 'package:flutter/material.dart';

import '../../../../common/presentaion/components/form_fields/number_form_field.dart';

class StockProductTileQuantityField extends StatefulWidget {
  final double quantity;
  final bool isSelected;
  final Widget? quantityLeading;
  final Key childKey;
  final int minValue;
  final int? maxValue;
  final double fieldButtonSize;
  final Function(int) onSaveValue;
  final Function(int?)? onFieldSubmitted;

  const StockProductTileQuantityField({
    super.key,
    required this.quantity,
    required this.isSelected,
    this.quantityLeading,
    required this.childKey,
    required this.minValue,
    this.maxValue,
    required this.fieldButtonSize,
    required this.onSaveValue,
    required this.onFieldSubmitted,
  });

  @override
  State<StockProductTileQuantityField> createState() =>
      _StockProductTileQuantityFieldState();
}

class _StockProductTileQuantityFieldState
    extends State<StockProductTileQuantityField> {
  @override
  Widget build(BuildContext context) {
    return widget.isSelected
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.quantityLeading != null) ...[
                widget.quantityLeading!,
                const SizedBox(width: 8),
              ],
              Container(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: NumberFormField(
                  minValue: widget.minValue,
                  maxValue: widget.maxValue,
                  buttonSize: widget.fieldButtonSize,
                  textFieldWidth: widget.fieldButtonSize,
                  useDecorator: false,
                  enabled: true,
                  hintText: 'How many do you have?',
                  key:
                      widget.key ??
                      GlobalKey(), // Key('${widget.childKey} quantity field'),
                  labelText: '',
                  onSaveValue: widget.onSaveValue,
                  inputAction: TextInputAction.done,
                  initialValue: widget.quantity.toInt(),
                  color: Colors.white,
                  borderColor: Theme.of(
                    context,
                  ).colorScheme.secondary.withOpacity(0.1),
                  onFieldSubmitted: widget.onFieldSubmitted,
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
