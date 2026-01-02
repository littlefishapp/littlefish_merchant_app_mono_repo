import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_transaction.dart';

part 'payment_type.g.dart';

@JsonSerializable(explicitToJson: true)
class PaymentType extends Equatable {
  final String providerName;
  final AcceptanceType acceptanceType;
  final AcceptanceChannel acceptanceChannel;
  final String businessId;
  final String paymentResponse;

  const PaymentType({
    this.acceptanceChannel = AcceptanceChannel.undefined,
    this.acceptanceType = AcceptanceType.undefined,
    this.businessId = '',
    this.paymentResponse = '',
    this.providerName = '',
  });

  PaymentType copyWith({
    String? providerName,
    AcceptanceType? acceptanceType,
    AcceptanceChannel? acceptanceChannel,
    String? businessId,
    String? paymentResponse,
  }) {
    return PaymentType(
      acceptanceChannel: acceptanceChannel ?? this.acceptanceChannel,
      acceptanceType: acceptanceType ?? this.acceptanceType,
      businessId: businessId ?? this.businessId,
      paymentResponse: paymentResponse ?? this.paymentResponse,
      providerName: providerName ?? this.providerName,
    );
  }

  factory PaymentType.fromJson(Map<String, dynamic> json) =>
      _$PaymentTypeFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentTypeToJson(this);

  @override
  List<Object?> get props => [
    providerName,
    acceptanceType,
    acceptanceChannel,
    businessId,
    paymentResponse,
  ];
}
