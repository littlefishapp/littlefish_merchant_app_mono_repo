import 'package:littlefish_merchant/features/errors/presentation/redux/error_actions.dart';
import 'package:littlefish_merchant/features/errors/presentation/redux/error_state.dart';
import 'package:redux/redux.dart';

final errorStateReducer = combineReducers<ErrorState>([
  TypedReducer<ErrorState, SetAppErrorAction>(_setAppError).call,
  TypedReducer<ErrorState, SetErrorStateLoadingAction>(_setIsLoading).call,
]);

ErrorState _setAppError(ErrorState state, SetAppErrorAction action) =>
    state.rebuild((s) {
      s.error = action.error;
      s.hasError = true;
    });

ErrorState _setIsLoading(ErrorState state, SetErrorStateLoadingAction action) =>
    state.rebuild((s) {
      s.isLoading = action.isLoading;
    });
