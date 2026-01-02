// removed ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:quiver/strings.dart';

import '../../../../injector.dart';
import '../../../../models/stock/stock_product.dart';
import '../../../../models/stock/stock_take_item.dart';
import '../../../../tools/network_image/flutter_network_image.dart';
import 'stock_product_tile_check_box.dart';
import 'stock_product_tile_info.dart';
import 'stock_product_tile_leading_button.dart';
import 'stock_product_tile_more.dart';

enum StockProductViewMode {
  manageView,
  eStoreView,
  stockView,
  listView,
  cartView,
}

class StockProductTile extends StatefulWidget {
  final StockProduct product;
  final StockProductViewMode viewMode;
  final double tileHeight;
  final double tileWidth;
  final double fieldButtonSize;
  final bool enableHighlighting;
  final int? maxValue;
  final int minValue;
  final Function(StockProduct item) onTileTap;
  final Function(StockProduct item, double quantity) onQuantityTileTap;
  final Function(StockProduct item)? onLongPress;
  final Function(StockProduct item)? onRemove;
  final String Function(StockProduct item)? getCategoryName;
  final bool Function(StockProduct item)? stockIsLow;
  final double Function(StockProduct item)? getStockLevel;
  final StockTakeItem Function(StockProduct item)? stockTakeItem;
  final String Function(StockTakeItem stockTakeItem)?
  getStockTakeItemDescription;
  final bool Function(StockProduct item)? isEstoreItem;
  final double Function(StockProduct item) getQuantityInCart;
  final void Function(String)? removeItem;

  const StockProductTile({
    Key? key,
    required this.product,
    required this.getQuantityInCart,
    required this.onQuantityTileTap,
    required this.viewMode,
    required this.onTileTap,
    this.enableHighlighting = true,
    this.onLongPress,
    this.onRemove,
    this.tileHeight = 70,
    this.tileWidth = double.infinity,
    this.maxValue,
    this.minValue = 0,
    this.fieldButtonSize = 40,
    this.getCategoryName,
    this.stockIsLow,
    this.getStockLevel,
    this.stockTakeItem,
    this.getStockTakeItemDescription,
    this.isEstoreItem,
    this.removeItem,
  }) : super(key: key);

  @override
  State<StockProductTile> createState() => _StockProductTileState();
}

class _StockProductTileState extends State<StockProductTile> {
  var _product = StockProduct();
  late StockTakeItem _stockTakeItem;
  var _isSelected = false;
  var _trailingText = '';
  var _categoryText = '';
  var _showCategories = false;
  var _showPriceAndStockField = false;
  var _showQuantityField = false;
  var _titleIsBold = false;
  var _priceText = '';
  var _quantityInStock = 0.0;
  var _stockIsLow = false;
  var _showTickBox = false;
  var _isEstoreItem = false;
  var _quantityInCart = 0.0;
  var _showMore = false;
  var _showDiscount = false;

  dynamic _leading;

  @override
  void initState() {
    _stockTakeItem = widget.stockTakeItem != null
        ? widget.stockTakeItem!(_product)
        : StockTakeItem();

    super.initState();
  }

