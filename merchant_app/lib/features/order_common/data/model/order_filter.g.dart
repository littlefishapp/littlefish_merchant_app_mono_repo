// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderFilter _$OrderFilterFromJson(Map<String, dynamic> json) => OrderFilter(
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  orderStatus: $enumDecodeNullable(_$OrderStatusEnumMap, json['orderStatus']),
  fulfillmentStatus: $enumDecodeNullable(
    _$FulfillmentStatusEnumMap,
    json['fulfillmentStatus'],
  ),
  orderSource: $enumDecodeNullable(_$OrderSourceEnumMap, json['orderSource']),
  fulfilmentMethod: $enumDecodeNullable(
    _$FulfilmentMethodEnumMap,
    json['fulfilmentMethod'],
  ),
  capturedChannels: (json['capturedChannels'] as List<dynamic>?)
      ?.map((e) => $enumDecode(_$CapturedChannelEnumMap, e))
      .toList(),
  financialStatuses: (json['financialStatuses'] as List<dynamic>?)
      ?.map((e) => $enumDecode(_$FinancialStatusEnumMap, e))
      .toList(),
);

Map<String, dynamic> _$OrderFilterToJson(
  OrderFilter instance,
) => <String, dynamic>{
  'startDate': instance.startDate?.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'fulfilmentMethod': _$FulfilmentMethodEnumMap[instance.fulfilmentMethod],
  'orderStatus': _$OrderStatusEnumMap[instance.orderStatus],
  'fulfillmentStatus': _$FulfillmentStatusEnumMap[instance.fulfillmentStatus],
  'orderSource': _$OrderSourceEnumMap[instance.orderSource],
  'capturedChannels': instance.capturedChannels
      .map((e) => _$CapturedChannelEnumMap[e]!)
      .toList(),
  'financialStatuses': instance.financialStatuses
      .map((e) => _$FinancialStatusEnumMap[e]!)
      .toList(),
};

const _$OrderStatusEnumMap = {
  OrderStatus.undefined: -1,
  OrderStatus.draft: 0,
  OrderStatus.discarded: 1,
  OrderStatus.open: 2,
  OrderStatus.closed: 3,
};

const _$FulfillmentStatusEnumMap = {
  FulfillmentStatus.undefined: -1,
  FulfillmentStatus.received: 0,
  FulfillmentStatus.processing: 1,
  FulfillmentStatus.dispatched: 2,
  FulfillmentStatus.complete: 3,
  FulfillmentStatus.failed: 4,
  FulfillmentStatus.cancelled: 5,
};

const _$OrderSourceEnumMap = {
  OrderSource.undefined: -1,
  OrderSource.instore: 0,
  OrderSource.online: 1,
};

const _$FulfilmentMethodEnumMap = {
  FulfilmentMethod.undefined: -1,
  FulfilmentMethod.delivery: 0,
  FulfilmentMethod.collection: 1,
};

const _$CapturedChannelEnumMap = {
  CapturedChannel.undefined: -1,
  CapturedChannel.web: 0,
  CapturedChannel.android: 1,
  CapturedChannel.ios: 2,
  CapturedChannel.pos: 3,
  CapturedChannel.notUsed: 4,
};

const _$FinancialStatusEnumMap = {
  FinancialStatus.undefined: -1,
  FinancialStatus.pending: 0,
  FinancialStatus.partiallyPaid: 1,
  FinancialStatus.paid: 2,
  FinancialStatus.partiallyRefunded: 3,
  FinancialStatus.refunded: 4,
  FinancialStatus.$void: 5,
  FinancialStatus.error: 6,
};
