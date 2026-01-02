// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderTransaction _$OrderTransactionFromJson(Map<String, dynamic> json) =>
    OrderTransaction(
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      deviceId: json['deviceId'] as String? ?? '',
      businessId: json['businessId'] as String? ?? '',
      capturedChannel:
          $enumDecodeNullable(
            _$CapturedChannelEnumMap,
            json['capturedChannel'],
          ) ??
          CapturedChannel.undefined,
      orderId: json['orderId'] as String? ?? '',
      paymentType: json['paymentType'] == null
          ? const PaymentType()
          : PaymentType.fromJson(json['paymentType'] as Map<String, dynamic>),
      transactionStatus:
          $enumDecodeNullable(
            _$TransactionStatusEnumMap,
            json['transactionStatus'],
          ) ??
          TransactionStatus.undefined,
      transactionType:
          $enumDecodeNullable(
            _$OrderTransactionTypeEnumMap,
            json['transactionType'],
          ) ??
          OrderTransactionType.undefined,
      createdBy: json['createdBy'] as String? ?? '',
      effectOnCartTotal:
          $enumDecodeNullable(
            _$EffectOnCartTotalEnumMap,
            json['effectOnCartTotal'],
          ) ??
          EffectOnCartTotal.none,
      additionalData: json['additionalData'] as String? ?? '',
      amountTendered: (json['amountTendered'] as num?)?.toDouble() ?? 0.0,
      changeGiven: (json['changeGiven'] as num?)?.toDouble() ?? 0.0,
      customer: json['customer'] == null
          ? const Customer()
          : Customer.fromJson(json['customer'] as Map<String, dynamic>),
      failureReason: json['failureReason'] as String? ?? '',
      id: json['id'] as String? ?? '',
      receiptData: json['receiptData'] as String? ?? '',
      tipAmount: (json['tipAmount'] as num?)?.toDouble() ?? 0.0,
      traceId: json['traceId'] as String? ?? '',
      transactionNumber: (json['transactionNumber'] as num?)?.toInt() ?? 0,
      dateCreated: json['dateCreated'] == null
          ? null
          : DateTime.parse(json['dateCreated'] as String),
      dateUpdated: json['dateUpdated'] == null
          ? null
          : DateTime.parse(json['dateUpdated'] as String),
      updatedBy: json['updatedBy'] as String? ?? '',
      terminalId: json['terminalId'] as String? ?? '',
      batchNo: (json['batchNo'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OrderTransactionToJson(
  OrderTransaction instance,
) => <String, dynamic>{
  'id': instance.id,
  'transactionNumber': instance.transactionNumber,
  'businessId': instance.businessId,
  'deviceId': instance.deviceId,
  'traceId': instance.traceId,
  'customer': instance.customer.toJson(),
  'orderId': instance.orderId,
  'amount': instance.amount,
  'changeGiven': instance.changeGiven,
  'amountTendered': instance.amountTendered,
  'tipAmount': instance.tipAmount,
  'transactionStatus': _$TransactionStatusEnumMap[instance.transactionStatus]!,
  'failureReason': instance.failureReason,
  'transactionType': _$OrderTransactionTypeEnumMap[instance.transactionType]!,
  'effectOnCartTotal': _$EffectOnCartTotalEnumMap[instance.effectOnCartTotal]!,
  'additionalData': instance.additionalData,
  'capturedChannel': _$CapturedChannelEnumMap[instance.capturedChannel]!,
  'receiptData': instance.receiptData,
  'paymentType': instance.paymentType.toJson(),
  'dateCreated': instance.dateCreated?.toIso8601String(),
  'dateUpdated': instance.dateUpdated?.toIso8601String(),
  'createdBy': instance.createdBy,
  'updatedBy': instance.updatedBy,
  'terminalId': instance.terminalId,
  'batchNo': instance.batchNo,
};

const _$CapturedChannelEnumMap = {
  CapturedChannel.undefined: -1,
  CapturedChannel.web: 0,
  CapturedChannel.android: 1,
  CapturedChannel.ios: 2,
  CapturedChannel.pos: 3,
  CapturedChannel.notUsed: 4,
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

const _$EffectOnCartTotalEnumMap = {
  EffectOnCartTotal.undefined: -1,
  EffectOnCartTotal.increase: 0,
  EffectOnCartTotal.decrease: 1,
  EffectOnCartTotal.none: 2,
};
