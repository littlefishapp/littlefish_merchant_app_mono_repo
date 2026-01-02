// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_actions.dart';
import 'package:littlefish_merchant/stores/stores.dart';

class PushSaleMiddleware extends MiddlewareClass<AppState> {
  final SalesStore salesStore = SalesStore();

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    //trigger the next action in the chain as expected
    next(action);

    if (action is CheckoutPushSaleCompletedAction) {
      if ((store.state.hasInternet ?? false) &&
          (action.transaction.pendingSync ?? false)) {
        store.dispatch(syncSales());
      }
    }
  }
}
