import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'order_discount.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderDiscount extends Equatable {
  final String id;
  final double value;
  final DiscountValueType type;
  final DiscountTarget discountTarget;

  const OrderDiscount({
    this.id = '',
    this.discountTarget = DiscountTarget.undefined,
    this.type = DiscountValueType.undefined,
    this.value = 0.0,
  });

  OrderDiscount copyWith({
    String? id,
    double? value,
    DiscountValueType? type,
    DiscountTarget? discountTarget,
  }) {
    return OrderDiscount(
      discountTarget: discountTarget ?? this.discountTarget,
      id: id ?? this.id,
      type: type ?? this.type,
      value: value ?? this.value,
    );
  }

  factory OrderDiscount.cart(double ammount, DiscountValueType type) {
    return OrderDiscount(
      id: const Uuid().v8(),
      discountTarget: DiscountTarget.cart,
      type: type,
      value: ammount,
    );
  }

  factory OrderDiscount.fromJson(Map<String, dynamic> json) =>
      _$OrderDiscountFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDiscountToJson(this);

  @override
  List<Object?> get props => [id, value, type, discountTarget];
}

@JsonEnum()
enum DiscountValueType {
  @JsonValue(-1)
  undefined,
  @JsonValue(0)
  fixedAmount,
  @JsonValue(1)
  percentage,
}

@JsonEnum()
enum DiscountTarget {
  @JsonValue(-1)
  undefined,
  @JsonValue(0)
  lineItem,
  @JsonValue(1)
  cart,
  @JsonValue(2)
  shipping,
}
