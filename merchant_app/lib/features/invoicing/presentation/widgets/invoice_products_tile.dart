import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:quiver/strings.dart';

class InvoiceProductsTile extends StatelessWidget {
  const InvoiceProductsTile({
    super.key,
    required this.onTap,
    required this.onLongPress,
    required this.context,
    required this.item,
    this.quantity,
  });

  final Function(StockProduct item)? onTap;
  final Function(StockProduct item)? onLongPress;
  final BuildContext context;
  final StockProduct item;
  final int? quantity;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      dense: false,
      isThreeLine: false,
      onTap: onTap == null ? null : () => onTap!(item),
      onLongPress: onLongPress == null ? null : () => onLongPress!(item),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          context.labelSmall(
            item.displayName ?? '',
            alignLeft: true,
            isBold: true,
            overflow: TextOverflow.ellipsis,
          ),
          if (quantity != null)
            context.labelSmall(
              '${quantity.toString()} items',
              alignLeft: true,
              isBold: false,
              overflow: TextOverflow.ellipsis,
            ),
        ],
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
