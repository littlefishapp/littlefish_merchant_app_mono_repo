// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/billing/billing_info.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

class BillingServiceCF {
  BillingServiceCF({required Store<AppState> this.store}) {
    client = RestClient(store: store);
    token = 'Bearer ${store!.state.token}';
    baseUrl =
        '${store!.state.environmentState.environmentConfig!.cloudFunctionsUrl!}billingAPI';
    // this.baseUrl =
    //     'https://europe-west1-littlefish-merchant-dev.cloudfunctions.net/billingAPI';
  }

  BillingServiceCF.fromStore(Store<AppState> storeValue) {
    store = storeValue;
    baseUrl =
        '${storeValue.state.environmentState.environmentConfig!.cloudFunctionsUrl!}billingAPI';
    businessId = storeValue.state.businessId;
    token = storeValue.state.token;

    client = RestClient(store: store);
  }

  String? baseUrl;
  String? token;
  String? businessId;
  Store<AppState>? store;
  late RestClient client;

  Future<dynamic> savePayment(
    BillingPaymentEntry paymentEntry,
    BillingStoreInfo storeInfo,
  ) async {
    var sInfo = storeInfo.toJson();
    var pEntry = paymentEntry.toJson();
    var response = await client.post(
      url: '$baseUrl/savePayment',
      token: token,
      requestData: {'paymentEntry': pEntry, 'storeInfo': sInfo},
    );

    if (response?.statusCode == 200) {
      return response!.data;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<dynamic> saveBillingInfo(BillingStoreInfo storeInfo) async {
    var response = await client.post(
      url: '$baseUrl/saveBillingInfo',
      token: token,
      requestData: storeInfo.toJson(),
    );

    if (response?.statusCode == 200) {
      return true;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<BillingStoreInfo?> getUserBillingInfo(String? busId) async {
    var result = await FirebaseFirestore.instance
        .collection('store_billing_pos')
        .doc(busId)
        .get();

    if (result.exists == true) {
      return BillingStoreInfo.fromJson(result.data()!);
    } else {
      return null;
    }
  }
}
