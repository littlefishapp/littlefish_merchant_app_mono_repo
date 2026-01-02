// Package imports:
import 'package:decimal/decimal.dart';
import 'package:geolocator/geolocator.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/tools/extensions/extensions.dart';
import 'package:littlefish_merchant/ui/online_store/common/constants/image_constants.dart';
import 'package:quiver/strings.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/models/settings/payments/payment_type.dart';
import 'package:littlefish_merchant/models/shared/simple_data_item.dart';
import 'package:littlefish_merchant/models/tax/sales_tax.dart';
import 'package:littlefish_merchant/providers/locale_provider.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_state.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund.dart';

import '../../../features/ecommerce_shared/models/checkout/checkout_order.dart';

part 'checkout_transaction.g.dart';

@JsonSerializable(createToJson: true, explicitToJson: true)
@IsoDateTimeConverter()
class CheckoutTransaction extends BusinessDataItem {
  String? customerId, customerName, customerEmail, customerMobile;

  String? ticketId, ticketName;
  String? sellerId, sellerName;
  String? currencyCode, countryCode;
  String? deviceId;
  bool? taxInclusive;

  double? totalValue;

  double? totalCost;

  double? totalMarkup;

  double? totalDiscount;

  double? totalTax;

  double? totalRefund;

  double? totalRefundCost;

  double? amountTendered;

  double? amountChange;

  PaymentType? paymentType;

  DateTime? transactionDate;

  bool? isOnline;

  List<Refund>? refunds;

  String? terminalId;

  int? batchNo;

  String? referenceNo;

  String? transactionStatus;

  @JsonKey(defaultValue: false)
  bool? pendingSync;

  List<CheckoutCartItem>? items;

  @JsonKey(includeIfNull: true, defaultValue: 0)
  double? transactionNumber;

  double? withdrawalAmount;

  double? cashbackAmount;

  double? tipAmount;

  Map<String, dynamic>? additionalInfo;

  String get cardType {
    return additionalInfo?['cardType'] ?? '';
  }

  String get cardTypeImageIcon {
    if (paymentType?.isCard ?? false) {
      String imageIcon = '';

      if (cardType.isNotEmpty) {
        if (cardType.toLowerCase().contains('visa')) {
          imageIcon = ImageConstants.visaSvg;
        } else if (cardType.toLowerCase().contains('master')) {
          imageIcon = ImageConstants.mastercardSvg;
        } else if (cardType.toLowerCase().contains('maestro')) {
          imageIcon = ImageConstants.maestroSvg;
        } else if (cardType.toLowerCase().contains('diners')) {
          imageIcon = ImageConstants.dinersSvg;
        } else if (cardType.toLowerCase().contains('amex')) {
          imageIcon = ImageConstants.amexSvg;
        }
      }

      return imageIcon;
    } else {
      return '';
    }
  }

  String get entry {
    return additionalInfo?['entry'] ?? '';
  }

  String get terminalIdPOS {
    return additionalInfo?['tid'] ?? '';
  }

  String get authCode {
    return additionalInfo?['authCode'] ?? '';
  }

  String get authResponse {
    return additionalInfo?['authResponse'] ?? '';
  }

  String get authResponseCode {
    return additionalInfo?['authCode'] ?? '';
  }

  String get traceID {
    return additionalInfo?['traceID'] ?? '';
  }

  CheckoutTransaction({
    required this.amountTendered,
    required this.amountChange,
    required this.items,
    required this.paymentType,
    required this.sellerId,
    required this.sellerName,
    required this.totalTax,
    this.countryCode,
    this.currencyCode,
    this.customerId,
    this.customerName,
    this.ticketId,
    this.ticketName,
    this.totalMarkup,
    this.totalRefundCost,
    this.totalRefund,
    this.deviceId,
    this.withdrawalAmount,
    this.cashbackAmount,
    this.tipAmount,
    this.totalDiscount,
    this.totalCost,
    this.totalValue,
    this.transactionDate,
    this.transactionNumber,
    this.customerEmail,
    this.customerMobile,
    this.taxInclusive,
    this.pendingSync = false,
    String? id,
    // this.position,
    this.isOnline,
    this.refunds,
    this.additionalInfo,
  }) : super(id: id) {
    if (isEmpty(id)) id = const Uuid().v4();
  }

