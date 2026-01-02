import 'package:flutter/widgets.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_transaction.dart';
import 'package:littlefish_merchant/features/order_transaction_history/presentation/redux/actions/order_transaction_history_actions.dart';
import 'package:littlefish_merchant/features/order_transaction_history/presentation/redux/state/order_transaction_history_state.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/data/models/filter_item.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/data/models/sort_item.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:quiver/strings.dart';
import 'package:redux/redux.dart';

import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

class OrderTransactionListVM
    extends
        StoreCollectionViewModel<
          OrderTransaction,
          OrderTransactionHistoryState
        > {
  OrderTransactionListVM.fromStore(Store<AppState> store)
    : super.fromStore(store);

  List<OrderTransaction> transactions = [];

  List<OrderTransaction> filteredTransactions = [];

  List<OrderTransaction> searchTransactions = [];

  List<OrderTransaction> displayTransactions = [];

  TransactionHistorySortItem? sortType;

  List<TransactionHistoryFilterItem>? filterTypes;

  String? searchText;

  bool isFiltered = false;

  bool hasFetchedAllTransactions = false;

  Function()? getAdditionalTransactions;

  Function()? getAdditionalTransactionsFilterSearch;

  Function(TransactionHistorySortItem)? updateTransactionSort;

  Function(TransactionHistoryFilterItem)? updateTransactionFilters;

  Function(
    List<TransactionHistoryFilterItem>,
    TransactionHistorySortItem?,
    String,
  )?
  updateSearchTransactions;

  Function(List<TransactionHistoryFilterItem>, TransactionHistorySortItem?)?
  updateFilteredTransactions;

  Function()? clearFilteredList;

  Function(OrderTransaction)? setCurrentTransaction;

  Function(String text)? setTransactionSearchText;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.orderTransactionHistoryState;
    isLoading = state!.isLoading;
    transactions = state!.transactions;
    filteredTransactions = state!.filteredTransactions;
    displayTransactions = state!.displayTransactions;
    searchTransactions = state!.searchTransactions;
    filterTypes = state!.transactionFilterTypes;
    sortType = state!.transactionSortType;
    searchText = state!.transactionSearchText;
    isFiltered = (filterTypes ?? []).isNotEmpty;
    hasFetchedAllTransactions = state!.hasFetchedAllTransactions;

    getAdditionalTransactions = () {
      store.dispatch(
        GetNextTransactionBatchAction(
          offset: transactions.length,
          limit: 20,
          updateStateLoading: false,
        ),
      );
    };

    getAdditionalTransactionsFilterSearch = () {
      store.dispatch(
        GetNextTransactionFilterSearchBatchAction(
          offset: isNotBlank(searchText)
              ? searchTransactions.length
              : filteredTransactions.length,
          limit: 20,
          updateStateLoading: false,
        ),
      );
    };
    updateTransactionFilters = (filter) {
      store.dispatch(UpdateTransactionFilterTypeAction(filter));
    };
    updateTransactionSort = (sort) {
      store.dispatch(UpdateTransactionSortTypeAction(sort));
    };
    updateSearchTransactions = (filters, sort, text) {
      store.dispatch(UpdateFilteredTransactionsAction(filters, sort, text));
    };
    updateFilteredTransactions = (filters, sort) {
      store.dispatch(UpdateFilteredTransactionsAction(filters, sort, null));
      if (isNotBlank(searchText)) {
        store.dispatch(
          UpdateFilteredTransactionsAction(filters, sort, searchText),
        );
      }
    };
    clearFilteredList = () {
      store.dispatch(ClearFilteredSortTransactionsAction());
    };
    setCurrentTransaction = (transaction) {
      if (transaction.transactionType != OrderTransactionType.refund) {
        store.dispatch(GetSetCurrentOrderByIdAction(transaction.orderId));
      }

      String userId = transaction.updatedBy.isNotEmpty
          ? transaction.updatedBy
          : transaction.createdBy;

      store.dispatch(GetSetTransactionSalesConsultantAction(userId));

      store.dispatch(SetCurrentTransactionAction(transaction));
    };
    setTransactionSearchText = (text) {
      store.dispatch(SaveTransactionSearchTextToStateAction(text));
    };
  }
}
