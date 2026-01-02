import 'package:littlefish_core/business/models/business_user.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_filter.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_transaction.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/data/models/filter_item.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/data/models/sort_item.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/shared/exceptions/general_error.dart';

class InitializeTransactionOrderHistoryAction {
  bool refresh;
  InitializeTransactionOrderHistoryAction({this.refresh = false});
}

class UpdateStateOrderAction {
  final Order order;

  const UpdateStateOrderAction({required this.order});
}

class GetNextOrderBatchAction {
  final int offset;
  final int limit;
  final bool updateStateLoading;

  const GetNextOrderBatchAction({
    required this.offset,
    this.limit = 50,
    this.updateStateLoading = true,
  });
}

class GetAllOrdersCountAction {
  OrderFilter filter;
  final FulfillmentStatus? fulfillmentStatus;

  GetAllOrdersCountAction(this.filter, {this.fulfillmentStatus});
}

class GetAllFulfillmentOrdersCountAction {
  OrderFilter filter;

  GetAllFulfillmentOrdersCountAction(this.filter);
}

class UpdateOrderShipperDetailsAction {
  Order order;

  UpdateOrderShipperDetailsAction(this.order);
}

class CancelOrderAction {
  Order order;
  String reason;

  CancelOrderAction(this.order, this.reason);
}

class MarkFailedDeliveryAction {
  Order order;
  String reason;

  MarkFailedDeliveryAction(this.order, this.reason);
}

class ConfirmOrderAction {
  String orderId;

  ConfirmOrderAction(this.orderId);
}

class MarkReadyForDeliveryOrCollectionAction {
  Order order;

  MarkReadyForDeliveryOrCollectionAction(this.order);
}

class ConfirmDeliveryOrCollectionAction {
  Order order;

  ConfirmDeliveryOrCollectionAction(this.order);
}

class GetNextTransactionBatchAction {
  final int offset;
  final int? limit;
  final bool updateStateLoading;
  final bool isRefresh;

  const GetNextTransactionBatchAction({
    required this.offset,
    required this.limit,
    this.updateStateLoading = true,
    this.isRefresh = false,
  });
}

class GetNextTransactionFilterSearchBatchAction {
  final int offset;
  final int? limit;
  final bool updateStateLoading;
  final bool isRefresh;
  final List<TransactionHistoryFilterItem>? filters;
  final TransactionHistorySortItem? sort;
  final String? searchText;

  const GetNextTransactionFilterSearchBatchAction({
    required this.offset,
    required this.limit,
    this.filters,
    this.sort,
    this.searchText,
    this.updateStateLoading = true,
    this.isRefresh = false,
  });
}

class UpdateFilteredOrdersAction {
  final String filterType;

  UpdateFilteredOrdersAction(this.filterType);
}

class UpdateFilteredTransactionsAction {
  final List<TransactionHistoryFilterItem> filters;
  final TransactionHistorySortItem? sort;
  final String? searchText;

  UpdateFilteredTransactionsAction(this.filters, this.sort, this.searchText);
}

class ClearFilteredSortTransactionsAction {
  ClearFilteredSortTransactionsAction();
}

class UpdateOrderFilterTypeAction {
  final String filterType;

  UpdateOrderFilterTypeAction(this.filterType);
}

class UpdateOrderSortTypeAction {
  final String sortType;

  UpdateOrderSortTypeAction(this.sortType);
}

class UpdateTransactionFilterTypeAction {
  final TransactionHistoryFilterItem filter;

  UpdateTransactionFilterTypeAction(this.filter);
}

class UpdateTransactionSortTypeAction {
  final TransactionHistorySortItem sortType;

  UpdateTransactionSortTypeAction(this.sortType);
}

class SetCurrentOrderAction {
  final Order order;
  final bool fetchTransactions;

  SetCurrentOrderAction(this.order, {this.fetchTransactions = false});
}

class GetSetCurrentOrderByIdAction {
  final String id;

  GetSetCurrentOrderByIdAction(this.id);
}

class GetSetCurrentOrderTransactionsAction {
  final Order order;
  GetSetCurrentOrderTransactionsAction(this.order);
}

class SaveCurrentOrderTransactionsAction {
  final List<OrderTransaction> transactions;
  SaveCurrentOrderTransactionsAction(this.transactions);
}

class GetSetTransactionSalesConsultantAction {
  final String id;

  GetSetTransactionSalesConsultantAction(this.id);
}

class GetSetOrderSalesConsultantAction {
  final String id;

  GetSetOrderSalesConsultantAction(this.id);
}

class SetCurrentTransactionAction {
  final OrderTransaction transaction;

  SetCurrentTransactionAction(this.transaction);
}

class SaveTransactionOrderHistoryToStateAction {
  final List<Order> orders;
  final List<OrderTransaction> transactions;

  const SaveTransactionOrderHistoryToStateAction(
    this.orders,
    this.transactions,
  );
}

class UpdateSearchTransactionAction {
  final List<TransactionHistoryFilterItem> filters;
  final TransactionHistorySortItem? sort;
  final String text;

  const UpdateSearchTransactionAction(this.filters, this.sort, this.text);
}

class SaveNextOrderBatchToStateAction {
  final List<Order> orders;

  const SaveNextOrderBatchToStateAction(this.orders);
}

class SaveAllOrdersCountToStateAction {
  final int allOrdersCount;

  const SaveAllOrdersCountToStateAction(this.allOrdersCount);
}

