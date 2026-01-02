// Package imports:
// ignore_for_file: overridden_fields

import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/shared/simple_data_item.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

import '../shared/data/address.dart';

part 'sales_tax.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class SalesTax extends BusinessDataItem {
  SalesTax({
    this.applyToCustomAmount = false,
    this.enabled = false,
    this.name,
    this.percentage = 0,
    this.id,
    this.taxPricingMode,
    this.businessId,
    this.description,
    this.vatRegistrationNumber,
    this.address,
  });

  @override
  String? businessId;

  @override
  String? id;
  @override
  @JsonKey(defaultValue: false)
  bool? enabled;

  bool? applyToCustomAmount;

  @override
  @override
  String? name, description;

  double? percentage;

  TaxPricingMode? taxPricingMode;

  String? vatRegistrationNumber;

  Address? address;

  factory SalesTax.fromJson(Map<String, dynamic> json) =>
      _$SalesTaxFromJson(json);

  Map<String, dynamic> toJson() => _$SalesTaxToJson(this);
}

enum TaxPricingMode {
  @JsonValue(0)
  addToItem,
  @JsonValue(1)
  alreadyIncluded,
}
