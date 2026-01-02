// removed ignore: depend_on_referenced_packages

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/models/stock/stock_take_item.dart';

class StockProductTileSimpleQuantity extends StatelessWidget {
  const StockProductTileSimpleQuantity({
    super.key,
    required this.context,
    required this.stockTakeItem,
  });

  final BuildContext context;
  final StockTakeItem stockTakeItem;

  @override
  Widget build(BuildContext context) {
    final roundedValue = stockTakeItem.expectedItemCount ?? 0;
    final displayedExpectedValue = math.max(roundedValue, 0.0);
    return context.body02x14R(
      '$displayedExpectedValue products',
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.4),
    );
  }
}
