// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:built_value/built_value.dart';
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/stock/goods_received_voucher.dart';
import 'package:littlefish_merchant/models/stock/stock_run.dart';

part 'inventory_state.g.dart';

@immutable
@JsonSerializable()
abstract class InventoryState
    implements Built<InventoryState, InventoryStateBuilder> {
  const InventoryState._();

  factory InventoryState() => _$InventoryState._(
    hasError: false,
    isLoading: false,
    errorMessage: null,
    stockRuns: const <StockRun>[],
    grvs: const <GoodsRecievedVoucher>[],
  );

  // static Serializer<InventoryState> get serializer =>
  //     _$inventoryStateSerializer;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isLoading;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get hasError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get errorMessage;

  List<StockRun>? get stockRuns;

  List<GoodsRecievedVoucher>? get grvs;
}

abstract class InventoryStockTakeUI
    implements Built<InventoryStockTakeUI, InventoryStockTakeUIBuilder> {
  InventoryStockTakeUI._();

  factory InventoryStockTakeUI() => _$InventoryStockTakeUI._(
    hasError: false,
    isLoading: false,
    errorMessage: null,
    stockTakeRun: StockRun.create(),
  );

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isLoading;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get hasError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get errorMessage;

  StockRun? get stockTakeRun;
}

abstract class InventoryRecievableUI
    implements Built<InventoryRecievableUI, InventoryRecievableUIBuilder> {
  InventoryRecievableUI._();

  factory InventoryRecievableUI() => _$InventoryRecievableUI._(
    hasError: false,
    isLoading: false,
    errorMessage: null,
    item: GoodsRecievedVoucher.create(),
  );

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isLoading;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get hasError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get errorMessage;

  GoodsRecievedVoucher? get item;
}
