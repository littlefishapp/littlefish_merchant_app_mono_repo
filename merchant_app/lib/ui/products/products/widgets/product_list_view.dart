// removed ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/ui/products/products/view_models/product_collection_vm.dart';

import '../../../../models/stock/stock_product.dart';
import '../../../../redux/product/product_actions.dart';
import '../../../checkout/widgets/checkout_product_tile.dart';
import 'product_category_tile.dart';
import 'product_list_tile.dart';
import 'product_stock_tile.dart';
import 'products_list.dart';

class ProductListView extends StatefulWidget {
  const ProductListView({
    super.key,
    required this.context,
    required this.vm,
    required this.isMultiSelect,
    required this.filteredList,
    required this.sortedList,
    required this.viewMode,
    required this.onTap,
    this.selectedProducts,
    this.onRemove,
    required this.isStockListing,
    required this.canAddNew,
    this.onLongPress,
    this.parentContext,
  });

  final BuildContext context;
  final ProductsViewModel vm;
  final BuildContext? parentContext;
  final bool isMultiSelect;
  final bool isStockListing;
  final bool canAddNew;
  final List<StockProduct> filteredList;
  final List<StockProduct> sortedList;
  final List<StockProduct>? selectedProducts;
  final ProductViewMode viewMode;
  final Function(StockProduct item) onTap;
  final Function(StockProduct item)? onRemove;
  final Function(StockProduct item)? onLongPress;

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: widget.isMultiSelect
          ? const EdgeInsets.only(bottom: 208)
          : widget.viewMode == ProductViewMode.checkoutView
          ? const EdgeInsets.symmetric(vertical: 8)
          : null,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (c, i) {
          switch (widget.viewMode) {
            case ProductViewMode.productsView:
            case ProductViewMode.stockView:
              return Container();
            case ProductViewMode.checkoutView:
            case ProductViewMode.cartView:
              return const SizedBox(height: 8);
          }
        },
        itemCount: widget.sortedList.length,
        itemBuilder: (BuildContext context, int index) {
          StockProduct item = widget.sortedList[index];

          switch (widget.viewMode) {
            case ProductViewMode.productsView:
              if (widget.isMultiSelect) {
                return ProductCategoryTile(
                  item: item,
                  selected:
                      widget.selectedProducts!.contains(item) ||
                      widget.selectedProducts!
                          .where((element) => element.id == item.id)
                          .isNotEmpty,
                  onTap: (item) {
                    widget.onTap(item);
                  },
                  onRemove: (item) {
                    widget.onRemove!(item);
                  },
                );
              }
              return ProductListTile(
                isProductOnline: widget.vm.checkOnlineProduct(
                  (item.id != null ? item.id! : '0'),
                ),
                item: item,
                isProductListing: !widget.isStockListing,
                dismissAllowed: widget.canAddNew,
                category: widget.vm.state!.getCategory(
                  categoryId: item.categoryId,
                ),
                selected: widget.vm.selectedItem == item,
                onLongPress: widget.onLongPress,
                onTap: (item) {
                  widget.onTap(item);
                },
                onRemove: (item) {
                  widget.vm.onRemove(item, widget.parentContext ?? context);
                },
              );
            case ProductViewMode.stockView:
              return ProductStockTile(
                item: item,
                category: widget.vm.state!.getCategory(
                  categoryId: item.categoryId,
                ),
                selected: widget.vm.selectedItem == item,
                onTap: (item) {
                  widget.onTap(item);
                },
              );
            case ProductViewMode.checkoutView:
              return CheckoutProductTile(
                product: item,
                enableVariantSelection: AppVariables.enableProductVariance,
                key: ValueKey(item.id),
              );

            case ProductViewMode.cartView:
              return CheckoutProductTile(product: item, key: ValueKey(item.id));

            default:
              return Container();
          }
        },
      ),
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
