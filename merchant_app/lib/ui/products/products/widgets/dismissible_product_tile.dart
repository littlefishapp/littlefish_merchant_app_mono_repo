// removed ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/product_tile_listing.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/product_tile_stock_select.dart';

class DismissibleProductTile extends StatelessWidget {
  const DismissibleProductTile({
    super.key,
    required this.isProductOnline,
    required this.onRemove,
    required this.isProductListing,
    required this.onTap,
    required this.onLongPress,
    required this.category,
    required this.context,
    required this.item,
  });

  final bool isProductOnline;
  final Function(StockProduct item)? onRemove;
  final bool isProductListing;
  final Function(StockProduct item)? onTap;
  final Function(StockProduct item)? onLongPress;
  final StockCategory? category;
  final BuildContext context;
  final StockProduct item;

  @override
  Widget build(BuildContext context) => Slidable(
    endActionPane: ActionPane(
      extentRatio: .25,
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (ctx) async {
            var message = isProductOnline
                ? 'Are you sure you want to delete this item? \n '
                      'Please note, this product will also be unpublished '
                      'from your online store aswell.'
                : 'Are you sure you want to delete this item?';

            var result = await confirmDismissal(
              context,
              item,
              message: message,
            );

            if (result == true) {
              onRemove!(item);
            }
          },
          backgroundColor: Theme.of(context).colorScheme.error,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
      ],
    ),
    key: Key(item.id!),
    // TODO(lampian): reinstate ?
    // I think since we don't want users to easily delete Products from the
    // catalogue, we were using an IconSlideAction to make the deleting
    // process a bit longer as opposed to simply sliding the item away to
    // delete. We want the users to think a bit for deleting an item.
    // Yes there's a pop-up but the extra step of tapping on the
    // delete icon is good because there get to be reminded again of
    // what they are about to do.

    // secondaryActions: [
    //   IconSlideAction(
    //     color: Colors.red,
    //     icon: Icons.delete,
    //     onTap: () async {
    //       var result = await confirmDismissal(context, item);

    //       if (result == true) {
    //         this.onRemove(item);
    //       }
    //     },
    //   ),
    // ],
    child: isProductListing
        ? ProductTileListing(
            onTap: onTap,
            onLongPress: onLongPress,
            category: category,
            context: context,
            item: item,
          )
        : ProductTileStockSelect(
            onTap: onTap,
            onLongPress: onLongPress,
            context: context,
            item: item,
          ),
    // actionPane: SlidableDrawerActionPane(),
    // actionExtentRatio: 0.25,
  );
}
