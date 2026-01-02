// Dart imports:
// remove ignore_for_file: use_build_context_synchronously

import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart' show IterableExtension;
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:quiver/strings.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

// Project imports:
import 'package:littlefish_merchant/models/stock/stock_run.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/models/stock/stock_take_item.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/products/product_combo.dart';
import 'package:littlefish_merchant/models/products/product_modifier.dart';
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/suppliers/supplier_actions.dart';
import 'package:littlefish_merchant/services/product_service.dart';
import 'package:littlefish_merchant/tools/exceptions/common_exceptions.dart';
import 'package:littlefish_merchant/ui/products/categories/widgets/product_category_page.dart';
import 'package:littlefish_merchant/ui/products/combos/pages/product_combo_page.dart';
import 'package:littlefish_merchant/ui/products/modifiers/pages/product_modifier_page.dart';
import 'package:littlefish_merchant/ui/products/products/pages/product_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/models/stock/full_product.dart';

import '../../ui/products/categories/view_models/category_collection_vm.dart';
import '../inventory/inventory_actions.dart';
import '../store/store_actions.dart';

late ProductService productService;

ThunkAction<AppState> initializeProductState({bool refresh = false}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      var productState = store.state.productState;

      if (!refresh && (productState.products?.length ?? 0) > 0) {
        return;
      }

      store.dispatch(ProductStateLoadingAction(true));

      await productService
          .getProducts()
          .catchError((e) {
            reportCheckedError(e, trace: StackTrace.current);
            store.dispatch(ProductStateFailureAction(e.toString()));
            return <StockProduct>[];
          })
          .then((result) {
            store.dispatch(ProductsLoadedAction(result));
          });

      await productService
          .getCategories()
          .catchError((e) {
            reportCheckedError(e, trace: StackTrace.current);
            store.dispatch(ProductStateFailureAction(e.toString()));
            return <StockCategory>[];
          })
          .then((result) {
            store.dispatch(CategoriesLoadedAction(result));
          });

      await productService
          .getModifiers()
          .catchError((e) {
            reportCheckedError(e, trace: StackTrace.current);
            store.dispatch(ProductStateFailureAction(e.toString()));
            return <ProductModifier>[];
          })
          .then((result) {
            store.dispatch(ModifiersLoadedAction(result));
          });

      await productService
          .getCombos()
          .catchError((e) {
            reportCheckedError(e, trace: StackTrace.current);
            store.dispatch(ProductStateFailureAction(e.toString()));
            return <ProductCombo>[];
          })
          .then((result) {
            store.dispatch(CombosLoadedAction(result));
          });

      store.dispatch(ProductStateLoadingAction(false));
    });
  };
}

