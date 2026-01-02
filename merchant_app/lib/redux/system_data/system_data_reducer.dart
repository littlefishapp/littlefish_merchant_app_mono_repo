// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/system_data/system_data_actions.dart';
import 'package:littlefish_merchant/redux/system_data/system_data_state.dart';

import '../../features/ecommerce_shared/models/store/store_subtype.dart';

final systemDataReducer = combineReducers<SystemDataState>([
  TypedReducer<SystemDataState, SetSystemStoreTypesAction>(
    onSetSystemStoreTypesAction,
  ).call,
  TypedReducer<SystemDataState, SetSystemStoreSubtypesAction>(
    onSetSystemStoreSubtypesAction,
  ).call,
  TypedReducer<SystemDataState, SetSystemVariantsAction>(
    onSetSystemVariantsAction,
  ).call,
  TypedReducer<SystemDataState, SetSystemStoreAttributesAction>(
    onSetSystemStoreAttributesAction,
  ).call,
  TypedReducer<SystemDataState, SetSystemStoreAttributeGroupsAction>(
    onSetSystemStoreAttributeGroupsAction,
  ).call,
  TypedReducer<SystemDataState, SetSystemStoreProductTypesAction>(
    onSetSystemStoreProductTypesAction,
  ).call,
  TypedReducer<SystemDataState, SetSystemStoreAttributeGroupLinksAction>(
    onSetSystemStoreAttributeGroupLinksAction,
  ).call,
]);

SystemDataState onSetSystemStoreTypesAction(
  SystemDataState state,
  SetSystemStoreTypesAction action,
) => state.rebuild((b) => b.storeTypes = action.value);

SystemDataState onSetSystemVariantsAction(
  SystemDataState state,
  SetSystemVariantsAction action,
) => state.rebuild((b) => b.variants = action.value);

SystemDataState onSetSystemStoreSubtypesAction(
  SystemDataState state,
  SetSystemStoreSubtypesAction action,
) => state.rebuild(
  (b) => b.storeSubtypes = _insertStoreSubtype(
    action.value,
    b.storeSubtypes ?? <StoreSubtype>[],
  ),
);

SystemDataState onSetSystemStoreAttributesAction(
  SystemDataState state,
  SetSystemStoreAttributesAction action,
) => state.rebuild((b) => b.storeAttributes = action.value);

SystemDataState onSetSystemStoreProductTypesAction(
  SystemDataState state,
  SetSystemStoreProductTypesAction action,
) => state.rebuild(
  (b) => b.storeProductTypes = _insertStoreProductType(
    action.value,
    b.storeProductTypes ?? <StoreProductType>[],
  ),
);

SystemDataState onSetSystemStoreAttributeGroupsAction(
  SystemDataState state,
  SetSystemStoreAttributeGroupsAction action,
) => state.rebuild((b) => b.storeAttributeGroups = action.value);

SystemDataState onSetSystemStoreAttributeGroupLinksAction(
  SystemDataState state,
  SetSystemStoreAttributeGroupLinksAction action,
) => state.rebuild(
  (b) => b.storeAttributeGroupLinks = _insertStoreAttributeGroupLinks(
    action.value,
    b.storeAttributeGroupLinks ?? <StoreAttributeGroupLink>[],
  ),
);

List<StoreSubtype> _insertStoreSubtype(
  List<StoreSubtype> items,
  List<StoreSubtype> state,
) {
  if (items.isEmpty) return state;

  if (state.isEmpty) state.addAll(items);

  if (state.indexWhere((element) => element.storeType == items[0].storeType) ==
      -1) {
    state.addAll(items);
  }

  return state;
}

List<StoreProductType> _insertStoreProductType(
  List<StoreProductType> items,
  List<StoreProductType> state,
) {
  if (items.isEmpty) return state;

  if (state.isEmpty) state.addAll(items);

  if (state.indexWhere(
        (element) => element.storeSubtypeId == items[0].storeSubtypeId,
      ) ==
      -1) {
    state.addAll(items);
  }

  return state;
}

List<StoreAttributeGroupLink> _insertStoreAttributeGroupLinks(
  List<StoreAttributeGroupLink> items,
  List<StoreAttributeGroupLink> state,
) {
  if (items.isEmpty) return state;

  if (state.isEmpty) state.addAll(items);

  if (state.indexWhere(
        (element) => element.storeSubtypeId == items[0].storeSubtypeId,
      ) ==
      -1) {
    state.addAll(items);
  }

  return state;
}
