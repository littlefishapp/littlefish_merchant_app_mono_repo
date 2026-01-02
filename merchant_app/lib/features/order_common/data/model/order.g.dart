// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
  id: json['id'] as String? ?? '',
  deviceInfo: json['deviceInfo'] as String? ?? '',
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  businessId: json['businessId'] as String? ?? '',
  totalAmountOutstanding:
      (json['totalAmountOutstanding'] as num?)?.toDouble() ?? 0.0,
  totalAmountPaid: (json['totalAmountPaid'] as num?)?.toDouble() ?? 0.0,
  totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
  totalCost: (json['totalCost'] as num?)?.toDouble() ?? 0.0,
  currentTotalPrice: (json['currentTotalPrice'] as num?)?.toDouble() ?? 0.0,
  subtotalPrice: (json['subtotalPrice'] as num?)?.toDouble() ?? 0.0,
  lineItemTotalPrice: (json['lineItemTotalPrice'] as num?)?.toDouble() ?? 0.0,
  totalLineItemsSold: (json['totalLineItemsSold'] as num?)?.toDouble() ?? 0,
  totalUniqueLineItems: (json['totalUniqueLineItems'] as num?)?.toInt() ?? 0,
  totalTip: (json['totalTip'] as num?)?.toDouble() ?? 0.0,
  totalWithdrawal: (json['totalWithdrawal'] as num?)?.toDouble() ?? 0.0,
  totalTax: (json['totalTax'] as num?)?.toDouble() ?? 0.0,
  totalDiscount: (json['totalDiscount'] as num?)?.toDouble() ?? 0.0,
  totalShipping: (json['totalShipping'] as num?)?.toDouble() ?? 0.0,
  totalRefunded: (json['totalRefunded'] as num?)?.toDouble() ?? 0.0,
  capturedChannel:
      $enumDecodeNullable(_$CapturedChannelEnumMap, json['capturedChannel']) ??
      CapturedChannel.undefined,
  financialStatus:
      $enumDecodeNullable(_$FinancialStatusEnumMap, json['financialStatus']) ??
      FinancialStatus.undefined,
  orderStatus:
      $enumDecodeNullable(_$OrderStatusEnumMap, json['orderStatus']) ??
      OrderStatus.undefined,
  createdBy: json['createdBy'] as String? ?? '',
  trackingValue: json['trackingValue'] as String? ?? '',
  orderNumber: (json['orderNumber'] as num?)?.toInt() ?? 0,
  taxes:
      (json['taxes'] as List<dynamic>?)
          ?.map((e) => TaxInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  discounts:
      (json['discounts'] as List<dynamic>?)
          ?.map((e) => OrderDiscount.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  orderLineItems:
      (json['orderLineItems'] as List<dynamic>?)
          ?.map((e) => OrderLineItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  refunds:
      (json['refunds'] as List<dynamic>?)
          ?.map((e) => OrderRefund.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  dateCreated: json['dateCreated'] == null
      ? null
      : DateTime.parse(json['dateCreated'] as String),
  dateUpdated: json['dateUpdated'] == null
      ? null
      : DateTime.parse(json['dateUpdated'] as String),
  updatedBy: json['updatedBy'] as String? ?? '',
  transactions:
      (json['transactions'] as List<dynamic>?)
          ?.map((e) => OrderTransaction.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  fulfillmentStatus:
      $enumDecodeNullable(
        _$FulfillmentStatusEnumMap,
        json['fulfillmentStatus'],
      ) ??
      FulfillmentStatus.undefined,
  orderSource:
      $enumDecodeNullable(_$OrderSourceEnumMap, json['orderSource']) ??
      OrderSource.undefined,
  fulfilmentMethod:
      $enumDecodeNullable(
        _$FulfilmentMethodEnumMap,
        json['fulfilmentMethod'],
      ) ??
      FulfilmentMethod.undefined,
  orderVersion: json['orderVersion'] as String? ?? '',
  orderHistory:
      (json['orderHistory'] as List<dynamic>?)
          ?.map((e) => OrderHistoryLog.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  customerReference: json['customerReference'] as String? ?? '',
  notes: json['notes'] as String? ?? '',
  deviceId: json['deviceId'] as String? ?? '',
  terminalId: json['terminalId'] as String? ?? '',
  batchNo: (json['batchNo'] as num?)?.toInt(),
  referenceNo: json['referenceNo'] as String? ?? '',
  customerId: json['customerId'] as String? ?? '',
  customerName: json['customerName'] as String? ?? '',
  customerEmail: json['customerEmail'] as String? ?? '',
  customerMobile: json['customerMobile'] as String? ?? '',
  sellerId: json['sellerId'] as String? ?? '',
  sellerName: json['sellerName'] as String? ?? '',
  totalCashBack: (json['totalCashBack'] as num?)?.toDouble() ?? 0,
  totalChange: (json['totalChange'] as num?)?.toDouble() ?? 0,
  customer: json['customer'] == null
      ? null
      : Customer.fromJson(json['customer'] as Map<String, dynamic>),
  parentID: json['parentID'] as String? ?? '',
  originatingChannelDetails: json['originatingChannelDetails'] as String? ?? '',
  type:
      $enumDecodeNullable(_$OrderTypeEnumMap, json['type']) ??
      OrderType.salesOrder,
  orderSubtotal: (json['orderSubtotal'] as num?)?.toDouble() ?? 0,
  orderTotal: (json['orderTotal'] as num?)?.toDouble() ?? 0,
  currencyCode: json['currencyCode'] as String? ?? '',
  shipperName: json['shipperName'] as String? ?? '',
  trackingNumber: json['trackingNumber'] as String? ?? '',
  estimateDeliverydate: json['estimateDeliverydate'] == null
      ? null
      : DateTime.parse(json['estimateDeliverydate'] as String),
  paymentLinkUrl: json['paymentLinkUrl'] as String? ?? '',
  paymentLinkStatus:
      $enumDecodeNullable(
        _$PaymentLinkStatusEnumMap,
        json['paymentLinkStatus'],
      ) ??
      PaymentLinkStatus.created,
  paymentLinkId: json['paymentLinkId'] as String? ?? '',
  url: json['url'] as String? ?? '',
  note: json['note'] as String? ?? '',
  invoiceDueDate: json['invoiceDueDate'] == null
      ? null
      : DateTime.parse(json['invoiceDueDate'] as String),
);

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
  'id': instance.id,
  'trackingValue': instance.trackingValue,
  'orderNumber': instance.orderNumber,
  'deviceInfo': instance.deviceInfo,
  'tags': instance.tags,
  'businessId': instance.businessId,
  'totalAmountOutstanding': instance.totalAmountOutstanding,
  'totalAmountPaid': instance.totalAmountPaid,
  'totalPrice': instance.totalPrice,
  'totalCost': instance.totalCost,
  'currentTotalPrice': instance.currentTotalPrice,
  'subtotalPrice': instance.subtotalPrice,
  'lineItemTotalPrice': instance.lineItemTotalPrice,
  'totalLineItemsSold': instance.totalLineItemsSold,
  'totalUniqueLineItems': instance.totalUniqueLineItems,
  'totalTip': instance.totalTip,
  'totalWithdrawal': instance.totalWithdrawal,
  'totalTax': instance.totalTax,
  'totalDiscount': instance.totalDiscount,
  'totalShipping': instance.totalShipping,
  'totalRefunded': instance.totalRefunded,
  'taxes': instance.taxes.map((e) => e.toJson()).toList(),
  'discounts': instance.discounts.map((e) => e.toJson()).toList(),
  'capturedChannel': _$CapturedChannelEnumMap[instance.capturedChannel]!,
  'orderLineItems': instance.orderLineItems.map((e) => e.toJson()).toList(),
  'refunds': instance.refunds.map((e) => e.toJson()).toList(),
  'financialStatus': _$FinancialStatusEnumMap[instance.financialStatus]!,
  'fulfillmentStatus': _$FulfillmentStatusEnumMap[instance.fulfillmentStatus]!,
  'orderStatus': _$OrderStatusEnumMap[instance.orderStatus]!,
  'dateCreated': instance.dateCreated?.toIso8601String(),
  'dateUpdated': instance.dateUpdated?.toIso8601String(),
  'createdBy': instance.createdBy,
  'updatedBy': instance.updatedBy,
  'transactions': instance.transactions.map((e) => e.toJson()).toList(),
  'orderSource': _$OrderSourceEnumMap[instance.orderSource]!,
  'fulfilmentMethod': _$FulfilmentMethodEnumMap[instance.fulfilmentMethod]!,
  'orderVersion': instance.orderVersion,
  'orderHistory': instance.orderHistory.map((e) => e.toJson()).toList(),
  'customerReference': instance.customerReference,
  'notes': instance.notes,
  'deviceId': instance.deviceId,
  'terminalId': instance.terminalId,
  'batchNo': instance.batchNo,
  'referenceNo': instance.referenceNo,
  'customerId': instance.customerId,
  'customerName': instance.customerName,
  'customerEmail': instance.customerEmail,
  'customerMobile': instance.customerMobile,
  'sellerId': instance.sellerId,
  'sellerName': instance.sellerName,
  'totalCashBack': instance.totalCashBack,
  'totalChange': instance.totalChange,
  'customer': instance.customer?.toJson(),
  'parentID': instance.parentID,
  'originatingChannelDetails': instance.originatingChannelDetails,
  'type': _$OrderTypeEnumMap[instance.type],
  'orderSubtotal': instance.orderSubtotal,
  'orderTotal': instance.orderTotal,
  'currencyCode': instance.currencyCode,
  'shipperName': instance.shipperName,
  'trackingNumber': instance.trackingNumber,
  'estimateDeliverydate': instance.estimateDeliverydate?.toIso8601String(),
  'paymentLinkUrl': instance.paymentLinkUrl,
  'paymentLinkId': instance.paymentLinkId,
  'paymentLinkStatus': _$PaymentLinkStatusEnumMap[instance.paymentLinkStatus]!,
  'url': instance.url,
  'note': instance.note,
  'invoiceDueDate': instance.invoiceDueDate?.toIso8601String(),
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

const _$OrderTypeEnumMap = {
  OrderType.salesOrder: 0,
  OrderType.invoice: 1,
  OrderType.orderTypeReturn: 2,
};

const _$PaymentLinkStatusEnumMap = {
  PaymentLinkStatus.notPaymentLink: 0,
  PaymentLinkStatus.created: 1,
  PaymentLinkStatus.sent: 2,
  PaymentLinkStatus.paid: 3,
  PaymentLinkStatus.disabled: 4,
  PaymentLinkStatus.expired: 5,
};