class SaveAllFulfillmentOrdersCountToStateAction {
  final Map<String, dynamic> allFulfillmentOrdersCount;

  const SaveAllFulfillmentOrdersCountToStateAction(
    this.allFulfillmentOrdersCount,
  );
}

class SaveNextTransactionBatchToStateAction {
  final List<OrderTransaction> transactions;
  final bool isRefresh;

  const SaveNextTransactionBatchToStateAction(
    this.transactions, {
    this.isRefresh = false,
  });
}

class SaveNextFilteredTransactionBatchToStateAction {
  final List<OrderTransaction> transactions;
  final bool isRefresh;

  const SaveNextFilteredTransactionBatchToStateAction(
    this.transactions, {
    this.isRefresh = false,
  });
}

class SaveNextSearchTransactionBatchToStateAction {
  final List<OrderTransaction> transactions;
  final bool isRefresh;

  const SaveNextSearchTransactionBatchToStateAction(
    this.transactions, {
    this.isRefresh = false,
  });
}

class SaveAllFetchedOrdersToStateAction {
  final List<Order> orders;

  SaveAllFetchedOrdersToStateAction(this.orders);
}

class SaveFilteredOrdersToStateAction {
  final List<Order> orders;

  SaveFilteredOrdersToStateAction(this.orders);
}

class ClearFilteredOrdersAction {
  ClearFilteredOrdersAction();
}

class SaveFilteredTransactionsToStateAction {
  final List<OrderTransaction> transactions;

  SaveFilteredTransactionsToStateAction(this.transactions);
}

class SaveSearchTransactionsToStateAction {
  final List<OrderTransaction> transactions;

  SaveSearchTransactionsToStateAction(this.transactions);
}

class SaveTransactionSearchTextToStateAction {
  final String text;

  SaveTransactionSearchTextToStateAction(this.text);
}

class SaveAggregateTransactionsToStateAction {
  final List<OrderTransaction> transactions;

  SaveAggregateTransactionsToStateAction(this.transactions);
}

class SaveCurrentOrderToStateAction {
  final Order order;

  SaveCurrentOrderToStateAction(this.order);
}

class SaveCurrentTransactionToStateAction {
  final OrderTransaction transaction;

  SaveCurrentTransactionToStateAction(this.transaction);
}

class SaveTransactionConsultantToStateAction {
  final BusinessUser? user;

  SaveTransactionConsultantToStateAction(this.user);
}

class SaveOrderConsultantToStateAction {
  final BusinessUser? user;

  SaveOrderConsultantToStateAction(this.user);
}

class SaveOrderFilterTypeToStateAction {
  final String filterType;

  SaveOrderFilterTypeToStateAction(this.filterType);
}

class SaveOrderSortTypeToStateAction {
  final String sortType;

  SaveOrderSortTypeToStateAction(this.sortType);
}

class SaveTransactionFilterTypeToStateAction {
  final TransactionHistoryFilterItem filter;

  SaveTransactionFilterTypeToStateAction(this.filter);
}

class SaveTransactionSortTypeToStateAction {
  final TransactionHistorySortItem sortType;

  SaveTransactionSortTypeToStateAction(this.sortType);
}

class SetTransactionOrderHistoryIsLoadingAction {
  final bool value;

  SetTransactionOrderHistoryIsLoadingAction(this.value);
}

class SetOrderHistoryTabIndexAction {
  final int index;

  SetOrderHistoryTabIndexAction(this.index);
}

class ClearTransactionAndOrderAction {
  ClearTransactionAndOrderAction();
}

class SetOrderHistoryErrorAction {
  GeneralError error;

  SetOrderHistoryErrorAction(this.error);
}

class SetOrderCountErrorAction {
  GeneralError error;

  SetOrderCountErrorAction(this.error);
}

class ResetOrderHistoryErrorAction {
  ResetOrderHistoryErrorAction();
}

class SetHasFetchedAllTransactionsAction {
  bool value;
  SetHasFetchedAllTransactionsAction(this.value);
}

class SetHasFetchedAllOrdersAction {
  bool value;
  SetHasFetchedAllOrdersAction(this.value);
}

class SetOrderFiltersAction {
  OrderFilter filter;

  SetOrderFiltersAction(this.filter);
}

class GetFilteredOrdersAction {
  OrderFilter filter;
  bool updateStateLoading;
  String? searchText;
  int? offset;

  GetFilteredOrdersAction(
    this.filter, {
    this.updateStateLoading = true,
    this.searchText,
    this.offset,
  });
}

class UpdateOrdersSearchTextAction {
  String? searchText;

  UpdateOrdersSearchTextAction(this.searchText);
}

class SearchOrdersAction {
  String? searchText;

  SearchOrdersAction(this.searchText);
}

class SearchOrdersByOrderNumberAction {
  List<Order> orders;
  String searchText;

  SearchOrdersByOrderNumberAction(this.orders, this.searchText);
}

class SetOrderDetailsPageTabIndexAction {
  int index;

  SetOrderDetailsPageTabIndexAction(this.index);
}

class FetchCheckoutTransactionAction {
  String transactionId;

  FetchCheckoutTransactionAction(this.transactionId);
}

class SetCheckoutTransactionAction {
  CheckoutTransaction transaction;

  SetCheckoutTransactionAction(this.transaction);
}

class ClearCheckoutTransactionAction {
  ClearCheckoutTransactionAction();
}
