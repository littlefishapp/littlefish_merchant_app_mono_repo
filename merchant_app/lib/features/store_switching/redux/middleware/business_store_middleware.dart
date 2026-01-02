import 'package:littlefish_core_utils/httpErrors/models/api_error.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/shared/exceptions/general_error.dart';

import '../../../../injector.dart';
import '../../data/business_store_data_source.dart';
import '../actions/business_actions.dart';

List<Middleware<AppState>> createBusinessMiddleware() {
  return [
    TypedMiddleware<AppState, LoadBusinessesAction>(_loadBusinesses()).call,
  ];
}

Middleware<AppState> _loadBusinesses() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    store.dispatch(SetBusinessStoresLoadingAction(true));

    try {
      final businesses = await getIt<BusinessStoreDataSource>().fetchBusinesses(
        store: store,
        userId: store.state.userState.profile?.userId.toString().trim(),
        token: store.state.authState.token,
      );

      store.dispatch(LoadBusinessesSuccessAction(businesses));
    } catch (error) {
      String message = 'Failed to fetch businesses.';
      if (error is ApiErrorException) {
        message = error.error.userMessage;
      }

      store.dispatch(
        LoadBusinessesFailureAction(
          GeneralError(
            message: message,
            methodName: 'createBusinessMiddleware: _loadBusinesses',
            error: error,
          ),
        ),
      );
    } finally {
      store.dispatch(SetBusinessStoresLoadingAction(false));
    }
  };
}
