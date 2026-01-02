// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

import '../../../../../features/ecommerce_shared/models/store/store_product.dart';

class ProductServiceCF {
  ProductServiceCF({required this.store}) {
    client = RestClient(store: store);
    token = 'Bearer ${store.state.token}';
    baseUrl =
        '${store.state.environmentState.environmentConfig!.cloudFunctionsUrl}productAPI';
  }

  String? baseUrl;
  String? token;
  Store<AppState> store;
  late RestClient client;

  Future<dynamic> upsertProductCategory(StoreProductCategory store) async {
    var response = await client.post(
      url: '$baseUrl/upsertProductCategory',
      token: token,
      requestData: store.toJson(),
    );

    if (response?.statusCode == 200) {
      return response!.data;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<dynamic> deleteProductCategory(String? id, String? businessId) async {
    var response = await client.delete(
      url: '$baseUrl/deleteProductCategory?businessId=$businessId&id=$id',
      token: token,
    );

    if (response?.statusCode == 200) {
      return id;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<dynamic> upsertStoreProduct(StoreProduct storeProduct) async {
    var response = await client.post(
      url: '$baseUrl/upsertProduct',
      token: token,
      requestData: storeProduct.toJson(),
    );

    if (response?.statusCode == 200) {
      return true;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<ProductVariant> upsertProductVariant(
    ProductVariant productVariant,
  ) async {
    var response = await client.post(
      url: '$baseUrl/upsertProductVariant',
      token: token,
      requestData: productVariant.toJson(),
    );

    if (response?.statusCode == 200) {
      return ProductVariant.fromJson(response!.data);
    } else {
      throw Exception(response!.data);
    }
  }

  Future<StoreProduct> upsertProductWithVariant(
    StoreProduct productVariant, {
    required List<StoreProduct> removedItems,
  }) async {
    var response = await client.post(
      url: '$baseUrl/upsertProductWithVariant',
      token: token,
      requestData: {
        'removedItems': removedItems.map((e) => e.toJson()).toList(),
        'product': productVariant.toJson(),
      },
    );

    if (response?.statusCode == 200) {
      return StoreProduct.fromJson(response!.data);
    } else {
      throw Exception(response!.data);
    }
  }

  // Future<void> deleteProductVariant(StoreProduct productVariant) async {
  //   var response = await client.post(
  //     url: '$baseUrl/deleteProductVariant',
  //     token: token,
  //     requestData: productVariant.toJson(),
  //   );

  //   if (response?.statusCode == 200) {
  //     // return ProductVariant.fromJson(response.data);
  //   } else
  //     throw new Exception(response.data);
  // }

  Future<dynamic> deleteProduct(String? id, String? businessId) async {
    var response = await client.delete(
      url: '$baseUrl/deleteProduct?businessId=$businessId&id=$id',
      token: token,
    );

    if (response?.statusCode == 200) {
      return true;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<QuerySnapshot> getStoreProducts() {
    return FirebaseFirestore.instance
        .collection('products')
        .where('deleted', isEqualTo: false)
        .get();
  }
}
