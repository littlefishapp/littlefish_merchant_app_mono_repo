import 'package:built_value/built_value.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:littlefish_merchant/shared/exceptions/general_error.dart';

import '../../model/business_store.dart';

part 'business_store_state.g.dart';

@immutable
@JsonSerializable()
abstract class BusinessStoreState
    implements Built<BusinessStoreState, BusinessStoreStateBuilder> {
  factory BusinessStoreState() => _$BusinessStoreState._(
    businessStores: const [],
    isLoading: false,
    hasError: false,
  );

  const BusinessStoreState._();

  List<BusinessStore> get businessStores;

  bool get isLoading;

  bool get hasError;

  GeneralError? get error;
}
