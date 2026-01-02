// Package imports:
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:littlefish_merchant/models/shared/simple_data_item.dart';
import 'package:littlefish_merchant/models/suppliers/supplier.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'supplier_invoice.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class SupplierInvoice extends BusinessDataItem {
  SupplierInvoice({
    this.amount,
    this.currencyCode,
    this.dueDate,
    this.invoiceDate,
    this.reference,
    this.supplierId,
    this.supplierName,
    this.taxAmount,
    this.isNew = false,
    this.amountOutstanding,
    this.payments,
    this.recieved,
  });

  SupplierInvoice.create() {
    id = const Uuid().v4();
    dateCreated = DateTime.now().toUtc();
    invoiceDate = DateTime.now().toUtc();
    amount = 0.0;
    taxAmount = 0.0;
    deleted = false;
    enabled = true;
    recieved = false;
    isNew = true;
    payments = <InvoicePayment>[];
  }
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? isNew;

  @JsonKey(includeFromJson: false, includeToJson: false)
  Supplier? supplier;

  String? supplierName;

  String? supplierId;

  String? reference;

  DateTime? invoiceDate;

  DateTime? dueDate;

  double? amount;

  double? amountOutstanding;

  double? taxAmount;

  String? currencyCode;

  bool? recieved;

  String? grvId;

  List<InvoicePayment>? payments;

  factory SupplierInvoice.fromJson(Map<String, dynamic> json) =>
      _$SupplierInvoiceFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierInvoiceToJson(this);
}

@JsonSerializable()
class InvoicePayment {
  String? paymentId;

  double? amount;

  DateTime? paymentDate;

  String? paidBy;

  InvoicePayment({this.paidBy, this.amount, this.paymentDate, this.paymentId});

  factory InvoicePayment.fromJson(Map<String, dynamic> json) =>
      _$InvoicePaymentFromJson(json);

  Map<String, dynamic> toJson() => _$InvoicePaymentToJson(this);
}
