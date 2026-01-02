import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/features/errors/data/notification_data_source.dart';
import 'package:littlefish_merchant/features/errors/data/models/error_reports.dart';
import 'package:littlefish_merchant/models/security/authentication/api_base_response.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

class LfNotificationDataSource extends NotificationDataSource {
  static const String _controllerPath = '/Notification';
  late final String _url;
  late final RestClient _restClient;

  LfNotificationDataSource({required String baseUrl}) {
    _restClient = RestClient(store: AppVariables.store!);
    _url = baseUrl + _controllerPath;
  }

  @override
  Future<ApiBaseResponse> sendErrorReport({
    required ErrorReport errorReport,
  }) async {
    final url = '$_url/SendErrorReportEmail';

    final response = await _restClient.post(
      url: url,
      requestData: errorReport.toJson(),
    );

    if (response == null || response.data == null) {
      throw Exception(
        'Failed to send error report. Response is null from server.',
      );
    }

    if (response.statusCode != 200) {
      throw Exception(
        response.statusMessage ??
            'Unable to send error report. Please try again.',
      );
    }

    return ApiBaseResponse.fromJson(response.data);
  }
}
