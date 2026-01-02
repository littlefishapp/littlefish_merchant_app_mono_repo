// Flutter imports:
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:built_value/built_value.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/models/enums.dart';

// Project imports:
import 'package:littlefish_merchant/models/products/product_combo.dart';
import 'package:littlefish_merchant/models/products/product_modifier.dart';
import 'package:littlefish_merchant/models/stock/full_product.dart';
import 'package:littlefish_merchant/models/stock/product_option.dart';
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';

part 'product_state.g.dart';

@immutable
@JsonSerializable()
abstract class ProductState
    implements Built<ProductState, ProductStateBuilder> {
  const ProductState._();

  factory ProductState() => _$ProductState._(
    hasError: false,
    isLoading: false,
    errorMessage: null,
    products: const <StockProduct>[],
    modifiers: const <ProductModifier>[],
    categories: const <StockCategory>[],
    productCombos: const <ProductCombo>[],
    tabIndex: 0,
    fullProducts: const <FullProduct>[],
    allOptionAttributes: const <ProductOptionAttribute>[],
  );

  Map<String, List<StockProduct>>? get productVariants;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isLoading;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get hasError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get errorMessage;

  SortBy? get sortBy;

  SortOrder? get sortOrder;

  FullProduct? get productWithOptions;

  List<StockCategory>? get categories;

  List<StockProduct>? get products;

  List<FullProduct> get fullProducts;

  List<ProductModifier>? get modifiers;

  List<ProductCombo>? get productCombos;

  List<ProductOptionAttribute> get allOptionAttributes;

  List<StockProduct>? get lowStockProducts => products
      ?.where(
        (item) =>
            (item.regularVariance?.lowQuantityValue ?? 10) >
                item.regularItemQuantity &&
            item.isStockTrackable == true,
      )
      .toList();

  int? get tabIndex;

  @nullable
  double get totalItems {
    if (products == null) return 0;

    return products!.map((p) => p.quantity).reduce((a, b) => a + b);
  }

  @nullable
  double? get totalValue {
    if (products == null) return 0;

    return products!.map((p) => p.regularPrice).reduce((a, b) => a! + b!);
  }

  @nullable
  double get averageItemValue {
    if (totalValue as bool? ?? 0 <= 0) return 0;

    return totalValue! / totalItems;
  }

  int getProductCountByCategory({required String categoryId}) {
    return products?.where((p) => p.categoryId == categoryId).length ?? 0;
  }

  StockCategory? getCategory({required String? categoryId}) {
    if (categoryId == null || categoryId.isEmpty) return null;

    if (categories!.any((c) => c.id == categoryId)) {
      return categories!.firstWhere((c) => c.id == categoryId);
    }
    return null;
  }

  double getProductQty({required String? productId}) {
    var thisProduct = getProductById(productId);

    if (thisProduct == null) return 0;

    return thisProduct.quantity;
  }

  StockProduct? getProductById(String? productId) {
    StockProduct? result;

    for (var product in products!) {
      if (product.isProductById(productId)) {
        result = product;
        break;
      }
    }

    return result;
  }

  StockProduct? getProductVariantById(String? variantId) {
    if (productVariants == null || productVariants!.isEmpty) return null;

    for (var variants in productVariants!.values) {
      var variant = variants.firstWhereOrNull((v) => v.id == variantId);
      if (variant != null) return variant;
    }

    return null;
  }

  ProductCombo? getComboById(String? comboId) {
    if (productCombos == null || productCombos!.isEmpty) {
      return null;
    }

    return productCombos?.firstWhere((c) => c.id == comboId);
  }

  StockProduct? getProductByBarcode(String barcode) {
    StockProduct? result;

    for (var product in products!) {
      if (product.isProduct(barcode)) {
        result = product;
        break;
      }
    }

    return result;
  }

  StockProduct? getProductVariantByBarcode(String barcode) {
    StockProduct? result;
    if (productVariants == null || productVariants!.isEmpty) return null;

    for (var variants in productVariants!.values) {
      result = variants.firstWhereOrNull((v) => v.regularBarCode == barcode);
      if (result != null) break;
    }

    return result;
  }

  StockProduct? getProductAndOptionsByBarcode(String barcode) {
    StockProduct? result;

    mainloop:
    for (var fullProduct in fullProducts) {
      if (fullProduct.product.isProduct(barcode)) {
        result = fullProduct.product;
        break;
      }
      for (ProductOption option in fullProduct.productOptions ?? []) {
        if (option.isProduct(barcode)) {
          result = fullProduct.product;
          break mainloop;
        }
      }
    }
    if (fullProducts.isEmpty) {
      for (var product in products!) {
        if (product.isProduct(barcode)) {
          result = product;
          break;
        }
      }
    }

    return result;
  }
}

abstract class ProductsUIState
    implements Built<ProductsUIState, ProductsUIStateBuilder> {
  factory ProductsUIState() {
    return _$ProductsUIState._(item: StockProduct.create());
  }

  ProductsUIState._();

  StockProduct? get item;

  bool get isNew => item?.isNew ?? false;
}

abstract class ModifierUIState
    implements Built<ModifierUIState, ModifierUIStateBuilder> {
  factory ModifierUIState() {
    return _$ModifierUIState._(item: ProductModifier.create());
  }

  ModifierUIState._();

  ProductModifier? get item;

  bool get isNew => item?.isNew ?? false;
}

abstract class CategoriesUIState
    implements Built<CategoriesUIState, CategoriesUIStateBuilder> {
  factory CategoriesUIState() {
    return _$CategoriesUIState._(item: StockCategory.create());
  }

  CategoriesUIState._();

  StockCategory? get item;

  bool get isNew => item?.isNew ?? false;
}

abstract class CombosUIState
    implements Built<CombosUIState, CombosUIStateBuilder> {
  factory CombosUIState() {
    return _$CombosUIState._(item: ProductCombo.create());
  }

  CombosUIState._();

  ProductCombo? get item;

  bool get isNew => item?.isNew ?? false;
}
