// Flutter imports:

// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'zapper.g.dart';

@JsonSerializable()
class ZapperPayment {
  double? paidAmount;
  double? invoicedAmount;
  double? totalVoucherAmount;
  String? reference;
  int? status;
  String? zapperId;
  int? siteId;
  int? totalVouchersRedeemedAmount;
  String? currencyIsoCode;
  String? paymentUtcDate;
  int? tipAmount;

  ZapperPayment({
    required this.siteId,
    required this.reference,
    this.currencyIsoCode,
    this.invoicedAmount,
    this.paidAmount,
    this.status,
    this.totalVoucherAmount,
    this.zapperId,
  });

  factory ZapperPayment.fromJson(Map<String, dynamic> json) =>
      _$ZapperPaymentFromJson(json);

  Map<String, dynamic> toJson() => _$ZapperPaymentToJson(this);
}

@JsonSerializable()
class ZapperInvoice {
  String? externalReference;
  String? siteReference;
  String? currencyISOCode;
  int? amount;
  List<LineItem>? lineItems;
  String? origin;
  String? createdUTCDate;
  String? originReference;

  ZapperInvoice({
    required this.origin,
    required this.siteReference,
    required this.externalReference,
    required this.amount,
    this.currencyISOCode,
    this.createdUTCDate,
    this.lineItems,
    this.originReference,
  });

  factory ZapperInvoice.fromJson(Map<String, dynamic> json) =>
      _$ZapperInvoiceFromJson(json);

  Map<String, dynamic> toJson() => _$ZapperInvoiceToJson(this);
}

@JsonSerializable()
class LineItem {
  String? name;
  String? productCode;

  @JsonKey(name: 'SKU')
  String? sKU;
  double? unitPrice;
  List<String>? categories;
  double? quantity;

  LineItem({
    required this.name,
    required this.unitPrice,
    required this.quantity,
    required this.productCode,
    this.sKU,
    this.categories,
  });

  factory LineItem.fromJson(Map<String, dynamic> json) =>
      _$LineItemFromJson(json);

  Map<String, dynamic> toJson() => _$LineItemToJson(this);
}
