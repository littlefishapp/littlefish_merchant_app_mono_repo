// removed ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

import '../../../../common/presentaion/components/icons/warning_icon.dart';

class StockProductTilePriceQuantity extends StatelessWidget {
  const StockProductTilePriceQuantity({
    super.key,
    required this.quantityInStock,
    required this.context,
    required this.price,
    required this.quantity,
    required this.stockIsLow,
  });

  final double quantityInStock;
  final BuildContext context;
  final String price;
  final String quantity;
  final bool stockIsLow;

  @override
  Widget build(BuildContext context) {
    final itemDescription = quantityInStock > 1
        ? ' products'
        : quantityInStock > 0
        ? ' product'
        : ' products';
    return Row(
      children: [
        context.body02x14R(
          price,
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
          alignLeft: true,
        ),
        const SizedBox(width: 4),
        Icon(
          Icons.circle,
          size: 3,
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
        ),
        const SizedBox(width: 4),
        if (stockIsLow) ...[
          const WarningIcon(),
          const SizedBox(width: 4),
          context.body02x14R(
            quantity + itemDescription,
            color: Theme.of(context).colorScheme.error,
            alignLeft: true,
          ),
        ] else
          context.body02x14R(
            quantity + itemDescription,
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
            alignLeft: true,
          ),
      ],
    );
  }
}
