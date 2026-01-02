// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'stock_variance.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class StockVariance extends ChangeNotifier {
  StockVariance({
    this.type,
    this.quantity = 0,
    this.sellingPrice,
    this.costPrice,
    this.name,
    this.id,
    this.lowQuantityValue = 10,
    this.vat = 0,
    this.margin = 0,
    this.supplier = '',
    this.barcode,
  }) {
    if (id == null || id!.isEmpty) id = const Uuid().v4();
  }

  factory StockVariance.fromJson(Map<String, dynamic> json) =>
      _$StockVarianceFromJson(json);

  Map<String, dynamic> toJson() => _$StockVarianceToJson(this);

  String? id;

  StockVarianceType? type;

  String? name;

  String? barcode;

  double? quantity;

  double get quantityAsNonNegative => (quantity ?? 0) < 0 ? 0 : (quantity ?? 0);

  double? sellingPrice, costPrice;

  @JsonKey(includeFromJson: false, includeToJson: false)
  double? _markup;

  double? lowQuantityValue;

  double vat;

  double margin;

  String supplier;

  double? get markup {
    if (_markup == null) {
      if (sellingPrice != null &&
          sellingPrice! > 0 &&
          costPrice != null &&
          costPrice! > 0) {
        //we need to do a base calculation

        var value = 100 - ((costPrice! / sellingPrice!) * 100);

        _markup = value;

        return _markup;
      }
    } else {
      return _markup;
    }

    return _markup;
  }

  set markup(double? value) {
    _markup = value;
  }

  StockVariance copyWith({
    String? id,
    StockVarianceType? type,
    String? name,
    String? barcode,
    double? quantity,
    double? sellingPrice,
    double? costPrice,
    double? lowQuantityValue,
    double? vat,
    double? margin,
    String? supplier,
  }) {
    return StockVariance(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      quantity: quantity ?? this.quantity,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      costPrice: costPrice ?? this.costPrice,
      lowQuantityValue: lowQuantityValue ?? this.lowQuantityValue,
      vat: vat ?? this.vat,
      margin: margin ?? this.margin,
      supplier: supplier ?? this.supplier,
    );
  }
}

enum StockVarianceType {
  @JsonValue(0)
  regular,
  @JsonValue(1)
  custom,
}
