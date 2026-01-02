// Project imports:
import 'package:littlefish_merchant/models/products/product_combo.dart';
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';

List<StockProduct>? productsSelector(AppState state) =>
    state.productState.products;

Iterable<StockProduct>? activeProductsSelector(AppState state) {
  //ToDo: add selector to query from local client side db.

  return productsSelector(state)?.where((p) => p.enabled!);
}

dynamic favoriteProductsSelector(AppState state) =>
    productsSelector(state)?.where((p) => p.favourite!);

List<StockCategory>? categoriesSelector(AppState state) =>
    state.productState.categories;

List<ProductCombo>? combosSelector(AppState state) =>
    state.productState.productCombos;

dynamic categoriesWithItemsSelector(AppState state) =>
    categoriesSelector(
      state,
    )?.where((c) => (c.productCount ?? 0) > 0).toList() ??
    <StockCategory>[];

dynamic combosWithItemsSelector(AppState state) =>
    combosSelector(state)?.where((c) => c.totalItems > 0).toList() ??
    <StockCategory>[];

dynamic activeCategoriesSelector(AppState state) =>
    categoriesSelector(state)?.where((c) => c.enabled!);

dynamic productsByCategorySelector(AppState state, String? categoryId) =>
    activeProductsSelector(state)?.where((p) => p.categoryId == categoryId);
