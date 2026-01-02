// Package imports:
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:littlefish_merchant/models/shared/simple_data_item.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'checkout_discount.g.dart';

@JsonSerializable()
@DiscountTypeConverter()
@IsoDateTimeConverter()
class CheckoutDiscount extends BusinessDataItem {
  CheckoutDiscount({
    this.isNew = false,
    this.maxValue,
    this.minValue,
    this.type,
    this.value,
  });

  CheckoutDiscount.create() {
    isNew = true;
    value = minValue = maxValue = 0.0;
    type = DiscountType.fixedAmount;

    id = const Uuid().v4();
    enabled = true;
    deleted = false;
    dateCreated = DateTime.now().toUtc();
  }

  @JsonKey(defaultValue: false, includeFromJson: false, includeToJson: false)
  bool? isNew;

  @JsonKey(defaultValue: 0.0)
  double? value;

  @JsonKey(defaultValue: 0.0)
  double? maxValue;

  @JsonKey(defaultValue: 0.0)
  double? minValue;

  @JsonKey(defaultValue: DiscountType.fixedAmount)
  DiscountType? type;

  factory CheckoutDiscount.fromJson(Map<String, dynamic> json) =>
      _$CheckoutDiscountFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutDiscountToJson(this);
}

enum DiscountType {
  @JsonValue(0)
  fixedAmount,
  @JsonValue(1)
  percentage,
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
