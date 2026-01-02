import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_transaction.dart';
import 'package:littlefish_merchant/features/order_transaction_history/presentation/redux/actions/order_transaction_history_actions.dart';
import 'package:littlefish_merchant/features/order_transaction_history/presentation/redux/state/order_transaction_history_state.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/data/models/filter_item.dart';
import 'package:littlefish_merchant/tools/extensions/extensions.dart';
import 'package:redux/redux.dart';

final orderTransactionHistoryReducer =
    combineReducers<OrderTransactionHistoryState>([
      TypedReducer<
            OrderTransactionHistoryState,
            SetTransactionOrderHistoryIsLoadingAction
          >(_setOrderTransactionHistoryStateIsLoadingAction)
          .call,
      TypedReducer<
            OrderTransactionHistoryState,
            SaveTransactionOrderHistoryToStateAction
          >(_setOrderTransactionHistoryStateAction)
          .call,
      TypedReducer<
            OrderTransactionHistoryState,
            SaveNextOrderBatchToStateAction
          >(_updateOrdersAction)
          .call,
      TypedReducer<
            OrderTransactionHistoryState,
            SaveAllFetchedOrdersToStateAction
          >(_updateAllFetchedOrdersAction)
          .call,
      TypedReducer<
            OrderTransactionHistoryState,
            SaveNextTransactionBatchToStateAction
          >(_updateTransactionsAction)
          .call,
      TypedReducer<
            OrderTransactionHistoryState,
            SaveNextSearchTransactionBatchToStateAction
          >(_updateSearchTransactionsAction)
          .call,
      TypedReducer<
            OrderTransactionHistoryState,
            SaveNextFilteredTransactionBatchToStateAction
          >(_updateFilteredTransactionsAction)
          .call,
      TypedReducer<
            OrderTransactionHistoryState,
            SaveFilteredTransactionsToStateAction
          >(_setFilteredTransactionsAction)
          .call,
      TypedReducer<
            OrderTransactionHistoryState,
            SaveSearchTransactionsToStateAction
          >(_setSearchTransactionsAction)
          .call,
      TypedReducer<
            OrderTransactionHistoryState,
            SaveTransactionSearchTextToStateAction
          >(_updateTransactionSearchTextAction)
          .call,
      TypedReducer<
            OrderTransactionHistoryState,
            SaveTransactionFilterTypeToStateAction
          >(_updateTransactionFilterTypeAction)
          .call,
      TypedReducer<
            OrderTransactionHistoryState,
            ClearFilteredSortTransactionsAction
          >(_clearFiltersAndSortAction)
          .call,
      TypedReducer<
            OrderTransactionHistoryState,
            SaveTransactionSortTypeToStateAction
          >(_updateTransactionSortTypeAction)
          .call,
      TypedReducer<
            OrderTransactionHistoryState,
            SaveOrderFilterTypeToStateAction
          >(_updateOrderFilterTypeAction)
          .call,
      TypedReducer<
            OrderTransactionHistoryState,
            SaveOrderSortTypeToStateAction
          >(_updateOrderSortTypeAction)
          .call,
      TypedReducer<OrderTransactionHistoryState, SaveCurrentOrderToStateAction>(
        _updateCurrentOrderAction,
      ).call,
      TypedReducer<
            OrderTransactionHistoryState,
            SaveCurrentTransactionToStateAction
          >(_updateCurrentTransactionAction)
          .call,
      TypedReducer<OrderTransactionHistoryState, SetOrderHistoryTabIndexAction>(
        _setOrderHistoryTabIndex,
      ).call,
      TypedReducer<OrderTransactionHistoryState, SetOrderHistoryErrorAction>(
        _setOrderHistoryError,
      ).call,
      TypedReducer<OrderTransactionHistoryState, ResetOrderHistoryErrorAction>(
        _resetOrderHistoryError,
      ).call,
      TypedReducer<
            OrderTransactionHistoryState,
            SetHasFetchedAllTransactionsAction
          >(_setHasFetchedAllTransactions)
          .call,
      TypedReducer<OrderTransactionHistoryState, SetHasFetchedAllOrdersAction>(
        _setHasFetchedAllOrdersAction,
      ).call,
      TypedReducer<
            OrderTransactionHistoryState,
            SaveTransactionConsultantToStateAction
          >(_saveTransactionConsultant)
          .call,
      TypedReducer<
            OrderTransactionHistoryState,
            SaveOrderConsultantToStateAction
          >(_saveOrderConsultant)
          .call,
      TypedReducer<OrderTransactionHistoryState, SetOrderFiltersAction>(
        _setOrderFilters,
      ).call,
      TypedReducer<
            OrderTransactionHistoryState,
            SaveFilteredOrdersToStateAction
          >(_updateFilteredOrdersAction)
          .call,
      TypedReducer<OrderTransactionHistoryState, ClearFilteredOrdersAction>(
        _clearFilteredOrders,
      ).call,
      TypedReducer<OrderTransactionHistoryState, UpdateOrdersSearchTextAction>(
        _setOrdersSearchText,
      ).call,
      TypedReducer<
            OrderTransactionHistoryState,
            SaveCurrentOrderTransactionsAction
          >(_saveCurrentOrderTransactionsAction)
          .call,
      TypedReducer<
            OrderTransactionHistoryState,
            ClearTransactionAndOrderAction
          >(_clearTransactionAndOrderAction)
          .call,
      TypedReducer<
            OrderTransactionHistoryState,
            SetOrderDetailsPageTabIndexAction
          >(_setOrderDetailsPageTab)
          .call,
      TypedReducer<OrderTransactionHistoryState, UpdateStateOrderAction>(
        _updateStateOrder,
      ).call,
      TypedReducer<
            OrderTransactionHistoryState,
            SaveAllOrdersCountToStateAction
          >(_saveOrdersCount)
          .call,
      TypedReducer<
            OrderTransactionHistoryState,
            SaveAllFulfillmentOrdersCountToStateAction
          >(_saveAllFulfillmentOrdersCount)
          .call,
      TypedReducer<OrderTransactionHistoryState, SetCheckoutTransactionAction>(
        _setCheckoutTransaction,
      ).call,
      TypedReducer<
            OrderTransactionHistoryState,
            ClearCheckoutTransactionAction
          >(_clearCheckoutTransaction)
          .call,
    ]);

