// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_refund.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Refund _$RefundFromJson(Map<String, dynamic> json) =>
    Refund(
        checkoutTransactionId: json['checkoutTransactionId'] as String,
        sellerId: json['sellerId'] as String?,
        sellerName: json['sellerName'] as String?,
        currencyCode: json['currencyCode'] as String?,
        countryCode: json['countryCode'] as String?,
        customerId: json['customerId'] as String?,
        customerName: json['customerName'] as String?,
        customerEmail: json['customerEmail'] as String?,
        customerMobile: json['customerMobile'] as String?,
        transactionNumber: (json['transactionNumber'] as num?)?.toDouble(),
        transactionDate: json['transactionDate'] == null
            ? null
            : DateTime.parse(json['transactionDate'] as String),
        terminalId: json['terminalId'] as String?,
        batchNo: (json['batchNo'] as num?)?.toInt(),
        referenceNo: json['referenceNo'] as String?,
        transactionStatus: json['transactionStatus'] as String?,
        deviceId: json['deviceId'] as String?,
        additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
        isOnline: json['isOnline'] as bool?,
        totalRefund: (json['totalRefund'] as num?)?.toDouble() ?? 0,
        totalItems: (json['totalItems'] as num?)?.toDouble() ?? 0,
        totalRefundCost: (json['totalRefundCost'] as num?)?.toDouble() ?? 0,
        paymentType: json['paymentType'] == null
            ? null
            : PaymentType.fromJson(json['paymentType'] as Map<String, dynamic>),
        items:
            (json['items'] as List<dynamic>?)
                ?.map((e) => RefundItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        isQuickRefund: json['isQuickRefund'] as bool? ?? false,
      )
      ..id = json['id'] as String?
      ..name = json['name'] as String?
      ..description = json['description'] as String?
      ..status = json['status'] as String?
      ..businessId = json['businessId'] as String?
      ..displayName = json['displayName'] as String?
      ..deviceName = json['deviceName'] as String?
      ..dateCreated = json['dateCreated'] == null
          ? null
          : DateTime.parse(json['dateCreated'] as String)
      ..dateUpdated = json['dateUpdated'] == null
          ? null
          : DateTime.parse(json['dateUpdated'] as String)
      ..createdBy = json['createdBy'] as String?
      ..updatedBy = json['updatedBy'] as String?
      ..indexNo = (json['indexNo'] as num?)?.toInt()
      ..deleted = json['deleted'] as bool?
      ..enabled = json['enabled'] as bool?;

Map<String, dynamic> _$RefundToJson(Refund instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'status': instance.status,
  'businessId': instance.businessId,
  'displayName': instance.displayName,
  'deviceName': instance.deviceName,
  'dateCreated': instance.dateCreated?.toIso8601String(),
  'dateUpdated': instance.dateUpdated?.toIso8601String(),
  'createdBy': instance.createdBy,
  'updatedBy': instance.updatedBy,
  'indexNo': instance.indexNo,
  'deleted': instance.deleted,
  'enabled': instance.enabled,
  'checkoutTransactionId': instance.checkoutTransactionId,
  'sellerId': instance.sellerId,
  'sellerName': instance.sellerName,
  'currencyCode': instance.currencyCode,
  'countryCode': instance.countryCode,
  'paymentType': instance.paymentType?.toJson(),
  'items': instance.items?.map((e) => e.toJson()).toList(),
  'customerId': instance.customerId,
  'customerName': instance.customerName,
  'customerEmail': instance.customerEmail,
  'customerMobile': instance.customerMobile,
  'transactionNumber': instance.transactionNumber,
  'transactionDate': instance.transactionDate?.toIso8601String(),
  'isOnline': instance.isOnline,
  'totalRefund': instance.totalRefund,
  'totalRefundCost': instance.totalRefundCost,
  'totalItems': instance.totalItems,
  'isQuickRefund': instance.isQuickRefund,
  'terminalId': instance.terminalId,
  'batchNo': instance.batchNo,
  'referenceNo': instance.referenceNo,
  'transactionStatus': instance.transactionStatus,
  'deviceId': instance.deviceId,
  'additionalInfo': instance.additionalInfo,
};
