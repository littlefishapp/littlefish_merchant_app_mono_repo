import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/features/order_common/data/model/customer.dart';
import 'package:quiver/strings.dart';

import '../../../order_common/data/model/order_discount.dart';
import '../../../order_common/data/model/order_line_item.dart';
import '../../../order_common/data/model/order_refund.dart';
import 'order_history_log.dart';
import 'order_transaction.dart';
import 'tax_info.dart';

part 'order.g.dart';

@JsonSerializable(explicitToJson: true)
class Order extends Equatable {
  final String id;
  final String trackingValue;
  final int orderNumber;
  final String deviceInfo;
  final List<String> tags;
  final String businessId;
  final double totalAmountOutstanding;
  final double totalAmountPaid;
  final double totalPrice;
  final double totalCost;
  final double currentTotalPrice;
  final double subtotalPrice;
  final double lineItemTotalPrice;
  final double totalLineItemsSold;
  final int totalUniqueLineItems;
  final double totalTip;
  final double totalWithdrawal;
  final double totalTax;
  final double totalDiscount;
  final double totalShipping;
  final double totalRefunded;
  final List<TaxInfo> taxes;
  final List<OrderDiscount> discounts;
  final CapturedChannel capturedChannel;
  final List<OrderLineItem> orderLineItems;
  final List<OrderRefund> refunds;
  final FinancialStatus financialStatus;
  final FulfillmentStatus fulfillmentStatus;
  final OrderStatus orderStatus;
  final DateTime? dateCreated;
  final DateTime? dateUpdated;
  final String createdBy;
  final String updatedBy;
  final List<OrderTransaction> transactions;
  final OrderSource orderSource;
  final FulfilmentMethod fulfilmentMethod;
  final String orderVersion;
  final List<OrderHistoryLog> orderHistory;
  final String customerReference;
  final String notes;
  final String deviceId;
  final String terminalId;
  final int? batchNo;
  final String referenceNo;
  final String customerId;
  final String customerName;
  final String customerEmail;
  final String customerMobile;
  final String sellerId;
  final String sellerName;
  final double totalCashBack;
  final double totalChange;
  final Customer? customer;
  final String parentID;
  final String originatingChannelDetails;
  final OrderType? type;
  final double? orderSubtotal;
  final double? orderTotal;
  final String currencyCode;
  final String shipperName;
  final String trackingNumber;
  final DateTime? estimateDeliverydate;
  final String paymentLinkUrl;
  final String paymentLinkId;
  final PaymentLinkStatus paymentLinkStatus;
  final String url;
  final String note;
  final DateTime? invoiceDueDate;

  const Order({
    this.id = '',
    this.deviceInfo = '',
    this.tags = const [],
    this.businessId = '',
    this.totalAmountOutstanding = 0.0,
    this.totalAmountPaid = 0.0,
    this.totalPrice = 0.0,
    this.totalCost = 0.0,
    this.currentTotalPrice = 0.0,
    this.subtotalPrice = 0.0,
    this.lineItemTotalPrice = 0.0,
    this.totalLineItemsSold = 0,
    this.totalUniqueLineItems = 0,
    this.totalTip = 0.0,
    this.totalWithdrawal = 0.0,
    this.totalTax = 0.0,
    this.totalDiscount = 0.0,
    this.totalShipping = 0.0,
    this.totalRefunded = 0.0,
    this.capturedChannel = CapturedChannel.undefined,
    this.financialStatus = FinancialStatus.undefined,
    this.orderStatus = OrderStatus.undefined,
    this.createdBy = '',
    this.trackingValue = '',
    this.orderNumber = 0,
    this.taxes = const [],
    this.discounts = const [],
    this.orderLineItems = const [],
    this.refunds = const [],
    this.dateCreated,
    this.dateUpdated,
    this.updatedBy = '',
    this.transactions = const [],
    this.fulfillmentStatus = FulfillmentStatus.undefined,
    this.orderSource = OrderSource.undefined,
    this.fulfilmentMethod = FulfilmentMethod.undefined,
    this.orderVersion = '',
    this.orderHistory = const [],
    this.customerReference = '',
    this.notes = '',
    this.deviceId = '',
    this.terminalId = '',
    this.batchNo,
    this.referenceNo = '',
    this.customerId = '',
    this.customerName = '',
    this.customerEmail = '',
    this.customerMobile = '',
    this.sellerId = '',
    this.sellerName = '',
    this.totalCashBack = 0,
    this.totalChange = 0,
    this.customer,
    this.parentID = '',
    this.originatingChannelDetails = '',
    this.type = OrderType.salesOrder,
    this.orderSubtotal = 0,
    this.orderTotal = 0,
    this.currencyCode = '',
    this.shipperName = '',
    this.trackingNumber = '',
    this.estimateDeliverydate,
    this.paymentLinkUrl = '',
    this.paymentLinkStatus = PaymentLinkStatus.created,
    this.paymentLinkId = '',
    this.url = '',
    this.note = '',
    this.invoiceDueDate,
  });

