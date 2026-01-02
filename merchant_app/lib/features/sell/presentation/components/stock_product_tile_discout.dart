import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

class StockProductTileDiscount extends StatelessWidget {
  final double discountValue;

  const StockProductTileDiscount({super.key, this.discountValue = 0.0});

  @override
  Widget build(BuildContext context) {
    return context.paragraphXSmall(
      discountValue.toStringAsFixed(2),
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
      alignRight: true,
    );
  }
}
