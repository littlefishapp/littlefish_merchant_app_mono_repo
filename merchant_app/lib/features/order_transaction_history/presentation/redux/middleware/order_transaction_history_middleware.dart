// package imports
import 'package:littlefish_core/business/models/business_user.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/services/checkout_service.dart';
import 'package:quiver/strings.dart';
import 'package:redux/redux.dart';
// project imports
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/features/order_common/data/data_source/order_data_source.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_filter.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_transaction.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_transaction_filter_options.dart';
import 'package:littlefish_merchant/features/order_transaction_history/presentation/redux/actions/order_transaction_history_actions.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/data/utility/transaction_filter_utility.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/data/utility/transaction_search_utility.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/data/utility/transaction_sort_utility.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/business_service.dart';
import 'package:littlefish_merchant/shared/exceptions/general_error.dart';

List<Middleware<AppState>> createOrderTransactionHistoryMiddleware() {
  return [
    TypedMiddleware<AppState, InitializeTransactionOrderHistoryAction>(
      _initializeOrderTransactionHistory(),
    ).call,
    TypedMiddleware<AppState, SetCurrentTransactionAction>(
      _setCurrentTransaction(),
    ).call,
    TypedMiddleware<AppState, GetNextOrderBatchAction>(
      _getNextBatchOrders(),
    ).call,
    TypedMiddleware<AppState, UpdateFilteredOrdersAction>(
      _getFilteredOrders(),
    ).call,
    TypedMiddleware<AppState, GetNextTransactionBatchAction>(
      _getNextBatchTransactions(),
    ).call,
    TypedMiddleware<AppState, GetNextTransactionFilterSearchBatchAction>(
      _getNextBatchFilterSearchTransactions(),
    ).call,
    TypedMiddleware<AppState, UpdateFilteredTransactionsAction>(
      _getFilteredTransactions(),
    ).call,
    TypedMiddleware<AppState, UpdateOrderFilterTypeAction>(
      _updateOrderFilterType(),
    ).call,
    TypedMiddleware<AppState, UpdateOrderSortTypeAction>(
      _updateOrderSortType(),
    ).call,
    TypedMiddleware<AppState, UpdateTransactionFilterTypeAction>(
      _updateTransactionFilterType(),
    ).call,
    TypedMiddleware<AppState, UpdateTransactionSortTypeAction>(
      _updateTransactionSortType(),
    ).call,
    TypedMiddleware<AppState, UpdateSearchTransactionAction>(
      _getSearchTransactions(),
    ).call,
    TypedMiddleware<AppState, GetSetCurrentOrderByIdAction>(
      _getAndSetOrderById(),
    ).call,
    TypedMiddleware<AppState, GetFilteredOrdersAction>(
      _getFilteredOrders(),
    ).call,
    TypedMiddleware<AppState, SearchOrdersAction>(_searchOrders()).call,
    TypedMiddleware<AppState, GetSetTransactionSalesConsultantAction>(
      _getAndSetTransactionSalesConsultant(),
    ).call,
    TypedMiddleware<AppState, GetSetOrderSalesConsultantAction>(
      _getAndSetOrderSalesConsultant(),
    ).call,
    TypedMiddleware<AppState, GetSetCurrentOrderTransactionsAction>(
      _getAndSetTransactionsForOrder(),
    ).call,
    TypedMiddleware<AppState, SetCurrentOrderAction>(_setCurrentOrder()).call,
    TypedMiddleware<AppState, GetAllOrdersCountAction>(
      _getAllOrdersCount(),
    ).call,
    TypedMiddleware<AppState, GetAllFulfillmentOrdersCountAction>(
      _getAllFulfillmentOrdersCount(),
    ).call,
    TypedMiddleware<AppState, FetchCheckoutTransactionAction>(
      _fetchCheckoutTransaction(),
    ).call,
    TypedMiddleware<AppState, UpdateOrderShipperDetailsAction>(
      _updateOrderShipperDetails(),
    ).call,
    TypedMiddleware<AppState, CancelOrderAction>(_cancelOrder()).call,
    TypedMiddleware<AppState, ConfirmOrderAction>(_confirmOrder()).call,
    TypedMiddleware<AppState, MarkReadyForDeliveryOrCollectionAction>(
      _markReadyForDeliveryOrCollection(),
    ).call,
    TypedMiddleware<AppState, ConfirmDeliveryOrCollectionAction>(
      _confirmDeliveryOrCollection(),
    ).call,
    TypedMiddleware<AppState, MarkFailedDeliveryAction>(
      _markFailedDelivery(),
    ).call,
  ];
}

