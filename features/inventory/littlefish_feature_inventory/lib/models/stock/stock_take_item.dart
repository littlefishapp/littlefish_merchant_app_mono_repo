// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/models/stock/stock_variance.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'stock_take_item.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class StockTakeItem with ChangeNotifier {
  StockTakeItem({
    this.product,
    this.variance,
    this.stockCount,
    this.productName,
    this.varianceName,
    this.costPrice = 0.0,
    this.type,
  });

  StockTakeItem.fromProduct(
    StockProduct this.product, {
    double qty = 1.0,
    this.type = StockRunType.reCount,
  }) {
    variance = product?.regularVariance;

    productName = product?.displayName;
    varianceName = variance!.name;

    productId = product?.id;
    varianceId = variance!.id;

    costPrice = variance!.costPrice;

    stockCount = qty;
    expectedItemCount = variance!.quantity;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  StockProduct? product;

  @JsonKey(includeFromJson: false, includeToJson: false)
  StockVariance? variance;

  String? productName;

  String? varianceName;

  String? _productId;

  StockRunType? type;

  String? get productId {
    if (_productId == null && product != null) {
      _productId = product!.id;
    }

    return _productId;
  }

  String? get stockTakeReason {
    switch (type) {
      case StockRunType.reCount:
        return 'Inv. Adj';
      case StockRunType.theft:
        return 'Stolen';
      case StockRunType.damagedStock:
        return 'Damaged';
      case StockRunType.returnedStock:
        return 'Returned';
      case StockRunType.otherDecrease:
        return 'Other';
      case StockRunType.otherIncrease:
        return 'Other';
      default:
        return 'Inv. Adj';
    }
  }

  set productId(value) {
    if (_productId != value) _productId = value;
  }

  String? _varianceId;

  String? get varianceId {
    if (_varianceId == null && variance != null) {
      _varianceId = variance!.id;
    }

    return _varianceId;
  }

  set varianceId(value) {
    if (_varianceId != value) _varianceId = value;
  }

  double? stockCount;

  double? _expectedItemCount = 0;

  double? get expectedItemCount {
    if (variance == null) {
      return _expectedItemCount;
    } else {
      return variance!.quantity;
    }
  }

  set expectedItemCount(value) {
    _expectedItemCount = value;
  }

  bool get isShort {
    return (stockCount ?? 0.0) < (expectedItemCount ?? 0.0);
  }

  @JsonKey(defaultValue: 0.0)
  double? costPrice;

  @JsonKey(includeFromJson: false, includeToJson: false)
  double get shortageItemCount {
    return isShort ? (expectedItemCount! - stockCount!) : 0;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  double get shortageItemValue {
    return (isShort ? (shortageItemCount * variance!.costPrice!) : 0.0)
        .roundToDouble();
  }

  bool get isOver {
    return (stockCount ?? 0.0) > (expectedItemCount ?? 0.0);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  double get overageItemCount {
    return isOver ? (stockCount! - expectedItemCount!) : 0;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  double get overageItemValue {
    return (isOver ? (overageItemCount * variance!.costPrice!) : 0.00)
        .roundToDouble();
  }

  factory StockTakeItem.fromJson(Map<String, dynamic> json) =>
      _$StockTakeItemFromJson(json);

  Map<String, dynamic> toJson() => _$StockTakeItemToJson(this);
}

enum StockRunType {
  @JsonValue(0)
  reCount,
  @JsonValue(1)
  damagedStock,
  @JsonValue(2)
  theft,
  @JsonValue(3)
  loss,
  @JsonValue(4)
  returnedStock,
  @JsonValue(5)
  otherDecrease,
  @JsonValue(6)
  otherIncrease,
}
