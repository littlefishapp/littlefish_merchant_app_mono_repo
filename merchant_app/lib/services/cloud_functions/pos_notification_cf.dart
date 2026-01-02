// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

class PosNotificationCF {
  PosNotificationCF({required Store<AppState> this.store}) {
    client = RestClient(store: store);
    token = 'Bearer ${store!.state.token}';
    baseUrl =
        '${store!.state.environmentState.environmentConfig!.cloudFunctionsUrl!}posNotificationAPI';
  }

  PosNotificationCF.fromStore(Store<AppState> storeValue) {
    store = storeValue;
    baseUrl =
        '${storeValue.state.environmentState.environmentConfig!.cloudFunctionsUrl!}posNotificationAPI';
    businessId = storeValue.state.businessId;
    token = storeValue.state.token;

    client = RestClient(store: store);
  }

  String? baseUrl;
  String? token;
  String? businessId;
  Store<AppState>? store;
  late RestClient client;

  Future<dynamic> sendSMS(String smsContent, String? number) async {
    var response = await client.post(
      url: '$baseUrl/sendReceiptSMS',
      token: token,
      requestData: {'content': smsContent, 'number': number},
    );

    if (response?.statusCode == 200) {
      return response!.data;
    } else {
      throw Exception(response!.data);
    }
  }
}