ThunkAction<AppState> getProducts({
  bool refresh = false,
  bool dispatch = true,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      var productState = store.state.productState;

      if (!refresh && (productState.products?.length ?? 0) > 0) {
        return;
      }

      store.dispatch(ProductStateLoadingAction(true));

      try {
        var result = await productService.getProducts();
        if (dispatch) store.dispatch(ProductsLoadedAction(result));
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        store.dispatch(ProductStateFailureAction(e.toString()));
      } finally {
        store.dispatch(ProductStateLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> getFullProducts({
  bool refresh = false,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      var productState = store.state.productState;

      if (!refresh && productState.fullProducts.isNotEmpty) {
        completer?.complete();
        return;
      }

      store.dispatch(ProductStateLoadingAction(true));

      try {
        var result = await productService.getFullProductsWithOptions();
        store.dispatch(SetFullProductsAction(result));
        completer?.complete();
        store.dispatch(ProductStateLoadingAction(false));
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        completer?.completeError(e);
        store.dispatch(ProductStateFailureAction(e.toString()));
        store.dispatch(ProductStateLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> getFullProductById({
  required String productId,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(ProductStateLoadingAction(true));

      try {
        var result = await productService.getFullProductByID(productId);
        store.dispatch(SetProductWithOptionsAction(result));
        completer?.complete();
        store.dispatch(ProductStateLoadingAction(false));
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        completer?.completeError(e);
        store.dispatch(ProductStateLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> getAllOptionAttributesAction({Completer? completer}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(ProductStateLoadingAction(true));

      try {
        var result = await productService.getAllProductOptionTags();
        store.dispatch(SetAllOptionAttributesAction(result));
        completer?.complete();
        store.dispatch(ProductStateLoadingAction(false));
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        completer?.completeError(e);
        store.dispatch(ProductStateFailureAction(e.toString()));
        store.dispatch(ProductStateLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> fetchAndSetProductById(String productId) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);
      final LoggerService logger = LittleFishCore.instance.get<LoggerService>();
      store.dispatch(ProductStateLoadingAction(true));

      try {
        var product = await productService.getProductByID(productId);
        store.dispatch(ProductChangedAction(product, ChangeType.updated));
        store.dispatch(ProductStateLoadingAction(false));
      } catch (e) {
        logger.error(
          'fetchAndSetProductById',
          'Failed to fetch and update product',
          error: e,
          stackTrace: StackTrace.current,
        );
        store.dispatch(ProductStateLoadingAction(false));
      }
    });
  };
}

Future<StockProduct?>? getProductById(
  Store<AppState> store,
  String productId,
) async {
  try {
    _initializeService(store);
    return await productService.getProductByID(productId);
  } catch (e) {
    reportCheckedError(e, trace: StackTrace.current);
    return null; // Return null for error or no product found.
  }
}

Future<Map<String, List<dynamic>>?>? getProductsAndCategoriesByID(
  Store<AppState> store,
  List<String> productIds,
) async {
  try {
    _initializeService(store);
    return await productService.getProductsAndCategories(productIds);
  } catch (e) {
    reportCheckedError(e, trace: StackTrace.current);
    return null; // Return null for error or no product found.
  }
}

ThunkAction<AppState> initializeCategories({bool refresh = false}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      var productState = store.state.productState;

      if (!refresh && (productState.categories?.length ?? 0) > 0) {
        return;
      }

      store.dispatch(ProductStateLoadingAction(true));
      try {
        var result = await productService.getCategories();
        store.dispatch(CategoriesLoadedAction(result));
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        store.dispatch(ProductStateFailureAction(e.toString()));
      } finally {
        store.dispatch(ProductStateLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> initializeModifiers({bool refresh = false}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      var productState = store.state.productState;

      if (!refresh && (productState.categories?.length ?? 0) > 0) {
        return;
      }

      store.dispatch(ProductStateLoadingAction(true));

      try {
        var result = await productService.getModifiers();

        store.dispatch(ModifiersLoadedAction(result));
        store.dispatch(ProductStateLoadingAction(false));
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        store.dispatch(ProductStateFailureAction(e.toString()));
      } finally {
        store.dispatch(ProductStateLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> initializeCombos({bool refresh = false}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      var productState = store.state.productState;

      if (!refresh && (productState.productCombos?.length ?? 0) > 0) {
        return;
      }

      store.dispatch(ProductStateLoadingAction(true));

      try {
        var result = await productService.getCombos();
        store.dispatch(CombosLoadedAction(result));
        store.dispatch(ProductStateLoadingAction(false));
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        store.dispatch(ProductStateFailureAction(e.toString()));
      } finally {
        store.dispatch(ProductStateLoadingAction(false));
      }
    });
  };
}

Future<List<ProductCombo>?> getCombosByComboIDs(
  Store<AppState> store,
  List<String> comboIds,
) async {
  try {
    _initializeService(store);
    return await productService.getCombosByComboIDs(comboIds);
  } catch (e) {
    reportCheckedError(e, trace: StackTrace.current);
    return null; // Return null for error or no combos found.
  }
}

ThunkAction<AppState> stockAdjustmentProductUpdate({
  required StockProduct item,
  required double diff,
  required StockRunType reason,
  BuildContext? context,
  bool? isProductPage = false,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);
      store.dispatch(ProductStateLoadingAction(true));
      StockTakeItem stockItem = StockTakeItem.fromProduct(
        item,
        type: reason,
        qty: diff,
      );
      StockRun stockRun = StockRun.create();
      stockRun.items = [stockItem];
      try {
        store.dispatch(
          uploadStockRun(
            context: context,
            run: stockRun,
            isProductPage: isProductPage,
          ),
        );
      } catch (e) {
        store.dispatch(ProductStateFailureAction(e.toString()));
        reportCheckedError(e, trace: StackTrace.current);
        completer?.completeError(e);
      } finally {
        store.dispatch(ProductStateLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> removeProduct({
  required StockProduct item,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(ProductStateLoadingAction(true));

      try {
        var result = await productService.removeProduct(item);
        if (result) {
          store.dispatch(ProductChangedAction(item, ChangeType.removed));
          var state = store.state;
          var combos = state.productState.productCombos;

          if (combos != null && combos.isNotEmpty) {
            var removedCombos = combos
                .where((x) => x.items!.any((y) => y.productId == item.id))
                .toList();

            for (var i = 0; i < removedCombos.length; i++) {
              store.dispatch(
                ComboModifiedAction(removedCombos[i], ChangeType.removed),
              );
            }
          }

          var suppliers = state.supplierState.suppliers;

          if (suppliers != null && suppliers.isNotEmpty) {
            var updatedSuppliers = suppliers
                .where((x) => x!.products!.any((y) => y.productId == item.id))
                .toList();

            for (var i = 0; i < updatedSuppliers.length; i++) {
              var sup = updatedSuppliers[i]!;
              sup.products = sup.products
                  ?.where((x) => x.productId != item.id)
                  .toList();
              sup.dateUpdated = DateTime.now().toUtc();
              sup.updatedBy = state.currentUser!.email;
              store.dispatch(SupplierChangedAction(sup, ChangeType.updated));
            }
          }

          if (item.categoryId != null) {
            var category = state.productState.getCategory(
              categoryId: item.categoryId,
            );

            if (category != null) {
              if (category.productCount! > 0) {
                category.productCount = (category.productCount ?? 0) - 1;
                category.dateUpdated = DateTime.now().toUtc();
                category.updatedBy = state.currentUser!.email;

                store.dispatch(
                  CategoryChangedAction(category, ChangeType.updated),
                );
              }
            }
          }
        }

        if (completer != null && !completer.isCompleted) completer.complete();
      } catch (e) {
        store.dispatch(ProductStateFailureAction(e.toString()));
        reportCheckedError(e, trace: StackTrace.current);

        completer?.completeError(e);
      } finally {
        store.dispatch(ProductStateLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> addProduct({
  required StockProduct? product,
  BuildContext? context,
  Completer? completer,
  bool updatedByCategory = false,
  bool runCompleter = true,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      if (product == null) return;

      store.dispatch(ProductStateLoadingAction(true));

      try {
        var result = await productService.addProduct(product);
        store.dispatch(ProductStateLoadingAction(true));

        store.dispatch(
          ProductChangedAction(
            result,
            ChangeType.added,
            updatedByCategory: updatedByCategory,
            ecomCompleter: !runCompleter ? completer : null,
          ),
        );
        double difference = result.regularVariance!.quantity ?? 0;

        if (product.isNew == true && product.isStockTrackable == true) {
          // TODO: WHY ARE WE MAKING STOCK ADJUSTMENTS? THE BACKEND SHOULD HANDLE THIS (THINK IT DOES ALREADY)!!!
          result.regularVariance!.quantity = 0;
          store.dispatch(
            stockAdjustmentProductUpdate(
              context: context,
              item: result,
              reason: StockRunType.reCount,
              diff: difference,
              isProductPage: false,
            ),
          );
        }

        if (result.categoryId != null && result.categoryId!.isNotEmpty) {
          var category = store.state.productState.categories?.firstWhereOrNull(
            (x) => x.id == result.categoryId,
          );

          if (category != null) {
            List<StockProduct>? products = store.state.productState.products
                ?.where((element) => element.categoryId == result.categoryId)
                .toList();

            int? existingProductIndex = products?.indexWhere(
              (p) => p.id == result.id,
            );

            if (existingProductIndex != -1 && existingProductIndex != null) {
              products?[existingProductIndex] = result;
              category.products = products ?? [];
            } else {
              category.products?.add(product);
            }
            category.updatedBy = store.state.currentUser!.email;
            category.dateUpdated = DateTime.now().toUtc();

            var countWithoutProduct = store.state.productState.products != null
                ? store.state.productState.products!
                      .where(
                        (p) =>
                            p.categoryId == category.id && p.id != product.id,
                      )
                      .toList()
                      .length
                : 0;

            category.productCount =
                countWithoutProduct == (category.productCount ?? 0)
                ? (category.productCount ?? 0) + 1
                : category.productCount;

            store.dispatch(
              CategoryChangedAction(
                category,
                ChangeType.updated,
                updateProducts: false,
              ),
            );
          }
        }

        if (runCompleter) completer?.complete();

        store.dispatch(ProductStateLoadingAction(false));
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        store.dispatch(ProductStateFailureAction(e.toString()));
        store.dispatch(ProductStateLoadingAction(false));

        completer?.completeError(e);
      }
    });
  };
}

ThunkAction<AppState> upsertProductWithOptions({
  required FullProduct productWithOptions,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(ProductStateLoadingAction(true));

      try {
        var result = await productService.upsertProductWithOption(
          productWithOptions,
        );

        store.dispatch(ProductChangedAction(result.product, ChangeType.added));

        // NOTE: Neglecting manual stock adjustment and category state update - backend should handle the update and we should just refresh the state

        completer?.complete();
        store.dispatch(ClearProductWithOptionsAction());
        store.dispatch(ProductStateLoadingAction(false));
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        store.dispatch(ProductStateFailureAction(e.toString()));

        completer?.completeError(e);
        store.dispatch(ProductStateLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> createProduct(
  BuildContext ctx, {
  ProductPageContext pageContext = ProductPageContext.general,
}) {
  return (Store<AppState> store) async {
    store.dispatch(ProductStateLoadingAction(true));

    store.dispatch(ProductCreateAction());
    store.dispatch(ClearProductWithOptionsAction());

    store.dispatch(ProductStateLoadingAction(false));

    if (store.state.isLargeDisplay ?? false) {
      showPopupDialog(
        context: ctx,
        content: const ProductPage(isEmbedded: true),
      );
    } else {
      Navigator.of(ctx).push<StockProduct>(
        CustomRoute(
          maintainState: true,
          builder: (BuildContext context) =>
              ProductPage(pageContext: pageContext),
        ),
      );
    }
  };
}

ThunkAction<AppState> editProduct(BuildContext ctx, StockProduct product) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(ProductStateLoadingAction(true));

      store.dispatch(ProductSelectAction(product));

      store.dispatch(ProductStateLoadingAction(false));

      if (store.state.isLargeDisplay ?? false) {
        // showDialog<StockProduct>(
        //   context: ctx,
        //   barrierDismissible: false,
        //   builder: (context) => ProductPage(
        //     onProductUpdate: () {
        //       // TODO:  This is not the right place for initializing categories, this can result in race conditions from different actions controlling loading state.
        //       store.dispatch(initializeCategories(refresh: true));
        //     },
        //   ),
        // );
      } else {
        Navigator.of(ctx).push<StockProduct>(
          CustomRoute(
            maintainState: true,
            builder: (BuildContext context) => ProductPage(
              onProductUpdate: () {
                store.dispatch(initializeCategories(refresh: true));
              },
            ),
          ),
        );
      }
    });
  };
}

ThunkAction<AppState> updateProductsDiscounts(List<StockProduct> products) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(ProductStateLoadingAction(true));
      if (products == []) return;
      _initializeService(store);
      var result = await productService.updateProductsDiscountId(products);
      store.dispatch(UpdateProductsAction(result));
      store.dispatch(ProductStateLoadingAction(false));
    });
  };
}

ThunkAction<AppState> removeCategory({
  required StockCategory item,
  Completer? completer,
  bool ecommerceUpdate = false,
  bool deleteProducts = false,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(ProductStateLoadingAction(true));

      await productService
          .removeCategory(item)
          .catchError((e) {
            reportCheckedError(e, trace: StackTrace.current);
            store.dispatch(ProductStateFailureAction(e.toString()));
            store.dispatch(ProductStateLoadingAction(false));
            completer?.completeError(e);
            return false;
          })
          .then((result) {
            if (result) {
              store.dispatch(
                CategoryChangedAction(
                  item,
                  ChangeType.removed,
                  ecommerceUpdate: ecommerceUpdate,
                  updateProducts: deleteProducts,
                ),
              );

              completer?.complete();
            }

            store.dispatch(ProductStateLoadingAction(false));
          });
    });
  };
}

ThunkAction<AppState> setCategoryAndProductsToOnline(
  StockCategory category, {
  List<StockProduct>? products,
  Completer? completer,
  bool ecommerceUpdate = false,
  BuildContext? context,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        // store.dispatch(ProductStateLoadingAction(true));

        if (products != null) {
          for (var item in products) {
            if (item.isOnline == false) {
              item.isOnline = true;

              store.dispatch(addProduct(product: item));
            }
          }
        }

        category.isOnline = true;

        store.dispatch(
          updateCategoryAndProducts(
            category: category,
            newItems: [],
            deletedItems: [],
            ecommerceUpdate: ecommerceUpdate,
            completer: completer,
            runCompleter: false,
            ctx: context,
          ),
        );

        //store.dispatch(ProductStateLoadingAction(false));

        //completer?.complete();
      } catch (e) {
        reportCheckedError((e as dynamic).message, trace: StackTrace.current);
        var exception = ManagedException(
          message:
              'Please Resolve the following:\n + ${(e as dynamic).message}',
          name: 'Publish Store',
        );

        store.dispatch(ProductStateLoadingAction(false));
        completer?.completeError(exception);

        return;
      }
    });
  };
}

ThunkAction<AppState> updateCategoryAndProducts({
  StockCategory? category,
  List<StockCategory>? categories,
  required List<String?> newItems,
  required List<String?> deletedItems,
  Completer? completer,
  bool runCompleter = true,
  bool ecommerceUpdate = false,
  bool updateProducts = true,
  BuildContext? ctx,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      if (category == null && (categories == null || categories.isEmpty)) {
        return;
      }

      _initializeService(store);
      store.dispatch(ProductStateLoadingAction(true));

      try {
        if (categories != null && categories.isNotEmpty) {
          store.dispatch(SetStoreLoadingAction(true));
          for (var cat in categories) {
            var result = await productService.updateProductsAndCategory(
              cat,
              newItems,
              deletedItems,
            );
            result.products = cat.products;
            result.productCount = cat.productCount;

            store.dispatch(
              CategoryChangedAction(
                result,
                ChangeType.updated,
                deletedItems: deletedItems,
                newItems: newItems,
                ecommerceUpdate: ecommerceUpdate,
                updateProducts: updateProducts,
                ecomCompleter: !runCompleter ? completer : null,
              ),
            );

            _handleEcommerceUpdate(store, cat, ecommerceUpdate, updateProducts);

            cat.isNew = false;
          }
        }

        if (category != null) {
          var result = await productService.updateProductsAndCategory(
            category,
            newItems,
            deletedItems,
          );
          result.products = category.products;
          result.productCount = category.productCount;

          store.dispatch(
            CategoryChangedAction(
              result,
              ChangeType.updated,
              deletedItems: deletedItems,
              newItems: newItems,
              ecommerceUpdate: ecommerceUpdate,
              updateProducts: updateProducts,
              ecomCompleter: !runCompleter ? completer : null,
            ),
          );

          _handleEcommerceUpdate(
            store,
            category,
            ecommerceUpdate,
            updateProducts,
          );

          category.isNew = false;
        }

        store.dispatch(ProductStateLoadingAction(false));

        if (runCompleter) {
          completer?.complete();
        } else {
          Navigator.pop(ctx!);
        }
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        store.dispatch(ProductStateFailureAction(e.toString()));
        store.dispatch(ProductStateLoadingAction(false));
        completer?.completeError(e, StackTrace.current);
      } finally {
        store.dispatch(SetStoreLoadingAction(false));
      }
    });
  };
}

void _handleEcommerceUpdate(
  Store<AppState> store,
  StockCategory category,
  bool ecommerceUpdate,
  bool updateProducts,
) {
  if (ecommerceUpdate && updateProducts) {
    var currentProducts = store.state.productState.products
        ?.where((p) => p.categoryId == category.id)
        .toList();

    if (currentProducts != null && (category.isOnline ?? false)) {
      for (var element in currentProducts) {
        if (!(element.isOnline ?? false)) {
          element.isOnline = true;
          store.dispatch(addProduct(product: element));
        }
      }
    }

    if (currentProducts != null && !(category.isOnline ?? false)) {
      for (var element in currentProducts) {
        if ((element.isOnline ?? false)) {
          element.isOnline = false;
          store.dispatch(addProduct(product: element));
        }
      }
    }
  }
}

ThunkAction<AppState> addCategory({
  required StockCategory category,
  Completer? completer,
  bool ecommerceUpdate = false,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(ProductStateLoadingAction(true));

      await productService
          .addCategory(
            category.name,
            color: category.categoryColor,
            description: category.description,
          )
          .catchError((e) {
            store.dispatch(ProductStateFailureAction(e.toString()));
            reportCheckedError(e, trace: StackTrace.current);

            store.dispatch(ProductStateLoadingAction(false));

            completer?.completeError(e);
            return StockCategory();
          })
          .then((result) {
            store.dispatch(
              CategoryChangedAction(
                category,
                ChangeType.added,
                ecommerceUpdate: ecommerceUpdate,
              ),
            );

            store.dispatch(ProductStateLoadingAction(false));
            completer?.complete();
          });
    });
  };
}

ThunkAction<AppState> createCategory(BuildContext ctx) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(ProductStateLoadingAction(true));

      store.dispatch(CategoryCreateAction());

      store.dispatch(ProductStateLoadingAction(false));

      if (store.state.isLargeDisplay ?? false) {
        showPopupDialog(
          context: ctx,
          content: const ProductCategoryPage(
            isEmbedded: true,
            displayProducts: false,
          ),
        );
      } else {
        Navigator.of(ctx).push(
          CustomRoute(
            maintainState: true,
            builder: (BuildContext context) => ProductCategoryPage(
              displayProducts: false,
              onCategoryUpdate: () {
                store.dispatch(initializeCategories(refresh: true));
                store.dispatch(getProducts(refresh: true));
                store.dispatch(getStockRuns(refresh: true));
              },
            ),
          ),
        );
      }
    });
  };
}

ThunkAction<AppState> editCategory(
  BuildContext ctx,
  StockCategory item,
  CategoriesViewModel vm,
) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(ProductStateLoadingAction(true));

      store.dispatch(CategorySelectAction(item));

      store.dispatch(ProductStateLoadingAction(false));

      if (store.state.isLargeDisplay ?? false) {
      } else {
        Navigator.of(ctx).push(
          CustomRoute(
            maintainState: true,
            builder: (BuildContext context) => ProductCategoryPage(
              parentContext: context,
              onCategoryUpdate: () {
                store.dispatch(initializeCategories(refresh: true));
                store.dispatch(getProducts(refresh: true));
                store.dispatch(getStockRuns(refresh: true));
              },
              vmParent: vm,
            ),
          ),
        );
      }
    });
  };
}