Middleware<AppState> _initializeOrderTransactionHistory() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    final act = action as InitializeTransactionOrderHistoryAction;
    try {
      if (store.state.orderTransactionHistoryState.orders.isEmpty ||
          act.refresh == true) {
        store.dispatch(
          const GetNextOrderBatchAction(
            offset: 0,
            limit: 20,
            updateStateLoading: true,
          ),
        );
      }
      if (store.state.orderTransactionHistoryState.transactions.isEmpty ||
          act.refresh == true) {
        store.dispatch(
          GetNextTransactionBatchAction(
            offset: 0,
            limit: 20,
            updateStateLoading: true,
            isRefresh: act.refresh,
          ),
        );
        store.dispatch(SaveTransactionSearchTextToStateAction(''));
      }
      store.dispatch(SaveTransactionSearchTextToStateAction(''));
      store.dispatch(UpdateOrdersSearchTextAction(''));
    } catch (error) {
      store.dispatch(
        SetOrderHistoryErrorAction(
          GeneralError(
            message: 'Could not load order and transaction history.',
            methodName:
                'createOrderTransactionHistoryMiddleware: _getNextBatchOrders',
            error: error,
          ),
        ),
      );
    }
    next(action);
  };
}

Middleware<AppState> _getFilteredOrders() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    var act = action as GetFilteredOrdersAction;
    List<Order> filteredStateOrders =
        store.state.orderTransactionHistoryState.filteredOrders;
    try {
      if (act.updateStateLoading) {
        store.dispatch(SetTransactionOrderHistoryIsLoadingAction(true));
      }
      store.dispatch(UpdateOrdersSearchTextAction(act.searchText));
      var fetchedOrders = await getIt<OrderDataSource>().filterAndSearchOrders(
        businessId: store.state.businessId!,
        offset: act.offset ?? filteredStateOrders.length,
        limit:
            30, // The initial limit value is 50, I  have been asked to temporarily change it as there's an issue with pulling bulk data, I will change this back after Sash fixes it.
        searchText: act.searchText,
        capturedChannels: act.filter.capturedChannels,
        financialStatuses: act.filter.financialStatuses,
        fulfilmentMethod: act.filter.fulfilmentMethod,
        orderStatus: act.filter.orderStatus,
        startDate: act.filter.startDate,
        endDate: act.filter.endDate,
        fulfillmentStatus: act.filter.fulfillmentStatus,
      );
      bool isOrdersEmpty = fetchedOrders.isEmpty;
      if (!isOrdersEmpty) {
        store.dispatch(SaveFilteredOrdersToStateAction(fetchedOrders));
        store.dispatch(SaveAllFetchedOrdersToStateAction(fetchedOrders));
      }
      store.dispatch(SetHasFetchedAllOrdersAction(isOrdersEmpty));
    } catch (error) {
      store.dispatch(
        SetOrderHistoryErrorAction(
          GeneralError(
            message: 'Error fetching filtered orders, please try again.',
            methodName:
                'createOrderTransactionHistoryMiddleware: _getFilteredOrders',
            error: error,
          ),
        ),
      );
    } finally {
      if (act.updateStateLoading) {
        store.dispatch(SetTransactionOrderHistoryIsLoadingAction(false));
      }
    }

    next(action);
  };
}

Middleware<AppState> _getNextBatchOrders() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    final act = action as GetNextOrderBatchAction;
    try {
      if (act.updateStateLoading) {
        store.dispatch(SetTransactionOrderHistoryIsLoadingAction(true));
      }
      var orders = await getIt<OrderDataSource>().getOrders(
        businessId: store.state.businessId!,
        offset: act.offset,
        limit: act.limit,
      );
      bool isOrdersEmpty = orders.isEmpty;
      if (!isOrdersEmpty) {
        store.dispatch(SaveNextOrderBatchToStateAction(orders));
        store.dispatch(SaveAllFetchedOrdersToStateAction(orders));
      }
      store.dispatch(SetHasFetchedAllOrdersAction(isOrdersEmpty));
    } catch (error) {
      store.dispatch(
        SetOrderHistoryErrorAction(
          GeneralError(
            message: 'Error fetching orders, please try again.',
            methodName:
                'createOrderTransactionHistoryMiddleware: _getNextBatchOrders',
            error: error,
          ),
        ),
      );
    } finally {
      if (act.updateStateLoading) {
        store.dispatch(SetTransactionOrderHistoryIsLoadingAction(false));
      }
      next(action);
    }
  };
}

