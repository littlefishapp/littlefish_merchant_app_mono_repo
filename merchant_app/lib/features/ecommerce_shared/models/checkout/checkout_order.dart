import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:uuid/uuid.dart';
import '../../../../tools/converters/iso_date_time_converter.dart';
import '../shared/firebase_document_model.dart';
import '../store/store.dart';
import '../store/store_product.dart';
import '../user/user.dart';

part 'checkout_order.g.dart';

@JsonSerializable(explicitToJson: true)
@EpochDateTimeConverter()
class CheckoutOrder extends FirebaseDocumentModel {
  CheckoutOrder({
    this.items,
    this.orderDate,
    this.orderId,
    this.storeId,
    this.storeName,
    this.events,
    this.shippingMethod,
    this.status,
    this.notes,
    this.customerId,
    this.customerName,
    this.storeLink,
    this.trackingNumber,
    this.orderUrl,
    this.businessId,
    this.billing,
    this.userLocation,
    this.shipping,
    this.paymentFee,
    this.paymentStatus,
    this.paymentType,
    this.payments,
    this.deliveryFee = 0.00,
    this.canDeliver,
    this.deliveryDistance,
    this.isForCollection,
    this.isForDelivery,
    this.maxDeliveryDistance,
  });

  CheckoutOrder.fromStore(Store store) {
    try {
      orderId = const Uuid().v4();

      storeId = store.businessId;
      businessId = store.businessId;

      storeName = store.displayName;
      storeLink = store.storeUrl;

      paymentFee = 0.0;
      events = [];

      status = 'NEW';
      orderDate = DateTime.now();

      items = <CheckoutItem>[];
      events = [];

      //this forces the default to collection

      if (store.storePreferences!.acceptsOnlineOrders == true) {
        // this.isForDelivery =
        canDeliver = store.deliverySettings?.enabled ?? false;
        // this.isForCollection = store.collectionSettings?.enabled ?? false;

        maxDeliveryDistance = canDeliver!
            ? store.deliverySettings?.deliveryRadius?.toDouble() ?? 0.00
            : 0.00;

        //only applicable for delivery
        deliveryFee = canDeliver!
            ? store.storePreferences?.onlineFee?.amount ?? 0.00
            : 0.00;
      } else {
        // this.isForCollection = false;
        // this.isForDelivery = false;
        store.storePreferences!.acceptsOnlineOrders = false;
      }

      // if (!store.collectionSettings.enabled &&
      //     !store.deliverySettings.enabled &&
      //     store.storePreferences.acceptsOnlineOrders) {
      //   this.isForCollection = true;
      //   this.isForDelivery = false;
      // } else if (store.collectionSettings.enabled) {
      //   this.isForCollection = true;
      //   this.isForDelivery = false;
      // } else {
      //   this.isForCollection = false;
      //   this.isForDelivery = true;
      // }
    } catch (error) {
      LittleFishCore.instance.get<LoggerService>().error(
        'features.ecommerce.checkout_order',
        'Error initializing checkout order: $error',
      );
      rethrow;
    }
  }

  String? orderId;

  String? storeId;

  String? trackingNumber;

  String? orderUrl;

  String? businessId;

  String? storeName;

  String? storeLink;

  String? status;

  //this is the uid which is shared by all users and shop keepers
  String? customerId;

  String? customerName;

  DateTime? orderDate;

  List<CheckoutItem>? items;

  String? paymentType;

  @JsonKey(defaultValue: 'unpaid')
  String? paymentStatus;

  @JsonKey(defaultValue: <OrderPayment>[])
  List<OrderPayment>? payments;

  String? notes;

  Billing? billing;

  UserLocation? userLocation;

  //this could be the exact same as the billing and it is by default
  Shipping? shipping;

  ShippingMethod? shippingMethod;

  bool? isForCollection;

  bool? isForDelivery;

  double get totalDueByCustomer {
    var value = orderValue + serviceFee + (paymentFee ?? 0.0);

    if (isForDelivery! && canDeliver!) value += deliveryFee!;

    return value;
  }

  double? paymentFee;

  bool get hasPaymentFee => (paymentFee ?? 0.0) > 0;

  @JsonKey(includeFromJson: false, includeToJson: false)
  CollectionReference? get chatCollection =>
      documentReference?.collection('chat');

