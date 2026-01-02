// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_create_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceCreateRequest _$InvoiceCreateRequestFromJson(
  Map<String, dynamic> json,
) => InvoiceCreateRequest(
  note: json['note'] as String?,
  capturedChannel: $enumDecodeNullable(
    _$CapturedChannelEnumMap,
    json['capturedChannel'],
  ),
  orderLineItems: (json['orderLineItems'] as List<dynamic>?)
      ?.map((e) => OrderLineItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$InvoiceCreateRequestToJson(
  InvoiceCreateRequest instance,
) => <String, dynamic>{
  'note': instance.note,
  'capturedChannel': _$CapturedChannelEnumMap[instance.capturedChannel],
  'orderLineItems': instance.orderLineItems,
};

const _$CapturedChannelEnumMap = {
  CapturedChannel.undefined: -1,
  CapturedChannel.web: 0,
  CapturedChannel.android: 1,
  CapturedChannel.ios: 2,
  CapturedChannel.pos: 3,
  CapturedChannel.notUsed: 4,
};
