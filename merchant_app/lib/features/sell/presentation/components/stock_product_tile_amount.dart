// removed ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

class StockProductTileAmount extends StatelessWidget {
  const StockProductTileAmount({
    super.key,
    required this.context,
    required this.trailText,
    this.color,
  });

  final BuildContext context;
  final String trailText;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return context.labelXSmall(
      trailText,
      color: color ?? Theme.of(context).colorScheme.primary,
      isSemiBold: true,
    );
  }
}