Middleware<AppState> _getAllOrdersCount() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    final act = action as GetAllOrdersCountAction;
    try {
      var ordersCount = await getIt<OrderDataSource>().getOrdersCount(
        businessId: store.state.businessId!,
        financialStatuses: act.filter.financialStatuses,
        orderStatus: act.filter.orderStatus,
        capturedChannels: act.filter.capturedChannels,
      );

      store.dispatch(SaveAllOrdersCountToStateAction(ordersCount));
    } catch (error) {
      store.dispatch(
        SetOrderCountErrorAction(
          GeneralError(
            message: 'Error fetching order counts, please try again.',
            methodName:
                'createOrderTransactionHistoryMiddleware: _getOrdersCount',
            error: error,
          ),
        ),
      );
    } finally {
      next(action);
    }
  };
}

Middleware<AppState> _getAllFulfillmentOrdersCount() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    final act = action as GetAllFulfillmentOrdersCountAction;
    try {
      var allFulfillmentOrders = await getIt<OrderDataSource>()
          .getAllFulfillmentOrdersCount(
            businessId: store.state.businessId!,
            financialStatuses: act.filter.financialStatuses,
            orderStatus: act.filter.orderStatus,
            capturedChannels: act.filter.capturedChannels,
          );
      store.dispatch(
        SaveAllFulfillmentOrdersCountToStateAction(allFulfillmentOrders),
      );
    } catch (error) {
      store.dispatch(
        SetOrderCountErrorAction(
          GeneralError(
            message: 'Error fetching order counts, please try again.',
            methodName:
                'createOrderTransactionHistoryMiddleware: _getOrdersCount',
            error: error,
          ),
        ),
      );
    } finally {
      next(action);
    }
  };
}

Middleware<AppState> _updateOrderShipperDetails() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    final act = action as UpdateOrderShipperDetailsAction;
    try {
      var updatedOrder = await getIt<OrderDataSource>()
          .updateOrderShipperDetails(
            businessId: store.state.businessId!,
            order: act.order,
          );
      store.dispatch(SaveCurrentOrderToStateAction(updatedOrder));
    } catch (error) {
      store.dispatch(
        SetOrderHistoryErrorAction(
          GeneralError(
            message: 'Error updating shipper details, please try again.',
            methodName:
                'createOrderTransactionHistoryMiddleware: _getOrdersCount',
            error: error,
          ),
        ),
      );
    } finally {
      next(action);
    }
  };
}

Middleware<AppState> _cancelOrder() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    final act = action as CancelOrderAction;
    try {
      var updatedOrder = await getIt<OrderDataSource>().cancelOrder(
        businessId: store.state.businessId!,
        order: act.order,
        reason: act.reason,
      );
      store.dispatch(SaveCurrentOrderToStateAction(updatedOrder));
    } catch (error) {
      store.dispatch(
        SetOrderHistoryErrorAction(
          GeneralError(
            message: 'Error updating shipper details, please try again.',
            methodName:
                'createOrderTransactionHistoryMiddleware: _getOrdersCount',
            error: error,
          ),
        ),
      );
    } finally {
      next(action);
    }
  };
}

Middleware<AppState> _confirmOrder() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    final act = action as ConfirmOrderAction;
    try {
      var updatedOrder = await getIt<OrderDataSource>().confirmOrder(
        businessId: store.state.businessId!,
        orderId: act.orderId,
      );
      store.dispatch(SaveCurrentOrderToStateAction(updatedOrder));
    } catch (error) {
      store.dispatch(
        SetOrderHistoryErrorAction(
          GeneralError(
            message: 'Error updating shipper details, please try again.',
            methodName:
                'createOrderTransactionHistoryMiddleware: _getOrdersCount',
            error: error,
          ),
        ),
      );
    } finally {
      next(action);
    }
  };
}

