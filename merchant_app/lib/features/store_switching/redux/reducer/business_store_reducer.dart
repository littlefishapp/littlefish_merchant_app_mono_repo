import '../actions/business_actions.dart';
import '../state/business_store_state.dart';
import 'package:redux/redux.dart';

final businessStoreReducer = combineReducers<BusinessStoreState>([
  TypedReducer<BusinessStoreState, LoadBusinessesAction>(_setIsLoading).call,
  TypedReducer<BusinessStoreState, LoadBusinessesSuccessAction>(
    _setBusinessStores,
  ).call,
  TypedReducer<BusinessStoreState, LoadBusinessesFailureAction>(_setError).call,
  TypedReducer<BusinessStoreState, SetBusinessStoresLoadingAction>(
    _setLoadingStatus,
  ).call,
]);

BusinessStoreState _setIsLoading(
  BusinessStoreState state,
  LoadBusinessesAction action,
) {
  return state.rebuild(
    (b) => b
      ..isLoading = true
      ..hasError = false
      ..error = null,
  );
}

BusinessStoreState _setBusinessStores(
  BusinessStoreState state,
  LoadBusinessesSuccessAction action,
) {
  return state.rebuild(
    (b) => b
      ..isLoading = false
      ..hasError = false
      ..businessStores = action.businessStores.toList(),
  );
}

BusinessStoreState _setError(
  BusinessStoreState state,
  LoadBusinessesFailureAction action,
) {
  return state.rebuild(
    (b) => b
      ..isLoading = false
      ..hasError = true
      ..error = action.error,
  );
}

BusinessStoreState _setLoadingStatus(
  BusinessStoreState state,
  SetBusinessStoresLoadingAction action,
) {
  return state.rebuild((b) => b..isLoading = action.value);
}
