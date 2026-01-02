// Package imports:
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:littlefish_merchant/models/shared/data/contact.dart';
import 'package:littlefish_merchant/models/shared/simple_data_item.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/models/stock/stock_variance.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

import '../../features/ecommerce_shared/models/store/store.dart';

part 'supplier.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class Supplier extends BusinessDataItem {
  Supplier({
    this.address,
    this.contactDetails,
    this.contacts,
    this.taxNumber,
    this.website,
    this.products,
  });

  Supplier.create() {
    id = const Uuid().v4();
    deleted = false;
    enabled = true;
    contactDetails = ContactDetail(isPrimary: true, label: 'Telephone');
    contacts = [];
    products = [];
    address = StoreAddress();
  }

  ContactDetail? contactDetails;

  StoreAddress? address;

  @JsonKey(defaultValue: <Contact>[])
  List<Contact>? contacts;

  String? taxNumber;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? newID;

  String? website;

  List<SupplierProduct>? products;

  factory Supplier.fromJson(Map<String, dynamic> json) =>
      _$SupplierFromJson(json)..newID = json['id'];

  Map<String, dynamic> toJson() => _$SupplierToJson(this);
}

@JsonSerializable()
@IsoDateTimeConverter()
class SupplierProduct {
  SupplierProduct(this.displayName, this.productId, this.varianceId);

  SupplierProduct.fromProduct(
    StockProduct this.product, {
    StockVariance? variance,
  }) {
    productId = product?.id;

    varianceId = variance?.id ?? product?.regularVariance?.id;
    this.variance = variance ?? product?.regularVariance;

    displayName = '${product!.displayName} - ${this.variance!.name}';
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  StockProduct? product;

  @JsonKey(includeFromJson: false, includeToJson: false)
  StockVariance? variance;

  String? displayName;

  String? productId;

  String? varianceId;

  factory SupplierProduct.fromJson(Map<String, dynamic> json) =>
      _$SupplierProductFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierProductToJson(this);
}
