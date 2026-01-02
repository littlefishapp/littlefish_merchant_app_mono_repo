// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/models/enums.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_merchant/redux/product/product_selectors.dart';
import 'package:littlefish_merchant/redux/product/product_state.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

class ProductsViewModel
    extends StoreCollectionViewModel<StockProduct, ProductState> {
  ProductsViewModel.fromStore(Store<AppState> store, {this.categoryId})
    : super.fromStore(store);

  String? categoryId;
  int? tabIndex;
  late Function(int index) setTabIndex;

  late Function(SortOrder, SortBy) updateSortOptions;

  bool get storeIsOnline => store!.state.storeState.store != null;

  late void Function() getProductOptionAttributes;

  List<StockProduct>? get checkoutProducts => (items ?? [])
      .where((p) => p.isInStore == true || p.isInStore == null)
      .toList();

  late SortBy sortBy;
  late SortOrder sortOrder;

  bool checkOnlineProduct(String id) {
    var res = store!.state.storeState.products?.indexWhere(
      (element) => element.id == id,
    );

    return res != -1;
  }

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.productState;
    tabIndex = state!.tabIndex ?? 0;
    items = (categoryId == null || categoryId!.isEmpty)
        ? activeProductsSelector(store.state)?.toList()
        : productsByCategorySelector(store.state, categoryId)!.toList();

    sortBy = state!.sortBy ?? SortBy.createdDate;
    sortOrder = state!.sortOrder ?? SortOrder.ascending;

    selectedItem = store.state.productsUIState!.item;
    updateSortOptions = (order, type) => {
      store.dispatch(SetProductSortOptionsAction(order, type)),
    };

    onRefresh = () => store.dispatch(getProducts(refresh: true));

    onRemove = (item, ctx) async {
      //syncChangesToOnlineStore = true;

      store.dispatch(
        removeProduct(
          item: item,
          completer: snackBarCompleter(ctx, '${item.displayName} deleted'),
        ),
      );
    };

    getProductOptionAttributes = () =>
        store.dispatch(getAllOptionAttributesAction());

    onAdd = (item, ctx) {};

    setTabIndex = (index) {
      tabIndex = index;
      store.dispatch(ProductsTabIndexAction(index));
    };

    isLoading = store.state.productState.isLoading ?? false;
    hasError = store.state.productState.hasError ?? false;

    errorMessage = state!.errorMessage;
  }
}