OrderTransactionHistoryState _setOrderTransactionHistoryStateIsLoadingAction(
  OrderTransactionHistoryState state,
  SetTransactionOrderHistoryIsLoadingAction action,
) => state.rebuild((s) => s.isLoading = action.value);

OrderTransactionHistoryState _clearTransactionAndOrderAction(
  OrderTransactionHistoryState state,
  ClearTransactionAndOrderAction action,
) => state.rebuild((s) {
  s.currentTransaction = null;
  s.currentOrder = null;
});

OrderTransactionHistoryState _updateTransactionSearchTextAction(
  OrderTransactionHistoryState state,
  SaveTransactionSearchTextToStateAction action,
) => state.rebuild((s) => s.transactionSearchText = action.text);

OrderTransactionHistoryState _setHasFetchedAllTransactions(
  OrderTransactionHistoryState state,
  SetHasFetchedAllTransactionsAction action,
) => state.rebuild((s) => s.hasFetchedAllTransactions = action.value);

OrderTransactionHistoryState _setHasFetchedAllOrdersAction(
  OrderTransactionHistoryState state,
  SetHasFetchedAllOrdersAction action,
) => state.rebuild((s) => s.hasFetchedAllOrders = action.value);

OrderTransactionHistoryState _setOrderTransactionHistoryStateAction(
  OrderTransactionHistoryState state,
  SaveTransactionOrderHistoryToStateAction action,
) => state.rebuild((s) {
  s.transactions = action.transactions;
  s.orders = action.orders;
  s.currentOrder = null;
  s.currentTransaction = null;
  s.isLoading = false;
  s.orderSortType = null;
  s.orderFilterType = null;
  s.transactionSortType = null;
  s.transactionFilterTypes = [];
});

OrderTransactionHistoryState _updateOrdersAction(
  OrderTransactionHistoryState state,
  SaveNextOrderBatchToStateAction action,
) => state.rebuild((s) {
  s.orders = List.from(state.orders.toList()..addAll(action.orders));
  s.orders = s.orders?.toSet().toList();
});

OrderTransactionHistoryState _saveOrdersCount(
  OrderTransactionHistoryState state,
  SaveAllOrdersCountToStateAction action,
) => state.rebuild((s) {
  s.allOrdersCount = action.allOrdersCount;
});

