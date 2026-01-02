import 'package:littlefish_merchant/features/payment_links/domain/entities/payment_link_core_request.dart';

class PaymentLinkCoreRequestModel {
  PaymentLinkCoreRequest fromJson(Map<String, dynamic> json) {
    return PaymentLinkCoreRequest(
      url: json['url'] as String? ?? '',
      orderId: json['orderId'] as String? ?? '',
      businessId: json['businessId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson(PaymentLinkCoreRequest instance) {
    return <String, dynamic>{
      'url': instance.url,
      'orderId': instance.orderId,
      'businessId': instance.businessId,
    };
  }
}