ThunkAction<AppState> addOrUpdateModifier({
  required ProductModifier? item,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      if (item == null) return;

      var modifiers = store.state.productState.modifiers;

      store.dispatch(ProductStateLoadingAction(true));

      if (modifiers != null && modifiers.any((m) => m.id == item.id)) {
        await productService
            .updateModifier(item)
            .catchError((e) {
              reportCheckedError(e, trace: StackTrace.current);
              store.dispatch(ProductStateFailureAction(e.toString()));
              store.dispatch(ProductStateLoadingAction(false));
              completer?.completeError(e);
              return ProductModifier();
            })
            .then((result) {
              store.dispatch(ModifierChangedAction(result, ChangeType.updated));
              store.dispatch(ProductStateLoadingAction(false));
              completer?.complete();
            });

        return;
      }

      await productService
          .addModifier(item)
          .catchError((e) {
            reportCheckedError(e, trace: StackTrace.current);
            store.dispatch(ProductStateFailureAction(e.toString()));
            completer?.completeError(e);
            return ProductModifier();
          })
          .then((result) {
            store.dispatch(ModifierChangedAction(result, ChangeType.added));
            store.dispatch(ProductStateLoadingAction(false));
            completer?.complete();
          });
    });
  };
}

ThunkAction<AppState> createModifier(BuildContext ctx) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(ProductStateLoadingAction(true));

      store.dispatch(ModifierCreateAction());

      store.dispatch(ProductStateLoadingAction(false));

      if (store.state.isLargeDisplay ?? false) {
        showPopupDialog(
          context: ctx,
          content: const ProductModifierPage(isEmbedded: true),
        );
      } else {
        Navigator.of(ctx).push(
          CustomRoute(
            maintainState: true,
            builder: (BuildContext context) => const ProductModifierPage(),
          ),
        );
      }
    });
  };
}

