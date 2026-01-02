import 'package:littlefish_core_utils/error/models/error_codes/app_error_codes.dart';
import 'package:littlefish_merchant/features/order_common/data/model/payment_result_constants.dart';

class AppConstants {
  static const paymentResultConstant = PaymentResultConstant;

  static const errorCodes = AppErrorCodes;

  static const String description = 'description';

  static const String wizzitTapToPay = 'WizzitTapToPay';
  static const String zapper = 'Zapper';
  static const String snapscan = 'Snapscan';

  static const String success = 'Success';

  static const String failed = 'Failed';
}
