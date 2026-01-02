import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_transaction.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_transaction_filter_options.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/data/models/filter_item.dart';
import 'package:littlefish_merchant/models/enums.dart';

class TransactionFilterUtility {
  static List<TransactionHistoryFilterItem> generateFilterTiles(
    List<TransactionHistoryFilterItem> existingFilters,
  ) {
    return List.generate(OrderTransactionHistoryFilter.values.length, (index) {
      OrderTransactionHistoryFilter filterType =
          OrderTransactionHistoryFilter.values[index];
      return TransactionHistoryFilterItem(
        type: filterType,
        label: getFilterLabel(filterType),
        groupLabel: getFilterGroup(filterType),
        enabled: getFilterStatus(existingFilters, filterType),
        date: getFilterDate(existingFilters, filterType),
      );
    });
  }

  static String getFilterLabel(OrderTransactionHistoryFilter filterType) {
    switch (filterType) {
      case OrderTransactionHistoryFilter.startDate:
        return 'Select start date';
      case OrderTransactionHistoryFilter.endDate:
        return 'Select end date';
      case OrderTransactionHistoryFilter.success:
        return 'Success';
      case OrderTransactionHistoryFilter.pending:
        return 'Pending';
      case OrderTransactionHistoryFilter.failure:
        return 'Failure';
      case OrderTransactionHistoryFilter.error:
        return 'Error';
      case OrderTransactionHistoryFilter.sales:
        return 'Sales';
      case OrderTransactionHistoryFilter.refunds:
        return 'Refunds';
      case OrderTransactionHistoryFilter.voids:
        return 'Voids';
      case OrderTransactionHistoryFilter.withdrawals:
        return 'Withdrawals';
      case OrderTransactionHistoryFilter.online:
        return 'Online';
      case OrderTransactionHistoryFilter.inStore:
        return 'In-Store';
      case OrderTransactionHistoryFilter.card:
        return 'Card';
      case OrderTransactionHistoryFilter.cash:
        return 'Cash';
    }
  }

  static String getFilterGroup(OrderTransactionHistoryFilter filterType) {
    switch (filterType) {
      case OrderTransactionHistoryFilter.startDate:
      case OrderTransactionHistoryFilter.endDate:
        return 'Filter By Date';
      case OrderTransactionHistoryFilter.success:
      case OrderTransactionHistoryFilter.pending:
      case OrderTransactionHistoryFilter.failure:
      case OrderTransactionHistoryFilter.error:
        return 'Status';
      case OrderTransactionHistoryFilter.sales:
      case OrderTransactionHistoryFilter.refunds:
      case OrderTransactionHistoryFilter.voids:
      case OrderTransactionHistoryFilter.withdrawals:
        return 'Transaction Type';
      case OrderTransactionHistoryFilter.online:
      case OrderTransactionHistoryFilter.inStore:
        return 'Acceptance Type';
      case OrderTransactionHistoryFilter.card:
      case OrderTransactionHistoryFilter.cash:
        return 'Payment Method';
    }
  }

  static OrderTransactionFilterOptions getFilterOptions(
    List<TransactionHistoryFilterItem>? filters,
    String? searchText,
  ) {
    List<TransactionStatus>? transactionStatus = [];
    List<OrderTransactionType>? transactionType = [];
    List<AcceptanceType>? acceptanceType = [];
    List<AcceptanceChannel>? acceptanceChannel = [];
    DateTime? startDate;
    DateTime? endDate;

    if (filters != null) {
      for (TransactionHistoryFilterItem filterType in filters) {
        switch (filterType.type) {
          case OrderTransactionHistoryFilter.startDate:
            startDate = filterType.date;
            break;
          case OrderTransactionHistoryFilter.endDate:
            endDate = filterType.date;
            break;
          case OrderTransactionHistoryFilter.success:
            transactionStatus.add(TransactionStatus.success);
            break;
          case OrderTransactionHistoryFilter.pending:
            transactionStatus.add(TransactionStatus.pending);
            break;
          case OrderTransactionHistoryFilter.failure:
            transactionStatus.add(TransactionStatus.failure);
            break;
          case OrderTransactionHistoryFilter.error:
            transactionStatus.add(TransactionStatus.error);
            break;
          case OrderTransactionHistoryFilter.sales:
            transactionType.add(OrderTransactionType.purchase);
            break;
          case OrderTransactionHistoryFilter.refunds:
            transactionType.add(OrderTransactionType.refund);
            break;
          case OrderTransactionHistoryFilter.voids:
            transactionType.add(OrderTransactionType.$void);
            break;
          case OrderTransactionHistoryFilter.withdrawals:
            transactionType.add(OrderTransactionType.withdrawal);
            break;
          case OrderTransactionHistoryFilter.online:
            acceptanceType.add(AcceptanceType.online);
            break;
          case OrderTransactionHistoryFilter.inStore:
            acceptanceType.add(AcceptanceType.inPerson);
            break;
          case OrderTransactionHistoryFilter.card:
            acceptanceChannel.add(AcceptanceChannel.card);
            break;
          case OrderTransactionHistoryFilter.cash:
            acceptanceChannel.add(AcceptanceChannel.cash);
            break;
          default:
            break;
        }
      }
    }

    OrderTransactionFilterOptions filterOptions = OrderTransactionFilterOptions(
      searchText: searchText,
      transactionStatus: transactionStatus,
      transactionType: transactionType,
      acceptanceChannel: acceptanceChannel,
      acceptanceType: acceptanceType,
      startDate: startDate,
      endDate: endDate,
    );

    return filterOptions;
  }