ThunkAction<AppState> editModifer(BuildContext ctx, ProductModifier item) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(ProductStateLoadingAction(true));

      store.dispatch(ModifierSelectAction(item));

      store.dispatch(ProductStateLoadingAction(false));

      if (store.state.isLargeDisplay ?? false) {
        // showDialog(
        //   context: ctx,
        //   builder: (ctx) => ProductModifierPage(),
        // );
      } else {
        Navigator.of(ctx).push(
          CustomRoute(
            maintainState: true,
            builder: (BuildContext context) => const ProductModifierPage(),
          ),
        );
      }
    });
  };
}

ThunkAction<AppState> removeModifier({
  required ProductModifier item,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(ProductStateLoadingAction(true));

      await productService
          .removeModifider(item.id)
          .catchError((e) {
            reportCheckedError(e, trace: StackTrace.current);
            store.dispatch(ProductStateFailureAction(e.toString()));
            completer?.completeError(e);
            return false;
          })
          .then((result) {
            store.dispatch(ModifierChangedAction(item, ChangeType.removed));

            completer?.complete();
          });

      store.dispatch(ProductStateLoadingAction(false));
    });
  };
}

ThunkAction<AppState> addOrUpdateCombo({
  required ProductCombo? item,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      if (item == null) return;

      _initializeService(store);

      store.dispatch(ProductStateLoadingAction(true));

      await productService
          .createOrUpdateCombo(item)
          .catchError((e) {
            reportCheckedError(e, trace: StackTrace.current);
            store.dispatch(ProductStateFailureAction(e.toString()));

            store.dispatch(ProductStateLoadingAction(false));

            completer?.completeError(e);
            return ProductCombo();
          })
          .then((result) {
            store.dispatch(ComboModifiedAction(result, ChangeType.added));

            store.dispatch(ProductStateLoadingAction(false));

            completer?.complete();
          });
    });
  };
}

