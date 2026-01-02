import 'package:littlefish_payments/models/shared/payment_result.dart';

class PaymentProcessHelper {
  static Map<String, dynamic> paymentResultObject(
    PaymentResult? item, {
    bool paid = true,
    bool proceed = true,
  }) {
    return {
      'proceed': proceed,
      'paid': paid,
      'providerPaymentReference': item?.traceId ?? '',
      'batchNumber': item?.batchNumber ?? '',
      'referenceNumber': item?.transactionReference ?? '',
      'status': item?.status ?? '',
      'authCode': item?.authCode ?? '',
      'entry': item?.entry ?? '',
      'cardType': item?.paymentMethod ?? '',
      // Additional fields
      'refNum': item?.transactionReference ?? '',
      'entryMode': item?.entryMode ?? '',
      'maskedPAN': item?.maskedPan ?? '',
      'uti': item?.uti ?? '',
      'traceID': item?.traceId ?? '',
      'tid': item?.terminalId ?? '',
      'mid': item?.merchantId ?? '',
      'authResponse': item?.authResponse ?? '',
      'authResponseCode': item?.authResponseCode ?? '',
      'rrn': item?.rrn ?? '',
      'stan': item?.stan ?? '',
      'aid': item?.aid ?? '',
      'tvr': item?.tvr ?? '',
      'tsi': item?.tsi ?? '',
      'cvr': item?.cvr ?? '',
    };
  }
}
