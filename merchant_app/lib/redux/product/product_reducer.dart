// removed ignore: depend_on_referenced_packages

import 'package:collection/collection.dart' show IterableExtension;
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:quiver/strings.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/products/product_combo.dart';
import 'package:littlefish_merchant/models/products/product_modifier.dart';
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_actions.dart';
import 'package:littlefish_merchant/redux/inventory/inventory_actions.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_merchant/redux/product/product_state.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:uuid/uuid.dart';

import '../../models/stock/stock_take_item.dart';

LittleFishCore core = LittleFishCore.instance;

LoggerService logger = LittleFishCore.instance.get<LoggerService>();

final productReducer = combineReducers<ProductState>([
  TypedReducer<ProductState, ProductStateLoadingAction>(onSetLoading).call,
  TypedReducer<ProductState, ProductsLoadedAction>(onProductsLoaded).call,
  TypedReducer<ProductState, CategoriesLoadedAction>(onCategoriesLoaded).call,
  TypedReducer<ProductState, ProductStateFailureAction>(onFailure).call,
  TypedReducer<ProductState, ProductChangedAction>(onProductChanged).call,
  TypedReducer<ProductState, CategoryChangedAction>(onCategoryChanged).call,
  TypedReducer<ProductState, ModifiersLoadedAction>(onModifiersLoaded).call,
  TypedReducer<ProductState, ModifierChangedAction>(onModifierChanged).call,
  TypedReducer<ProductState, CombosLoadedAction>(onCombosLoaded).call,
  TypedReducer<ProductState, ComboModifiedAction>(onComboModified).call,
  TypedReducer<ProductState, InventoryRunUploadedAction>(
    onInventoryChanged,
  ).call,
  TypedReducer<ProductState, RecievablesCancelledAction>(
    onInventoryCancelled,
  ).call,
  TypedReducer<ProductState, RecievablesUploadedAction>(
    onInventoryReceived,
  ).call,
  TypedReducer<ProductState, ProductsTabIndexAction>(onSetProductTabIndex).call,
  TypedReducer<ProductState, SignoutAction>(onClearState).call,
  TypedReducer<ProductState, CheckoutPushSaleCompletedAction>(
    onSaleComplete,
  ).call,
  TypedReducer<ProductState, RefundSaleAction>(onRefundComplete).call,
  TypedReducer<ProductState, CheckoutSaleCancelledAction>(onSaleCancelled).call,
  TypedReducer<ProductState, BatchUpsertProductsAction>(
    onBatchUpsertProducts,
  ).call,
  TypedReducer<ProductState, BatchDeleteProductsAction>(
    onBatchDeleteProducts,
  ).call,
  TypedReducer<ProductState, SetProductSortOptionsAction>(
    onSetSortOptions,
  ).call,
  TypedReducer<ProductState, SetFullProductsAction>(onSetFullProducts).call,
  TypedReducer<ProductState, SetAllOptionAttributesAction>(
    onSetAllOptionAttributes,
  ).call,
  TypedReducer<ProductState, SetProductWithOptionsAction>(
    onSetProductWithOptions,
  ).call,
  TypedReducer<ProductState, AddProductOptionAttributeAction>(
    onAddProductOptionAttribute,
  ).call,
  TypedReducer<ProductState, DeleteProductOptionAttributeAction>(
    onDeleteProductOptionAttribute,
  ).call,
  TypedReducer<ProductState, ClearProductWithOptionsAction>(
    onClearProductWithOptions,
  ).call,
  TypedReducer<ProductState, AddVariantToStateAction>(onAddVariantToState).call,
  TypedReducer<ProductState, ClearProductVariantsByParentIdAction>(
    onClearProductVariantsByParentId,
  ).call,
  TypedReducer<ProductState, SetCategoryAction>(onSetCategory).call,
]);

ProductState onSetCategory(ProductState state, SetCategoryAction action) {
  return state.rebuild((b) {
    int categoryIndex = b.categories!.indexWhere(
      (c) => c.id == action.value.id,
    );

    if (categoryIndex == -1) {
      return;
    }

    b.categories![categoryIndex] = action.value;
  });
}

