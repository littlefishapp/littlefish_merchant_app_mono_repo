// removed ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

class StockProductTileTitle extends StatelessWidget {
  const StockProductTileTitle({
    super.key,
    required this.context,
    required this.title,
    required this.bold,
  });

  final BuildContext context;
  final String title;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return bold
        ? context.paragraphMedium(
            title,
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
            alignLeft: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            isBold: true,
          )
        : context.paragraphMedium(
            title,
            color: Theme.of(context).colorScheme.secondary,
            alignLeft: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            isSemiBold: true,
          );
  }
}
