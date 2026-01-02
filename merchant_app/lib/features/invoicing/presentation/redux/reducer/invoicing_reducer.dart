import 'package:littlefish_merchant/features/invoicing/presentation/redux/actions/invoicing_actions.dart';
import 'package:redux/redux.dart';
import 'package:built_collection/built_collection.dart';
import '../state/invoicing_state.dart';

final invoicingReducer = combineReducers<InvoicingState>([
  TypedReducer<InvoicingState, LoadInvoicesAction>(_setIsLoading).call,
  TypedReducer<InvoicingState, LoadInvoicesSuccessAction>(_setInvoices).call,
  TypedReducer<InvoicingState, LoadInvoicesFailureAction>(_setError).call,
  TypedReducer<InvoicingState, SetInvoicesLoadingAction>(
    _setLoadingStatus,
  ).call,
  TypedReducer<InvoicingState, SetInvoiceDiscountAction>(_setDiscount).call,
  TypedReducer<InvoicingState, SetInvoiceTotalAmountAction>(
    _setTotalAmount,
  ).call,
  TypedReducer<InvoicingState, SetInvoiceDueDateAction>(
    _setInvoiceDueDate,
  ).call,
  TypedReducer<InvoicingState, SetInvoiceSelectedProductsAction>(
    _setSelectedProducts,
  ).call,
  TypedReducer<InvoicingState, SetInvoiceNotesAction>(_setInvoiceNotes).call,
  TypedReducer<InvoicingState, SetSelectedQuantitiesAction>(
    _setSelectedQuantities,
  ).call,
  TypedReducer<InvoicingState, ResetInvoicingStateAction>(
    _resetInvoicingState,
  ).call,
  TypedReducer<InvoicingState, AppendInvoicesSuccessAction>(
    _appendInvoices,
  ).call,
  TypedReducer<InvoicingState, ResetInvoicesStateAction>(_resetState).call,
]);

InvoicingState _setIsLoading(InvoicingState state, LoadInvoicesAction action) {
  return state.rebuild(
    (b) => b
      ..isLoading = true
      ..hasError = false
      ..error = null,
  );
}

InvoicingState _setInvoices(
  InvoicingState state,
  LoadInvoicesSuccessAction action,
) {
  return state.rebuild(
    (b) => b
      ..isLoading = false
      ..hasError = false
      ..invoices.replace(action.invoices),
  );
}

InvoicingState _setError(
  InvoicingState state,
  LoadInvoicesFailureAction action,
) {
  return state.rebuild(
    (b) => b
      ..isLoading = false
      ..hasError = true
      ..error = action.error,
  );
}

InvoicingState _setLoadingStatus(
  InvoicingState state,
  SetInvoicesLoadingAction action,
) {
  return state.rebuild((b) => b..isLoading = action.value);
}

InvoicingState _setDiscount(
  InvoicingState state,
  SetInvoiceDiscountAction action,
) {
  return state.rebuild((b) => b..discount = action.discount);
}

InvoicingState _setTotalAmount(
  InvoicingState state,
  SetInvoiceTotalAmountAction action,
) {
  return state.rebuild((b) => b..totalAmount = action.total);
}

InvoicingState _setInvoiceDueDate(
  InvoicingState state,
  SetInvoiceDueDateAction action,
) {
  return state.rebuild((b) => b..dueDate = action.dueDate);
}

InvoicingState _setSelectedProducts(
  InvoicingState state,
  SetInvoiceSelectedProductsAction action,
) {
  return state.rebuild((b) => b..selectedProducts.replace(action.products));
}

InvoicingState _setInvoiceNotes(
  InvoicingState state,
  SetInvoiceNotesAction action,
) {
  return state.rebuild((b) => b..notes = action.notes);
}

InvoicingState _setSelectedQuantities(
  InvoicingState state,
  SetSelectedQuantitiesAction action,
) {
  return state.rebuild((b) => b..selectedQuantities.replace(action.quantities));
}

InvoicingState _resetInvoicingState(
  InvoicingState state,
  ResetInvoicingStateAction action,
) {
  return state.rebuild(
    (b) => b
      ..discount = null
      ..totalAmount = 0
      ..dueDate = null
      ..notes = ''
      ..selectedProducts.clear()
      ..selectedQuantities.clear()
      //..isLoading = false
      ..hasError = false
      ..error = null,
  );
}

InvoicingState _appendInvoices(
  InvoicingState state,
  AppendInvoicesSuccessAction action,
) {
  return state.rebuild(
    (b) => b
      ..invoices.replace([...state.invoices, ...action.invoices])
      ..offset = action.offset
      ..totalRecords = action.totalRecords
      ..hasMore =
          [...state.invoices, ...action.invoices].length < action.totalRecords,
  );
}

InvoicingState _resetState(
  InvoicingState state,
  ResetInvoicesStateAction action,
) {
  return InvoicingState(
    (b) => b
      ..invoices = ListBuilder()
      ..offset = 0
      ..limit = 10
      ..totalRecords = 0
      ..hasMore = true
      ..isLoading = true
      ..hasError = false
      ..error = null,
  );
}
