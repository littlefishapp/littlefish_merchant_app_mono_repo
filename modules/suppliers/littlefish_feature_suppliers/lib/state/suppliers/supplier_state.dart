// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:built_value/built_value.dart';
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/suppliers/supplier.dart';
import 'package:littlefish_merchant/redux/ui/ui_entity_state.dart';

part 'supplier_state.g.dart';

@immutable
abstract class SupplierState
    implements Built<SupplierState, SupplierStateBuilder> {
  const SupplierState._();

  factory SupplierState() => _$SupplierState._(
    hasError: false,
    isLoading: false,
    errorMessage: null,
    suppliers: const <Supplier>[],
  );

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isLoading;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get hasError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get errorMessage;

  List<Supplier?>? get suppliers;
}

abstract class SupplierUIState
    implements Built<SupplierUIState, SupplierUIStateBuilder> {
  factory SupplierUIState() {
    return _$SupplierUIState._(
      item: UIEntityState<Supplier>(Supplier.create(), isNew: true),
    );
  }

  SupplierUIState._();

  UIEntityState<Supplier?>? get item;

  bool get isNew => item?.isNew ?? false;
}
