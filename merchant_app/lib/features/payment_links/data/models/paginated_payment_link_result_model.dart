// paginated_payment_link_result_model.dart
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/payment_links/domain/entities/paginated_payment_link_result.dart';

class PaginatedPaymentLinkResultModel {
  PaginatedPaymentLinkResult fromJson(Map<String, dynamic> json) {
    return PaginatedPaymentLinkResult(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => Order.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalRecords: (json['totalRecords'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson(PaginatedPaymentLinkResult instance) {
    return <String, dynamic>{
      'items': instance.items,
      'totalRecords': instance.totalRecords,
    };
  }
}
