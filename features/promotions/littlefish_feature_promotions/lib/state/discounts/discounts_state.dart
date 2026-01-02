// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:built_value/built_value.dart';
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/sales/checkout/checkout_discount.dart';

part 'discounts_state.g.dart';

@immutable
@JsonSerializable()
abstract class DiscountState
    implements Built<DiscountState, DiscountStateBuilder> {
  const DiscountState._();

  factory DiscountState() => _$DiscountState._(
    hasError: false,
    isLoading: false,
    errorMessage: null,
    discounts: const <CheckoutDiscount>[],
  );

  // static Serializer<CustomerState> get serializer => _$customerStateSerializer;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isLoading;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get hasError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get errorMessage;

  List<CheckoutDiscount>? get discounts;
}

abstract class DiscountUIState
    implements Built<DiscountUIState, DiscountUIStateBuilder> {
  factory DiscountUIState() {
    return _$DiscountUIState._(item: CheckoutDiscount.create());
  }

  DiscountUIState._();

  CheckoutDiscount? get item;

  bool get isNew => item?.isNew ?? false;
}
