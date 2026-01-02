// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/models/settings/payments/payment_type.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';

part 'paged_checkout_transaction_view.g.dart';

@JsonSerializable()
class PagedCheckoutTransactionView {
  PagedCheckoutTransactionView({this.result, this.count});

  int? count;
  List<CheckoutTransactionView>? result;

  factory PagedCheckoutTransactionView.fromJson(Map<String, dynamic> json) =>
      _$PagedCheckoutTransactionViewFromJson(json);

  Map<String, dynamic> toJson() => _$PagedCheckoutTransactionViewToJson(this);
}

@JsonSerializable()
class CheckoutTransactionView {
  CheckoutTransactionView({
    this.products,
    this.customerId,
    this.customerName,
    this.customerEmail,
    this.customerMobile,
    this.transactionNumber,
    this.ticketId,
    this.ticketName,
    this.sellerId,
    this.sellerName,
    this.totalValue,
    this.totalCost,
    this.totalMarkup,
    this.totalDiscount,
    this.totalTax,
    this.taxInclusive,
    this.amountTendered,
    this.amountChange,
    this.paymentType,
    this.transactionDate,
    this.items,
  });

  List<StockProduct>? products;
  String? customerId;
  String? customerName;
  String? customerEmail;
  String? customerMobile;
  double? transactionNumber;
  String? ticketId;
  String? ticketName;
  String? sellerId;
  String? sellerName;
  double? totalValue;
  double? totalCost;
  double? totalMarkup;
  double? totalDiscount;
  double? totalTax;
  bool? taxInclusive;
  double? amountTendered;
  double? amountChange;
  PaymentType? paymentType;
  DateTime? transactionDate;
  CheckoutCartItem? items;

  factory CheckoutTransactionView.fromJson(Map<String, dynamic> json) =>
      _$CheckoutTransactionViewFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutTransactionViewToJson(this);
}
