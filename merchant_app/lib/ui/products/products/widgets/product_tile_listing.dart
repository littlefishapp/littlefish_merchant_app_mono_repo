// removed ignore: depend_on_referenced_packages

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:quiver/strings.dart';

class ProductTileListing extends StatelessWidget {
  const ProductTileListing({
    super.key,
    required this.onTap,
    required this.onLongPress,
    required this.category,
    required this.context,
    required this.item,
  });

  final Function(StockProduct item)? onTap;
  final Function(StockProduct item)? onLongPress;
  final StockCategory? category;
  final BuildContext context;
  final StockProduct item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: false,
      isThreeLine: true,
      onTap: onTap == null
          ? null
          : () {
              if (onTap != null) onTap!(item);
            },
      leading: isNotBlank(item.imageUri)
          ? ListLeadingImageTile(url: item.imageUri)
          : Container(
              width: AppVariables.appDefaultlistItemSize,
              height: AppVariables.appDefaultlistItemSize,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).extension<AppliedSurface>()?.brandSubTitle,
                border: Border.all(color: Colors.transparent, width: 1),
                borderRadius: BorderRadius.circular(
                  AppVariables.appDefaultRadius,
                ),
              ),
              child: Center(
                child: context.labelLarge(
                  (item.displayName ?? '??').substring(0, 2).toUpperCase(),
                  isSemiBold: true,
                ),
              ),
            ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            child: context.labelXSmall(
              category?.displayName ?? 'No Category',
              alignLeft: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          context.labelSmall(
            item.displayName ?? '',
            alignLeft: true,
            isBold: true,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      subtitle: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: context.labelXSmall(
          '${math.max(item.quantity.round(), 0)} items in stock',
          alignLeft: true,
        ),
      ),
      trailing: context.labelXSmall(
        TextFormatter.toStringCurrency(
          item.regularSellingPrice ?? 0,
          currencyCode: '',
        ),
        alignRight: true,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