ThunkAction<AppState> removeCombo({
  required ProductCombo item,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(ProductStateLoadingAction(true));

      await productService
          .removeCombo(item.id)
          .catchError((e) {
            store.dispatch(ProductStateFailureAction(e.toString()));
            reportCheckedError(e, trace: StackTrace.current);

            store.dispatch(ProductStateLoadingAction(false));

            completer?.completeError(e);
            return false;
          })
          .then((result) {
            if (result) {
              store.dispatch(ComboModifiedAction(item, ChangeType.removed));

              store.dispatch(ProductStateLoadingAction(false));

              completer?.complete();
            } else {
              store.dispatch(ProductStateLoadingAction(false));
            }
          });
    });
  };
}

ThunkAction<AppState> createCombo(BuildContext ctx) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(ProductStateLoadingAction(true));

      store.dispatch(ComboCreateAction());

      store.dispatch(ProductStateLoadingAction(false));

      if (store.state.isLargeDisplay ?? false) {
        showPopupDialog(
          context: ctx,
          content: const ProductComboPage(isEmbedded: true),
          defaultPadding: false,
        );
      } else {
        Navigator.of(ctx).push(
          CustomRoute(
            maintainState: true,
            builder: (BuildContext context) => const ProductComboPage(),
          ),
        );
      }
    });
  };
}