ProductState onClearProductVariantsByParentId(
  ProductState state,
  ClearProductVariantsByParentIdAction action,
) {
  return state.rebuild((b) {
    if (action.parentId.isEmpty) return;

    Map<String, List<StockProduct>> productVariants =
        Map<String, List<StockProduct>>.from(b.productVariants ?? {});

    productVariants.removeWhere(
      (key, value) => key.toLowerCase() == action.parentId.toLowerCase(),
    );

    b.productVariants = productVariants;
  });
}

ProductState onAddVariantToState(
  ProductState state,
  AddVariantToStateAction action,
) {
  return state.rebuild((b) {
    if (isBlank(action.parentId)) return;
    var productVariants = Map<String, List<StockProduct>>.from(
      b.productVariants ?? {},
    );

    final variants = productVariants[action.parentId] ?? <StockProduct>[];
    final existingIndex = variants.indexWhere((v) => v.id == action.variant.id);
    if (existingIndex >= 0) {
      // Update the existing variant
      variants[existingIndex] = action.variant;
    } else {
      // Add new variant
      variants.add(action.variant);
    }
    productVariants[action.parentId] = variants;
    b.productVariants = productVariants;
  });
}

ProductState onClearProductWithOptions(
  ProductState state,
  ClearProductWithOptionsAction action,
) => state.rebuild((b) {
  b.productWithOptions = null;
});

ProductState onAddProductOptionAttribute(
  ProductState state,
  AddProductOptionAttributeAction action,
) => state.rebuild((b) {
  List<ProductOptionAttribute> productOptionAttributes = List.from(
    b.productWithOptions?.product.productOptionAttributes ?? [],
  );
  productOptionAttributes.add(action.optionAttribute);
  b.productWithOptions?.product.productOptionAttributes =
      productOptionAttributes;
});

ProductState onDeleteProductOptionAttribute(
  ProductState state,
  DeleteProductOptionAttributeAction action,
) => state.rebuild((b) {
  List<ProductOptionAttribute> productOptionAttributes = List.from(
    b.productWithOptions?.product.productOptionAttributes ?? [],
  );
  productOptionAttributes.removeWhere(
    (element) => element.option == action.optionAttribute.option,
  );
  b.productWithOptions?.product.productOptionAttributes =
      productOptionAttributes;
});

ProductState onSetProductWithOptions(
  ProductState state,
  SetProductWithOptionsAction action,
) => state.rebuild((b) {
  b.productWithOptions = action.productWithOptions;
});

ProductState onSetAllOptionAttributes(
  ProductState state,
  SetAllOptionAttributesAction action,
) => state.rebuild((b) {
  b.allOptionAttributes = action.optionAttributes;
});

ProductState onInventoryChanged(
  ProductState state,
  InventoryRunUploadedAction action,
) => state.rebuild((builder) {
  for (var stockItem in action.value.items!) {
    if (builder.products!.any((product) => product.id == stockItem.productId)) {
      var product = builder.products!
          .where((p) => p.id == stockItem.productId)
          .first;

      switch (stockItem.type) {
        case StockRunType.reCount:
        case StockRunType.otherIncrease:
        case StockRunType.returnedStock:
          product.regularItemQuantity += stockItem.stockCount ?? 0;
          break;
        case StockRunType.theft:
        case StockRunType.damagedStock:
        case StockRunType.otherDecrease:
          product.regularItemQuantity -= stockItem.stockCount ?? 0;
          break;
        default:
          product.regularItemQuantity = stockItem.stockCount ?? 0;
      }
    }
  }
});

ProductState onInventoryCancelled(
  ProductState state,
  RecievablesCancelledAction action,
) => state.rebuild((b) {
  for (var i in action.value.items!) {
    var dd = i.totalUnits;
    var ind = b.products!.indexWhere((element) => element.id == i.productId);

    if (ind != -1) b.products![ind].regularItemQuantity -= dd;
  }
});

ProductState onInventoryReceived(
  ProductState state,
  RecievablesUploadedAction action,
) => state.rebuild((b) {
  for (var i in action.value.items!) {
    if (b.products!.any((p) => p.id == i.productId)) {
      b.products!.where((p) => p.id == i.productId).first.regularItemQuantity +=
          i.totalUnits.floor();
    }
  }
});

ProductState onSetProductTabIndex(
  ProductState state,
  ProductsTabIndexAction action,
) => state.rebuild((b) => b.tabIndex = action.value);

