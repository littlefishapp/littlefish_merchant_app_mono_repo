// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/suppliers/supplier.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/redux/suppliers/supplier_actions.dart';
import 'package:littlefish_merchant/redux/suppliers/supplier_state.dart';
import 'package:littlefish_merchant/redux/ui/ui_entity_state.dart';

final suppliersReducer = combineReducers<SupplierState>([
  TypedReducer<SupplierState, SupplierChangedAction>(onSupplierChanged).call,
  TypedReducer<SupplierState, SetSuppliersLoadedAction>(onSuppliersLoaded).call,
  TypedReducer<SupplierState, SetSupplierStateFailureAction>(onSetFailure).call,
  TypedReducer<SupplierState, SetSupplierStateLoadingAction>(onSetLoading).call,
  TypedReducer<SupplierState, SignoutAction>(onClearState).call,
]);

SupplierState onClearState(SupplierState state, SignoutAction action) =>
    state.rebuild((b) {
      b.isLoading = false;
      b.hasError = false;
      b.errorMessage = null;

      b.suppliers = [];
    });

SupplierState onSupplierChanged(
  SupplierState state,
  SupplierChangedAction action,
) => state.rebuild(
  (b) => b.suppliers =
      (action.type != ChangeType.removed
              ? _addOrUpdateItem(b.suppliers, action.value)
              : _removeItem(b.suppliers, action.value))
          .cast<Supplier?>(),
);

SupplierState onSetFailure(
  SupplierState state,
  SetSupplierStateFailureAction action,
) => state.rebuild(
  (b) => b
    ..hasError = true
    ..errorMessage = action.value,
);

SupplierState onSuppliersLoaded(
  SupplierState state,
  SetSuppliersLoadedAction action,
) => state.rebuild((b) => b.suppliers = action.value);

SupplierState onSetLoading(
  SupplierState state,
  SetSupplierStateLoadingAction action,
) => state.rebuild((b) => b.isLoading = action.value);

final suppliersUIReducer = combineReducers<SupplierUIState>([
  TypedReducer<SupplierUIState, SupplierChangedAction>(onChangeUISupplier).call,
  TypedReducer<SupplierUIState, SupplierSelectAction>(onSelectSupplier).call,
  TypedReducer<SupplierUIState, SupplierCreateAction>(onCreateSupplier).call,
  TypedReducer<SupplierUIState, SetSuppliersLoadedAction>(onReset).call,
  TypedReducer<SupplierUIState, SignoutAction>(onClearUIState).call,
]);

SupplierUIState onClearUIState(SupplierUIState state, SignoutAction action) =>
    state.rebuild(
      (b) => b.item = UIEntityState<Supplier>(Supplier.create(), isNew: true),
    );

SupplierUIState onReset(
  SupplierUIState state,
  SetSuppliersLoadedAction action,
) => state.rebuild(
  (b) => b.item = UIEntityState<Supplier>(Supplier.create(), isNew: true),
);

SupplierUIState onChangeUISupplier(
  SupplierUIState state,
  SupplierChangedAction action,
) {
  // return state.rebuild((b) {
  //   if (action.value == null || b.item == null) {
  //     b.item = null;
  //     return;
  //   }

  //   if (action.type == ChangeType.removed &&
  //       b.item.item.id == action.value.id) {
  //     b.item = null;
  //     return;
  //   }
  //   if (action.type != ChangeType.removed &&
  //       b.item.item.id == action.value.id) {
  //     b.item = UIEntityState<Supplier>(action.value);
  //     return;
  //   }
  // });
  return state.rebuild(
    (b) => b.item = UIEntityState<Supplier>(Supplier.create(), isNew: true),
  );
}

SupplierUIState onSelectSupplier(
  SupplierUIState state,
  SupplierSelectAction action,
) => state.rebuild((b) {
  b.item = UIEntityState<Supplier?>(action.value, isNew: false);
});

SupplierUIState onCreateSupplier(
  SupplierUIState state,
  SupplierCreateAction action,
) => state.rebuild(
  (b) => b.item = UIEntityState<Supplier>(Supplier.create(), isNew: true),
);

List<Supplier?> _addOrUpdateItem(List<Supplier?>? state, Supplier? item) {
  if (state == null || state.isEmpty) {
    state = [item];
    return state;
  }

  var index = state.indexWhere((i) => i!.id == item!.id);
  if (index >= 0) {
    return state..[index] = item;
  } else {
    return state..add(item);
  }
}

List _removeItem(List<Supplier?>? state, Supplier? item) {
  if (state == null || state.isEmpty) return [];
  state.removeWhere((i) => i!.newID == item!.newID);

  return state;
}
