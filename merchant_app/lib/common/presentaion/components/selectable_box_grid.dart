// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/chips/chip_selectable.dart';

// project imports
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';

class SelectableBoxGrid<T> extends StatefulWidget {
  final List<T> items;
  final Function(T? selectedItem) onTap;
  final int numColumns;
  final double childAspectRatio; // Width to height ratio of each grid item
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final T? initiallySelectedItem;
  final String suffix;
  final Color? borderColour;
  final Color? selectedBorderColour;
  final double gridPadding;
  final SelectableBoxItemFormat itemFormat;

  const SelectableBoxGrid({
    required this.onTap,
    required this.items,
    required this.numColumns,
    this.gridPadding = 16,
    this.crossAxisSpacing = 16,
    this.mainAxisSpacing = 16,
    this.childAspectRatio = 2,
    this.initiallySelectedItem,
    this.suffix = '',
    this.borderColour,
    this.selectedBorderColour,
    this.itemFormat = SelectableBoxItemFormat.withSuffix,
    Key? key,
  }) : super(key: key);

  @override
  State<SelectableBoxGrid<T>> createState() => _SelectableBoxGridState<T>();
}

class _SelectableBoxGridState<T> extends State<SelectableBoxGrid<T>> {
  T? selectedItem;

  @override
  void initState() {
    selectedItem = widget.initiallySelectedItem;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SelectableBoxGrid<T> oldWidget) {
    if (widget.initiallySelectedItem != oldWidget.initiallySelectedItem) {
      selectedItem = widget.initiallySelectedItem;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(vertical: widget.gridPadding),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: widget.crossAxisSpacing,
        mainAxisSpacing: widget.mainAxisSpacing,
        crossAxisCount: widget.numColumns,
        childAspectRatio: widget.childAspectRatio,
      ),
      itemBuilder: (context, index) {
        final item = widget.items[index];
        final isSelected = item == selectedItem;
        return GridTile(
          child: ChipSelectable(
            text: getText(
              widget.items[index],
              widget.itemFormat,
              widget.suffix,
            ),
            selected: isSelected,
            onTap: (_) {
              if (mounted) {
                setState(() {
                  if (isSelected) {
                    selectedItem = null; // deselect
                    widget.onTap(null);
                  } else {
                    selectedItem = item;
                    widget.onTap(item);
                  }
                });
              }
            },
          ),
        );
      },
      itemCount: widget.items.length,
    );
  }

  String getText(T item, SelectableBoxItemFormat format, String suffix) {
    if (format == SelectableBoxItemFormat.withSuffix) {
      return '$item ${widget.suffix}';
    }

    if (item is int || item is double) {
      switch (format) {
        case SelectableBoxItemFormat.numberOnly:
          return '$item';
        case SelectableBoxItemFormat.percentage:
          return '$item %';
        case SelectableBoxItemFormat.currency:
          return TextFormatter.toStringCurrency(
            (item! as num).toDouble(),
            currencyCode: '',
          );
        case SelectableBoxItemFormat.currencyNoDecimal:
          return TextFormatter.toStringCurrencyNoDecimal(
            (item as num).toDouble(),
          );
        case SelectableBoxItemFormat.percentageRemoveDecimalsIfZero:
          return '${TextFormatter.toStringRemoveZeroDecimals((item as num).toDouble())} %';
        default:
          return '$item';
      }
    }

    return '$item';
  }
}
