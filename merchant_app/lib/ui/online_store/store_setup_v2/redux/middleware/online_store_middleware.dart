// removed ignore: depend_on_referenced_packages

import 'package:redux/redux.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';

class OnlineStoreMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    if (action is SetStoreNameAction ||
        action is SetStoreDescriptionAction ||
        action is SetStoreSloganAction ||
        action is SetStoreMobileNumberAction ||
        action is SetStoreEmailAddressAction ||
        action is SetStoreAddressAction ||
        action is UpdateStoreContactInformationAction ||
        action is UpdateTradingHoursAction) {
      var onlineStoreState = store.state.storeState;
      if (onlineStoreState.store == null) {
        store.dispatch(CreateDefaultStoreAction());
      }
    }

    next(action);
  }
}
