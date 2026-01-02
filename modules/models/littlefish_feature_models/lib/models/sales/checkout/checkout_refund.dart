import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/models/settings/payments/payment_type.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund_item.dart';
import 'package:littlefish_merchant/models/shared/simple_data_item.dart';
import 'package:littlefish_merchant/providers/locale_provider.dart';
import 'package:littlefish_merchant/ui/online_store/common/constants/image_constants.dart';
import 'package:uuid/uuid.dart';

part 'checkout_refund.g.dart';

@JsonSerializable(createToJson: true, explicitToJson: true)
class Refund extends BusinessDataItem {
  late String checkoutTransactionId;
  String? sellerId;
  String? sellerName;
  String? currencyCode;
  String? countryCode;
  PaymentType? paymentType;
  List<RefundItem>? items;
  String? customerId;
  String? customerName;
  String? customerEmail;
  String? customerMobile;
  double? transactionNumber;
  DateTime? transactionDate;

  bool? isOnline;
  double? totalRefund;
  double? totalRefundCost;
  double? totalItems;
  bool isQuickRefund;

  String? terminalId;
  int? batchNo;
  String? referenceNo;
  String? transactionStatus;
  String? deviceId;
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

  Refund({
    required this.checkoutTransactionId,
    this.sellerId,
    this.sellerName,
    this.currencyCode,
    this.countryCode,
    this.customerId,
    this.customerName,
    this.customerEmail,
    this.customerMobile,
    this.transactionNumber,
    this.transactionDate,
    this.terminalId,
    this.batchNo,
    this.referenceNo,
    this.transactionStatus,
    this.deviceId,
    this.additionalInfo,
    this.isOnline,
    this.totalRefund = 0,
    this.totalItems = 0,
    this.totalRefundCost = 0,
    this.paymentType,
    this.items = const [],
    this.isQuickRefund = false,
  });

  Refund.create({
    required String? userId,
    required String userName,
    required String? businessId,
    required this.isQuickRefund,
  }) {
    currencyCode = LocaleProvider.instance.currencyCode;
    countryCode = LocaleProvider.instance.countryCode;
    items = [];
    transactionDate = DateTime.now().toUtc();
    sellerId = userId;
    sellerName = userName;
    id = const Uuid().v4();
    this.businessId = businessId;
    dateCreated = DateTime.now().toUtc();
    createdBy = userName;
    displayName = isQuickRefund ? 'Quick Refund' : 'Refund';
    totalRefund = 0.0;
    totalRefundCost = 0;
    totalItems = 0;
    checkoutTransactionId = '';
    isOnline = false;
    items = [];
  }

  Refund.copy(Refund original)
    : checkoutTransactionId = original.checkoutTransactionId,
      sellerId = original.sellerId,
      sellerName = original.sellerName,
      currencyCode = original.currencyCode,
      countryCode = original.countryCode,
      paymentType = original.paymentType,
      items = List<RefundItem>.from(original.items ?? []),
      customerId = original.customerId,
      customerName = original.customerName,
      customerEmail = original.customerEmail,
      customerMobile = original.customerMobile,
      transactionNumber = original.transactionNumber,
      transactionDate = original.transactionDate,
      terminalId = original.terminalId,
      batchNo = original.batchNo,
      referenceNo = original.referenceNo,
      transactionStatus = original.transactionStatus,
      deviceId = original.deviceId,
      additionalInfo = original.additionalInfo,
      isOnline = original.isOnline,
      totalRefund = original.totalRefund,
      totalRefundCost = original.totalRefundCost,
      totalItems = original.totalItems,
      isQuickRefund = original.isQuickRefund,
      super(
        id: original.id,
        businessId: original.businessId,
        dateCreated: original.dateCreated,
        createdBy: original.createdBy,
        displayName: original.displayName,
        dateUpdated: original.dateUpdated,
        deleted: original.deleted,
        description: original.description,
        enabled: original.enabled,
        indexNo: original.indexNo,
        name: original.name,
        status: original.status,
        updatedBy: original.updatedBy,
      );

  factory Refund.fromJson(Map<String, dynamic> json) => _$RefundFromJson(json);

  Map<String, dynamic> toJson() => _$RefundToJson(this);
}