OrderTransactionHistoryState _saveAllFulfillmentOrdersCount(
  OrderTransactionHistoryState state,
  SaveAllFulfillmentOrdersCountToStateAction action,
) => state.rebuild((s) {
  s.allFulfillmentOrdersCount = action.allFulfillmentOrdersCount;
});

OrderTransactionHistoryState _updateTransactionsAction(
  OrderTransactionHistoryState state,
  SaveNextTransactionBatchToStateAction action,
) => state.rebuild((s) {
  List<OrderTransaction> transactions = action.isRefresh
      ? []
      : List.from(s.transactions ?? []);
  transactions.addAllNotPresent(action.transactions);
  transactions.toList();
  s.transactions = transactions;
});

OrderTransactionHistoryState _updateSearchTransactionsAction(
  OrderTransactionHistoryState state,
  SaveNextSearchTransactionBatchToStateAction action,
) => state.rebuild((s) {
  List<OrderTransaction> transactions = action.isRefresh
      ? []
      : List.from(s.searchTransactions ?? []);
  transactions.addAllNotPresent(action.transactions);
  transactions.toList();
  s.searchTransactions = transactions;
});

OrderTransactionHistoryState _updateFilteredTransactionsAction(
  OrderTransactionHistoryState state,
  SaveNextFilteredTransactionBatchToStateAction action,
) => state.rebuild((s) {
  List<OrderTransaction> transactions = action.isRefresh
      ? []
      : List.from(s.filteredTransactions ?? []);
  transactions.addAllNotPresent(action.transactions);
  transactions.toList();
  s.filteredTransactions = transactions;
});

OrderTransactionHistoryState _updateFilteredOrdersAction(
  OrderTransactionHistoryState state,
  SaveFilteredOrdersToStateAction action,
) => state.rebuild((s) {
  s.filteredOrders = List.from(
    state.filteredOrders.toList()..addAll(action.orders),
  );
  s.filteredOrders = s.filteredOrders?.toSet().toList();
});

OrderTransactionHistoryState _clearFilteredOrders(
  OrderTransactionHistoryState state,
  ClearFilteredOrdersAction action,
) => state.rebuild((s) {
  List<Order> noOrders = [];
  s.filteredOrders = noOrders;
});

OrderTransactionHistoryState _updateAllFetchedOrdersAction(
  OrderTransactionHistoryState state,
  SaveAllFetchedOrdersToStateAction action,
) => state.rebuild((s) {
  s.allOrders = List.from(state.allOrders.toList()..addAll(action.orders));
  s.allOrders = s.allOrders?.toSet().toList();
});

OrderTransactionHistoryState _setFilteredTransactionsAction(
  OrderTransactionHistoryState state,
  SaveFilteredTransactionsToStateAction action,
) => state.rebuild((s) => s.filteredTransactions = action.transactions);

OrderTransactionHistoryState _setSearchTransactionsAction(
  OrderTransactionHistoryState state,
  SaveSearchTransactionsToStateAction action,
) => state.rebuild((s) => s.searchTransactions = action.transactions);

OrderTransactionHistoryState _updateCurrentOrderAction(
  OrderTransactionHistoryState state,
  SaveCurrentOrderToStateAction action,
) => state.rebuild((s) => s.currentOrder = action.order);

OrderTransactionHistoryState _updateCurrentTransactionAction(
  OrderTransactionHistoryState state,
  SaveCurrentTransactionToStateAction action,
) => state.rebuild((s) => s.currentTransaction = action.transaction);

OrderTransactionHistoryState _updateOrderFilterTypeAction(
  OrderTransactionHistoryState state,
  SaveOrderFilterTypeToStateAction action,
) => state.rebuild((s) => s.orderFilterType = action.filterType);

OrderTransactionHistoryState _saveTransactionConsultant(
  OrderTransactionHistoryState state,
  SaveTransactionConsultantToStateAction action,
) => state.rebuild((s) => s.transactionConsultant = action.user);

OrderTransactionHistoryState _saveOrderConsultant(
  OrderTransactionHistoryState state,
  SaveOrderConsultantToStateAction action,
) => state.rebuild((s) => s.orderConsultant = action.user);

OrderTransactionHistoryState _updateOrderSortTypeAction(
  OrderTransactionHistoryState state,
  SaveOrderSortTypeToStateAction action,
) => state.rebuild((s) => s.orderSortType = action.sortType);

