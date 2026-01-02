// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutOrder _$CheckoutOrderFromJson(Map<String, dynamic> json) =>
    CheckoutOrder(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => CheckoutItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      orderDate: const EpochDateTimeConverter().fromJson(json['orderDate']),
      orderId: json['orderId'] as String?,
      storeId: json['storeId'] as String?,
      storeName: json['storeName'] as String?,
      events: (json['events'] as List<dynamic>?)
          ?.map((e) => OrderEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      shippingMethod: json['shippingMethod'] == null
          ? null
          : ShippingMethod.fromJson(
              json['shippingMethod'] as Map<String, dynamic>,
            ),
      status: json['status'] as String?,
      notes: json['notes'] as String?,
      customerId: json['customerId'] as String?,
      customerName: json['customerName'] as String?,
      storeLink: json['storeLink'] as String?,
      trackingNumber: json['trackingNumber'] as String?,
      orderUrl: json['orderUrl'] as String?,
      businessId: json['businessId'] as String?,
      billing: json['billing'] == null
          ? null
          : Billing.fromJson(json['billing'] as Map<String, dynamic>),
      userLocation: json['userLocation'] == null
          ? null
          : UserLocation.fromJson(json['userLocation'] as Map<String, dynamic>),
      shipping: json['shipping'] == null
          ? null
          : Shipping.fromJson(json['shipping'] as Map<String, dynamic>),
      paymentFee: (json['paymentFee'] as num?)?.toDouble(),
      paymentStatus: json['paymentStatus'] as String? ?? 'unpaid',
      paymentType: json['paymentType'] as String?,
      payments:
          (json['payments'] as List<dynamic>?)
              ?.map((e) => OrderPayment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0.00,
      canDeliver: json['canDeliver'] as bool?,
      deliveryDistance: (json['deliveryDistance'] as num?)?.toDouble(),
      isForCollection: json['isForCollection'] as bool?,
      isForDelivery: json['isForDelivery'] as bool?,
      maxDeliveryDistance: (json['maxDeliveryDistance'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CheckoutOrderToJson(CheckoutOrder instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'storeId': instance.storeId,
      'trackingNumber': instance.trackingNumber,
      'orderUrl': instance.orderUrl,
      'businessId': instance.businessId,
      'storeName': instance.storeName,
      'storeLink': instance.storeLink,
      'status': instance.status,
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'orderDate': const EpochDateTimeConverter().toJson(instance.orderDate),
      'items': instance.items?.map((e) => e.toJson()).toList(),
      'paymentType': instance.paymentType,
      'paymentStatus': instance.paymentStatus,
      'payments': instance.payments?.map((e) => e.toJson()).toList(),
      'notes': instance.notes,
      'billing': instance.billing?.toJson(),
      'userLocation': instance.userLocation?.toJson(),
      'shipping': instance.shipping?.toJson(),
      'shippingMethod': instance.shippingMethod?.toJson(),
      'isForCollection': instance.isForCollection,
      'isForDelivery': instance.isForDelivery,
      'paymentFee': instance.paymentFee,
      'canDeliver': instance.canDeliver,
      'maxDeliveryDistance': instance.maxDeliveryDistance,
      'deliveryDistance': instance.deliveryDistance,
      'deliveryFee': instance.deliveryFee,
      'events': instance.events?.map((e) => e.toJson()).toList(),
    };

OrderStatus _$OrderStatusFromJson(Map<String, dynamic> json) => OrderStatus(
  enabled: json['enabled'] as bool?,
  color: json['color'] as String?,
  displayName: json['displayName'] as String?,
  name: json['name'] as String?,
  searchName: json['searchName'] as String?,
  deleted: json['deleted'] as bool?,
  description: json['description'] as String?,
  id: json['id'] as String?,
  businessId: json['businessId'] as String?,
  totalOrders: (json['totalOrders'] as num?)?.toInt() ?? 0,
  isSystemStatus: json['isSystemStatus'] as bool?,
);

Map<String, dynamic> _$OrderStatusToJson(OrderStatus instance) =>
    <String, dynamic>{
      'name': instance.name,
      'displayName': instance.displayName,
      'searchName': instance.searchName,
      'description': instance.description,
      'businessId': instance.businessId,
      'color': instance.color,
      'id': instance.id,
      'enabled': instance.enabled,
      'deleted': instance.deleted,
      'isSystemStatus': instance.isSystemStatus,
      'totalOrders': instance.totalOrders,
    };

CheckoutItem _$CheckoutItemFromJson(Map<String, dynamic> json) => CheckoutItem(
  name: json['name'] as String?,
  productId: json['productId'] as String?,
  quantity: (json['quantity'] as num?)?.toDouble(),
  varianceId: json['varianceId'] as String?,
  varianceName: json['varianceName'] as String?,
  unitCostPrice: (json['unitCostPrice'] as num?)?.toDouble(),
  unitCompareAtPrice: (json['unitCompareAtPrice'] as num?)?.toDouble(),
  unitSellingPrice: (json['unitSellingPrice'] as num?)?.toDouble(),
);

Map<String, dynamic> _$CheckoutItemToJson(CheckoutItem instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'varianceId': instance.varianceId,
      'name': instance.name,
      'varianceName': instance.varianceName,
      'quantity': instance.quantity,
      'unitSellingPrice': instance.unitSellingPrice,
      'unitCompareAtPrice': instance.unitCompareAtPrice,
      'unitCostPrice': instance.unitCostPrice,
    };

OrderEvent _$OrderEventFromJson(Map<String, dynamic> json) => OrderEvent(
  details: json['details'] as String?,
  eventDate: const IsoDateTimeConverter().fromJson(json['eventDate']),
  eventId: json['eventId'] as String?,
  title: json['title'] as String?,
  user: json['user'] as String?,
);

Map<String, dynamic> _$OrderEventToJson(OrderEvent instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'eventDate': const IsoDateTimeConverter().toJson(instance.eventDate),
      'title': instance.title,
      'details': instance.details,
      'user': instance.user,
    };

TrackedOrder _$TrackedOrderFromJson(Map<String, dynamic> json) => TrackedOrder(
  status: json['status'] as String?,
  storeId: json['storeId'] as String?,
  data: json['data'],
  datePlaced: const EpochDateTimeConverter().fromJson(json['datePlaced']),
  dateUpdated: const EpochDateTimeConverter().fromJson(json['dateUpdated']),
  logoUrl: json['logoUrl'] as String?,
  orderId: json['orderId'] as String?,
  orderValue: (json['orderValue'] as num?)?.toDouble(),
  storeName: json['storeName'] as String?,
  trackingNumber: json['trackingNumber'] as String?,
);

Map<String, dynamic> _$TrackedOrderToJson(
  TrackedOrder instance,
) => <String, dynamic>{
  'orderId': instance.orderId,
  'trackingNumber': instance.trackingNumber,
  'status': instance.status,
  'datePlaced': const EpochDateTimeConverter().toJson(instance.datePlaced),
  'dateUpdated': const EpochDateTimeConverter().toJson(instance.dateUpdated),
  'data': instance.data,
  'orderValue': instance.orderValue,
  'storeName': instance.storeName,
  'storeId': instance.storeId,
  'logoUrl': instance.logoUrl,
};

OrderPayment _$OrderPaymentFromJson(Map<String, dynamic> json) => OrderPayment(
  amount: (json['amount'] as num?)?.toDouble(),
  date: const IsoDateTimeConverter().fromJson(json['date']),
  notes: json['notes'] as String?,
  paymentReference: json['paymentReference'] as String?,
  paymentType: json['paymentType'] as String?,
  id: json['id'] as String?,
  paidBy: json['paidBy'] as String?,
);

Map<String, dynamic> _$OrderPaymentToJson(OrderPayment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'paidBy': instance.paidBy,
      'paymentType': instance.paymentType,
      'paymentReference': instance.paymentReference,
      'notes': instance.notes,
      'amount': instance.amount,
      'date': const IsoDateTimeConverter().toJson(instance.date),
    };

SimpleOrder _$SimpleOrderFromJson(Map<String, dynamic> json) => SimpleOrder(
  customerName: json['customerName'] as String?,
  customerEmail: json['customerEmail'] as String?,
  customerMobile: json['customerMobile'] as String?,
  totalValue: (json['totalValue'] as num?)?.toDouble(),
  itemsInCart: (json['itemsInCart'] as num?)?.toInt(),
  paymentType: json['paymentType'] as String?,
  businessName: json['businessName'] as String?,
  transactionDate: const IsoDateTimeConverter().fromJson(
    json['transactionDate'],
  ),
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => SimpleOrderItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SimpleOrderToJson(SimpleOrder instance) =>
    <String, dynamic>{
      'customerName': instance.customerName,
      'customerEmail': instance.customerEmail,
      'customerMobile': instance.customerMobile,
      'totalValue': instance.totalValue,
      'itemsInCart': instance.itemsInCart,
      'paymentType': instance.paymentType,
      'businessName': instance.businessName,
      'transactionDate': const IsoDateTimeConverter().toJson(
        instance.transactionDate,
      ),
      'items': instance.items?.map((e) => e.toJson()).toList(),
    };

SimpleOrderItem _$SimpleOrderItemFromJson(Map<String, dynamic> json) =>
    SimpleOrderItem(
      id: json['id'] as String?,
      name: json['name'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SimpleOrderItemToJson(SimpleOrderItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'quantity': instance.quantity,
      'total': instance.total,
    };