ProductState onClearState(ProductState state, SignoutAction action) =>
    state.rebuild((b) {
      b.isLoading = false;
      b.hasError = false;
      b.errorMessage = null;

      b.products = [];
      b.categories = [];
      b.productCombos = [];
      b.modifiers = [];
      b.fullProducts = [];
      b.productWithOptions = null;
      b.allOptionAttributes = [];
    });

ProductState onSetLoading(
  ProductState state,
  ProductStateLoadingAction action,
) => state.rebuild((b) => b.isLoading = action.value);

ProductState onProductsLoaded(ProductState state, ProductsLoadedAction action) {
  logger.debug(
    'products-reducer',
    'products loaded action recieved, ${action.value?.length ?? 0} retrieved',
  );

  return state.rebuild((b) {
    b.products = action.value;
    b.isLoading = false;
    b.hasError = false;
  });
}

ProductState onCategoriesLoaded(
  ProductState state,
  CategoriesLoadedAction action,
) => state.rebuild((b) {
  b.categories = action.value;
  b.isLoading = false;
  b.hasError = false;
});

ProductState onFailure(ProductState state, ProductStateFailureAction action) =>
    state.rebuild((b) {
      b.hasError = true;
      b.errorMessage = action.value;
      b.isLoading = false;
    });

ProductState onSetSortOptions(
  ProductState state,
  SetProductSortOptionsAction action,
) => state.rebuild((b) {
  b.sortBy = action.type;
  b.sortOrder = action.order;
});

ProductState onProductChanged(ProductState state, ProductChangedAction action) {
  return state.rebuild((b) {
    if (action.value.isOnline == false) {
      b.products?.firstWhereOrNull((element) => element.id == action.value.id);
    }

    b.products = action.changeType == ChangeType.removed
        ? removeProduct(action.value, b.products)
        : addOrUpdateProduct(action.value, b.products ?? <StockProduct>[]);
  });
}

ProductState onBatchUpsertProducts(
  ProductState state,
  BatchUpsertProductsAction action,
) {
  return state.rebuild((b) {
    if (action.products.isEmpty) return;
    for (StockProduct product in action.products) {
      addOrUpdateProduct(product, state.products ?? []);
    }
  });
}

ProductState onBatchDeleteProducts(
  ProductState state,
  BatchDeleteProductsAction action,
) {
  return state.rebuild((b) {
    if (action.products.isEmpty) return;
    for (StockProduct product in action.products) {
      removeProduct(product, state.products ?? []);
    }
  });
}

ProductState onCategoryChanged(
  ProductState state,
  CategoryChangedAction action,
) {
  return state.rebuild((b) {
    List<StockProduct> emptyList = [];
    List<StockProduct> deletedProductsList = [];

    for (var element in b.products!) {
      if (element.categoryId == action.value.id && element.isOnline!) {
        emptyList.add(StockProduct());
      }
    }

    if (action.value.isOnline == false) {
      var currentCat = b.categories?.firstWhereOrNull(
        (element) => element.id == action.value.id,
      );

      if (currentCat?.isOnline == true &&
          (action.ecommerceUpdate ?? false) == true) {
        var products = (action.updateProducts ?? true)
            ? b.products
                  ?.where(
                    (element) => element.categoryId == action.value.id,
                    //&& element.isOnline == true
                  )
                  .toList()
            : emptyList;

        AppVariables.store!.dispatch(
          upsertEcommerceProductCategory(
            action.value,
            products: products,
            changeType: action.changeType,
            completer: action.ecomCompleter,
          ),
        );
      }
    }

    b.categories = action.changeType == ChangeType.removed
        ? removeCategory(action.value, b.categories)
        : addOrUpdateCategory(action.value, b.categories);

    if (action.changeType == ChangeType.removed) {
      b.products!.where((p) => p.categoryId == action.value.id).forEach((p) {
        p.categoryId = null;
        deletedProductsList.add(p);
      });
    } else if (action.changeType == ChangeType.updated) {
      if (action.newItems != null && action.newItems!.isNotEmpty) {
        for (var p in action.newItems!) {
          b.products!
              .where((product) => product.id == p)
              .forEach((p) => p.categoryId = action.value.id);
        }
      }

      if (action.deletedItems != null && action.deletedItems!.isNotEmpty) {
        for (var p in action.deletedItems!) {
          b.products!
              .where((product) => product.id == p)
              .forEach((p) => p.categoryId = null);
        }
      }
    }

    if (action.value.isOnline == true &&
        (action.ecommerceUpdate ?? false) == true) {
      var products = (action.updateProducts ?? true)
          ? b.products
                ?.where(
                  (element) => element.categoryId == action.value.id,
                  //&& element.isOnline == true
                )
                .toList()
          : emptyList;

      if ((action.updateProducts ?? true) &&
          action.changeType == ChangeType.removed) {
        deletedProductsList = deletedProductsList.map((e) {
          e.isOnline = false;
          return e;
        }).toList();

        products = deletedProductsList;
      }

      AppVariables.store!.dispatch(
        upsertEcommerceProductCategory(
          action.value,
          products: products,
          changeType: action.changeType,
          completer: action.ecomCompleter,
        ),
      );
    }
  });
}

