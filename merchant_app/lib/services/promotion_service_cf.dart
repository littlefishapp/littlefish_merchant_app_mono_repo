import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';
import 'package:littlefish_merchant/ui/online_store/common/constants.dart';

// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

import '../features/ecommerce_shared/models/store/broadcast.dart';
import '../features/ecommerce_shared/models/store/promotion.dart';
import '../features/ecommerce_shared/models/store/store.dart' as store_model;

class PromotionServiceCF {
  PromotionServiceCF({required this.store}) {
    client = RestClient(store: store);
    token = 'Bearer ${store.state.token}';
    baseUrl =
        '${store.state.environmentState.environmentConfig!.cloudFunctionsUrl}promotionsAPI';
  }

  String? baseUrl;
  String? token;
  Store<AppState> store;
  late RestClient client;

  Future<dynamic> createPromotion(Promotion promo) async {
    var data = promo.toJson();
    var cc = data.toString();
    printLog(cc);
    var response = await client.post(
      url: '$baseUrl/createPromotion',
      // url:
      // 'http://10.0.2.2:6001/littlefish-merchant-dev/europe-west1/promotionsAPI/createPromotion',
      token: token,
      requestData: data,
    );

    if (response?.statusCode == 200) {
      return store;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<dynamic> reportPost({
    required String? postId,
    required String? storeId,
    required String reportedById,
  }) async {
    var response = await client.post(
      url: '$baseUrl/reportPost',
      token: token,
      requestData: {
        'postId': postId,
        'storeId': storeId,
        'reportedById': reportedById,
      },
    );

    if (response?.statusCode == 200) {
      return store;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<dynamic> cancelPromotion(Promotion promo) async {
    var response = await client.post(
      url: '$baseUrl/cancelPromotion',
      token: token,
      requestData: promo.toJson(),
    );

    if (response?.statusCode == 200) {
      return store;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<dynamic> deletePromotion(Promotion promo) async {
    var response = await client.post(
      url: '$baseUrl/deletePromotion',
      token: token,
      requestData: promo.toJson(),
    );

    if (response?.statusCode == 200) {
      return store;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<dynamic> saveFeaturedStore(store_model.FeaturedStore store) async {
    var response = await client.post(
      url: '$baseUrl/saveFeaturedStore',
      token: token,
      requestData: store.toJson(),
    );

    if (response?.statusCode == 200) {
      return store;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<dynamic> deleteFeaturedStore(store_model.FeaturedStore store) async {
    var response = await client.post(
      url: '$baseUrl/deleteFeaturedStore',
      token: token,
      requestData: store.toJson(),
    );

    if (response?.statusCode == 200) {
      return store;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<dynamic> createBroadcast(Broadcast broadcast) async {
    broadcast.broadcastData ??= {};

    var response = await client.post(
      url: '$baseUrl/createBroadcast',
      token: token,
      requestData: broadcast.toJson(),
    );

    if (response?.statusCode == 200) {
      return broadcast;
    } else {
      throw Exception(response!.data);
    }
  }
}
