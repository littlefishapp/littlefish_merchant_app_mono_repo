// Dart imports:
import 'dart:async';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/finance/loan_request.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

class LoanService {
  Store<AppState>? store;
  String? baseUrl;
  String? businessId;
  String? token;

  late RestClient _restClient;

  LoanService({
    required this.store,
    required this.token,
    required this.baseUrl,
    required this.businessId,
  }) {
    _restClient = RestClient(store: store);
  }

  LoanService.fromStore(Store<AppState> storeValue) {
    store = storeValue;
    baseUrl = storeValue.state.financeUrl;
    businessId = storeValue.state.businessId;
    token = storeValue.state.token;

    _restClient = RestClient(store: storeValue);
  }

  Future<bool> submitLoanRequest({required LoanRequest? request}) async {
    String url = '$baseUrl/loan/SubmitLoanRequest/businessId=$businessId';

    var response = await (_restClient.post(
      url: url,
      token: token,
      requestData: request,
    ));

    if (response!.statusCode == 200) {
      if (response.data == true) {
        return true;
      } else {
        return false;
      }
    } else {
      throw Exception(
        'Unable to submit loan request. Please verify your application details and try again.',
      );
    }
  }
}