ProductState onSetFullProducts(
  ProductState state,
  SetFullProductsAction action,
) => state.rebuild((b) => b.fullProducts = action.fullProducts);

ProductState onModifiersLoaded(
  ProductState state,
  ModifiersLoadedAction action,
) => state.rebuild((b) => b.modifiers = action.value);

ProductState onModifierChanged(
  ProductState state,
  ModifierChangedAction action,
) {
  return state.rebuild((b) {
    b.modifiers = action.changeType == ChangeType.removed
        ? removeModifier(action.value, b.modifiers)
        : addOrUpdateModifier(action.value, b.modifiers);
  });
}

ProductState onCombosLoaded(ProductState state, CombosLoadedAction action) =>
    state.rebuild((b) => b.productCombos = action.value);

ProductState onComboModified(ProductState state, ComboModifiedAction action) {
  return state.rebuild((b) {
    b.productCombos = action.changeType == ChangeType.removed
        ? removeCombo(action.value, b.productCombos)
        : addOrUpdateCombo(action.value, b.productCombos);
  });
}

List<ProductCombo> addOrUpdateCombo(
  ProductCombo value,
  List<ProductCombo>? state,
) {
  var index = state!.indexWhere((p) => p.id == value.id);
  if (index >= 0) {
    state[index] = value;
  } else {
    state.add(value);
  }

  return state;
}

List<ProductCombo> removeCombo(ProductCombo value, List<ProductCombo>? state) {
  state!.removeWhere((p) => p.id == value.id);

  return state;
}

List<ProductModifier> addOrUpdateModifier(
  ProductModifier value,
  List<ProductModifier>? state,
) {
  var index = state!.indexWhere((p) => p.id == value.id);
  if (index >= 0) {
    state[index] = value;
  } else {
    state.add(value);
  }

  return state;
}

List<ProductModifier> removeModifier(
  ProductModifier value,
  List<ProductModifier>? state,
) {
  state!.removeWhere((p) => p.id == value.id);

  return state;
}

List<StockCategory> addOrUpdateCategory(
  StockCategory value,
  List<StockCategory>? state,
) {
  var index = state!.indexWhere((p) => p.id == value.id);
  if (index >= 0) {
    state[index] = value;
  } else {
    state.add(value);
  }

  return state;
}

List<StockCategory> removeCategory(
  StockCategory value,
  List<StockCategory>? state,
) {
  state!.removeWhere((p) => p.id == value.id);

  return state;
}

List<StockProduct> addOrUpdateProduct(
  StockProduct value,
  List<StockProduct> state,
) {
  var productIndex = state.indexWhere((p) => p.id == value.id);
  if (productIndex >= 0) {
    state[productIndex] = value;
  } else {
    state.add(value);
  }

  return state;
}

List<StockProduct> removeProduct(
  StockProduct value,
  List<StockProduct>? state,
) {
  state!.removeWhere((p) => p.id == value.id);

  return state;
}

//UI REDUCERS
final productsUIReducer = combineReducers<ProductsUIState>([
  TypedReducer<ProductsUIState, ProductSelectAction>(onSelectProduct).call,
  TypedReducer<ProductsUIState, ProductChangedAction>(onUIProductChanged).call,
  TypedReducer<ProductsUIState, ProductCreateAction>(onUIProductCreate).call,
]);

ProductsUIState onSelectProduct(
  ProductsUIState state,
  ProductSelectAction action,
) {
  return state.rebuild((b) => b.item = action.value);
}

ProductsUIState onUIProductChanged(
  ProductsUIState state,
  ProductChangedAction action,
) => state.rebuild(
  (b) => b.item = StockProduct.create(
    businessId: AppVariables.store!.state.businessId,
    id: const Uuid().v4(),
  ),
);

