import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_transaction.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/models/security/authentication/api_base_response.dart';

abstract class OrderReceiptDataSource {
  Future<ApiBaseResponse> sendSMSReceipt({
    required String businessId,
    required String mobileNumber,
    required Order? order,
    required OrderTransaction transaction,
  });
  Future<ApiBaseResponse> sendEmailReceipt({
    required String businessId,
    required String email,
    required String firstName,
    required Order? order,
    required OrderTransaction transaction,
  });

  Future<ApiBaseResponse> sendCheckoutSaleSMSReceipt({
    required String businessId,
    required String mobileNumber,
    required CheckoutTransaction transaction,
  });

  Future<ApiBaseResponse> sendCheckoutRefundSMSReceipt({
    required String businessId,
    required String mobileNumber,
    required Refund transaction,
  });
}
