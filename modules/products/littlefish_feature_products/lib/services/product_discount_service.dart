// Dart imports:
import 'dart:convert';

//Package imports
import 'package:littlefish_merchant/models/products/product_discount.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

class ProductDiscountService {
  ProductDiscountService({
    required this.baseUrl,
    required this.businessId,
    required this.token,
    required this.store,
  }) {
    client = RestClient(store: store as Store<AppState>?);
  }

  ProductDiscountService.fromStore(Store<AppState> aStore) {
    store = aStore;
    baseUrl = aStore.state.baseUrl;
    token = 'Bearer ${aStore.state.token}';
    businessId = aStore.state.businessId;
    client = RestClient(store: aStore);
  }

  String? baseUrl;
  String? businessId;
  String? token;

  late RestClient client;
  Store? store;

  Future<List<ProductDiscount>> getProductDiscounts() async {
    var url =
        '$baseUrl/ProductDiscount/GetProductDiscounts/businessId=$businessId';

    var response = await client.get(url: url, token: token);

    if (response?.statusCode == 200) {
      {
        return (response!.data as List)
            .map((i) => ProductDiscount.fromJson(i))
            .toList();
      }
    } else {
      throw Exception('Error while Sending Receipt to Customer');
    }
  }

  Future<ProductDiscount?> getProductDiscountsById(productDiscountId) async {
    var url =
        '$baseUrl/ProductDiscount/GetProductDiscountById/businessId=$businessId,id=$productDiscountId';

    var response = await client.get(url: url, token: token);

    if (response?.statusCode == 200) {
      {
        try {
          return ProductDiscount.fromJson(response!.data);
        } catch (error) {
          return null;
        }
      }
    } else {
      throw Exception('Error while Sending Receipt to Customer');
    }
  }

  Future<List<ProductDiscount>> upsertProductDiscount(
    ProductDiscount discount,
  ) async {
    var url =
        '$baseUrl/ProductDiscount/UpdateOrCreateProductDiscount/businessId=$businessId';

    var response = await client.post(
      url: url,
      requestData: discount.toJson(),
      token: token,
    );

    if (response?.statusCode == 200) {
      return (response?.data as List)
          .map((f) => ProductDiscount.fromJson(f))
          .toList();
    } else {
      throw Exception(
        'Unable to create / update discount at this time, bad server response',
      );
    }
  }

  Future<ProductDiscount> deleteProductDiscount(
    ProductDiscount discount,
  ) async {
    var url =
        '$baseUrl/ProductDiscount/DeleteProductDiscount/businessId=$businessId';

    var response = await client.post(
      url: url,
      requestData: discount.toJson(),
      token: token,
    );

    if (response?.statusCode == 200) {
      return ProductDiscount.fromJson(response!.data);
    } else {
      throw Exception(
        'Unable to create / update discount at this time, bad server response',
      );
    }
  }

  Future<List<ProductDiscount>> updateProductDiscounts(
    List<ProductDiscount> discounts,
  ) async {
    var url =
        '$baseUrl/ProductDiscount/UpdateProductDiscounts/businessId=$businessId';

    var response = await client.post(
      url: url,
      requestData: jsonEncode(discounts),
      token: token,
    );

    if (response?.statusCode == 200) {
      return (response?.data as List)
          .map((f) => ProductDiscount.fromJson(f))
          .toList();
    } else {
      throw Exception(
        'Unable to create / update discount at this time, bad server response',
      );
    }
  }
}
