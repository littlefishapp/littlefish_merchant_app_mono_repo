// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:built_value/built_value.dart';
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/promotions/promotion.dart';

part 'promotions_state.g.dart';

@immutable
abstract class PromotionsState
    implements Built<PromotionsState, PromotionsStateBuilder> {
  const PromotionsState._();

  factory PromotionsState() => _$PromotionsState._(
    hasError: false,
    isLoading: false,
    errorMessage: null,
    items: const [],
  );

  // static Serializer<ProductState> get serializer => _$productStateSerializer;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isLoading;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get hasError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get errorMessage;

  List<Promotion>? get items;
}
