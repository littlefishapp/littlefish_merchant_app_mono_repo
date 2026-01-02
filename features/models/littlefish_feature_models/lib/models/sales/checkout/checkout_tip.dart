// Package imports:
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:littlefish_merchant/models/shared/simple_data_item.dart';

import '../../../tools/converters/iso_date_time_converter.dart';

part 'checkout_tip.g.dart';

@JsonSerializable()
@TipTypeConverter()
@IsoDateTimeConverter()
class CheckoutTip extends BusinessDataItem with EquatableMixin {
  CheckoutTip({
    this.isNew = false,
    this.maxValue,
    this.minValue,
    this.type,
    this.value,
  });

  CheckoutTip.create() {
    isNew = true;
    value = minValue = maxValue = 0.0;
    type = TipType.fixedAmount;

    id = const Uuid().v4();
    enabled = true;
    deleted = false;
    dateCreated = DateTime.now().toUtc();
  }

  @JsonKey(defaultValue: false, includeFromJson: true, includeToJson: true)
  bool? isNew;

  @JsonKey(defaultValue: 0.0)
  double? value;

  double? maxValue;

  @JsonKey(defaultValue: 0.0)
  double? minValue;

  @JsonKey(defaultValue: TipType.fixedAmount)
  TipType? type;

  factory CheckoutTip.fromJson(Map<String, dynamic> json) =>
      _$CheckoutTipFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutTipToJson(this);

  @override
  List<Object?> get props => [
    id,
    isNew,
    value,
    maxValue,
    minValue,
    type,
    enabled,
    deleted,
    dateCreated,
  ];
}

enum TipType {
  @JsonValue(0)
  fixedAmount,
  @JsonValue(1)
  percentage,
}

class TipTypeConverter implements JsonConverter<TipType, int> {
  const TipTypeConverter();

  @override
  TipType fromJson(int json) {
    return TipType.values[json];
  }

  @override
  int toJson(TipType object) {
    return object.index;
  }
}
