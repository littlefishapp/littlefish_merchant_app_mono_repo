// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

import '../../app/app.dart';

class ThirdPartySyncService {
  static String subTitle = '';
  String businessDomain = AppVariables.store!.state.uniqueSubdomin ?? 'unknown';

  ThirdPartySyncService({required Store<AppState> this.store}) {
    client = RestClient(store: store);
    token = 'Bearer ${store!.state.token}';
    baseUrl =
        // store!.state.environmentState.environmentConfig!.cloudFunctionsUrl! +
        //    'apiGoogleMerch-googleMerchAPI';
        baseUrl =
            'https://europe-west1-littlefish-merchant-dev.cloudfunctions.net/apiGoogleMerch-googleMerchAPI';
  }

  ThirdPartySyncService.fromStore(Store<AppState> storeValue) {
    store = storeValue;
    baseUrl =
        'https://europe-west1-littlefish-merchant-dev.cloudfunctions.net/apiGoogleMerch-googleMerchAPI';
    businessId = storeValue.state.businessId;
    token = 'Bearer ${storeValue.state.token}';

    client = RestClient(store: store);
  }

  String? baseUrl;
  String? token;
  String? businessId;
  Store<AppState>? store;
  late RestClient client;

  Future<dynamic> googleMerchSync(String businessId, bool enabled) async {
    var response = await client.post(
      url: '$baseUrl/GoogleMerchantEnableSync',
      token: token,
      requestData: {'businessId': businessId, 'enabled': enabled},
    );

    if (response?.statusCode == 200) {
      return response!.data;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<dynamic> shortenUrl(String businessId) async {
    var response = await client.get(
      url: '$baseUrl/ShortenUrl?businessId=$businessId',
      token: token,
    );

    if (response?.statusCode == 200) {
      return response!.data;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<bool> checkSyncStatus(String businessId) async {
    var response = await client.post(
      url: '$baseUrl/CheckSyncStatus',
      token: token,
      requestData: {'businessId': businessId},
    );

    if (response?.statusCode == 200) {
      if (response?.data == true) {
        subTitle = 'Products Syncing';
      } else if (response?.data == false) {
        subTitle = 'Products Not Syncing';
      } else {
        subTitle = 'Unknown';
      }

      return response!.data;
    } else {
      return false;
    }
  }
}
