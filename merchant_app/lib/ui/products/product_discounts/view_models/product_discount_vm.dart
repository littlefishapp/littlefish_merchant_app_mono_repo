// Flutter imports:
// remove ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/products/product_discount.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/redux/discounts/product_discounts_actions.dart';
import 'package:littlefish_merchant/redux/discounts/product_discount_state.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_merchant/redux/product/product_state.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';

class ProductDiscountVM
    extends StoreItemViewModel<ProductDiscount?, ProductDiscountState> {
  ProductDiscountVM.fromStore(Store<AppState> store) : super.fromStore(store);

  ProductState? productState;

  Function(List<StockProduct>)? updateExistingProducts;

  Function()? onRefresh;

  Function(ProductDiscount)? setCurrentProductDiscount;

  Function(ProductDiscount)? removeProductDiscount;

  Function(
    List<StockProduct>?,
    List<StockProduct>?,
    ChangeType,
    ProductDiscount,
  )?
  updatesProductDiscounts;
  Function(List<StockProduct>?)? setStockProducts;
  Function(List<StockProduct>)? removeDuplicateProducts;
  ProductDiscount? currentDiscount;
  List<ProductDiscount>? productDiscounts;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.productDiscountState;
    productState = store.state.productState;
    productDiscounts = store.state.productDiscountState.discounts;
    isNew = currentDiscount?.isNew ?? false;
    currentDiscount = state!.currentDiscount;
    onRefresh = () => store.dispatch(getProductDiscounts(refresh: true));

    onAdd = (item, ctx) async {
      if (key == null || key!.currentState == null) return;

      if (key!.currentState!.validate()) {
        key!.currentState!.save();

        await store.dispatch(createOrUpdateProductDiscount(item: item!));
      }
    };
    setCurrentProductDiscount = (discount) {
      store.dispatch(SelectProductDiscountAction(discount));
    };

    updatesProductDiscounts = (products, newProducts, type, discount) {
      List<ProductDiscount> discounts = [];
      if (type == ChangeType.added && newProducts != null) {
        // Removes products from existing discounts
        for (StockProduct product in newProducts) {
          if (product.discountId != null || product.discountId != '') {
            int index = state!.discounts!.indexWhere(
              (discount) => discount.id == product.discountId,
            );
            if (index != -1) {
              state!.discounts![index].products!.removeWhere(
                (element) => element.id == product.id,
              );
              discounts.add(state!.discounts![index]);
            }
          }
        }
        int index = state!.discounts!.indexWhere(
          (discount) => discount.id == state!.currentDiscount!.id,
        );
        if (index != -1) {
          state!.discounts![index].products = products;
          discounts.add(state!.discounts![index]);
          state!.currentDiscount!.products = products;
        } else {
          discount.products = products;
          discounts.add(discount);
        }

        //Updates current discount
        store.dispatch(updateProductDiscounts(discounts: discounts));
      }
    };

    removeProductDiscount = (discount) {
      store.dispatch(deleteProductDiscount(item: discount));
    };

    updateExistingProducts = (products) {
      state!.currentDiscount!.products = products;
      store.dispatch(
        createOrUpdateProductDiscount(item: state!.currentDiscount!),
      );
    };

    setStockProducts = (products) async {
      store.dispatch(updateProductsDiscounts(products ?? []));
    };

    isLoading = store.state.productDiscountState.isLoading ?? false;
    hasError = store.state.productDiscountState.hasError ?? false;

    errorMessage = state!.errorMessage;
  }
}