ThunkAction<AppState> editCombo(BuildContext ctx, ProductCombo item) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(ProductStateLoadingAction(true));

      store.dispatch(ComboSelectAction(item));

      store.dispatch(ProductStateLoadingAction(false));

      if (store.state.isLargeDisplay ?? false) {
        // showPopupDialog(
        //   context: ctx,
        //   content: ProductComboPage(isEmbedded: true),
        // );
      } else {
        Navigator.of(ctx).push(
          CustomRoute(
            maintainState: true,
            builder: (BuildContext context) => const ProductComboPage(),
          ),
        );
      }
    });
  };
}

ThunkAction<AppState> setProductFavouriteStatus({
  required StockProduct item,
  required bool value,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);
      store.dispatch(ProductStateLoadingAction(true));

      await productService
          .markFavouriteStatus(item: item, value: value)
          .catchError((e) {
            store.dispatch(ProductStateFailureAction(e.toString()));

            reportCheckedError(e, trace: StackTrace.current);
            store.dispatch(ProductStateLoadingAction(false));

            completer?.completeError(e);
            return false;
          })
          .then((result) {
            if (result) {
              store.dispatch(
                ProductChangedAction(
                  item..favourite = value,
                  ChangeType.updated,
                ),
              );

              store.dispatch(ProductStateLoadingAction(false));

              completer?.complete();
            } else {
              store.dispatch(ProductStateLoadingAction(false));
            }
          });
    });
  };
}

