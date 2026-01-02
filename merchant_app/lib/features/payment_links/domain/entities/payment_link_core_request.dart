import 'package:equatable/equatable.dart';

class PaymentLinkCoreRequest extends Equatable {
  final String url;
  final String orderId;
  final String businessId;

  const PaymentLinkCoreRequest({
    this.url = '',
    this.orderId = '',
    this.businessId = '',
  });

  PaymentLinkCoreRequest copyWith({
    String? url,
    String? orderId,
    String? businessId,
  }) {
    return PaymentLinkCoreRequest(
      url: url ?? this.url,
      orderId: orderId ?? this.orderId,
      businessId: businessId ?? this.businessId,
    );
  }

  @override
  List<Object?> get props => [url, orderId, businessId];
}
