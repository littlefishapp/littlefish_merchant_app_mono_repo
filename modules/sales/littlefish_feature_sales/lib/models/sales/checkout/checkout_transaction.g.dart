// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutTransaction _$CheckoutTransactionFromJson(Map<String, dynamic> json) =>
    CheckoutTransaction(
        amountTendered: (json['amountTendered'] as num?)?.toDouble(),
        amountChange: (json['amountChange'] as num?)?.toDouble(),
        items: (json['items'] as List<dynamic>?)
            ?.map((e) => CheckoutCartItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        paymentType: json['paymentType'] == null
            ? null
            : PaymentType.fromJson(json['paymentType'] as Map<String, dynamic>),
        sellerId: json['sellerId'] as String?,
        sellerName: json['sellerName'] as String?,
        totalTax: (json['totalTax'] as num?)?.toDouble(),
        countryCode: json['countryCode'] as String?,
        currencyCode: json['currencyCode'] as String?,
        customerId: json['customerId'] as String?,
        customerName: json['customerName'] as String?,
        ticketId: json['ticketId'] as String?,
        ticketName: json['ticketName'] as String?,
        totalMarkup: (json['totalMarkup'] as num?)?.toDouble(),
        totalRefundCost: (json['totalRefundCost'] as num?)?.toDouble(),
        totalRefund: (json['totalRefund'] as num?)?.toDouble(),
        deviceId: json['deviceId'] as String?,
        withdrawalAmount: (json['withdrawalAmount'] as num?)?.toDouble(),
        cashbackAmount: (json['cashbackAmount'] as num?)?.toDouble(),
        tipAmount: (json['tipAmount'] as num?)?.toDouble(),
        totalDiscount: (json['totalDiscount'] as num?)?.toDouble(),
        totalCost: (json['totalCost'] as num?)?.toDouble(),
        totalValue: (json['totalValue'] as num?)?.toDouble(),
        transactionDate: const IsoDateTimeConverter().fromJson(
          json['transactionDate'],
        ),
        transactionNumber: (json['transactionNumber'] as num?)?.toDouble() ?? 0,
        customerEmail: json['customerEmail'] as String?,
        customerMobile: json['customerMobile'] as String?,
        taxInclusive: json['taxInclusive'] as bool?,
        pendingSync: json['pendingSync'] as bool? ?? false,
        id: json['id'] as String?,
        isOnline: json['isOnline'] as bool?,
        refunds: (json['refunds'] as List<dynamic>?)
            ?.map((e) => Refund.fromJson(e as Map<String, dynamic>))
            .toList(),
        additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
      )
      ..name = json['name'] as String?
      ..description = json['description'] as String?
      ..status = json['status'] as String?
      ..businessId = json['businessId'] as String?
      ..displayName = json['displayName'] as String?
      ..deviceName = json['deviceName'] as String?
      ..dateCreated = const IsoDateTimeConverter().fromJson(json['dateCreated'])
      ..dateUpdated = const IsoDateTimeConverter().fromJson(json['dateUpdated'])
      ..createdBy = json['createdBy'] as String?
      ..updatedBy = json['updatedBy'] as String?
      ..indexNo = (json['indexNo'] as num?)?.toInt()
      ..deleted = json['deleted'] as bool?
      ..enabled = json['enabled'] as bool?
      ..terminalId = json['terminalId'] as String?
      ..batchNo = (json['batchNo'] as num?)?.toInt()
      ..referenceNo = json['referenceNo'] as String?
      ..transactionStatus = json['transactionStatus'] as String?;

Map<String, dynamic> _$CheckoutTransactionToJson(
  CheckoutTransaction instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'status': instance.status,
  'businessId': instance.businessId,
  'displayName': instance.displayName,
  'deviceName': instance.deviceName,
  'dateCreated': const IsoDateTimeConverter().toJson(instance.dateCreated),
  'dateUpdated': const IsoDateTimeConverter().toJson(instance.dateUpdated),
  'createdBy': instance.createdBy,
  'updatedBy': instance.updatedBy,
  'indexNo': instance.indexNo,
  'deleted': instance.deleted,
  'enabled': instance.enabled,
  'customerId': instance.customerId,
  'customerName': instance.customerName,
  'customerEmail': instance.customerEmail,
  'customerMobile': instance.customerMobile,
  'ticketId': instance.ticketId,
  'ticketName': instance.ticketName,
  'sellerId': instance.sellerId,
  'sellerName': instance.sellerName,
  'currencyCode': instance.currencyCode,
  'countryCode': instance.countryCode,
  'deviceId': instance.deviceId,
  'taxInclusive': instance.taxInclusive,
  'totalValue': instance.totalValue,
  'totalCost': instance.totalCost,
  'totalMarkup': instance.totalMarkup,
  'totalDiscount': instance.totalDiscount,
  'totalTax': instance.totalTax,
  'totalRefund': instance.totalRefund,
  'totalRefundCost': instance.totalRefundCost,
  'amountTendered': instance.amountTendered,
  'amountChange': instance.amountChange,
  'paymentType': instance.paymentType?.toJson(),
  'transactionDate': const IsoDateTimeConverter().toJson(
    instance.transactionDate,
  ),
  'isOnline': instance.isOnline,
  'refunds': instance.refunds?.map((e) => e.toJson()).toList(),
  'terminalId': instance.terminalId,
  'batchNo': instance.batchNo,
  'referenceNo': instance.referenceNo,
  'transactionStatus': instance.transactionStatus,
  'pendingSync': instance.pendingSync,
  'items': instance.items?.map((e) => e.toJson()).toList(),
  'transactionNumber': instance.transactionNumber,
  'withdrawalAmount': instance.withdrawalAmount,
  'cashbackAmount': instance.cashbackAmount,
  'tipAmount': instance.tipAmount,
  'additionalInfo': instance.additionalInfo,
};