OrderTransactionHistoryState _updateTransactionFilterTypeAction(
  OrderTransactionHistoryState state,
  SaveTransactionFilterTypeToStateAction action,
) => state.rebuild((s) {
  List<TransactionHistoryFilterItem> filters = List.from(
    s.transactionFilterTypes ?? [],
  );
  if (filters.isEmpty) s.transactionFilterTypes = [action.filter];
  int index = filters.indexWhere(
    (element) => element.type == action.filter.type,
  );
  if (index == -1) {
    filters.add(action.filter);
  } else {
    if (action.filter.enabled) {
      filters[index] = action.filter;
    } else {
      filters.remove(filters[index]);
    }
  }
  s.transactionFilterTypes = filters;
});

OrderTransactionHistoryState _updateTransactionSortTypeAction(
  OrderTransactionHistoryState state,
  SaveTransactionSortTypeToStateAction action,
) => state.rebuild((s) {
  s.transactionSortType = action.sortType;
});

OrderTransactionHistoryState _setOrderHistoryTabIndex(
  OrderTransactionHistoryState state,
  SetOrderHistoryTabIndexAction action,
) => state.rebuild((s) => s.tabIndex = action.index);

OrderTransactionHistoryState _setOrderHistoryError(
  OrderTransactionHistoryState state,
  SetOrderHistoryErrorAction action,
) => state.rebuild((s) {
  s.hasError = true;
  s.error = action.error;
});

OrderTransactionHistoryState _clearFiltersAndSortAction(
  OrderTransactionHistoryState state,
  ClearFilteredSortTransactionsAction action,
) => state.rebuild((s) {
  s.transactionFilterTypes = [];
  s.transactionSortType = null;
});

OrderTransactionHistoryState _resetOrderHistoryError(
  OrderTransactionHistoryState state,
  ResetOrderHistoryErrorAction action,
) => state.rebuild((s) {
  s.hasError = false;
  s.error = null;
});

OrderTransactionHistoryState _setOrderFilters(
  OrderTransactionHistoryState state,
  SetOrderFiltersAction action,
) => state.rebuild((s) {
  s.orderFilter = action.filter;
});

OrderTransactionHistoryState _setOrdersSearchText(
  OrderTransactionHistoryState state,
  UpdateOrdersSearchTextAction action,
) => state.rebuild((s) {
  s.ordersSearchText = action.searchText;
});

OrderTransactionHistoryState _saveCurrentOrderTransactionsAction(
  OrderTransactionHistoryState state,
  SaveCurrentOrderTransactionsAction action,
) => state.rebuild((s) {
  if (s.currentOrder == null) return;
  s.currentOrder = s.currentOrder!.copyWith(transactions: action.transactions);
});

OrderTransactionHistoryState _setOrderDetailsPageTab(
  OrderTransactionHistoryState state,
  SetOrderDetailsPageTabIndexAction action,
) => state.rebuild((s) {
  s.orderDetailsPageTabIndex = action.index;
});

OrderTransactionHistoryState _updateStateOrder(
  OrderTransactionHistoryState state,
  UpdateStateOrderAction action,
) => state.rebuild((s) {
  List<Order> orders = List.from(s.orders ?? []);
  int ordersIndex = orders.indexWhere(
    (element) => element.id == action.order.id,
  );
  if (ordersIndex != -1) {
    orders[ordersIndex] = action.order;
  }
  s.orders = orders;

  List<Order> allOrders = List.from(s.allOrders ?? []);
  int allOrdersIndex = allOrders.indexWhere(
    (element) => element.id == action.order.id,
  );
  if (allOrdersIndex != -1) {
    allOrders[allOrdersIndex] = action.order;
  }
  s.allOrders = allOrders;

  List<Order> filteredOrders = List.from(s.filteredOrders ?? []);
  int filteredIndex = filteredOrders.indexWhere(
    (element) => element.id == action.order.id,
  );
  if (filteredIndex != -1) {
    filteredOrders[filteredIndex] = action.order;
  }
  s.filteredOrders = filteredOrders;
});

OrderTransactionHistoryState _setCheckoutTransaction(
  OrderTransactionHistoryState state,
  SetCheckoutTransactionAction action,
) => state.rebuild((s) {
  s.checkoutTransaction = action.transaction;
});

OrderTransactionHistoryState _clearCheckoutTransaction(
  OrderTransactionHistoryState state,
  ClearCheckoutTransactionAction action,
) => state.rebuild((s) {
  s.checkoutTransaction = null;
});
