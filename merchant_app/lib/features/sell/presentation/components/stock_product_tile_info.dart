// removed ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/features/sell/presentation/components/stock_product_tile.dart';
import 'package:littlefish_merchant/features/sell/presentation/components/stock_product_tile_category.dart';
import 'package:littlefish_merchant/features/sell/presentation/components/stock_product_tile_discout.dart';
import 'package:littlefish_merchant/features/sell/presentation/components/stock_product_tile_quantity_field.dart';
import 'package:littlefish_merchant/features/sell/presentation/components/stock_product_tile_title.dart';
import 'package:littlefish_merchant/features/sell/presentation/components/stock_product_tile_amount.dart';
import 'package:littlefish_merchant/models/stock/stock_take_item.dart';

import 'stock_product_tile_price_quantity.dart';
import 'stock_product_tile_simple_quantity.dart';
import 'stock_product_tile_stock.dart';

class StockProductTileInfo extends StatelessWidget {
  const StockProductTileInfo({
    required this.context,
    required this.viewMode,
    this.title = '',
    this.category = '',
    this.trailText = '',
    this.priceText = '',
    this.quantity = 0.0,
    this.quantityInStock = 0,
    this.stockIsLow = false,
    this.isSelected = false,
    this.showCatagories = false,
    this.showPriceAndStockField = false,
    this.titleIsBold = false,
    super.key,
    required this.childKey,
    required this.stockTakeItem,
    required this.quantityFieldButtonSize,
    required this.minValue,
    required this.maxValue,
    required this.showQuantityField,
    this.onSaveValue,
    this.onFieldSubmitted,
    this.showDiscount = true,
    this.discountValue = 0.0,
  });

  final BuildContext context;
  final Key childKey;
  final StockProductViewMode viewMode;
  final StockTakeItem stockTakeItem;
  final String title;
  final String category;
  final String trailText;
  final String priceText;
  final double quantity;
  final double quantityInStock;
  final double quantityFieldButtonSize;
  final double discountValue;
  final int minValue;
  final int maxValue;
  final bool stockIsLow;
  final bool isSelected;
  final bool showCatagories;
  final bool showPriceAndStockField;
  final bool titleIsBold;
  final bool showQuantityField;
  final bool showDiscount;

  final void Function(int)? onSaveValue;
  final void Function(int?)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    var widthFactor = 0.6;
    var amountColor = Theme.of(context).colorScheme.primary;
    if (viewMode == StockProductViewMode.cartView) {
      widthFactor = 0.5;
      amountColor = Theme.of(context).colorScheme.secondary;
    } else if (viewMode == StockProductViewMode.eStoreView) {
      amountColor = Theme.of(context).colorScheme.secondary;
      widthFactor = 0.5;
    }
    final width = MediaQuery.of(context).size.width * widthFactor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StockProductTileCategory(
          context: context,
          category: category.toUpperCase(),
          showCategories: showCatagories,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StockProductTileTitle(
                    context: context,
                    title: title,
                    bold: titleIsBold,
                  ),
                  if (showQuantityField) ...[
                    const SizedBox(height: 4),
                    StockProductTileQuantityField(
                      key: Key(title),
                      childKey: childKey,
                      quantity: quantity,
                      isSelected: isSelected,
                      minValue: minValue,
                      maxValue: maxValue,
                      fieldButtonSize: quantityFieldButtonSize,
                      onSaveValue: (p0) => onSaveValue!(p0),
                      onFieldSubmitted: (p0) => onFieldSubmitted!(p0),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                StockProductTileAmount(
                  context: context,
                  trailText: trailText,
                  color: amountColor,
                ),
                if (showDiscount)
                  StockProductTileDiscount(discountValue: discountValue),
              ],
            ),
          ],
        ),
        if (showPriceAndStockField)
          StockProductTilePriceQuantity(
            quantityInStock: quantityInStock,
            context: context,
            price: priceText,
            quantity: quantityInStock.toString(),
            stockIsLow: stockIsLow,
          ),
        if (viewMode == StockProductViewMode.stockView)
          StockProductTileStock(context: context, stockTakeItem: stockTakeItem),
        if (viewMode == StockProductViewMode.eStoreView)
          StockProductTileSimpleQuantity(
            context: context,
            stockTakeItem: stockTakeItem,
          ),
      ],
    );
  }
}
