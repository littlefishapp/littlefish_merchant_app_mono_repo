// flutter imports
import 'package:flutter/material.dart';
// remove ignore: implementation_imports
import 'package:redux/src/store.dart';

// project imports
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/order_transaction_history/presentation/redux/actions/order_transaction_history_actions.dart';
import 'package:littlefish_merchant/shared/exceptions/general_error.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';
import 'package:littlefish_merchant/features/order_transaction_history/presentation/redux/state/order_transaction_history_state.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';

class OrderHistoryTabVM
    extends StoreCollectionViewModel<int, OrderTransactionHistoryState> {
  OrderHistoryTabVM.fromStore(Store<AppState> store) : super.fromStore(store);

  late int tabIndex;
  late void Function(int index) setTabIndex;
  late List<Order> orders;
  late List<Order> displayedOrders;
  GeneralError? error;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.orderTransactionHistoryState;
    tabIndex = state!.tabIndex ?? 0;
    orders = state!.orders;
    displayedOrders = state!.displayedOrders;
    error = state!.error;
    isLoading = state!.isLoading;
    hasError = state!.hasError;
    onResetErorr = () => store.dispatch(ResetOrderHistoryErrorAction());
    setTabIndex = (index) =>
        store.dispatch(SetOrderHistoryTabIndexAction(index));
  }
}