ProductsUIState onUIProductCreate(
  ProductsUIState state,
  ProductCreateAction action,
) => state.rebuild(
  (b) => b.item = StockProduct.create(
    businessId: AppVariables.store!.state.businessId,
    id: const Uuid().v4(),
  ),
);

final modifiersUIReducer = combineReducers<ModifierUIState>([
  TypedReducer<ModifierUIState, ModifierSelectAction>(onSelectModifier).call,
  TypedReducer<ModifierUIState, ModifierChangedAction>(onUIModChanged).call,
  TypedReducer<ModifierUIState, ModifierCreateAction>(onUINewMod).call,
]);

ModifierUIState onSelectModifier(
  ModifierUIState state,
  ModifierSelectAction action,
) {
  return state.rebuild((b) {
    b.item = action.value;
  });
}

ModifierUIState onUIModChanged(
  ModifierUIState state,
  ModifierChangedAction action,
) => state.rebuild((b) => b.item = ProductModifier.create());

ModifierUIState onUINewMod(
  ModifierUIState state,
  ModifierCreateAction action,
) => state.rebuild((b) => b.item = ProductModifier.create());

final categoryUIReducer = combineReducers<CategoriesUIState>([
  TypedReducer<CategoriesUIState, CategorySelectAction>(onSelectCategory).call,
  TypedReducer<CategoriesUIState, CategoryCreateAction>(onResetCategory).call,
  TypedReducer<CategoriesUIState, CategoryChangedAction>(
    onUICategoryChanged,
  ).call,
  TypedReducer<CategoriesUIState, ResetCategoryAction>(onResetCategory).call,
  TypedReducer<CategoriesUIState, SetCategoryAction>(onSetUICategory).call,
]);

CategoriesUIState onSelectCategory(
  CategoriesUIState state,
  CategorySelectAction action,
) {
  return state.rebuild((b) {
    b.item = action.value;
  });
}

CategoriesUIState onUICategoryChanged(
  CategoriesUIState state,
  CategoryChangedAction action,
) {
  return state.rebuild((b) {
    b.item = action.value;
  });
}

CategoriesUIState onSetUICategory(
  CategoriesUIState state,
  SetCategoryAction action,
) {
  return state.rebuild((b) {
    b.item = action.value;
  });
}

CategoriesUIState onResetCategory(CategoriesUIState state, dynamic action) =>
    state.rebuild((b) => b.item = StockCategory.create());

final comboUIReducer = combineReducers<CombosUIState>([
  TypedReducer<CombosUIState, ComboSelectAction>(onSelectCombo).call,
  TypedReducer<CombosUIState, ComboModifiedAction>(onResetCombo).call,
  TypedReducer<CombosUIState, ComboCreateAction>(onResetCombo).call,
]);

CombosUIState onSelectCombo(CombosUIState state, ComboSelectAction action) =>
    state.rebuild((b) {
      b.item = action.value;
    });

CombosUIState onResetCombo(CombosUIState state, dynamic action) =>
    state.rebuild((b) => b.item = ProductCombo.create());

ProductState onSaleCancelled(
  ProductState state,
  CheckoutSaleCancelledAction action,
) {
  if (action.transaction.items!.any(
    (i) =>
        i.isCombo! || i.productId != null || (i.productId?.isNotEmpty ?? false),
  )) {
    //here we have work to do :)

    return state.rebuild((b) {
      //re-create the temp product list
      var products = List<StockProduct>.from(b.products!);

      for (var item in action.transaction.items!) {
        if (item.productId != null && item.productId!.isNotEmpty) {
          _subtractProductQuantity(
            products,
            item.productId,
            item.quantity,
            varianceId: item.varianceId,
          );
        } else if ((item.isCombo) ?? false) {
          var combo = b.productCombos!.firstWhereOrNull(
            (c) => c.id == item.comboId,
          );

          if (combo == null) continue;

          //need to look at the items in the combo and make the adjustment
          for (var cItem in combo.items!) {
            if (cItem.productId != null) {
              _subtractProductQuantity(
                products,
                cItem.productId,
                cItem.quantity! * item.quantity,
              );
            }
          }
        } else if ((item.isPromotion ?? false)) {
          continue;
        } else if ((item.isCustomSale ?? false) || (item.isService ?? false)) {
          continue;
        }
      }

      //add the applicable changes back
      b.products = products;
    });
  } else {
    return state;
  }
}