Middleware<AppState> _markReadyForDeliveryOrCollection() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    final act = action as MarkReadyForDeliveryOrCollectionAction;
    try {
      var updatedOrder = await getIt<OrderDataSource>()
          .markReadyForDeliveryOrCollection(
            businessId: store.state.businessId!,
            order: act.order,
          );
      store.dispatch(SaveCurrentOrderToStateAction(updatedOrder));
    } catch (error) {
      store.dispatch(
        SetOrderHistoryErrorAction(
          GeneralError(
            message: 'Error updating shipper details, please try again.',
            methodName:
                'createOrderTransactionHistoryMiddleware: _getOrdersCount',
            error: error,
          ),
        ),
      );
    } finally {
      next(action);
    }
  };
}

Middleware<AppState> _confirmDeliveryOrCollection() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    final act = action as ConfirmDeliveryOrCollectionAction;
    try {
      var updatedOrder = await getIt<OrderDataSource>()
          .confirmDeliveryOrCollection(
            businessId: store.state.businessId!,
            order: act.order,
          );
      store.dispatch(SaveCurrentOrderToStateAction(updatedOrder));
    } catch (error) {
      store.dispatch(
        SetOrderHistoryErrorAction(
          GeneralError(
            message: 'Error updating shipper details, please try again.',
            methodName:
                'createOrderTransactionHistoryMiddleware: _getOrdersCount',
            error: error,
          ),
        ),
      );
    } finally {
      next(action);
    }
  };
}

Middleware<AppState> _markFailedDelivery() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    final act = action as MarkFailedDeliveryAction;
    try {
      var updatedOrder = await getIt<OrderDataSource>().markFailedDelivery(
        businessId: store.state.businessId!,
        order: act.order,
        reason: act.reason,
      );
      store.dispatch(SaveCurrentOrderToStateAction(updatedOrder));
    } catch (error) {
      store.dispatch(
        SetOrderHistoryErrorAction(
          GeneralError(
            message: 'Error updating shipper details, please try again.',
            methodName:
                'createOrderTransactionHistoryMiddleware: _getOrdersCount',
            error: error,
          ),
        ),
      );
    } finally {
      next(action);
    }
  };
}

Middleware<AppState> _getNextBatchTransactions() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    final act = action as GetNextTransactionBatchAction;
    if (act.updateStateLoading) {
      store.dispatch(SetTransactionOrderHistoryIsLoadingAction(true));
    }

    try {
      final transactions = await getIt<OrderDataSource>().getOrderTransactions(
        businessId: store.state.businessId!,
        offset: act.offset,
        limit: act.limit ?? 20,
      );
      bool isTransactionsEmpty = transactions.isEmpty;
      store.dispatch(SetHasFetchedAllTransactionsAction(isTransactionsEmpty));
      store.dispatch(
        SaveNextTransactionBatchToStateAction(
          transactions,
          isRefresh: act.isRefresh,
        ),
      );
    } catch (error) {
      store.dispatch(
        SetOrderHistoryErrorAction(
          GeneralError(
            message: 'Error fetching transactions, please try again.',
            methodName:
                'createOrderTransactionHistoryMiddleware: _getNextBatchOrders',
            error: error,
          ),
        ),
      );
    } finally {
      if (act.updateStateLoading) {
        store.dispatch(SetTransactionOrderHistoryIsLoadingAction(false));
      }
    }
    next(action);
  };
}

