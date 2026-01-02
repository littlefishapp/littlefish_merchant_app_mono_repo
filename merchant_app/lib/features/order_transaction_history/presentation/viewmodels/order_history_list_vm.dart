// flutter imports
import 'package:flutter/material.dart';
import 'package:littlefish_core/business/models/business_user.dart';

import 'package:quiver/strings.dart';
// remove ignore: implementation_imports
import 'package:redux/src/store.dart';

// project imports
import 'package:littlefish_merchant/features/order_common/data/model/order_filter.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/order_transaction_history/presentation/redux/actions/order_transaction_history_actions.dart';
import 'package:littlefish_merchant/shared/exceptions/general_error.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';
import 'package:littlefish_merchant/features/order_transaction_history/presentation/redux/state/order_transaction_history_state.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';

class OrderHistoryListVM
    extends StoreCollectionViewModel<Order, OrderTransactionHistoryState> {
  OrderHistoryListVM.fromStore(Store<AppState> store) : super.fromStore(store);

  Order? currentOrder;

  BusinessUser? orderConsultant;

  late List<Order> orders;

  late List<Order> filteredOrders;

  late List<Order> allOrders;

  late List<Order> displayedOrders;

  late bool hasFetchedAllOrders;

  late GeneralError? error;

  late void Function(String text) searchOrders;

  late void Function(String text) updateSearchText;

  late void Function() getMoreOrders;

  late void Function(OrderFilter filter) saveAndApplyFilter;

  late Function(Order order, bool fetchOrderTransactions) setCurrentOrder;

  late Function(String id) getSetOrderConsultant;

  OrderFilter? orderFilter;

  String? searchText;

  late bool isSearchOrFilterApplied;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.orderTransactionHistoryState;
    currentOrder = state!.currentOrder;
    orderConsultant = state!.orderConsultant;
    orders = state!.orders;
    filteredOrders = state!.filteredOrders;
    allOrders = state!.allOrders;
    displayedOrders = state!.displayedOrders;
    hasFetchedAllOrders = state!.hasFetchedAllOrders;
    orderFilter = state!.orderFilter;
    searchText = state!.ordersSearchText;
    isLoading = state!.isLoading;
    hasError = state!.hasError;
    error = state!.error;
    isSearchOrFilterApplied =
        (orderFilter != null && orderFilter!.hasData()) ||
        isNotBlank(searchText);

    getSetOrderConsultant = (id) =>
        store.dispatch(GetSetOrderSalesConsultantAction(id));

    setCurrentOrder = (order, fetchOrderTransactions) => store.dispatch(
      SetCurrentOrderAction(order, fetchTransactions: fetchOrderTransactions),
    );

    onResetErorr = () => store.dispatch(ResetOrderHistoryErrorAction());

    getMoreOrders = () {
      if (isSearchOrFilterApplied) {
        store.dispatch(
          GetFilteredOrdersAction(
            orderFilter ?? OrderFilter(),
            updateStateLoading: false,
            searchText: searchText,
          ),
        );
      } else {
        store.dispatch(
          GetNextOrderBatchAction(
            offset: orders.length,
            updateStateLoading: false,
          ),
        );
      }
    };

    saveAndApplyFilter = (OrderFilter filter) {
      store.dispatch(ClearFilteredOrdersAction());
      store.dispatch(SetOrderFiltersAction(filter));
      store.dispatch(
        GetFilteredOrdersAction(filter, searchText: searchText, offset: 0),
      );
    };

    searchOrders = (searchedText) {
      store.dispatch(ClearFilteredOrdersAction());
      store.dispatch(SearchOrdersAction(searchedText));
    };

    updateSearchText = (searchedText) {
      store.dispatch(UpdateOrdersSearchTextAction(searchedText));
      if (isBlank(searchedText)) {
        store.dispatch(ClearFilteredOrdersAction());
      }
    };
  }
}
