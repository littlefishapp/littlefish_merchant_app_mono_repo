import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_transaction.dart';
import 'package:littlefish_merchant/features/receipt_common/data/data_source/order_receipt_data_source.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/models/security/authentication/api_base_response.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

class LFOrderReceiptDataSource implements OrderReceiptDataSource {
  static const String _controllerPath = '/OrderNotification';
  late final String _url;
  late final RestClient _restClient;

  LFOrderReceiptDataSource({required String baseUrl}) {
    _restClient = RestClient(store: AppVariables.store!);
    _url = baseUrl + _controllerPath;
  }

  @override
  Future<ApiBaseResponse> sendSMSReceipt({
    required String businessId,
    required String mobileNumber,
    required Order? order,
    required OrderTransaction transaction,
  }) async {
    final url =
        '$_url/GenerateSmsReceipt?businessId=$businessId&mobileNumber=$mobileNumber';

    final response = await _restClient.post(
      url: url,
      requestData: order!.toJson(),
    );

    if (response == null) throw Exception('Response is null from server');

    if (response.data == null) throw Exception('Response has no data');

    if (response.statusCode != 200) {
      throw Exception(
        response.statusMessage ??
            'Unable to send SMS receipt. Please verify the mobile number and try again.',
      );
    }

    return ApiBaseResponse.fromJson(response.data);
  }

  @override
  Future<ApiBaseResponse> sendEmailReceipt({
    required String businessId,
    required String email,
    required String firstName,
    required Order? order,
    required OrderTransaction transaction,
  }) async {
    final url =
        '$_url/GenerateEmailReceipt?businessId=$businessId&email=$email&firstName=$firstName';

    final response = await _restClient.post(
      url: url,
      requestData: order!.toJson(),
    );

    if (response == null) throw Exception('Response is null from server');

    if (response.data == null) throw Exception('Response has no data');

    if (response.statusCode != 200) {
      throw Exception(
        response.statusMessage ??
            'Unable to send email receipt. Please verify the email address and try again.',
      );
    }

    return ApiBaseResponse.fromJson(response.data);
  }

  @override
  Future<ApiBaseResponse> sendCheckoutRefundSMSReceipt({
    required String businessId,
    required String mobileNumber,
    required Refund transaction,
  }) async {
    final url =
        '$_url/GenerateRefundSmsReceipt?businessId=$businessId&mobileNumber=$mobileNumber';

    final response = await _restClient.post(
      url: url,
      requestData: transaction.toJson(),
    );

    if (response == null) throw Exception('Response is null from server');

    if (response.data == null) throw Exception('Response has no data');

    if (response.statusCode != 200) {
      throw Exception(
        response.statusMessage ??
            'Unable to send refund SMS receipt. Please verify the mobile number and try again.',
      );
    }

    return ApiBaseResponse.fromJson(response.data);
  }

  @override
  Future<ApiBaseResponse> sendCheckoutSaleSMSReceipt({
    required String businessId,
    required String mobileNumber,
    required CheckoutTransaction transaction,
  }) async {
    final url =
        '$_url/GenerateCheckoutSmsReceipt?businessId=$businessId&mobileNumber=$mobileNumber';

    final response = await _restClient.post(
      url: url,
      requestData: transaction.toJson(),
    );

    if (response == null) throw Exception('Response is null from server');

    if (response.data == null) throw Exception('Response has no data');

    if (response.statusCode != 200) {
      throw Exception(
        response.statusMessage ??
            'Unable to send checkout SMS receipt. Please verify the mobile number and try again.',
      );
    }

    return ApiBaseResponse.fromJson(response.data);
  }
}
