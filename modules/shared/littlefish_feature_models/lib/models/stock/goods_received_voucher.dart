// Package imports:
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:littlefish_merchant/models/shared/simple_data_item.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/models/stock/stock_variance.dart';
import 'package:littlefish_merchant/models/suppliers/supplier_invoice.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'goods_received_voucher.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class GoodsRecievedVoucher extends BusinessDataItem {
  GoodsRecievedVoucher({
    this.dateReceived,
    this.deliveredBy,
    this.invoiceAmount,
    this.invoiceId,
    this.invoiceReference,
    this.isNew = false,
    this.items,
    this.notes,
    this.receivedBy,
    this.supplierId,
    this.supplierName,
  });

  GoodsRecievedVoucher.create() {
    isNew = true;
    id = const Uuid().v4();
    enabled = true;
    deleted = false;
    dateCreated = DateTime.now().toUtc();
    notes = <String>[];
    items = <GoodsRecievedItem>[];
  }

  GoodsRecievedVoucher.fromInvoice(SupplierInvoice invoice) {
    isNew = true;
    id = const Uuid().v4();
    enabled = true;
    deleted = false;
    dateCreated = DateTime.now().toUtc();
    notes = <String>[];
    items = <GoodsRecievedItem>[];

    loadInvoiceData(invoice);
  }

  loadInvoiceData(SupplierInvoice invoice) {
    supplierName = invoice.supplierName;
    invoiceId = invoice.id;
    invoiceAmount = invoice.amount;
    invoiceReference = invoice.reference;
  }

  resetInvoiceData() {
    supplierId = null;
    supplierName = null;
    invoiceAmount = 0;
    invoiceReference = null;
  }

  @JsonKey(defaultValue: false, includeFromJson: true, includeToJson: true)
  bool? isNew;

  @JsonKey(includeFromJson: false, includeToJson: false)
  SupplierInvoice? invoice;

  String? supplierId, supplierName;

  String? invoiceId, invoiceReference;

  double? invoiceAmount;

  double get receivablesValue {
    if (items == null || items!.isEmpty) return 0.0;

    return items!.map((i) => i.totalUnitCost).reduce((a, b) => a + b);
  }

  set receivablesValue(value) {}

  DateTime? dateReceived;

  String? receivedBy, deliveredBy;

  List<String>? notes;

  List<GoodsRecievedItem>? items;

  factory GoodsRecievedVoucher.fromJson(Map<String, dynamic> json) =>
      _$GoodsRecievedVoucherFromJson(json);

  Map<String, dynamic> toJson() => _$GoodsRecievedVoucherToJson(this);
}

@JsonSerializable()
@IsoDateTimeConverter()
class GoodsRecievedItem {
  GoodsRecievedItem({this.packUnitQuantity = 1.0, this.taxInclusive = true});

  GoodsRecievedItem.fromProduct(StockProduct product, StockVariance variance) {
    productName = product.displayName;
    variantName = variance.name;

    productId = product.id;
    variantId = variance.id;

    byUnit = product.unitType == StockUnitType.byUnit;

    currentUnitCost = variance.costPrice;
    currentUnitCount = variance.quantity;

    packCost = 0;
    packQuantity = 1;

    taxInclusive = true;
    packTax = 0.0;
  }

  String? productName, productId;

  String? variantName, variantId;

  bool? byUnit;

  bool? taxInclusive;

  double? currentUnitCost;
  double? currentUnitCount;

  double? packCost;
  double? packTax;
  double? packQuantity;
  double? packUnitQuantity;

  double get totalUnits {
    if (packQuantity == null || packQuantity == 0) return 0.0;

    return packQuantity! * (packUnitQuantity ?? 1.0);
  }

  set totalUnits(value) {}

  double get totalUnitCost {
    if (totalUnits <= 0.0) return 0.0;

    if (packCost == null || packCost! <= 0.0) return 0.0;

    if (taxInclusive!) {
      return packQuantity! * packCost!;
    } else {
      return packQuantity! * (packCost! + (packTax ?? 0.0));
    }
  }

  set totalUnitCost(value) {}

  double get unitCost {
    if (totalUnitCost > 0) {
      return totalUnitCost / totalUnits;
    } else {
      return 0.0;
    }
  }

  set unitCost(value) {}

  double get unitTax {
    if (packTax == null || packTax! <= 0.0) return 0.0;

    if (totalUnits <= 0.0) return 0.0;

    return (packTax! * packQuantity!) / totalUnits;
  }

  set unitTax(value) {}

  factory GoodsRecievedItem.fromJson(Map<String, dynamic> json) =>
      _$GoodsRecievedItemFromJson(json);

  Map<String, dynamic> toJson() => _$GoodsRecievedItemToJson(this);
}