  static bool getFilterStatus(
    List<TransactionHistoryFilterItem> filters,
    OrderTransactionHistoryFilter filter,
  ) {
    if (filters.where((element) => element.type == filter).isNotEmpty) {
      return true;
    }
    return false;
  }

  static DateTime? getFilterDate(
    List<TransactionHistoryFilterItem> filters,
    OrderTransactionHistoryFilter filter,
  ) {
    if ((filter == OrderTransactionHistoryFilter.startDate ||
        filter == OrderTransactionHistoryFilter.endDate)) {
      int index = filters.indexWhere((element) => element.type == filter);
      if (index == -1) {
        return null;
      } else {
        return filters[index].date;
      }
    }
    return null;
  }

  static List<OrderTransaction> filteredList(
    List<TransactionHistoryFilterItem> filters,
    List<OrderTransaction> transactions,
  ) {
    List<OrderTransaction> aTransactions = List.from(transactions);
    for (TransactionHistoryFilterItem filter in filters) {
      aTransactions = filterList(filter, aTransactions);
    }
    return aTransactions;
  }

  static List<OrderTransaction> filterList(
    TransactionHistoryFilterItem filter,
    List<OrderTransaction> transactions,
  ) {
    List<OrderTransaction> localTransactions = List.from(transactions);
    switch (filter.type) {
      case OrderTransactionHistoryFilter.startDate:
        if (filter.date != null) {
          localTransactions = localTransactions
              .where((element) => element.dateCreated!.isAfter(filter.date!))
              .toList();
        }
        return localTransactions;
      case OrderTransactionHistoryFilter.endDate:
        if (filter.date != null) {
          localTransactions = localTransactions
              .where((element) => element.dateCreated!.isBefore(filter.date!))
              .toList();
        }
        return localTransactions;
      case OrderTransactionHistoryFilter.success:
        localTransactions = localTransactions
            .where(
              (element) =>
                  element.transactionStatus == TransactionStatus.success,
            )
            .toList();
        return localTransactions;
      case OrderTransactionHistoryFilter.pending:
        localTransactions = localTransactions
            .where(
              (element) =>
                  element.transactionStatus == TransactionStatus.pending,
            )
            .toList();
        return localTransactions;
      case OrderTransactionHistoryFilter.failure:
        localTransactions = localTransactions
            .where(
              (element) =>
                  element.transactionStatus == TransactionStatus.failure,
            )
            .toList();
        return localTransactions;
      case OrderTransactionHistoryFilter.error:
        localTransactions = localTransactions
            .where(
              (element) => element.transactionStatus == TransactionStatus.error,
            )
            .toList();
        return localTransactions;
      case OrderTransactionHistoryFilter.sales:
        localTransactions = localTransactions
            .where(
              (element) =>
                  element.transactionType == OrderTransactionType.purchase,
            )
            .toList();
        return localTransactions;
      case OrderTransactionHistoryFilter.refunds:
        localTransactions = localTransactions
            .where(
              (element) =>
                  element.transactionType == OrderTransactionType.refund,
            )
            .toList();
        return localTransactions;
      case OrderTransactionHistoryFilter.voids:
        localTransactions = localTransactions
            .where(
              (element) =>
                  element.transactionType == OrderTransactionType.$void,
            )
            .toList();
        return localTransactions;
      case OrderTransactionHistoryFilter.withdrawals:
        localTransactions = localTransactions
            .where(
              (element) =>
                  element.transactionType == OrderTransactionType.withdrawal,
            )
            .toList();
        return localTransactions;
      case OrderTransactionHistoryFilter.online:
        localTransactions = localTransactions
            .where((element) => element.capturedChannel == CapturedChannel.web)
            .toList();
        return localTransactions;
      case OrderTransactionHistoryFilter.inStore:
        localTransactions = localTransactions
            .where((element) => element.capturedChannel != CapturedChannel.web)
            .toList();
        return localTransactions;
      case OrderTransactionHistoryFilter.card:
        localTransactions = localTransactions
            .where(
              (element) =>
                  element.paymentType.acceptanceChannel ==
                  AcceptanceChannel.card,
            )
            .toList();
        return localTransactions;
      case OrderTransactionHistoryFilter.cash:
        localTransactions = localTransactions
            .where(
              (element) =>
                  element.paymentType.acceptanceChannel ==
                  AcceptanceChannel.cash,
            )
            .toList();
        return localTransactions;
    }
  }
}