  void setupWidget() {
    _product = widget.product;
    _quantityInCart = widget.getQuantityInCart(_product);
    _isSelected = _quantityInCart > 0;
    debugPrint(
      '#### StockProductTile setupWidget '
      ' ${widget.product.name}  $_quantityInCart',
    );
    _leading = isNotBlank(_product.imageUri)
        ? getIt<FlutterNetworkImage>().asWidget(
            id: _product.id!,
            category: 'products',
            legacyUrl: _product.imageUri!,
            fit: BoxFit.fill,
            height: AppVariables.listImageHeight,
            width: AppVariables.listImageWidth,
          )
        : const Icon(Icons.inventory_2_outlined);
    _stockIsLow = widget.stockIsLow != null
        ? widget.stockIsLow!(_product)
        : false;
    switch (widget.viewMode) {
      case StockProductViewMode.listView:
        _trailingText = _product.regularPrice?.toStringAsFixed(2) ?? '0.00';
        _showQuantityField = true;
        break;
      case StockProductViewMode.cartView:
        _trailingText = _product.regularPrice?.toStringAsFixed(2) ?? '0.00';
        _showQuantityField = true;
        _showMore = true;
        _showDiscount = true;
        break;
      case StockProductViewMode.manageView:
        final currencyCode = _product.currencyCode ?? '';
        final price = _product.regularPrice?.toStringAsFixed(2) ?? '0.00';
        _priceText = currencyCode + price;
        _titleIsBold = true;
        _categoryText = widget.getCategoryName != null
            ? widget.getCategoryName!(_product)
            : '';

        _showCategories = true;
        _showPriceAndStockField = true;
        _quantityInStock = widget.getStockLevel != null
            ? widget.getStockLevel!(_product)
            : 0;
        break;
      case StockProductViewMode.stockView:
        _quantityInStock = widget.getStockLevel != null
            ? widget.getStockLevel!(_product)
            : 0;
        _trailingText = 'Confirmed';
        break;
      case StockProductViewMode.eStoreView:
        _quantityInStock = widget.getStockLevel != null
            ? widget.getStockLevel!(_product)
            : 0;
        _isEstoreItem = widget.isEstoreItem != null
            ? widget.isEstoreItem!(_product)
            : false;
        _categoryText = widget.getCategoryName != null
            ? widget.getCategoryName!(_product)
            : '';
        _trailingText = '';
        _showTickBox = true;
        _showCategories = true;
        _titleIsBold = true;
        break;
      default:
        _trailingText = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO(lampian): move to init
    setupWidget();
    debugPrint(
      '#### StockProductTile build ${widget.product.name} '
      'isSelected $_isSelected '
      'qty $_quantityInCart',
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: () {
          if (widget.viewMode == StockProductViewMode.listView) {
            debugPrint('### StockProductTile onTileTap $_quantityInCart');
            widget.onTileTap(_product);
            _quantityInCart = widget.getQuantityInCart(_product);
          } else if (widget.viewMode == StockProductViewMode.manageView) {
            debugPrint('### navigate to tile detail');
          }
        },
        child: SizedBox(
          height: widget.tileHeight,
          width: widget.tileWidth,
          child: Row(
            children: [
              if (_showTickBox)
                StockProductTileCheckBox(
                  isEstoreItem: _isEstoreItem,
                  // TODO(lampian): add implementation when used in e store
                  onChanged: (p0) {},
                ),
              if (_leading != null)
                StockProductTileLeadingButton(
                  showQuantityField: _showQuantityField,
                  isSelected: _isSelected,
                  leading: _leading,
                ),
              Flexible(
                child: StockProductTileInfo(
                  quantityFieldButtonSize: widget.fieldButtonSize,
                  childKey: widget.key ?? GlobalKey(),
                  context: context,
                  maxValue: widget.maxValue ?? 1000,
                  minValue: widget.minValue,
                  showQuantityField: _showQuantityField,
                  stockTakeItem: _stockTakeItem,
                  viewMode: widget.viewMode,
                  category: _categoryText,
                  isSelected: _isSelected,
                  onFieldSubmitted: onFieldSubmitted,
                  onSaveValue: (p0) {
                    _quantityInStock = p0.toDouble();
                  },
                  priceText: _priceText,
                  quantity: _quantityInCart,
                  quantityInStock: _quantityInStock,
                  showCatagories: _showCategories,
                  showPriceAndStockField: _showPriceAndStockField,
                  stockIsLow: _stockIsLow,
                  title: _product.displayName ?? 'Unnamed Product',
                  titleIsBold: _titleIsBold,
                  trailText: _trailingText,
                  discountValue: 123,
                  showDiscount: _showDiscount,
                ),
              ),
              StockProductTileMore(
                removeItem: widget.removeItem,
                showMore: _showMore,
                productId: _product.id ?? '',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onFieldSubmitted(value) {
    var submittedQuantity = 0.0;
    if (value != null) {
      if (value is String) {
        submittedQuantity = double.tryParse(value) ?? 0.0;
      } else if (value is int) {
        submittedQuantity = value.toDouble();
      } else if (value is double) {
        submittedQuantity = value;
      }
    }

    debugPrint(
      '#### StockProductTile onQuantityTileTap '
      ' $submittedQuantity',
    );
    widget.onQuantityTileTap(widget.product, submittedQuantity);
    //_quantityInCart = widget.getQuantityInCart(_product);
    if (submittedQuantity == 0.0) {
      _isSelected = false;
    }
  }
}
