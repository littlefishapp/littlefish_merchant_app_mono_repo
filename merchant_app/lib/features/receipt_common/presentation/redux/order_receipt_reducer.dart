import 'package:littlefish_merchant/features/receipt_common/presentation/redux/order_receipt_actions.dart';
import 'package:littlefish_merchant/features/receipt_common/presentation/redux/order_receipt_state.dart';
import 'package:redux/redux.dart';

final orderReceiptReducer = combineReducers<OrderReceiptState>([
  TypedReducer<OrderReceiptState, InitializeReceiptStateAction>(
    _initializeReceiptStateAction,
  ).call,
  TypedReducer<OrderReceiptState, SetOrderReceiptStateIsLoadingAction>(
    _setOrderReceiptStateIsLoadingAction,
  ).call,
  TypedReducer<OrderReceiptState, SetOrderReceiptStateHasSentAction>(
    _setOrderReceiptStateHasSentAction,
  ).call,
  TypedReducer<OrderReceiptState, SetOrderReceiptErrorAction>(
    _setOrderReceiptErrorAction,
  ).call,
  TypedReducer<OrderReceiptState, SetReceiptCustomerAction>(
    _setReceiptCustomerAction,
  ).call,
  TypedReducer<OrderReceiptState, SetReceiptOrderAction>(
    _setReceiptOrderAction,
  ).call,
  TypedReducer<OrderReceiptState, SetReceiptOrderTransactionAction>(
    _setReceiptOrderTransactionAction,
  ).call,
  TypedReducer<OrderReceiptState, ClearReceiptStateAction>(
    _clearReceiptStateAction,
  ).call,
]);

OrderReceiptState _initializeReceiptStateAction(
  OrderReceiptState state,
  InitializeReceiptStateAction action,
) => state.rebuild((s) {
  s.customer = action.customer;
  s.currentTransaction = action.transaction;
  s.currentOrder = action.order;
  s.error = null;
  s.hasSent = false;
});

OrderReceiptState _clearReceiptStateAction(
  OrderReceiptState state,
  ClearReceiptStateAction action,
) => state.rebuild((s) {
  s.customer = null;
  s.currentTransaction = null;
  s.currentOrder = null;
  s.error = null;
  s.hasSent = false;
  s.isLoading = false;
});

OrderReceiptState _setReceiptCustomerAction(
  OrderReceiptState state,
  SetReceiptCustomerAction action,
) => state.rebuild((s) => s.customer = action.customer);

OrderReceiptState _setOrderReceiptStateIsLoadingAction(
  OrderReceiptState state,
  SetOrderReceiptStateIsLoadingAction action,
) => state.rebuild((s) => s.isLoading = action.value);

OrderReceiptState _setOrderReceiptStateHasSentAction(
  OrderReceiptState state,
  SetOrderReceiptStateHasSentAction action,
) => state.rebuild((s) => s.hasSent = action.value);

OrderReceiptState _setOrderReceiptErrorAction(
  OrderReceiptState state,
  SetOrderReceiptErrorAction action,
) => state.rebuild((s) => s.error = action.error);

OrderReceiptState _setReceiptOrderAction(
  OrderReceiptState state,
  SetReceiptOrderAction action,
) => state.rebuild((s) => s.currentOrder = action.order);

OrderReceiptState _setReceiptOrderTransactionAction(
  OrderReceiptState state,
  SetReceiptOrderTransactionAction action,
) => state.rebuild((s) => s.currentTransaction = action.transaction);