  Order copyWith({
    String? id,
    String? trackingValue,
    int? orderNumber,
    String? deviceInfo,
    List<String>? tags,
    String? businessId,
    double? totalAmountOutstanding,
    double? totalAmountPaid,
    double? totalPrice,
    double? totalCost,
    double? currentTotalPrice,
    double? subtotalPrice,
    double? lineItemTotalPrice,
    double? totalLineItemsSold,
    int? totalUniqueLineItems,
    double? totalTip,
    double? totalWithdrawal,
    double? totalTax,
    double? totalDiscount,
    double? totalShipping,
    double? totalRefunded,
    List<TaxInfo>? taxes,
    List<OrderDiscount>? discounts,
    CapturedChannel? capturedChannel,
    List<OrderLineItem>? orderLineItems,
    List<OrderRefund>? refunds,
    FinancialStatus? financialStatus,
    OrderStatus? orderStatus,
    DateTime? dateCreated,
    DateTime? dateUpdated,
    String? createdBy,
    String? updatedBy,
    List<OrderTransaction>? transactions,
    FulfillmentStatus? fulfillmentStatus,
    OrderSource? orderSource,
    FulfilmentMethod? fulfilmentMethod,
    String? orderVersion,
    List<OrderHistoryLog>? orderHistory,
    String? customerReference,
    String? notes,
    String? deviceId,
    String? terminalId,
    int? batchNo,
    String? referenceNo,
    String? customerId,
    String? customerName,
    String? customerEmail,
    String? customerMobile,
    String? sellerId,
    String? sellerName,
    double? totalCashBack,
    double? totalChange,
    Customer? customer,
    String? shipperName,
    String? trackingNumber,
    DateTime? estimateDeliverydate,
    OrderType? type,
    String? paymentLinkUrl,
    PaymentLinkStatus? paymentLinkStatus,
    String? paymentLinkId,
    String? url,
    String? note,
    DateTime? invoiceDueDate,
  }) {
    return Order(
      businessId: businessId ?? this.businessId,
      capturedChannel: capturedChannel ?? this.capturedChannel,
      createdBy: createdBy ?? this.createdBy,
      currentTotalPrice: currentTotalPrice ?? this.currentTotalPrice,
      dateCreated: dateCreated ?? this.dateCreated,
      dateUpdated: dateUpdated ?? this.dateUpdated,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      discounts: discounts ?? this.discounts,
      financialStatus: financialStatus ?? this.financialStatus,
      id: id ?? this.id,
      lineItemTotalPrice: lineItemTotalPrice ?? this.lineItemTotalPrice,
      orderLineItems: orderLineItems ?? this.orderLineItems,
      orderNumber: orderNumber ?? this.orderNumber,
      orderStatus: orderStatus ?? this.orderStatus,
      refunds: refunds ?? this.refunds,
      subtotalPrice: subtotalPrice ?? this.subtotalPrice,
      tags: tags ?? this.tags,
      taxes: taxes ?? this.taxes,
      totalAmountOutstanding:
          totalAmountOutstanding ?? this.totalAmountOutstanding,
      totalAmountPaid: totalAmountPaid ?? this.totalAmountPaid,
      totalCost: totalCost ?? this.totalCost,
      totalDiscount: totalDiscount ?? this.totalDiscount,
      totalLineItemsSold: totalLineItemsSold ?? this.totalLineItemsSold,
      totalPrice: totalPrice ?? this.totalPrice,
      totalRefunded: totalRefunded ?? this.totalRefunded,
      totalShipping: totalShipping ?? this.totalShipping,
      totalTax: totalTax ?? this.totalTax,
      totalTip: totalTip ?? this.totalTip,
      totalUniqueLineItems: totalUniqueLineItems ?? this.totalUniqueLineItems,
      totalWithdrawal: totalWithdrawal ?? this.totalWithdrawal,
      trackingValue: trackingValue ?? this.trackingValue,
      transactions: transactions ?? this.transactions,
      updatedBy: updatedBy ?? this.updatedBy,
      fulfillmentStatus: fulfillmentStatus ?? this.fulfillmentStatus,
      orderSource: orderSource ?? this.orderSource,
      fulfilmentMethod: fulfilmentMethod ?? this.fulfilmentMethod,
      orderHistory: orderHistory ?? this.orderHistory,
      orderVersion: orderVersion ?? this.orderVersion,
      customerReference: customerReference ?? this.customerReference,
      notes: notes ?? this.notes,
      deviceId: deviceId ?? this.deviceId,
      terminalId: terminalId ?? this.terminalId,
      batchNo: batchNo ?? this.batchNo,
      referenceNo: referenceNo ?? this.referenceNo,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerMobile: customerMobile ?? this.customerMobile,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      totalCashBack: totalCashBack ?? this.totalCashBack,
      totalChange: totalChange ?? this.totalChange,
      customer: customer ?? this.customer,
      shipperName: shipperName ?? this.shipperName,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      estimateDeliverydate: estimateDeliverydate ?? this.estimateDeliverydate,
      type: type ?? this.type,
      paymentLinkUrl: paymentLinkUrl ?? this.paymentLinkUrl,
      paymentLinkStatus: paymentLinkStatus ?? this.paymentLinkStatus,
      paymentLinkId: paymentLinkId ?? this.paymentLinkId,
      url: url ?? this.url,
      note: note ?? this.note,
      invoiceDueDate: invoiceDueDate ?? this.invoiceDueDate,
    );
  }

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);

  static int financialStatusToJson(FinancialStatus financialStatus) =>
      _$FinancialStatusEnumMap[financialStatus]!;

  static int orderStatusToJson(OrderStatus orderStatus) =>
      _$OrderStatusEnumMap[orderStatus]!;

  static int fulfillmentStatusToJson(FulfillmentStatus fulfillmentStatus) =>
      _$FulfillmentStatusEnumMap[fulfillmentStatus]!;

  static int capturedChannelToJson(CapturedChannel capturedChannel) =>
      _$CapturedChannelEnumMap[capturedChannel]!;

  static int fulfilmentMethodToJson(FulfilmentMethod fulfilmentMethod) =>
      _$FulfilmentMethodEnumMap[fulfilmentMethod]!;

  static int orderSourceToJson(OrderSource orderSource) =>
      _$OrderSourceEnumMap[orderSource]!;

  @override
  List<Object?> get props => [
    id,
    trackingValue,
    orderNumber,
    deviceInfo,
    tags,
    businessId,
    totalAmountOutstanding,
    totalAmountPaid,
    totalPrice,
    totalCost,
    currentTotalPrice,
    subtotalPrice,
    lineItemTotalPrice,
    totalLineItemsSold,
    totalUniqueLineItems,
    totalTip,
    totalWithdrawal,
    totalTax,
    totalDiscount,
    totalShipping,
    totalRefunded,
    taxes,
    discounts,
    capturedChannel,
    orderLineItems,
    refunds,
    financialStatus,
    orderStatus,
    dateCreated,
    dateUpdated,
    createdBy,
    updatedBy,
    transactions,
    fulfilmentMethod,
    fulfillmentStatus,
    orderSource,
    orderVersion,
    orderHistory,
    customerReference,
    notes,
    deviceId,
    terminalId,
    batchNo,
    referenceNo,
    customerId,
    customerName,
    customerEmail,
    customerMobile,
    sellerId,
    sellerName,
    totalCashBack,
    customer,
    shipperName,
    trackingNumber,
    estimateDeliverydate,
    paymentLinkUrl,
    paymentLinkStatus,
    paymentLinkId,
    url,
    note,
    invoiceDueDate,
  ];

  List<Customer> get customersFromTransactions {
    return transactions
        .where((transaction) => isNotBlank(transaction.customer.id))
        .map((transaction) => transaction.customer)
        .toSet()
        .toList();
  }
}

