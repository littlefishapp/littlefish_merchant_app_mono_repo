// removed ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/dismissible_product_tile.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/product_tile_listing.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/product_tile_stock_select.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/products_list.dart';

class ProductListTile extends StatefulWidget {
  final bool selected;
  final bool isProductListing;
  final ProductViewMode viewMode;
  final StockProduct? item;
  final bool dismissAllowed;
  final Function(StockProduct item)? onTap;
  final Function(StockProduct item)? onLongPress;
  final Function(StockProduct item)? onRemove;
  final StockCategory? category;
  final bool isProductOnline;

  const ProductListTile({
    Key? key,
    required this.item,
    this.onTap,
    this.dismissAllowed = false,
    this.onRemove,
    this.category,
    this.selected = false,
    this.onLongPress,
    this.isProductOnline = false,
    this.isProductListing = true,
    this.viewMode = ProductViewMode.productsView,
  }) : super(key: key);

  @override
  State<ProductListTile> createState() => _ProductListTileState();
}

class _ProductListTileState extends State<ProductListTile> {
  @override
  Widget build(BuildContext context) {
    return widget.dismissAllowed
        ? DismissibleProductTile(
            isProductOnline: widget.isProductOnline,
            onRemove: widget.onRemove,
            isProductListing: widget.isProductListing,
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            category: widget.category,
            context: context,
            item: widget.item!,
          )
        : widget.isProductListing
        ? ProductTileListing(
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            category: widget.category,
            context: context,
            item: widget.item!,
          )
        : ProductTileStockSelect(
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            context: context,
            item: widget.item!,
          );
  }
}
