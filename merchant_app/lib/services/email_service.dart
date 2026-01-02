import 'package:littlefish_merchant/models/device/device_email_request.dart';
import 'package:littlefish_merchant/models/security/authentication/api_base_response.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';
import 'package:redux/redux.dart';

class EmailService {
  EmailService({
    required this.baseUrl,
    required this.businessId,
    required this.token,
    required this.store,
  }) {
    client = RestClient(store: store as Store<AppState>?);
  }

  String? baseUrl;
  String? businessId;
  String? token;

  late RestClient client;
  Store store;

  Future<ApiBaseResponse> sendDeviceLimitEmail({
    required String email,
    required DeviceEmailRequest request,
  }) async {
    var response = await client.post(
      url:
          '$baseUrl/Notification/SendMaxDeviceLimitEmail?businessId=$businessId&email=$email',
      token: token,
      requestData: request.toJson(),
    );

    if (response?.statusCode == 200) {
      return ApiBaseResponse.fromJson(response!.data);
    } else {
      throw Exception('Unable to send device limit email, bad server response');
    }
  }

  Future<ApiBaseResponse> sendRegisterDeviceEmail({
    required String email,
    required DeviceEmailRequest request,
  }) async {
    var response = await client.post(
      url:
          '$baseUrl/Notification/SendDeviceRegisteredEmail?businessId=$businessId&email=$email',
      token: token,
      requestData: request.toJson(),
    );

    if (response?.statusCode == 200) {
      return ApiBaseResponse.fromJson(response!.data);
    } else {
      throw Exception(
        'Unable to send register device email, bad server response',
      );
    }
  }

  Future<ApiBaseResponse> sendDeRegisterDeviceEmail({
    required String email,
    required DeviceEmailRequest request,
  }) async {
    var response = await client.post(
      url:
          '$baseUrl/Notification/SendDeviceDeRegisteredEmail?businessId=$businessId&email=$email',
      token: token,
      requestData: request.toJson(),
    );

    if (response?.statusCode == 200) {
      return ApiBaseResponse.fromJson(response!.data);
    } else {
      throw Exception(
        'Unable to send de-register device email, bad server response',
      );
    }
  }
}
