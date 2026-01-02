// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:built_value/built_value.dart';
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/products/product_discount.dart';
part 'product_discount_state.g.dart';

@immutable
@JsonSerializable()
abstract class ProductDiscountState
    implements Built<ProductDiscountState, ProductDiscountStateBuilder> {
  const ProductDiscountState._();

  factory ProductDiscountState() => _$ProductDiscountState._(
    hasError: false,
    isLoading: false,
    errorMessage: null,
    discounts: const <ProductDiscount>[],
  );

  @JsonKey(includeToJson: false)
  bool? get isLoading;

  @JsonKey(includeToJson: false)
  bool? get hasError;

  @JsonKey(includeToJson: false)
  String? get errorMessage;

  List<ProductDiscount>? get discounts;

  ProductDiscount? get currentDiscount;
}
