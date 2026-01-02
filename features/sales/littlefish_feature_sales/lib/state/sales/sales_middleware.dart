// Dart imports:

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/stores/stores.dart';

class SalesMiddleware extends MiddlewareClass<AppState> {
  final SalesStore salesStore = SalesStore();

  final OfflineSalesStore offlineSalesStore = OfflineSalesStore();

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    //trigger the next action in the chain as expected
    next(action);

    //this was a batch lookup and the local sales store should be updated accordingly
    // if (action is TransactionBatchLoadedAction && action.fromServer) {
    //   SalesStore salesStore = SalesStore();

    //   //we will append to our local storage sales, this will ensure that all the items are loaded as expected
    //   salesStore.storeSales(action.value);
    // }
  }
}
