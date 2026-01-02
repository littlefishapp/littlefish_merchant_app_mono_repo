import 'dart:math';

import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/product_service.dart';
import 'package:redux/redux.dart';

class SkuGenerator {
  static String generateSKU() {
    // Define the length of each segment and the total length of the SKU
    int segmentLength = 5;
    int totalLength = 20;

    // Generate random alphanumeric characters for the SKU
    String characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    String randomSKU = '';

    for (int i = 0; i < totalLength; i++) {
      if (i > 0 && i % segmentLength == 0) {
        randomSKU += '-';
      }
      randomSKU += characters[random.nextInt(characters.length)];
    }

    return randomSKU;
  }

  static bool isUniqueSkuStateCheck({
    required Store<AppState> store,
    required String productId,
    required String sku,
  }) {
    var products = store.state.productState.products ?? [];

    bool productExists = products.any((p) => p.sku == sku && p.id != productId);
    if (productExists) {
      return false;
    } else {
      return true;
    }
  }

  static bool areAllSkusUniqueInState({
    required Store<AppState> store,
    required List<ProductIdAndSku> skusAndIds,
  }) {
    // Check for duplicate SKUs within the input list itself.
    final inputSkus = skusAndIds.map((item) => item.sku).toList();
    if (inputSkus.toSet().length != inputSkus.length) {
      // This means the same SKU is being assigned to multiple products in this batch.
      return false;
    }

    // Get the list of all products currently in the state.
    final productsInState = store.state.productState.products ?? [];
    if (productsInState.isEmpty) {
      // If there are no products in the state, the new SKUs are guaranteed to be unique.
      return true;
    }

    // For each item, check if its SKU exists in the state on a different product.
    for (final itemToCheck in skusAndIds) {
      final isDuplicateInState = productsInState.any(
        (productInState) =>
            productInState.sku == itemToCheck.sku &&
            productInState.id != itemToCheck.productId,
      );

      // If a duplicate is found on another product, return false immediately.
      if (isDuplicateInState) {
        return false;
      }
    }

    return true;
  }

  static Future<bool> isUniqueSkuDatabaseCheck({
    required Store<AppState> store,
    required String productId,
    required String sku,
  }) async {
    if (sku.isEmpty) {
      throw ArgumentError('SKU cannot be empty');
    }
    ProductService productService = ProductService(
      baseUrl: store.state.baseUrl,
      businessId: store.state.businessId,
      token: store.state.token,
      currentLocale: store.state.localeState.currentLocale,
      store: store,
    );
    StockProduct? product = await productService.getProductBySku(sku);
    if (product != null && productId != product.id) {
      return false;
    } else {
      return true;
    }
  }
}

class ProductIdAndSku {
  final String productId;
  final String sku;

  ProductIdAndSku({required this.productId, required this.sku});
}
