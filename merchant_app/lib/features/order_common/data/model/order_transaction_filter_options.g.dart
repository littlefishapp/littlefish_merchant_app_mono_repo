// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_transaction_filter_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderTransactionFilterOptions _$OrderTransactionFilterOptionsFromJson(
  Map<String, dynamic> json,
) => OrderTransactionFilterOptions(
  searchText: json['searchText'] as String?,
  transactionStatus: (json['transactionStatus'] as List<dynamic>?)
      ?.map((e) => $enumDecode(_$TransactionStatusEnumMap, e))
      .toList(),
  transactionType: (json['transactionType'] as List<dynamic>?)
      ?.map((e) => $enumDecode(_$OrderTransactionTypeEnumMap, e))
      .toList(),
  acceptanceType: (json['acceptanceType'] as List<dynamic>?)
      ?.map((e) => $enumDecode(_$AcceptanceTypeEnumMap, e))
      .toList(),
  acceptanceChannel: (json['acceptanceChannel'] as List<dynamic>?)
      ?.map((e) => $enumDecode(_$AcceptanceChannelEnumMap, e))
      .toList(),
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
);

Map<String, dynamic> _$OrderTransactionFilterOptionsToJson(
  OrderTransactionFilterOptions instance,
) => <String, dynamic>{
  'searchText': instance.searchText,
  'transactionStatus': instance.transactionStatus
      ?.map((e) => _$TransactionStatusEnumMap[e]!)
      .toList(),
  'transactionType': instance.transactionType
      ?.map((e) => _$OrderTransactionTypeEnumMap[e]!)
      .toList(),
  'acceptanceType': instance.acceptanceType
      ?.map((e) => _$AcceptanceTypeEnumMap[e]!)
      .toList(),
  'acceptanceChannel': instance.acceptanceChannel
      ?.map((e) => _$AcceptanceChannelEnumMap[e]!)
      .toList(),
  'startDate': instance.startDate?.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
};

const _$TransactionStatusEnumMap = {
  TransactionStatus.undefined: -1,
  TransactionStatus.pending: 0,
  TransactionStatus.failure: 1,
  TransactionStatus.success: 2,
  TransactionStatus.error: 3,
};

const _$OrderTransactionTypeEnumMap = {
  OrderTransactionType.undefined: -1,
  OrderTransactionType.refund: 0,
  OrderTransactionType.$void: 1,
  OrderTransactionType.withdrawal: 2,
  OrderTransactionType.purchase: 3,
  OrderTransactionType.cashback: 4,
  OrderTransactionType.purchaseCashback: 5,
};

const _$AcceptanceTypeEnumMap = {
  AcceptanceType.undefined: -1,
  AcceptanceType.online: 0,
  AcceptanceType.inPerson: 1,
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
