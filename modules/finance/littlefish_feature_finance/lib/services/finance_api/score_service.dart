// Dart imports:
import 'dart:async';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/finance/score.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

class ScoreService {
  Store<AppState>? store;
  String? baseUrl;
  String? businessId;
  String? token;

  late RestClient _restClient;

  ScoreService({
    required this.store,
    required this.token,
    required this.baseUrl,
    required this.businessId,
  }) {
    _restClient = RestClient(store: store);
  }

  ScoreService.fromStore(Store<AppState> storeValue) {
    store = storeValue;
    baseUrl = storeValue.state.financeUrl;
    businessId = storeValue.state.businessId;
    token = storeValue.state.token;

    _restClient = RestClient(store: storeValue);
  }

  Future<BusinessPerformanceScore?> getBusinessPerfomanceScore() async {
    String url =
        '$baseUrl/score/GetBusinessPerformanceScore/businessId=$businessId';

    var response = await (_restClient.get(url: url, token: token));

    if (response!.statusCode == 200) {
      if (response.data == null) return null;

      return BusinessPerformanceScore.fromJson(response.data);
    } else {
      throw Exception(
        'Unable to retrieve business performance score. Please check your connection and try again.',
      );
    }
  }
}
