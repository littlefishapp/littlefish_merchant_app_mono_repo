// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

class PlatformSyncServiceCF {
  PlatformSyncServiceCF({required Store<AppState> this.store}) {
    client = RestClient(store: store);
    token = 'Bearer ${store!.state.token}';
    baseUrl =
        '${store!.state.environmentState.environmentConfig!.cloudFunctionsUrl!}platformSyncAPI-primary';
    // this.baseUrl =
    //     'https://europe-west1-littlefish-merchant-dev.cloudfunctions.net/billingAPI';
  }

  PlatformSyncServiceCF.fromStore(Store<AppState> storeValue) {
    store = storeValue;
    baseUrl =
        '${storeValue.state.environmentState.environmentConfig!.cloudFunctionsUrl!}platformSyncAPI';
    businessId = storeValue.state.businessId;
    token = 'Bearer ${storeValue.state.token}';

    client = RestClient(store: store);
  }

  String? baseUrl;
  String? token;
  String? businessId;
  Store<AppState>? store;
  late RestClient client;

  Future<dynamic> updateStoreProduct(StockProduct product) async {
    var response = await client.post(
      url: '$baseUrl/updateStoreProduct',
      token: token,
      requestData: product.toJson(),
    );

    if (response?.statusCode == 200) {
      return response!.data;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<dynamic> upsertCategory(
    StockCategory category, {
    List<StockProduct>? products,
  }) async {
    var response = await client.post(
      url: '$baseUrl/upsertCategory',
      token: token,
      requestData: {
        'category': category.toJson(),
        'products': products?.map((e) => e.toJson()).toList(),
      },
    );

    if (response?.statusCode == 200) {
      return response!.data;
    } else {
      throw Exception(response!.data);
    }
  }
}
