// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_checkout_transaction_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedCheckoutTransactionView _$PagedCheckoutTransactionViewFromJson(
  Map<String, dynamic> json,
) => PagedCheckoutTransactionView(
  result: (json['result'] as List<dynamic>?)
      ?.map((e) => CheckoutTransactionView.fromJson(e as Map<String, dynamic>))
      .toList(),
  count: (json['count'] as num?)?.toInt(),
);

Map<String, dynamic> _$PagedCheckoutTransactionViewToJson(
  PagedCheckoutTransactionView instance,
) => <String, dynamic>{'count': instance.count, 'result': instance.result};

CheckoutTransactionView _$CheckoutTransactionViewFromJson(
  Map<String, dynamic> json,
) => CheckoutTransactionView(
  products: (json['products'] as List<dynamic>?)
      ?.map((e) => StockProduct.fromJson(e as Map<String, dynamic>))
      .toList(),
  customerId: json['customerId'] as String?,
  customerName: json['customerName'] as String?,
  customerEmail: json['customerEmail'] as String?,
  customerMobile: json['customerMobile'] as String?,
  transactionNumber: (json['transactionNumber'] as num?)?.toDouble(),
  ticketId: json['ticketId'] as String?,
  ticketName: json['ticketName'] as String?,
  sellerId: json['sellerId'] as String?,
  sellerName: json['sellerName'] as String?,
  totalValue: (json['totalValue'] as num?)?.toDouble(),
  totalCost: (json['totalCost'] as num?)?.toDouble(),
  totalMarkup: (json['totalMarkup'] as num?)?.toDouble(),
  totalDiscount: (json['totalDiscount'] as num?)?.toDouble(),
  totalTax: (json['totalTax'] as num?)?.toDouble(),
  taxInclusive: json['taxInclusive'] as bool?,
  amountTendered: (json['amountTendered'] as num?)?.toDouble(),
  amountChange: (json['amountChange'] as num?)?.toDouble(),
  paymentType: json['paymentType'] == null
      ? null
      : PaymentType.fromJson(json['paymentType'] as Map<String, dynamic>),
  transactionDate: json['transactionDate'] == null
      ? null
      : DateTime.parse(json['transactionDate'] as String),
  items: json['items'] == null
      ? null
      : CheckoutCartItem.fromJson(json['items'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CheckoutTransactionViewToJson(
  CheckoutTransactionView instance,
) => <String, dynamic>{
  'products': instance.products,
  'customerId': instance.customerId,
  'customerName': instance.customerName,
  'customerEmail': instance.customerEmail,
  'customerMobile': instance.customerMobile,
  'transactionNumber': instance.transactionNumber,
  'ticketId': instance.ticketId,
  'ticketName': instance.ticketName,
  'sellerId': instance.sellerId,
  'sellerName': instance.sellerName,
  'totalValue': instance.totalValue,
  'totalCost': instance.totalCost,
  'totalMarkup': instance.totalMarkup,
  'totalDiscount': instance.totalDiscount,
  'totalTax': instance.totalTax,
  'taxInclusive': instance.taxInclusive,
  'amountTendered': instance.amountTendered,
  'amountChange': instance.amountChange,
  'paymentType': instance.paymentType,
  'transactionDate': instance.transactionDate?.toIso8601String(),
  'items': instance.items,
};
