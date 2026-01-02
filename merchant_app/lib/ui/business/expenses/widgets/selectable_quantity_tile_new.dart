import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_image_with_badge.dart';

import '../../../../common/presentaion/components/form_fields/number_form_field.dart';

class SelectableQuantityTile extends StatefulWidget {
  final bool enableHighlighting;
  final bool enableQuantityField;
  final Function(double quantity)? onTap;
  final Function(double quantity)? onFieldSubmitted;
  final double initialQuantity;
  final int? maxValue;
  final int minValue;
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final Widget? quantityLeading;
  final double tileHeight;
  final double leadingWidgetSize;
  final double fieldButtonSize;
  final double? cumulativeVariantQuantity;
  final bool enableAutoIncrementOnTap;

  const SelectableQuantityTile({
    Key? key,
    this.enableHighlighting = false,
    this.enableQuantityField = true,
    this.onTap,
    this.onFieldSubmitted,
    this.initialQuantity = 0,
    this.maxValue,
    this.minValue = 0,
    this.leading,
    this.leadingWidgetSize = 56,
    this.tileHeight = 82,
    this.fieldButtonSize = 40,
    this.title,
    this.trailing,
    this.quantityLeading,
    this.cumulativeVariantQuantity,
    this.enableAutoIncrementOnTap = true,
  }) : super(key: key);

  @override
  State<SelectableQuantityTile> createState() => _SelectableQuantityTileState();
}

class _SelectableQuantityTileState extends State<SelectableQuantityTile> {
  late double _quantity;
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
    _isSelected = _quantity > 0;
  }

  @override
  void didUpdateWidget(SelectableQuantityTile oldWidget) {
    if (widget.initialQuantity != oldWidget.initialQuantity) {
      _quantity = widget.initialQuantity;
    }

    _isSelected = _quantity > widget.minValue;

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return tileInfo(context, _quantity, _isSelected);
  }

  tileInfo(BuildContext context, double quantity, bool isSelected) {
    Widget? subtitleWidget;
    bool showBadge = isSelected;
    String badgeText = quantity.toInt().toString();

    if (widget.cumulativeVariantQuantity != null &&
        widget.cumulativeVariantQuantity! > 0) {
      showBadge = true;
      badgeText = widget.cumulativeVariantQuantity!.toInt().toString();

      final int totalQty = widget.cumulativeVariantQuantity!.toInt();
      final String itemText = totalQty == 1 ? 'item' : 'items';
      subtitleWidget = context.paragraphSmall(
        '$totalQty $itemText',
        alignLeft: true,
      );
    } else if (isSelected && widget.enableQuantityField) {
      subtitleWidget = _quantityField(context, quantity, isSelected);
    }
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      onTap: () {
        if (mounted) {
          setState(() {
            if (widget.enableAutoIncrementOnTap) {
              _quantity += 1;
            }
            if (widget.onTap != null) widget.onTap!(_quantity);
          });
        }
      },
      leading: Visibility(
        visible: widget.leading != null,
        child: ButtonImageWithBadge(
          leading: widget.leading!,
          isSelected: showBadge,
          textValue: badgeText,
        ),
      ),
      trailing: widget.trailing,
      title: widget.title,
      subtitle: subtitleWidget,
    );
  }

  Widget _quantityField(
    BuildContext context,
    double quantity,
    bool isSelected,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.quantityLeading != null) ...[
              widget.quantityLeading!,
              const SizedBox(width: 8),
            ],
            NumberFormField(
              minValue: widget.minValue,
              maxValue: widget.maxValue,
              buttonSize: widget.fieldButtonSize,
              textFieldWidth: widget.fieldButtonSize,
              useDecorator: false,
              enabled: true,
              hintText: 'How many do you have?',
              key: Key('${widget.key} quantity field'),
              labelText: '',
              onSaveValue: (value) {
                _quantity = value.toDouble();
              },
              inputAction: TextInputAction.done,
              initialValue: _quantity.toInt(),
              color: Colors.white,
              borderColor: Theme.of(
                context,
              ).colorScheme.secondary.withOpacity(0.1),
              onFieldSubmitted: (value) {
                if (value == null) {
                  if (mounted) {
                    setState(() {
                      _quantity = 0;
                      _isSelected = false;
                      if (widget.onFieldSubmitted != null) {
                        widget.onFieldSubmitted!(_quantity);
                      }
                    });
                  }
                  return;
                }

                if (mounted) {
                  setState(() {
                    double? difference = value.toDouble() - quantity;
                    _quantity = quantity + difference;

                    _isSelected = _quantity > 0;

                    if (widget.onFieldSubmitted != null) {
                      widget.onFieldSubmitted!(_quantity);
                    }
                  });
                }
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
          ],
        ),
      ],
    );
  }
}
