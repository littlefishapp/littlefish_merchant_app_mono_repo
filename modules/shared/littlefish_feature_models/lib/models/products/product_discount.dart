// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/shared/simple_data_item.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'product_discount.g.dart';

@JsonSerializable()
@DiscountTypeConverter()
@IsoDateTimeConverter()
class ProductDiscount extends BusinessDataItem {
  ProductDiscount({
    this.isNew = false,
    this.maxValue,
    this.minValue,
    this.type,
    this.value,
    this.products,
  });

  ProductDiscount.create() {
    isNew = true;
    value = minValue = maxValue = 0.0;
    type = DiscountType.fixedDiscountAmount;
    products = [];
    enabled = true;
    deleted = false;
    dateCreated = DateTime.now().toUtc();
  }

  ProductDiscount.copy(ProductDiscount? original) {
    isNew = original?.isNew ?? true;
    name = original?.name;
    displayName = original?.displayName;
    description = original?.description;
    value = original?.value;
    minValue = original?.minValue;
    maxValue = original?.maxValue;
    type = original?.type;
    products = List<StockProduct>.from(
      (original?.products ?? []).map(
        (product) => StockProduct.clone(product: product),
      ),
    );
    enabled = original?.enabled;
    deleted = original?.deleted;
    dateCreated = original?.dateCreated;
    id = original?.id;
  }

  @JsonKey(defaultValue: false, includeFromJson: true, includeToJson: true)
  bool? isNew;

  @JsonKey(defaultValue: 0.0)
  double? value;

  @JsonKey(defaultValue: 0.0)
  double? maxValue;

  @JsonKey(defaultValue: 0.0)
  double? minValue;

  @JsonKey(defaultValue: DiscountType.fixedDiscountAmount)
  DiscountType? type;

  List<StockProduct>? products;

  factory ProductDiscount.fromJson(Map<String, dynamic> json) =>
      _$ProductDiscountFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDiscountToJson(this);
}

class DiscountTypeConverter implements JsonConverter<DiscountType, int> {
  const DiscountTypeConverter();

  @override
  DiscountType fromJson(int json) {
    return DiscountType.values[json];
  }

  @override
  int toJson(DiscountType object) {
    return object.index;
  }
}