ThunkAction<AppState> fetchProductVariantByDisplayName({
  required String parentProductId,
  required String displayName,
  bool refresh = true,
  Completer<StockProduct>? completer,
}) {
  return (Store<AppState> store) async {
    try {
      if (parentProductId.isEmpty || displayName.isEmpty) {
        completer?.completeError(
          ArgumentError(
            'Invalid parent product or variant information, please try again.',
          ),
        );
        return;
      }

      _initializeService(store);
      store.dispatch(ProductStateLoadingAction(true));

      // TODO: Leaving state fetching until we have a way to sync variant changes from web to app.
      // var productState = store.state.productState;
      // var productVariantsMap = productState.productVariants ?? {};
      // if (!refresh && productVariantsMap.containsKey(parentProductId)) {
      //   var variantInState =
      //       productVariantsMap[parentProductId]!.firstWhereOrNull(
      //     (v) => v.displayName?.toLowerCase() == displayName.toLowerCase(),
      //   );
      //   if (variantInState != null) {
      //     store.dispatch(ProductStateLoadingAction(false));
      //     completer?.complete(variantInState);
      //     return;
      //   }
      // }

      var variant = await productService.getProductVariantByDisplayName(
        parentId: parentProductId,
        displayName: displayName,
      );

      store.dispatch(AddVariantToStateAction(parentProductId, variant));

      store.dispatch(ProductStateLoadingAction(false));
      completer?.complete(variant);
    } on NoDataException catch (e) {
      reportCheckedError(e, trace: StackTrace.current);
      showMessageDialog(
        globalNavigatorKey.currentContext!,
        'No variant found, please ensure the variant exists or try again.',
        LittleFishIcons.error,
        status: StatusType.destructive,
      );
      store.dispatch(ProductStateLoadingAction(false));
      completer?.completeError(e);
    } catch (e) {
      reportCheckedError(e, trace: StackTrace.current);
      completer?.completeError(e);
      store.dispatch(ProductStateLoadingAction(false));
    }
  };
}

ThunkAction<AppState> getProductByBarcode({
  required String barcode,
  Completer<StockProduct?>? completer,
}) {
  return (Store<AppState> store) async {
    try {
      if (barcode.isEmpty) {
        completer?.completeError(
          ArgumentError(
            'Unable to find a product because the barcode is empty, please try again.',
          ),
        );
        return;
      }

      _initializeService(store);
      store.dispatch(ProductStateLoadingAction(true));

      var productState = store.state.productState;
      var productFromState = productState.getProductByBarcode(barcode);

      if (productFromState != null) {
        store.dispatch(ProductStateLoadingAction(false));
        completer?.complete(productFromState);
        return;
      }

      if (AppVariables.enableProductVariance) {
        productFromState = productState.getProductVariantByBarcode(barcode);
      }

      if (productFromState != null) {
        store.dispatch(ProductStateLoadingAction(false));
        completer?.complete(productFromState);
        return;
      }

      var product = await productService.getProductByBarcode(barcode: barcode);

      if (product == null) {
        store.dispatch(ProductStateLoadingAction(false));
        completer?.complete(null);
        return;
      }

      bool isVariant = isNotBlank(product.parentId);
      if (isVariant) {
        if (AppVariables.enableProductVariance) {
          store.dispatch(AddVariantToStateAction(product.parentId!, product));
          completer?.complete(product);
        } else {
          completer?.complete(null);
        }
      } else {
        store.dispatch(ProductChangedAction(product, ChangeType.added));
        completer?.complete(product);
      }

      store.dispatch(ProductStateLoadingAction(false));
    } catch (e) {
      reportCheckedError(e, trace: StackTrace.current);
      completer?.completeError(e);
      store.dispatch(ProductStateLoadingAction(false));
    }
  };
}