Middleware<AppState> _getNextBatchFilterSearchTransactions() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    final act = action as GetNextTransactionFilterSearchBatchAction;
    if (act.updateStateLoading) {
      store.dispatch(SetTransactionOrderHistoryIsLoadingAction(true));
    }
    try {
      OrderTransactionFilterOptions filterOptions =
          TransactionFilterUtility.getFilterOptions(
            act.filters,
            act.searchText,
          );

      final transactions = await getIt<OrderDataSource>()
          .getOrderTransactionsWithFilters(
            businessId: store.state.businessId!,
            offset: act.offset,
            limit: act.limit ?? 20,
            filterOptions: filterOptions,
          );
      bool isTransactionsEmpty = transactions.isEmpty;
      store.dispatch(SetHasFetchedAllTransactionsAction(isTransactionsEmpty));

      if (isNotBlank(act.searchText)) {
        store.dispatch(
          SaveNextSearchTransactionBatchToStateAction(
            transactions,
            isRefresh: act.isRefresh,
          ),
        );
      } else {
        store.dispatch(
          SaveNextFilteredTransactionBatchToStateAction(
            transactions,
            isRefresh: act.isRefresh,
          ),
        );
      }
    } catch (error) {
      store.dispatch(
        SetOrderHistoryErrorAction(
          GeneralError(
            message: 'Error fetching transactions, please try again.',
            methodName:
                'createOrderTransactionHistoryMiddleware: _getNextBatchOrders',
            error: error,
          ),
        ),
      );
    } finally {
      if (act.updateStateLoading) {
        store.dispatch(SetTransactionOrderHistoryIsLoadingAction(false));
      }
    }
    next(action);
  };
}

Middleware<AppState> _getFilteredTransactions() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    var act = action as UpdateFilteredTransactionsAction;

    try {
      store.dispatch(SetTransactionOrderHistoryIsLoadingAction(true));

      List<OrderTransaction> transactions = [];

      OrderTransactionFilterOptions filterOptions =
          TransactionFilterUtility.getFilterOptions(
            act.filters,
            act.searchText,
          );
      transactions = await getIt<OrderDataSource>()
          .getOrderTransactionsWithFilters(
            limit: 50,
            offset: 0,
            businessId: store.state.businessId!,
            filterOptions: filterOptions,
          );

      if (act.sort != null) {
        transactions = TransactionSortUtility.sortList(act.sort!, transactions);
      }
      if (act.searchText != null) {
        store.dispatch(SaveSearchTransactionsToStateAction(transactions));
        store.dispatch(SaveTransactionSearchTextToStateAction(act.searchText!));
      } else {
        store.dispatch(SaveFilteredTransactionsToStateAction(transactions));
      }
    } catch (error) {
      store.dispatch(
        SetOrderHistoryErrorAction(
          GeneralError(
            message: 'Error fetching transactions, please try again.',
            methodName:
                'createOrderTransactionHistoryMiddleware: _getNextBatchOrders',
            error: error,
          ),
        ),
      );
    } finally {
      store.dispatch(SetTransactionOrderHistoryIsLoadingAction(false));
    }
    next(action);
  };
}

Middleware<AppState> _getSearchTransactions() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    var act = action as UpdateSearchTransactionAction;
    store.dispatch(SetTransactionOrderHistoryIsLoadingAction(true));
    List<OrderTransaction> transactions = [];

    if (act.filters.isNotEmpty) {
      transactions = TransactionFilterUtility.filteredList(
        act.filters,
        transactions,
      );
    }
    if (act.sort != null) {
      transactions = TransactionSortUtility.sortList(act.sort!, transactions);
    }
    if (act.text.isNotEmpty) {
      transactions = TransactionSearchUtility.searchList(
        act.text,
        transactions,
      );
    }

    store.dispatch(SaveFilteredTransactionsToStateAction(transactions));
    store.dispatch(SaveTransactionSearchTextToStateAction(act.text));

    store.dispatch(SetTransactionOrderHistoryIsLoadingAction(false));
    next(action);
  };
}

Middleware<AppState> _updateOrderFilterType() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    store.dispatch(SetTransactionOrderHistoryIsLoadingAction(true));

    final act = action as UpdateOrderFilterTypeAction;

    try {
      store.dispatch(SaveOrderFilterTypeToStateAction(act.filterType));
    } catch (error) {
      store.dispatch(
        SetOrderHistoryErrorAction(
          GeneralError(
            message: 'Error applying filter, please try again.',
            methodName:
                'createOrderTransactionHistoryMiddleware: _getNextBatchOrders',
            error: error,
          ),
        ),
      );
    }

    store.dispatch(SetTransactionOrderHistoryIsLoadingAction(false));
    next(action);
  };
}

