import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

class PaywallDataSource {
  late final String _payUrl;
  late final String _baseUrl;

  late final RestClient _restClient;

  PaywallDataSource({String? baseUrl, String? payUrl}) {
    _restClient = RestClient(store: AppVariables.store!);
    final cleanedBaseUrl = (baseUrl ?? AppVariables.store?.state.baseUrl)
        ?.replaceFirst(RegExp(r'/api/?$'), '');

    _baseUrl = cleanedBaseUrl ?? '';
    _payUrl = payUrl ?? AppVariables.store?.state.paymentLinksPayUrl ?? '';
  }

  Future<bool> logAcceptance({required String businessId}) async {
    final url = '$_baseUrl/api/v1/log-acceptance';
    final response = await _restClient.post(
      url: url,
      requestData: {'businessId': businessId},
    );

    final success = response?.data?['success'] == true;
    return response != null && response.statusCode == 200 && success;
  }
}
