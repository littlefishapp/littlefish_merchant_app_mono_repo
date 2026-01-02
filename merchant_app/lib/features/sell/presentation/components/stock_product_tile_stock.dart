// removed ignore: depend_on_referenced_packages

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/models/stock/stock_take_item.dart';

class StockProductTileStock extends StatelessWidget {
  const StockProductTileStock({
    super.key,
    required this.context,
    required this.stockTakeItem,
    this.getStockTakeItemDescription,
  });

  final BuildContext context;
  final StockTakeItem stockTakeItem;
  final String Function(StockTakeItem stockTakeItem)?
  getStockTakeItemDescription;

  @override
  Widget build(BuildContext context) {
    final roundedValue = stockTakeItem.expectedItemCount ?? 0;
    final displayedExpectedValue = math.max(roundedValue, 0.0);
    final description = getStockTakeItemDescription != null
        ? getStockTakeItemDescription!(stockTakeItem)
        : '';
    return Row(
      children: [
        context.body02x14R('$displayedExpectedValue products'),
        const SizedBox(width: 4),
        const Icon(
          Icons.keyboard_double_arrow_right,
          size: 14,
          // TODO(lampian): follow up if this is required
          //color: vm.getStockMovementColor(item, context),
        ),
        const SizedBox(width: 4),
        context.body02x14R(description, alignLeft: true),
      ],
    );
  }
}