@JsonEnum()
enum FinancialStatus {
  @JsonValue(-1)
  undefined,
  @JsonValue(0)
  pending,
  @JsonValue(1)
  partiallyPaid,
  @JsonValue(2)
  paid,
  @JsonValue(3)
  partiallyRefunded,
  @JsonValue(4)
  refunded,
  @JsonValue(5)
  $void,
  @JsonValue(6)
  error,
}

@JsonEnum()
enum OrderStatus {
  @JsonValue(-1)
  undefined,
  @JsonValue(0)
  draft,
  @JsonValue(1)
  discarded,
  @JsonValue(2)
  open,
  @JsonValue(3)
  closed,
}

@JsonEnum()
enum CapturedChannel {
  @JsonValue(-1)
  undefined,
  @JsonValue(0)
  web,
  @JsonValue(1)
  android,
  @JsonValue(2)
  ios,
  @JsonValue(3)
  pos,
  @JsonValue(4)
  notUsed,
}

@JsonEnum()
enum FulfillmentStatus {
  @JsonValue(-1)
  undefined,
  @JsonValue(0)
  received,
  @JsonValue(1)
  processing,
  @JsonValue(2)
  dispatched,
  @JsonValue(3)
  complete,
  @JsonValue(4)
  failed,
  @JsonValue(5)
  cancelled,
}

@JsonEnum()
enum FulfilmentMethod {
  @JsonValue(-1)
  undefined,
  @JsonValue(0)
  delivery,
  @JsonValue(1)
  collection,
}

@JsonEnum()
enum OrderSource {
  @JsonValue(-1)
  undefined,
  @JsonValue(0)
  instore,
  @JsonValue(1)
  online,
}

@JsonEnum()
enum OrderType {
  @JsonValue(0)
  salesOrder,
  @JsonValue(1)
  invoice,
  @JsonValue(2)
  orderTypeReturn,
}

@JsonEnum()
enum PaymentLinkStatus {
  @JsonValue(0)
  notPaymentLink,
  @JsonValue(1)
  created,
  @JsonValue(2)
  sent,
  @JsonValue(3)
  paid,
  @JsonValue(4)
  disabled,
  @JsonValue(5)
  expired,
}
