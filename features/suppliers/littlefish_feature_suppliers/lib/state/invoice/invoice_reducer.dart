// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/suppliers/supplier_invoice.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/redux/invoice/invoice_actions.dart';
import 'package:littlefish_merchant/redux/invoice/invoice_state.dart';
import 'package:littlefish_merchant/redux/ui/ui_entity_state.dart';

final invoiceReducer = combineReducers<InvoiceState>([
  TypedReducer<InvoiceState, InvoicesLoadedAction>(onInvoicesLoaded).call,
  TypedReducer<InvoiceState, InvoiceSetLoadingAction>(onSetLoading).call,
  TypedReducer<InvoiceState, InvoiceChangedAction>(onInvoiceChanged).call,
  TypedReducer<InvoiceState, SignoutAction>(onClearState).call,
]);

InvoiceState onClearState(InvoiceState state, SignoutAction action) =>
    state.rebuild((b) {
      b.isLoading = false;
      b.hasError = false;
      b.errorMessage = null;

      b.invoices = [];
    });

InvoiceState onInvoicesLoaded(
  InvoiceState state,
  InvoicesLoadedAction action,
) => state.rebuild((b) {
  b.invoices = action.value;
});

InvoiceState onSetLoading(InvoiceState state, InvoiceSetLoadingAction action) =>
    state.rebuild((b) => b.isLoading = action.value);

InvoiceState onInvoiceChanged(
  InvoiceState state,
  InvoiceChangedAction action,
) => state.rebuild((b) {
  var invoices = b.invoices;

  if (action.type != ChangeType.removed) {
    b.invoices = _addOrRemoveInvoice(action.item, invoices);
  } else {
    b.invoices = _removeInvoice(action.item, invoices);
  }
});

final invoiceUIReducer = combineReducers<InvoiceUIState>([
  TypedReducer<InvoiceUIState, InvoiceSelectAction>(onSelectInvoice).call,
  TypedReducer<InvoiceUIState, InvoiceCreateAction>(onCreateInvoice).call,
  TypedReducer<InvoiceUIState, InvoiceChangedAction>(
    onSetUIInvoiceChanged,
  ).call,
]);

InvoiceUIState onSelectInvoice(
  InvoiceUIState state,
  InvoiceSelectAction action,
) => state.rebuild((b) {
  b.item = UIEntityState(action.value, isNew: false);
});

InvoiceUIState onCreateInvoice(
  InvoiceUIState state,
  InvoiceCreateAction action,
) => state.rebuild(
  (b) => b.item = UIEntityState(SupplierInvoice.create(), isNew: true),
);

InvoiceUIState onSetUIInvoiceChanged(
  InvoiceUIState state,
  InvoiceChangedAction action,
) {
  return state.rebuild((b) {
    if (action.item == null || b.item == null) {
      b.item = null;
      return;
    }

    if (action.type == ChangeType.removed &&
        b.item!.item!.id == action.item!.id) {
      b.item = null;
      return;
    }
    if (action.type != ChangeType.removed &&
        b.item!.item!.id == action.item!.id) {
      b.item = UIEntityState<SupplierInvoice?>(action.item);
      return;
    }
  });
}

List<SupplierInvoice>? _addOrRemoveInvoice(
  SupplierInvoice? value,
  List<SupplierInvoice>? state,
) {
  if (value == null) return state;

  var index = state!.indexWhere((p) => p.id == value.id);
  if (index >= 0) {
    state[index] = value;
  } else {
    state.add(value);
  }

  return state;
}

List<SupplierInvoice>? _removeInvoice(
  SupplierInvoice? value,
  List<SupplierInvoice>? state,
) {
  if (value == null) return state;

  state!.removeWhere((p) => p.id == value.id);

  return state;
}