ProductState onSaleComplete(
  ProductState state,
  CheckoutPushSaleCompletedAction action,
) {
  if (!action.success) return state;

  if (action.transaction.items!.any(
    (i) =>
        i.isCombo! || i.productId != null || (i.productId?.isNotEmpty ?? false),
  )) {
    //here we have work to do :)

    return state.rebuild((b) {
      //re-create the temp product list
      var products = List<StockProduct>.from(b.products!);

      for (var item in action.transaction.items!) {
        if (item.productId != null && item.productId!.isNotEmpty) {
          _adjustProductQuantity(
            products,
            item.productId,
            item.quantity,
            varianceId: item.varianceId,
          );
        } else if ((item.isCombo) ?? false) {
          var combo = b.productCombos!.firstWhereOrNull(
            (c) => c.id == item.comboId,
          );

          if (combo == null) continue;

          //need to look at the items in the combo and make the adjustment
          for (var cItem in combo.items!) {
            if (cItem.productId != null) {
              _adjustProductQuantity(
                products,
                cItem.productId,
                cItem.quantity! * item.quantity,
              );
            }
          }
        } else if ((item.isPromotion ?? false)) {
          continue;
        } else if ((item.isCustomSale ?? false) || (item.isService ?? false)) {
          continue;
        }
      }

      //add the applicable changes back
      b.products = products;
    });
  } else {
    return state;
  }
}

ProductState onRefundComplete(ProductState state, RefundSaleAction action) {
  if (action.value.items!.any(
    (i) => i.isCombo! || i.productId != null || isNotBlank(i.productId),
  )) {
    return state.rebuild((b) {
      var products = List<StockProduct>.from(b.products!);
      if (action.refund.items != null) {
        for (var refund in action.refund.items!) {
          CheckoutCartItem? cartItem = action.value.items!.firstWhere(
            (element) => element.id == refund.checkoutCartItemId,
          );

          if (isNotEmpty(cartItem.productId)) {
            _adjustProductQuantity(
              products,
              cartItem.productId,
              refund.quantity,
              varianceId: cartItem.varianceId,
              isRefund: true,
            );
          } else if ((cartItem.isCombo) ?? false) {
            var combo = b.productCombos!.firstWhereOrNull(
              (c) => c.id == cartItem.comboId,
            );

            if (combo == null) return;
            for (final cItem in combo.items!) {
              if (cItem.productId != null) {
                _adjustProductQuantity(
                  products,
                  cItem.productId,
                  cItem.quantity! * refund.quantity!,
                  isRefund: true,
                );
              }
            }
          } else if ((cartItem.isPromotion ?? false)) {
            return;
          } else if ((cartItem.isCustomSale ?? false) ||
              (cartItem.isService ?? false)) {
            return;
          }
        }
      }
      b.products = products;
    });
  } else {
    return state;
  }
}

StockProduct? _adjustProductQuantity(
  List<StockProduct> products,
  String? productId,
  double? value, {
  String? varianceId,
  bool? isRefund = false,
}) {
  //we need to reduce the product count
  var product = products.firstWhereOrNull((p) => p.id == productId);

  //no matching product
  if (product == null) return null;

  var variance = varianceId == null
      ? product.regularVariance
      : product.getProductVarianceById(varianceId);

  if (variance == null) return null;

  //subtract the quantity from the relevent variance only
  if (product.isStockTrackable ?? true) {
    if ((isRefund ?? false)) {
      variance.quantity = (variance.quantity ?? 0) + (value ?? 0);
    } else {
      variance.quantity = (variance.quantity ?? 0) - (value ?? 0);
    }
    variance.quantity = variance.quantityAsNonNegative;
  }

  return product;
}

StockProduct? _subtractProductQuantity(
  List<StockProduct> products,
  String? productId,
  double? value, {
  String? varianceId,
}) {
  //we need to reduce the product count
  var product = products.firstWhereOrNull((p) => p.id == productId);

  //no matching product
  if (product == null) return null;

  var variance = varianceId == null
      ? product.regularVariance
      : product.getProductVarianceById(varianceId);

  if (variance == null) return null;

  //subtract the quantity from the relevent variance only
  variance.quantity = (variance.quantity ?? 0) + value!;
  variance.quantity = variance.quantityAsNonNegative;

  return product;
}