  double get serviceFee {
    if (orderValue <= 0) return 0;

    //ToDo: calculate based on shopper tier

    var feePercentage = 0.01;

    var minFee = 2.50;

    var maxFee = 55.00;

    var fee = orderValue * feePercentage;

    if (fee <= minFee) return minFee;
    if (fee >= maxFee) return maxFee;

    return fee;
  }

  bool? canDeliver;

  double? maxDeliveryDistance;

  double? deliveryDistance;

  double? deliveryFee;

  double get orderItemCount {
    if (items == null || items!.isEmpty) return 0;

    return items?.map((i) => i.quantity).reduce((a, b) => a! + b!) ?? 0;
  }

  double get orderValue {
    if (items!.isEmpty) return 0;
    var value = items?.map((i) => i.totalAmount).reduce((a, b) => a + b) ?? 0;

    return double.parse(value.toStringAsFixed(2));
  }

  double get orderCost {
    if (items!.isEmpty) return 0;
    var value = items?.map((i) => i.totalCost).reduce((a, b) => a + b) ?? 0;

    return double.parse((value).toStringAsFixed(2));
  }

  double get orderSaving {
    if (items!.isEmpty) return 0;
    var value = items?.map((i) => i.totalSaving).reduce((a, b) => a + b) ?? 0;

    return double.parse(value.toStringAsFixed(2));
  }

  double get markup {
    if (orderValue <= 0) return 0;

    if (orderCost <= 0) return 0;

    var totalCalculatedValue = items!
        .map((s) => s.totalAmount)
        .reduce((a, b) => a + b);

    var totalCalculatedCost = items!
        .map((s) => s.totalCost)
        .reduce((a, b) => a + b);

    if (totalCalculatedValue <= 0) return 0.0;

    if (totalCalculatedCost <= 0) return 0.0;

    //mark-up only applies to items that can be measured, should there be no measurable items no markup should be tracked / recorded
    return 100 - ((totalCalculatedCost / totalCalculatedValue) * 100);
  }

  bool get hasBillingAddress => billing?.hasBillingAddress ?? false;

  List<OrderEvent>? events;

  factory CheckoutOrder.fromJson(Map<String, dynamic> json) =>
      _$CheckoutOrderFromJson(json);

  //add additional entries that will enrich the information sent to the server
  Map<String, dynamic> toJson() => _$CheckoutOrderToJson(this);
  // ..addAll(
  //   {
  //     "orderTotal": totalDueByCustomer,
  //     "orderMarkup": markup,
  //     "orderValue": orderValue,
  //     "orderCost": orderCost,
  //     "orderFees": totalDueByCustomer - orderValue,
  //     "orderPaymentFee": paymentFee,
  //     "orderServiceFee": serviceFee,
  //     "orderDeliveryFee": deliveryFee,
  //     "orderSaving": orderSaving,
  //     "orderItemCount": orderItemCount,
  //   },
  // );

  //this is to be used when loading
  factory CheckoutOrder.fromDocumentSnapshot(
    DocumentSnapshot snapshot, {
    DocumentReference? reference,
  }) => _$CheckoutOrderFromJson(snapshot.data() as Map<String, dynamic>)
    ..documentSnapshot = snapshot
    ..documentReference = reference;
}

@JsonSerializable(explicitToJson: true)
class OrderStatus {
  String? name, displayName, searchName, description;
  String? businessId;
  String? color;
  String? id;
  bool? enabled, deleted;
  bool? isSystemStatus;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? action;

  @JsonKey(defaultValue: 0)
  int? totalOrders;

  OrderStatus({
    this.enabled,
    this.color,
    this.displayName,
    this.name,
    this.searchName,
    this.deleted,
    this.description,
    this.id,
    this.businessId,
    this.totalOrders,
    this.isSystemStatus,
    this.action,
  });

  factory OrderStatus.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusFromJson(json);