_initializeService(Store<AppState> store) {
  productService = ProductService(
    store: store,
    baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
    token: store.state.authState.token,
    businessId: store.state.currentBusinessId,
    currentLocale: store.state.localeState.currentLocale,
  );
}

class AddVariantToStateAction {
  String parentId;
  StockProduct variant;

  AddVariantToStateAction(this.parentId, this.variant);
}

class ClearProductVariantsByParentIdAction {
  String parentId;

  ClearProductVariantsByParentIdAction(this.parentId);
}

class ProductsLoadedAction {
  List<StockProduct>? value;

  ProductsLoadedAction(this.value);
}

class ProductStateFailureAction {
  String value;

  ProductStateFailureAction(this.value);
}

class ProductStateLoadingAction {
  bool value;

  ProductStateLoadingAction(this.value);
}

class SetProductSortOptionsAction {
  SortBy type;
  SortOrder order;

  SetProductSortOptionsAction(this.order, this.type);
}

class ProductChangedAction {
  StockProduct value;

  ChangeType changeType;

  bool? updatedByCategory;

  Completer? ecomCompleter;

  ProductChangedAction(
    this.value,
    this.changeType, {
    this.updatedByCategory,
    this.ecomCompleter,
  });
}

class ProductsTabIndexAction {
  int value;

  ProductsTabIndexAction(this.value);
}

class ProductStockAdjustmentAction {
  String productId;

  String varianceId;

  double value;

  ProductStockAdjustmentAction(this.productId, this.varianceId, this.value);
}

class CategoriesLoadedAction {
  List<StockCategory> value;

  CategoriesLoadedAction(this.value);
}

class CategoryChangedAction {
  StockCategory value;

  List<String?>? newItems;

  List<String?>? deletedItems;

  List<String?>? updatedItems;

  ChangeType changeType;

  bool? ecommerceUpdate;

  bool? updateProducts;

  Completer? ecomCompleter;

  CategoryChangedAction(
    this.value,
    this.changeType, {
    this.newItems,
    this.deletedItems,
    this.ecommerceUpdate,
    this.updateProducts,
    this.ecomCompleter,
  });
}

class SetCategoryAction {
  StockCategory value;

  SetCategoryAction(this.value);
}

class ModifiersLoadedAction {
  List<ProductModifier>? value;

  ModifiersLoadedAction(this.value);
}

class ModifierChangedAction {
  ProductModifier value;

  ChangeType changeType;

  ModifierChangedAction(this.value, this.changeType);
}

class CombosLoadedAction {
  List<ProductCombo>? value;

  CombosLoadedAction(this.value);
}

class ComboModifiedAction {
  ProductCombo value;

  ChangeType changeType;

  ComboModifiedAction(this.value, this.changeType);
}

class UpdateProductsAction {
  List<StockProduct> value;

  UpdateProductsAction(this.value);
}

//UI Actions
class ProductSelectAction {
  StockProduct value;

  ProductSelectAction(this.value);
}

class ProductCreateAction {}

class ModifierSelectAction {
  ProductModifier value;

  ModifierSelectAction(this.value);
}

class ModifierCreateAction {}

class CategorySelectAction {
  StockCategory value;

  CategorySelectAction(this.value);
}

class CategoryCreateAction {}

class ComboSelectAction {
  ProductCombo value;

  ComboSelectAction(this.value);
}

class ComboCreateAction {}

class SetProductFavouriteAction {
  StockProduct item;

  bool value;

  SetProductFavouriteAction(this.item, this.value);
}

class BatchUpsertProductsAction {
  List<StockProduct> products;

  BatchUpsertProductsAction(this.products);
}

class BatchDeleteProductsAction {
  List<StockProduct> products;

  BatchDeleteProductsAction(this.products);
}

class ResetCategoryAction {}

class SetFullProductsAction {
  final List<FullProduct> fullProducts;

  SetFullProductsAction(this.fullProducts);
}

class SetAllOptionAttributesAction {
  final List<ProductOptionAttribute> optionAttributes;

  SetAllOptionAttributesAction(this.optionAttributes);
}

class AddProductOptionAttributeAction {
  final ProductOptionAttribute optionAttribute;

  AddProductOptionAttributeAction(this.optionAttribute);
}

class DeleteProductOptionAttributeAction {
  final ProductOptionAttribute optionAttribute;

  DeleteProductOptionAttributeAction(this.optionAttribute);
}

class SetProductWithOptionsAction {
  final FullProduct productWithOptions;

  SetProductWithOptionsAction(this.productWithOptions);
}

class ClearProductWithOptionsAction {}
