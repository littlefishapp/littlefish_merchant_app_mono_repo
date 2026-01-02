// Package imports:
import 'dart:convert';

// removed ignore: depend_on_referenced_packages
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core/monitoring/services/monitoring_service.dart';
import 'package:littlefish_merchant/models/stock/full_product.dart';
import 'package:littlefish_merchant/models/stock/online_product_update.dart';
import 'package:littlefish_merchant/tools/exceptions/common_exceptions.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/products/product_combo.dart';
import 'package:littlefish_merchant/models/products/product_modifier.dart';
import 'package:littlefish_merchant/models/settings/locale/country_stub.dart';
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';
// removed ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class ProductService {
  ProductService({
    required this.baseUrl,
    required this.businessId,
    required this.token,
    required this.currentLocale,
    required this.store,
  }) {
    client = RestClient(store: store as Store<AppState>?);
  }

  LittleFishCore core = LittleFishCore.instance;

  LoggerService get logger => LittleFishCore.instance.get<LoggerService>();

  MonitoringService get monitoringService => core.get<MonitoringService>();

  String? baseUrl;
  String? businessId;
  String? token;
  CountryStub? currentLocale;

  Store store;

  late RestClient client;

  Future<List<StockProduct>> getProducts() async {
    var trace = await monitoringService.createTrace(name: 'getProducts');

    try {
      //ToDo: add system value to determine if we must fetch or not.
      //ToDo: this requires pagination.

      var response = await client.get(
        url: '$baseUrl/Inventory/GetEnabledProducts/businessId=$businessId',
        token: token,
      );

      if (response?.statusCode == 200) {
        {
          var result = <StockProduct>[];
          for (var p in (response!.data as List)) {
            result.add(StockProduct.fromJson(p));
          }

          trace.setMetric('products', result.length);

          return result;
        }
      } else {
        logger.warning(
          this,
          'Failed to get products, response is ${response?.statusCode ?? 'null'}',
        );

        throw Exception('Unable to get products, server response error');
      }
    } catch (e) {
      rethrow;
    } finally {
      trace.stop();
    }
  }

  Future<List<ProductOptionAttribute>> getAllProductOptionTags() async {
    var trace = await monitoringService.createTrace(
      name: 'getAllProductOptionTags',
    );

    try {
      final response = await client.get(
        url:
            '$baseUrl/Inventory/GetAllProductOptionTags/businessId=$businessId',
        token: token,
      );

      if (response?.statusCode == 200) {
        var result = <ProductOptionAttribute>[];
        for (var p in (response!.data as List)) {
          result.add(ProductOptionAttribute.fromJson(p));
        }
        trace.setMetric('productOptionAttributes', result.length);
        return result;
      } else {
        logger.warning(
          this,
          'Failed to get product option tags, response is ${response?.statusCode ?? 'null'}',
        );
        throw Exception(
          'Unable to get product option tags, server response error',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    } finally {
      trace.stop();
    }
  }

  Future<FullProduct> getFullProductByID(String productId) async {
    var trace = await monitoringService.createTrace(name: 'getFullProductById');

    try {
      final response = await client.get(
        url:
            '$baseUrl/Inventory/GetFullProductByID?businessId=$businessId&productId=$productId',
        token: token,
      );

      if (response?.statusCode == 200) {
        return FullProduct.fromJson(response!.data);
      } else {
        logger.warning(
          this,
          'Failed to get full product, response is ${response?.statusCode ?? 'null'}',
        );

        throw Exception('Unable to get full product, bad server response');
      }
    } catch (e) {
      throw Exception('Error: $e');
    } finally {
      trace.stop();
    }
  }

  Future<List<FullProduct>> getFullProductsWithOptions() async {
    var trace = await monitoringService.createTrace(
      name: 'getFullProductsWithOptions',
    );

    try {
      var response = await client.get(
        url:
            '$baseUrl/Inventory/GetFullProductsWithOptions?businessId=$businessId',
        token: token,
      );

      if (response?.statusCode == 200) {
        var result = <FullProduct>[];
        for (var p in (response!.data as List)) {
          result.add(FullProduct.fromJson(p));
        }
        trace.setMetric('fullProducts', result.length);
        return result;
      } else {
        logger.warning(
          this,
          'Failed to get full products with options, response is \\${response?.statusCode ?? 'null'}',
        );
        throw Exception(
          'Unable to get full products with options, server response error',
        );
      }
    } catch (e) {
      rethrow;
    } finally {
      trace.stop();
    }
  }

  Future<StockProduct> getProductByID(String productId) async {
    var trace = await monitoringService.createTrace(name: 'getProductById');

    try {
      final response = await client.get(
        url:
            '$baseUrl/Inventory/GetProductById?businessId=$businessId&productId=$productId',
        token: token,
      );

      if (response?.statusCode == 200) {
        return StockProduct.fromJson(response?.data);
      } else {
        logger.warning(
          this,
          'Failed to get product, response is ${response?.statusCode ?? 'null'}',
        );

        throw Exception('Unable to get product, bad server response');
      }
    } catch (e) {
      throw Exception('Error: $e');
    } finally {
      trace.stop();
    }
  }

  Future<StockProduct?> getProductBySku(String sku) async {
    var trace = await monitoringService.createTrace(name: 'getProductBySKU');

    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/Inventory/GetProductBySku?businessId=$businessId&sku=$sku',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          // Add other headers if needed
        },
      );

      if (response.statusCode == 200) {
        // Check if the response body is not empty
        if (response.body != 'null') {
          return StockProduct.fromJson(json.decode(response.body));
        } else {
          return null; // Return null when the response body is empty
        }
      } else {
        logger.warning(
          this,
          'Failed to get product by SKU, response is ${response.statusCode}',
        );
        throw Exception('Unable to get product, bad server response');
      }
    } catch (e) {
      throw Exception('Error: $e'); // Pass the caught exception for debugging
    } finally {
      trace.stop();
    }
  }

  Future<Map<String, List<dynamic>>> getProductsAndCategories(
    List<String> productIds,
  ) async {
    var trace = await monitoringService.createTrace(
      name: 'getProductsAndCategories',
    );

    try {
      String url = '$baseUrl/Inventory/GetProductsAndCategories';
      url += '?';
      url += 'businessId=$businessId';
      for (String productId in productIds) {
        url += '&productIds=$productId';
      }

      final response = await client.get(
        url: url,
        // requestData: args,
        token: token,
      );

      if (response?.statusCode == 200) {
        // final data = json.decode(response.body);
        List<StockProduct> products = (response!.data['products'] as List)
            .map((productJson) => StockProduct.fromJson(productJson))
            .toList();

        trace.setMetric('products', products.length);

        List<StockCategory> categories = (response.data['categories'] as List)
            .map((categegoryJson) => StockCategory.fromJson(categegoryJson))
            .toList();

        trace.setMetric('categories', categories.length);

        return {'products': products, 'categories': categories};
      } else {
        throw Exception(
          'Unable to get products or categories. Bad server response.',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    } finally {
      trace.stop();
    }
  }

  Future<List<StockCategory>> getCategories() async {
    var trace = await monitoringService.createTrace(name: 'getCategories');

    try {
      //here we need to make a call to the server to pull the details.
      var response = await client.get(
        url: '$baseUrl/Inventory/GetCategories/businessId=$businessId',
        token: token,
      );

      if (response?.statusCode == 200) {
        var result = <StockCategory>[];
        for (var p in (response!.data as List)) {
          result.add(StockCategory.fromJson(p));
        }

        result.sort((a, b) {
          return a.name!
              .substring(0, 1)
              .toLowerCase()
              .compareTo(b.name!.substring(0, 1).toLowerCase());
        });

        trace.setMetric('categories', result.length);

        return result;
      } else {
        logger.warning(
          this,
          'Failed to get categories, response is ${response?.statusCode ?? 'null'}',
        );
        throw Exception('Unable to add get categories, bad server response');
      }
    } catch (e) {
      rethrow;
    } finally {
      trace.stop();
    }
  }

  Future<StockCategory> addCategory(
    String? name, {
    String? description,
    String? color,
  }) async {
    var response = await client.put(
      url:
          '$baseUrl/Inventory/AddCategory/businessId=$businessId,categoryName=$name',
      token: token,
    );

    if (response?.statusCode == 200) {
      return StockCategory.fromJson(response!.data);
    } else {
      throw Exception('Unable to add category, bad server response');
    }
  }

  Future<StockProduct> addProduct(StockProduct item) async {
    item.dateUpdated = DateTime.now().toUtc();
    item.enabled = true;
    var json = item.toJson();

    var response = await client.post(
      url: '$baseUrl/Inventory/AddProduct/businessId=$businessId',
      token: token,
      requestData: json,
    );

    if (response?.statusCode == 200) {
      return StockProduct.fromJson(response!.data);
    } else {
      throw Exception('Unable to add product, bad server response');
    }
  }

  Future<FullProduct> upsertProductWithOption(FullProduct fullProduct) async {
    var trace = await monitoringService.createTrace(
      name: 'upsertProductWithOption',
    );

    try {
      final response = await client.post(
        url:
            '$baseUrl/Inventory/UpsertProductwithOption/businessId=$businessId',
        token: token,
        requestData: fullProduct.toJson(),
      );

      if (response?.statusCode == 200) {
        return FullProduct.fromJson(response!.data);
      } else {
        logger.warning(
          this,
          'Failed to upsert product with option, response is \\${response?.statusCode ?? 'null'}',
        );
        throw Exception(
          'Unable to upsert product with option, bad server response',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    } finally {
      trace.stop();
    }
  }

  Future<bool> batchUpdateProductsOnlineStatus(
    List<OnlineProductUpdate> productsUpdated,
  ) async {
    try {
      var response = await client.post(
        url: '$baseUrl/Store/updateOnlineProducts/businessId=$businessId',
        token: token,
        requestData: jsonEncode(productsUpdated),
      );

      if (response?.statusCode == 200 && response!.data != null) {
        return response.data['success'] as bool;
      } else {
        throw Exception('Unable to update products, bad server response.');
      }
    } catch (error) {
      throw Exception('Unable to update online products, bad server response.');
    }
  }

  Future<bool> markFavouriteStatus({
    required StockProduct item,
    required bool value,
  }) async {
    var response = await client.put(
      url:
          '$baseUrl/Inventory/SetFavouriteStatus/businessId=$businessId,productId=${item.id},value=$value',
      token: token,
    );

    if (response?.statusCode == 200) {
      return true;
    } else {
      throw Exception('Unable to mark favourite status');
    }
  }

  Future<StockCategory> updateProductsAndCategory(
    StockCategory category,
    List<String?> newProducts,
    List<String?> removedProducts,
  ) async {
    var requestData = {
      'category': category.toJson(),
      'newProducts': newProducts,
      'removedProducts': removedProducts,
    };

    var response = await client.put(
      url:
          '$baseUrl/Inventory/UpdateProductsAndCategory/businessId=$businessId',
      token: token,
      requestData: requestData,
    );

    if (response?.statusCode == 200) {
      return StockCategory.fromJson(response!.data);
    } else {
      throw Exception(
        'Unable to updateProductsAndCategory, bad server response',
      );
    }
  }

  Future<List<StockProduct>> updateProductsDiscountId(
    List<StockProduct?> products,
  ) async {
    var response = await client.post(
      url: '$baseUrl/Inventory/UpdateProductsDiscountId/businessId=$businessId',
      token: 'Bearer $token',
      requestData: jsonEncode(products),
    );

    if (response?.statusCode == 200) {
      return (response?.data as List)
          .map((f) => StockProduct.fromJson(f))
          .toList();
    } else {
      throw Exception(
        'Unable to updateProductsAndCategory, bad server response',
      );
    }
  }

  Future<bool> removeProduct(StockProduct product) async {
    var response = await client.delete(
      url: '$baseUrl/Inventory/DeleteProduct/businessId=$businessId',
      token: token,
      requestData: product.toJson(),
    );

    if (response?.statusCode != 200) {
      throw Exception(
        'Unable to remove product at this time, bad server response',
      );
    } else {
      return true;
    }
  }

  Future<bool> removeCategory(StockCategory item) async {
    var response = await client.delete(
      url:
          '$baseUrl/Inventory/DeleteCategory/businessId=$businessId,id=${item.id}',
      token: token,
    );

    if (response?.statusCode != 200) {
      throw Exception(
        'Unable to remove category at this time, bad server response',
      );
    } else {
      return true;
    }
  }

  //Modifiers
  Future<List<ProductModifier>> getModifiers() async {
    //here we need to make a call to the server to pull the details.
    var response = await client.get(
      url:
          '$baseUrl/ModifierSet/GetAllEnabledModifierSets/businessId=$businessId',
      token: token,
    );

    if (response?.statusCode == 200) {
      var result = <ProductModifier>[];
      for (var p in (response!.data as List)) {
        result.add(ProductModifier.fromJson(p));
      }

      result.sort((a, b) {
        return a.name!
            .substring(0, 1)
            .toLowerCase()
            .compareTo(b.name!.substring(0, 1).toLowerCase());
      });

      return result;
    } else {
      throw Exception('Unable to get modifiers, bad server response');
    }
  }

  Future<ProductModifier> addModifier(ProductModifier modifier) async {
    var response = await client.post(
      url: '$baseUrl/ModifierSet/CreateModifierSet/businessId=$businessId',
      requestData: modifier.toJson(),
      token: token,
    );

    if (response?.statusCode == 200) {
      return ProductModifier.fromJson(response!.data);
    } else {
      throw Exception('Unable to add modifier, bad server response');
    }
  }

  Future<ProductModifier> updateModifier(ProductModifier modifier) async {
    var response = await client.put(
      url: '$baseUrl/ModifierSet/UpdateModifierSet/businessId=$businessId',
      token: token,
      requestData: modifier.toJson(),
    );

    if (response?.statusCode == 200) {
      return ProductModifier.fromJson(response!.data);
    } else {
      throw Exception('Unable to update modifier, bad server response');
    }
  }

  Future<bool> removeModifider(String? id) async {
    var response = await client.delete(
      url:
          '$baseUrl/ModifierSet/DeleteModifierSet/businessId=$businessId,modifierId=$id',
      token: token,
    );

    if (response?.statusCode == 200) {
      return true;
    } else {
      throw Exception('Unable to remove modifier, bad server response');
    }
  }

  //Product Combos
  Future<List<ProductCombo>> getCombos() async {
    var response = await client.get(
      url: '$baseUrl/Combo/GetAllEnabledCombos/businessId=$businessId',
      token: token,
    );

    if (response?.statusCode == 200) {
      var result = <ProductCombo>[];
      for (var p in (response!.data as List)) {
        result.add(ProductCombo.fromJson(p));
      }

      result.sort((a, b) {
        return a.name!
            .substring(0, 1)
            .toLowerCase()
            .compareTo(b.name!.substring(0, 1).toLowerCase());
      });

      return result;
    } else {
      throw Exception('Unable to get product combos, bad server response');
    }
  }

  Future<List<ProductCombo>> getCombosByComboIDs(List<String> comboIDs) async {
    // Map<String, dynamic> args =  {
    //     "businessId": businessId,
    //     "comboIds": comboIDs,
    //   };

    String url = '$baseUrl/Combo/GetCombosByComboIds';
    url += '?';
    url += 'businessId=$businessId';
    for (String comboId in comboIDs) {
      url += '&comboIds=$comboId';
    }

    var response = await client.get(
      url: url,
      token: token,
      // requestData: args,
    );

    if (response?.statusCode == 200) {
      var result = <ProductCombo>[];
      for (var p in (response!.data as List)) {
        result.add(ProductCombo.fromJson(p));
      }

      result.sort((a, b) {
        return a.name!
            .substring(0, 1)
            .toLowerCase()
            .compareTo(b.name!.substring(0, 1).toLowerCase());
      });

      return result;
    } else {
      throw Exception('Unable to add get combos, bad server response');
    }
  }

  Future<ProductCombo> createOrUpdateCombo(ProductCombo value) async {
    var response = await client.post(
      url: '$baseUrl/Combo/CreateOrUpdateCombo/businessId=$businessId',
      requestData: value.toJson(),
      token: token,
    );

    if (response?.statusCode == 200) {
      return ProductCombo.fromJson(response!.data);
    } else {
      throw Exception('Unable to add combo, bad server response');
    }
  }

  Future<ProductCombo> updateCombo(ProductCombo value) async {
    var response = await client.put(
      url: '$baseUrl/Combo/UpdateCombo/businessId=$businessId',
      token: token,
      requestData: value.toJson(),
    );

    if (response?.statusCode == 200) {
      return ProductCombo.fromJson(response!.data);
    } else {
      throw Exception('Unable to update combo, bad server response');
    }
  }

  Future<bool> removeCombo(String? id) async {
    var response = await client.delete(
      url: '$baseUrl/Combo/DeleteCombo/businessId=$businessId,comboId=$id',
      token: token,
    );

    if (response?.statusCode == 200) {
      return true;
    } else {
      throw Exception('Unable to remove combo, bad server response');
    }
  }

  Future<StockProduct> getProductVariantByDisplayName({
    required String parentId,
    required String displayName,
  }) async {
    var trace = await monitoringService.createTrace(
      name: 'getProductVariantByDisplayName',
    );
    try {
      final encodedDisplayName = Uri.encodeQueryComponent(displayName);

      final url =
          '$baseUrl/Inventory/GetProductVariantByDisplayName?businessId=$businessId&parentId=$parentId&displayName=$encodedDisplayName';

      final response = await client.get(url: url, token: token);
      if (response?.statusCode == 200) {
        if (response!.data == null) {
          throw NoDataException(
            name: 'getProductVariantByDisplayName',
            message: 'No product variant found for display name: $displayName',
          );
        }
        return StockProduct.fromJson(response.data);
      } else {
        logger.warning(
          this,
          'Failed to get product variant by display name, response is ${response?.statusCode ?? 'null'}',
        );
        throw Exception('Unable to get product variant, bad server response');
      }
    } on NoDataException {
      rethrow;
    } catch (e) {
      throw Exception('Error: $e');
    } finally {
      trace.stop();
    }
  }

  Future<StockProduct?> getProductByBarcode({required String barcode}) async {
    var trace = await monitoringService.createTrace(
      name: 'GetProductByBarcode',
    );
    try {
      final encodedBarcode = Uri.encodeQueryComponent(barcode);

      final url =
          '$baseUrl/Inventory/GetProductByBarcode?businessId=$businessId&barcode=$encodedBarcode';

      final response = await client.get(url: url, token: token);
      if (response?.statusCode == 200) {
        return response!.data == null
            ? null
            : StockProduct.fromJson(response.data);
      } else {
        logger.warning(
          this,
          'Failed to get product by barcode, response is ${response?.statusCode ?? 'null'}'
          'Barcode: $barcode',
        );
        throw Exception('No product found for this barcode: $barcode');
      }
    } catch (e) {
      throw Exception('Error: $e');
    } finally {
      trace.stop();
    }
  }
}