  CheckoutTransaction.fromState(
    CheckoutState state,
    String? userId,
    String userName,
    String? businessId,
    this.terminalId,
    this.deviceId, {
    bool pushToServer = false,
  }) {
    amountChange = state.amountChange.toDouble();
    amountTendered = (state.amountTendered ?? Decimal.zero).toDouble();
    withdrawalAmount = state.withdrawalAmount?.toDouble();
    cashbackAmount = state.cashbackAmount?.toDouble();
    tipAmount = state.tipAmount?.toDouble();
    currencyCode = LocaleProvider.instance.currencyCode;
    countryCode = LocaleProvider.instance.countryCode;
    items = state.items;
    refunds = state.refunds;
    paymentType = state.paymentType;
    totalTax = state.totalSalesTax.toDouble();
    customerId = state.customer?.id;
    customerName = state.customer?.displayName;
    ticketId = state.ticket?.id;
    ticketName = state.ticket?.reference;
    totalCost = state.totalCost.toDouble();
    totalDiscount = state.totalDiscount?.toDouble();
    totalMarkup = state.markup.toDouble();
    totalValue =
        (state.salesTax?.taxPricingMode ?? TaxPricingMode.alreadyIncluded) ==
            TaxPricingMode.alreadyIncluded
        ? state.totalValue.toDouble()
        : (state.totalValue + state.totalSalesTax).toDouble();
    transactionDate = DateTime.now().toUtc();
    sellerId = userId;
    pendingSync = !pushToServer;
    sellerName = userName;
    customerEmail = state.customer?.email;
    customerMobile = state.customer?.mobileNumber;
    taxInclusive =
        (state.salesTax?.taxPricingMode ?? TaxPricingMode.alreadyIncluded) ==
        TaxPricingMode.alreadyIncluded;

    id = const Uuid().v4();
    this.businessId = businessId;
    dateCreated = DateTime.now().toUtc();
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  int? get itemCount {
    return items?.length;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  double get totalQty {
    if (items == null || items!.isEmpty) return 0;
    return items!.map((i) => i.quantity).reduce((a, b) => a + b);
  }

  // @JsonKey(toJson: positionToJson)
  // Position position;

  double get checkoutTotal {
    var total =
        totalValue! -
        (totalDiscount ?? 0.0) +
        (withdrawalAmount ?? 0) +
        (cashbackAmount ?? 0) +
        (tipAmount ?? 0);

    return total.truncateToDecimalPlaces(2);
  }

  double get displayTotal {
    return isQuickRefund ? totalRefund ?? 0 : checkoutTotal;
  }

  bool get isQuickRefund {
    if (isNullOrEmpty(refunds)) return false;
    return refunds!.indexWhere((refund) => refund.isQuickRefund == true) != -1;
  }

  bool get isFullyRefunded {
    double quantityRefunded = 0;
    if (isRefunded == true) {
      quantityRefunded = refunds!.fold(
        0,
        (previousValue, refund) => previousValue + refund.totalItems!,
      );
    }
    if (quantityRefunded != totalQty || quantityRefunded == 0) return false;
    return true;
  }

  bool get isCashBack {
    return isNotZeroOrNull(cashbackAmount);
  }

  bool get isWithdrawal {
    return isNotZeroOrNull(withdrawalAmount);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isCancelled {
    if ((deleted ?? false) && status?.toLowerCase() == 'cancelled') return true;

    return false;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isRefunded => status?.toLowerCase() == 'refunded';

  factory CheckoutTransaction.fromJson(Map<String, dynamic> json) =>
      _$CheckoutTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutTransactionToJson(this);

  static Map<String, dynamic> positionToJson(Position instance) =>
      instance.toJson();

  factory CheckoutTransaction.fromCheckoutOrder(CheckoutOrder order) =>
      CheckoutTransaction(
        amountTendered: order.totalDueByCustomer,
        amountChange: 0,
        items: order.items?.map((e) {
          var product = StockProduct.fromCartItem(e);

          var checkoutItem = CheckoutCartItem.fromProduct(
            product,
            product.variances!.first,
            quantity: e.quantity,
          );
          return checkoutItem;
        }).toList(),
        paymentType: PaymentType(
          name: order.paymentType,
          id: order.paymentType,
          paid: order.paymentStatus == 'paid',
          displayIndex: 0,
          enabled: true,
        ),
        sellerId: null,
        sellerName: 'online',
        totalTax: 0,
        countryCode:
            AppVariables.store?.state.localeState.currentLocale!.countryCode,
        currencyCode:
            AppVariables.store?.state.localeState.currentLocale!.currencyCode,
        customerEmail: order.billing!.email,
        customerId: order.customerId,
        customerName: order.customerName,
        customerMobile: order.billing!.phone,
        taxInclusive: true,
        totalCost: order.orderCost,
        totalDiscount: 0,
        totalValue: order.totalDueByCustomer,
        transactionDate: order.orderDate,
        id: order.orderId,
        isOnline: true,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CheckoutTransaction && other.id == id && other.name == name;
  }

  static CheckoutTransaction copyCheckoutTransaction(
    CheckoutTransaction original,
  ) {
    return CheckoutTransaction(
      amountTendered: original.amountTendered,
      amountChange: original.amountChange,
      items: original.items,
      paymentType: original.paymentType,
      sellerId: original.sellerId,
      sellerName: original.sellerName,
      totalTax: original.totalTax,
      countryCode: original.countryCode,
      currencyCode: original.currencyCode,
      customerId: original.customerId,
      customerName: original.customerName,
      ticketId: original.ticketId,
      ticketName: original.ticketName,
      totalMarkup: original.totalMarkup,
      totalRefundCost: original.totalRefundCost,
      totalRefund: original.totalRefund,
      deviceId: original.deviceId,
      totalDiscount: original.totalDiscount,
      totalCost: original.totalCost,
      totalValue: original.totalValue,
      transactionDate: original.transactionDate,
      transactionNumber: original.transactionNumber,
      customerEmail: original.customerEmail,
      customerMobile: original.customerMobile,
      taxInclusive: original.taxInclusive,
      pendingSync: original.pendingSync,
      id: original.id,
      isOnline: original.isOnline,
      refunds: original.refunds,
      cashbackAmount: original.cashbackAmount,
      withdrawalAmount: original.withdrawalAmount,
      tipAmount: original.tipAmount,
      additionalInfo: original.additionalInfo,
    );
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
