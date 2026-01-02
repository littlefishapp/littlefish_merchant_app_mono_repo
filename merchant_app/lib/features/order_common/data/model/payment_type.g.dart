// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentType _$PaymentTypeFromJson(Map<String, dynamic> json) => PaymentType(
  acceptanceChannel:
      $enumDecodeNullable(
        _$AcceptanceChannelEnumMap,
        json['acceptanceChannel'],
      ) ??
      AcceptanceChannel.undefined,
  acceptanceType:
      $enumDecodeNullable(_$AcceptanceTypeEnumMap, json['acceptanceType']) ??
      AcceptanceType.undefined,
  businessId: json['businessId'] as String? ?? '',
  paymentResponse: json['paymentResponse'] as String? ?? '',
  providerName: json['providerName'] as String? ?? '',
);

Map<String, dynamic> _$PaymentTypeToJson(
  PaymentType instance,
) => <String, dynamic>{
  'providerName': instance.providerName,
  'acceptanceType': _$AcceptanceTypeEnumMap[instance.acceptanceType]!,
  'acceptanceChannel': _$AcceptanceChannelEnumMap[instance.acceptanceChannel]!,
  'businessId': instance.businessId,
  'paymentResponse': instance.paymentResponse,
};

const _$AcceptanceChannelEnumMap = {
  AcceptanceChannel.undefined: -1,
  AcceptanceChannel.qrCode: 0,
  AcceptanceChannel.tapOnGlass: 1,
  AcceptanceChannel.cash: 2,
  AcceptanceChannel.pos: 3,
  AcceptanceChannel.payByLink: 4,
  AcceptanceChannel.mobileWallet: 5,
  AcceptanceChannel.card: 6,
  AcceptanceChannel.other: 7,
};

const _$AcceptanceTypeEnumMap = {
  AcceptanceType.undefined: -1,
  AcceptanceType.online: 0,
  AcceptanceType.inPerson: 1,
};
