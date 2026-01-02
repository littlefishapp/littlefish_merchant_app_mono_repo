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

class FilteredProductListView extends StatelessWidget {
  const FilteredProductListView({
    super.key,
    required this.context,
    required this.vm,
    this.parentContext,
    required this.filteredList,
    this.selectedProducts,
    required this.viewMode,
    required this.isMultiSelect,
    this.onTap,
    this.onRemove,
    this.onLongPress,
    required this.canAddNew,
  });

  final BuildContext context;
  final ProductsViewModel vm;
  final BuildContext? parentContext;
  final List<StockProduct> filteredList;
  final List<StockProduct>? selectedProducts;
  final ProductViewMode viewMode;
  final bool isMultiSelect;
  final Function(StockProduct item)? onTap;
  final Function(StockProduct item)? onRemove;
  final Function(StockProduct item)? onLongPress;
  final bool canAddNew;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: filteredList.length,
      itemBuilder: (BuildContext context, int index) {
        StockProduct item = filteredList[index];

        switch (viewMode) {
          case ProductViewMode.productsView:
            if (isMultiSelect) {
              return ProductCategoryTile(
                item: item,
                selected:
                    selectedProducts!.contains(item) ||
                    selectedProducts!
                        .where((element) => element.id == item.id)
                        .isNotEmpty,
                onTap: (item) {
                  onTap!(item);
                },
                onRemove: (item) {
                  onRemove!(item);
                },
              );
            }
            return ProductListTile(
              isProductOnline: vm.checkOnlineProduct(item.id!),
              item: item,
              dismissAllowed: canAddNew,
              category: vm.state!.getCategory(categoryId: item.categoryId),
              selected: vm.selectedItem == item,
              onLongPress: onLongPress,
              onTap: (item) {
                if (onTap == null) {
                  captureProduct(context, vm, product: item);
                } else {
                  onTap!(item);
                }
              },
              onRemove: (item) {
                vm.onRemove(item, parentContext ?? context);
              },
            );
          case ProductViewMode.stockView:
            return ProductStockTile(
              item: item,
              category: vm.state!.getCategory(categoryId: item.categoryId),
              selected: vm.selectedItem == item,
              onTap: (item) {
                if (onTap == null) {
                  captureProduct(context, vm, product: item);
                } else {
                  onTap!(item);
                }
              },
            );
          case ProductViewMode.checkoutView:
            return CheckoutProductTile(
              product: item,
              enableVariantSelection: AppVariables.enableProductVariance,
            );

          default:
            return Container();
        }
      },
      separatorBuilder: (BuildContext context, int index) {
        switch (viewMode) {
          case ProductViewMode.productsView:
          case ProductViewMode.stockView:
            return Container();
          case ProductViewMode.checkoutView:
          case ProductViewMode.cartView:
            return const SizedBox(height: 8);
        }
      },
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