Middleware<AppState> _updateOrderSortType() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    store.dispatch(SetTransactionOrderHistoryIsLoadingAction(true));

    final act = action as UpdateOrderSortTypeAction;

    try {
      store.dispatch(SaveOrderSortTypeToStateAction(act.sortType));
    } catch (error) {
      store.dispatch(
        SetOrderHistoryErrorAction(
          GeneralError(
            message: 'Error applying order sort, please try again.',
            methodName:
                'createOrderTransactionHistoryMiddleware: _getNextBatchOrders',
            error: error,
          ),
        ),
      );
    }

    store.dispatch(SetTransactionOrderHistoryIsLoadingAction(false));
    next(action);
  };
}

Middleware<AppState> _updateTransactionFilterType() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    store.dispatch(SetTransactionOrderHistoryIsLoadingAction(true));

    final act = action as UpdateTransactionFilterTypeAction;

    try {
      store.dispatch(SaveTransactionFilterTypeToStateAction(act.filter));
    } catch (error) {
      store.dispatch(
        SetOrderHistoryErrorAction(
          GeneralError(
            message: 'Error applying transaction filter, please try again.',
            methodName:
                'createOrderTransactionHistoryMiddleware: _getNextBatchOrders',
            error: error,
          ),
        ),
      );
    }

    store.dispatch(SetTransactionOrderHistoryIsLoadingAction(false));
    next(action);
  };
}

Middleware<AppState> _updateTransactionSortType() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    store.dispatch(SetTransactionOrderHistoryIsLoadingAction(true));

    final act = action as UpdateTransactionSortTypeAction;

    try {
      store.dispatch(SaveTransactionSortTypeToStateAction(act.sortType));
    } catch (error) {
      store.dispatch(
        SetOrderHistoryErrorAction(
          GeneralError(
            message: 'Error applying transaction sort, please try again.',
            methodName:
                'createOrderTransactionHistoryMiddleware: _getNextBatchOrders',
            error: error,
          ),
        ),
      );
    }

    store.dispatch(SetTransactionOrderHistoryIsLoadingAction(false));
    next(action);
  };
}

Middleware<AppState> _getAndSetOrderById() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    store.dispatch(SetTransactionOrderHistoryIsLoadingAction(true));

    final act = action as GetSetCurrentOrderByIdAction;
    try {
      int orderIndex = AppVariables
          .store!
          .state
          .orderTransactionHistoryState
          .orders
          .indexWhere((element) => element.id == act.id);
      Order order;
      if (orderIndex == -1) {
        order = await getIt<OrderDataSource>().getOrderById(act.id);
      } else {
        order = AppVariables
            .store!
            .state
            .orderTransactionHistoryState
            .orders[orderIndex];
      }
      store.dispatch(SaveNextOrderBatchToStateAction([order]));
      store.dispatch(SaveCurrentOrderToStateAction(order));
    } catch (error) {
      store.dispatch(
        SetOrderHistoryErrorAction(
          GeneralError(
            message: 'Error getting this order, please try again.',
            methodName:
                'createOrderTransactionHistoryMiddleware: _getAndSetOrderById',
            error: error,
          ),
        ),
      );
    }

    store.dispatch(SetTransactionOrderHistoryIsLoadingAction(false));
    next(action);
  };
}

Middleware<AppState> _getAndSetTransactionSalesConsultant() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    store.dispatch(SetTransactionOrderHistoryIsLoadingAction(true));

    final act = action as GetSetTransactionSalesConsultantAction;
    BusinessUser? salesConsultant = await getSalesConsultant(
      store: store,
      id: act.id,
    );

    store.dispatch(SaveTransactionConsultantToStateAction(salesConsultant));

    store.dispatch(SetTransactionOrderHistoryIsLoadingAction(false));
    next(action);
  };
}

Middleware<AppState> _getAndSetOrderSalesConsultant() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    store.dispatch(SetTransactionOrderHistoryIsLoadingAction(true));

    final act = action as GetSetOrderSalesConsultantAction;
    BusinessUser? salesConsultant = await getSalesConsultant(
      store: store,
      id: act.id,
    );

    store.dispatch(SaveOrderConsultantToStateAction(salesConsultant));

    store.dispatch(SetTransactionOrderHistoryIsLoadingAction(false));
    next(action);
  };
}

