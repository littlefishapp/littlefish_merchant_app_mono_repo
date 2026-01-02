// Flutter imports:

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

class ReportService {
  ReportService({
    required this.baseUrl,
    required this.token,
    required this.businessId,
    required this.store,
  }) {
    client = RestClient(store: store as Store<AppState>?);
  }

  ReportService.fromStore(Store<AppState> storeValue) {
    store = storeValue;
    baseUrl = storeValue.state.reportsUrl;
    businessId = storeValue.state.businessId;
    token = storeValue.state.token;

    client = RestClient(store: store as Store<AppState>?);
  }

  Store? store;
  String? baseUrl;
  String? businessId;
  String? token;

  RestClient? client;

  //ToDo: API Calls come below here
}
