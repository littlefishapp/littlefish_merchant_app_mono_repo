// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:built_value/built_value.dart';

import '../../features/ecommerce_shared/models/online/system_variant.dart';
import '../../features/ecommerce_shared/models/store/store_attribute.dart';
import '../../features/ecommerce_shared/models/store/store_subtype.dart';
import '../../features/ecommerce_shared/models/store/store_type.dart';

part 'system_data_state.g.dart';

@immutable
abstract class SystemDataState
    implements Built<SystemDataState, SystemDataStateBuilder> {
  const SystemDataState._();

  factory SystemDataState() => _$SystemDataState._(
    hasError: false,
    isLoading: false,
    errorMessage: null,
  );

  bool? get isLoading;

  bool? get hasError;

  String? get errorMessage;

  List<StoreSubtype>? get storeSubtypes;

  List<SystemVariant>? get variants;

  List<List<StoreAttribute>>? get storeAttributes;

  List<StoreAttributeGroup>? get storeAttributeGroups;

  List<StoreProductType>? get storeProductTypes;

  List<StoreAttributeGroupLink>? get storeAttributeGroupLinks;

  List<StoreType>? get storeTypes;
}
