// removed ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

class StockProductTileCategory extends StatelessWidget {
  const StockProductTileCategory({
    super.key,
    required this.context,
    required this.category,
    required this.showCategories,
  });

  final BuildContext context;
  final String category;
  final bool showCategories;

  @override
  Widget build(BuildContext context) {
    if (showCategories) {
      return context.paragraphSmall(
        category.toUpperCase(),
        alignLeft: true,
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.4),
        isSemiBold: true,
      );
    }
    return const SizedBox.shrink();
  }
}
