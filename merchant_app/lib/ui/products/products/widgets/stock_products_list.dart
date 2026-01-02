// removed ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/features/sell/presentation/components/stock_product_tile.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_merchant/ui/products/products/view_models/product_collection_vm.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

import '../../../../models/stock/stock_take_item.dart';
import 'stock_product_list_empty.dart';

// TODO(lampian): refactor to be stateless
class StockProductsList extends StatefulWidget {
  final Function(StockProduct item) onTileTapped;
  final Function(StockProduct item)? onRemove;
  final Function(StockProduct item)? onLongPress;
  final String Function(StockProduct item)? getCategoryName;
  final bool Function(StockProduct item)? stockIsLow;
  final double Function(StockProduct item)? getStockLevel;
  final bool canAddNew;
  final String categoryId;
  final String filterField;
  final Key? newItemKey;
  final StockProductViewMode viewMode;
  final bool isMultiSelect;
  final SortOrder sortOrder;
  final SortBy sortBy;
  final List<StockProduct> items;
  final bool isLoading;
  final StockTakeItem Function(StockProduct item)? stockTakeItem;
  final String Function(StockTakeItem stockTakeItem)?
  getStockTakeItemDescription;
  final bool Function(StockProduct item)? isEstoreItem;
  final double Function(StockProduct item) getQuantityInCart;
  final Function(StockProduct item, double quantity) onQuantityTileTap;
  final void Function(String)? removeItem;

  const StockProductsList({
    Key? key,
    required this.onTileTapped,
    this.onRemove,
    this.canAddNew = true,
    this.categoryId = '',
    this.newItemKey,
    this.viewMode = StockProductViewMode.listView,
    this.onLongPress,
    this.isMultiSelect = false,
    this.sortOrder = SortOrder.ascending,
    this.sortBy = SortBy.name,
    this.items = const [],
    this.filterField = '',
    this.isLoading = false,
    this.getCategoryName,
    this.stockIsLow,
    this.getStockLevel,
    this.stockTakeItem,
    this.getStockTakeItemDescription,
    this.isEstoreItem,
    required this.getQuantityInCart,
    required this.onQuantityTileTap,
    this.removeItem,
  }) : super(key: key);

  @override
  State<StockProductsList> createState() => _StockProductsListState();
}

class _StockProductsListState extends State<StockProductsList> {
  GlobalKey<AutoCompleteTextFieldState<StockProduct>>? filterkey;
  GlobalKey? newItemKey;

  @override
  void initState() {
    filterkey = GlobalKey<AutoCompleteTextFieldState<StockProduct>>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('### StockProductsList build ${widget.viewMode}');
    newItemKey = widget.newItemKey as GlobalKey<State<StatefulWidget>>?;
    return widget.isLoading
        ? const AppProgressIndicator()
        : widget.items.isEmpty
        ? StockProductListEmpty(
            addProductsOnTap:
                // TODO(lampian): add implementation
                (p0) {}, //addProductsOnTap: (_) => captureProduct(context, vm),
          )
        : hasProductsLayout(context, widget.items);
  }

  Widget hasProductsLayout(context, List<StockProduct> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: ((context, index) {
        return StockProductTile(
          product: items[index],
          viewMode: widget.viewMode,
          onTileTap: widget.onTileTapped,
          getCategoryName: widget.getCategoryName,
          getStockLevel: widget.getStockLevel,
          stockTakeItem: widget.stockTakeItem,
          getStockTakeItemDescription: widget.getStockTakeItemDescription,
          isEstoreItem: widget.isEstoreItem,
          getQuantityInCart: widget.getQuantityInCart,
          onQuantityTileTap: widget.onQuantityTileTap,
          removeItem: widget.removeItem,
        );
      }),
    );
  }

  Future<void> captureProduct(
    BuildContext context,
    ProductsViewModel vm, {
    StockProduct? product,
  }) async {
    //this is an existing product that should be edited
    if (product != null) {
      vm.store!.dispatch(ProductSelectAction(product));
      if (!(vm.store!.state.isLargeDisplay ?? false)) {
        vm.store!.dispatch(editProduct(context, product));
      }
    } else {
      vm.store!.dispatch(createProduct(context));
    }
  }
}