  Map<String, dynamic> toJson() => _$OrderStatusToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CheckoutItem {
  CheckoutItem({
    this.name,
    this.productId,
    this.quantity,
    this.varianceId,
    this.varianceName,
    this.unitCostPrice,
    this.unitCompareAtPrice,
    this.unitSellingPrice,
    this.productUrl,
    this.product,
  });

  CheckoutItem.fromProduct(StoreProduct product, double this.quantity) {
    productId = product.productId;
    name = product.displayName;

    productUrl = product.featureImageUrl;

    //prices
    unitSellingPrice = double.parse((product.sellingPrice?.toString() ?? '0'));

    unitCostPrice = double.parse((product.costPrice?.toString() ?? '0'));

    unitCompareAtPrice = double.parse(
      (product.compareAtPrice?.toString() ?? '0'),
    );
  }

  String? productId;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? productUrl;

  @JsonKey(includeFromJson: false, includeToJson: false)
  StoreProduct? product;

  String? varianceId;

  String? name;

  String? varianceName;

  double? quantity;

  double? unitSellingPrice;

  double? unitCompareAtPrice;

  double? unitCostPrice;

  double get totalCost => (unitCostPrice ?? 0) * (quantity ?? 0);

  double get totalSaving =>
      (unitCompareAtPrice ?? 0) * (quantity ?? 0) - totalCost;

  double get totalAmount => (unitSellingPrice ?? 0) * (quantity ?? 0);

  factory CheckoutItem.fromJson(Map<String, dynamic> json) =>
      _$CheckoutItemFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutItemToJson(this);
}

@JsonSerializable(explicitToJson: true)
@IsoDateTimeConverter()
class OrderEvent {
  OrderEvent({
    this.details,
    this.eventDate,
    this.eventId,
    this.title,
    this.user,
  });

  String? eventId;

  DateTime? eventDate;

  String? title;

  String? details;

  String? user;

  factory OrderEvent.fromJson(Map<String, dynamic> json) =>
      _$OrderEventFromJson(json);

  Map<String, dynamic> toJson() => _$OrderEventToJson(this);
}

@JsonSerializable()
@EpochDateTimeConverter()
class TrackedOrder {
  TrackedOrder({
    this.status,
    this.storeId,
    this.data,
    this.datePlaced,
    this.dateUpdated,
    this.logoUrl,
    this.orderId,
    this.orderValue,
    this.storeName,
    this.trackingNumber,
  });

  String? orderId;

  String? trackingNumber;

  String? status;

  DateTime? datePlaced;

  DateTime? dateUpdated;

  dynamic data;

  double? orderValue;

  String? storeName, storeId, logoUrl;

  factory TrackedOrder.fromJson(Map<String, dynamic> json) =>
      _$TrackedOrderFromJson(json);
}

@JsonSerializable()
@IsoDateTimeConverter()
class OrderPayment {
  OrderPayment({
    this.amount,
    this.date,
    this.notes,
    this.paymentReference,
    this.paymentType,
    this.id,
    this.paidBy,
  });

  String? id;

  String? paidBy;

  String? paymentType;

  String? paymentReference;

  String? notes;

  double? amount;

  DateTime? date;

  factory OrderPayment.fromJson(Map<String, dynamic> json) =>
      _$OrderPaymentFromJson(json);

  Map<String, dynamic> toJson() => _$OrderPaymentToJson(this);
}

@JsonSerializable(explicitToJson: true)
@IsoDateTimeConverter()
class SimpleOrder {
  String? customerName;
  String? customerEmail;
  String? customerMobile;
  double? totalValue;
  int? itemsInCart;
  String? paymentType;
  String? businessName;
  DateTime? transactionDate;
  List<SimpleOrderItem>? items;

  SimpleOrder({
    this.customerName,
    this.customerEmail,
    this.customerMobile,
    this.totalValue,
    this.itemsInCart,
    this.paymentType,
    this.businessName,
    this.transactionDate,
    this.items,
  });

  SimpleOrder.fromCheckoutOrder(CheckoutOrder order) {
    customerName = order.billing!.firstName;
    customerEmail = order.billing!.email;
    customerMobile = order.billing!.phone;
    totalValue = order.orderValue;
    itemsInCart = order.orderItemCount.toInt();
    paymentType = order.paymentType;
    businessName = order.storeName;
    transactionDate = order.orderDate;
    items = order.items!
        .map((i) => SimpleOrderItem.fromCheckoutItem(i))
        .toList();
  }

  factory SimpleOrder.fromJson(Map<String, dynamic> json) =>
      _$SimpleOrderFromJson(json);

  Map<String, dynamic> toJson() => _$SimpleOrderToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SimpleOrderItem {
  String? id;
  String? name;
  int? quantity;
  double? total;

  SimpleOrderItem({this.id, this.name, this.quantity, this.total});

  SimpleOrderItem.fromCheckoutItem(CheckoutItem item) {
    total = item.totalAmount;
    name = item.name;
    quantity = item.quantity!.toInt();
  }

  factory SimpleOrderItem.fromJson(Map<String, dynamic> json) =>
      _$SimpleOrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$SimpleOrderItemToJson(this);
}