Middleware<AppState> _setCurrentTransaction() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    store.dispatch(SetTransactionOrderHistoryIsLoadingAction(true));

    final act = action as SetCurrentTransactionAction;

    try {
      store.dispatch(SaveCurrentTransactionToStateAction(act.transaction));
    } catch (error) {
      store.dispatch(
        SetOrderHistoryErrorAction(
          GeneralError(
            message: 'Error accessing this transaction, please try again.',
            methodName:
                'createOrderTransactionHistoryMiddleware: _getNextBatchOrders',
            error: error,
          ),
        ),
      );
    }

    store.dispatch(SetTransactionOrderHistoryIsLoadingAction(false));
    next(action);
  };
}

Middleware<AppState> _searchOrders() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    var act = action as SearchOrdersAction;

    var state = store.state.orderTransactionHistoryState;

    store.dispatch(UpdateOrdersSearchTextAction(act.searchText));

    store.dispatch(
      GetFilteredOrdersAction(
        state.orderFilter ?? OrderFilter(),
        searchText: act.searchText,
        updateStateLoading: true,
        offset: 0,
      ),
    );

    next(action);
  };
}

Middleware<AppState> _getAndSetTransactionsForOrder() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    final act = action as GetSetCurrentOrderTransactionsAction;

    store.dispatch(SetTransactionOrderHistoryIsLoadingAction(true));
    try {
      // TODO(Michael) : find efficient way to decide if we should use state or fetch
      List<OrderTransaction> orderTransactions = await getIt<OrderDataSource>()
          .getTransactionsByOrderId(act.order.id);

      store.dispatch(SaveNextTransactionBatchToStateAction(orderTransactions));
      store.dispatch(SaveCurrentOrderTransactionsAction(orderTransactions));
    } catch (error) {
      store.dispatch(
        SetOrderHistoryErrorAction(
          GeneralError(
            message:
                'Error getting transactions for this order, please try again.',
            methodName:
                'createOrderTransactionHistoryMiddleware: _getAndSetTransactionsForOrder',
            error: error,
          ),
        ),
      );
    }

    store.dispatch(SetTransactionOrderHistoryIsLoadingAction(false));
    next(action);
  };
}

Middleware<AppState> _setCurrentOrder() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    final act = action as SetCurrentOrderAction;
    store.dispatch(SaveCurrentOrderToStateAction(act.order));
    if (act.fetchTransactions == true) {
      store.dispatch(GetSetCurrentOrderTransactionsAction(act.order));
    }
    next(action);
  };
}

Future<BusinessUser?> getSalesConsultant({
  required Store<AppState> store,
  required String id,
}) async {
  BusinessUser? salesConsultant;
  try {
    int sellerIndex = (store.state.businessState.users ?? []).indexWhere(
      (element) => element?.uid == id,
    );

    if (sellerIndex == -1) {
      var businessService = BusinessService.fromStore(store);
      salesConsultant = await businessService.getUserById(
        userId: id,
        checkDeletedUsers: true,
      );
    } else {
      salesConsultant = store.state.businessState.users![sellerIndex]!;
    }
  } catch (error) {
    store.dispatch(
      SetOrderHistoryErrorAction(
        GeneralError(
          message: 'Error getting sales consultant, please try again.',
          methodName:
              'createOrderTransactionHistoryMiddleware: _getSalesConsultant',
          error: error,
        ),
      ),
    );
    return null;
  }

  return salesConsultant;
}

Middleware<AppState> _fetchCheckoutTransaction() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    final act = action as FetchCheckoutTransactionAction;

    try {
      if (isBlank(act.transactionId)) {
        throw Exception('Transaction ID is blank');
      }

      CheckoutService checkoutService = _initializeService(store);

      store.dispatch(SetTransactionOrderHistoryIsLoadingAction(true));
      CheckoutTransaction transaction = await checkoutService
          .getTransactionById(act.transactionId);

      store.dispatch(SetCheckoutTransactionAction(transaction));
    } catch (e) {
      store.dispatch(ClearCheckoutTransactionAction());
    } finally {
      store.dispatch(SetTransactionOrderHistoryIsLoadingAction(false));
    }

    next(action);
  };
}

CheckoutService _initializeService(Store<AppState> store) {
  return CheckoutService(
    store: store,
    baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
    businessId: store.state.currentBusinessId,
    token: store.state.authState.token,
    userId: store.state.authState.userId,
    userName:
        store.state.userState.profile?.firstName ??
        store.state.authState.userName,
  );
}
