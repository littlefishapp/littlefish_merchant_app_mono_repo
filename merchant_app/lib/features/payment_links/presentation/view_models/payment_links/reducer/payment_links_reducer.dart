import 'package:redux/redux.dart';
import '../actions/payment_links_actions.dart';
import '../state/payment_link_state.dart';
import 'package:built_collection/built_collection.dart';

final paymentLinkReducer = combineReducers<PaymentLinksState>([
  TypedReducer<PaymentLinksState, LoadPaymentLinksAction>(_setIsLoading).call,
  TypedReducer<PaymentLinksState, LoadPaymentLinksSuccessAction>(
    _setPaymentLinks,
  ).call,
  TypedReducer<PaymentLinksState, LoadPaymentLinksFailureAction>(
    _setError,
  ).call,
  TypedReducer<PaymentLinksState, SetPaymentLinksLoadingAction>(
    _setLoadingStatus,
  ).call,
  TypedReducer<PaymentLinksState, AppendPaymentLinksSuccessAction>(
    _appendPaymentLinks,
  ).call,
  TypedReducer<PaymentLinksState, ResetPaymentLinksStateAction>(
    _resetState,
  ).call,
  //TypedReducer<PaymentLinksState, ClearPaymentLinksAction>(_clearLinks).call,
]);

PaymentLinksState _setIsLoading(
  PaymentLinksState state,
  LoadPaymentLinksAction action,
) {
  return state.rebuild(
    (b) => b
      ..isLoading = true
      ..hasError = false
      ..error = null,
  );
}

PaymentLinksState _setPaymentLinks(
  PaymentLinksState state,
  LoadPaymentLinksSuccessAction action,
) {
  return state.rebuild(
    (b) => b
      ..isLoading = false
      ..hasError = false
      ..links.replace(action.paymentLinks)
      ..offset = action.offset
      ..totalRecords = action.totalRecords
      ..hasMore = action.paymentLinks.length < action.totalRecords,
  );
}

PaymentLinksState _setError(
  PaymentLinksState state,
  LoadPaymentLinksFailureAction action,
) {
  return state.rebuild(
    (b) => b
      ..isLoading = false
      ..hasError = true
      ..error = action.error,
  );
}

PaymentLinksState _setLoadingStatus(
  PaymentLinksState state,
  SetPaymentLinksLoadingAction action,
) {
  return state.rebuild((b) => b..isLoading = action.value);
}

PaymentLinksState _appendPaymentLinks(
  PaymentLinksState state,
  AppendPaymentLinksSuccessAction action,
) {
  return state.rebuild(
    (b) => b
      ..links.replace([...state.links, ...action.paymentLinks])
      ..offset = action.offset
      ..totalRecords = action.totalRecords
      ..hasMore =
          [...state.links, ...action.paymentLinks].length < action.totalRecords,
  );
}

PaymentLinksState _resetState(
  PaymentLinksState state,
  ResetPaymentLinksStateAction action,
) {
  return PaymentLinksState(
    (b) => b
      ..links = ListBuilder()
      ..offset = 0
      ..limit = 10
      ..totalRecords = 0
      ..hasMore = true
      ..isLoading = true
      ..hasError = false
      ..error = null,
  );
}
