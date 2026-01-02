import 'package:littlefish_merchant/features/errors/data/models/error_reports.dart';
import 'package:littlefish_merchant/models/security/authentication/api_base_response.dart';

abstract class NotificationDataSource {
  Future<ApiBaseResponse> sendErrorReport({required ErrorReport errorReport});
}
