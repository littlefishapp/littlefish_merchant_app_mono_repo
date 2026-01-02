import 'package:littlefish_merchant/features/order_common/data/model/order_transaction.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/data/models/sort_item.dart';
import 'package:littlefish_merchant/models/enums.dart';

class TransactionSortUtility {
  static List<TransactionHistorySortItem> generateSortTiles(
    TransactionHistorySortItem? existingSorts,
  ) {
    return List.generate(OrderTransactionHistorySort.values.length, (index) {
      OrderTransactionHistorySort sortType =
          OrderTransactionHistorySort.values[index];
      List<TransactionHistorySortItem>? existingSortedlist =
          existingSorts == null ? [] : [existingSorts];
      return TransactionHistorySortItem(
        type: sortType,
        label: getSortLabel(sortType),
        groupLabel: getSortGroup(sortType),
        enabled: getSortStatus(existingSortedlist, sortType),
      );
    });
  }

  static String getSortLabel(OrderTransactionHistorySort sortType) {
    switch (sortType) {
      case OrderTransactionHistorySort.nameAsc:
        return 'Name - Ascending';
      case OrderTransactionHistorySort.nameDesc:
        return 'Name - Descending';
      case OrderTransactionHistorySort.priceAsc:
        return 'Price - Low to High';
      case OrderTransactionHistorySort.priceDesc:
        return 'Price - High to Low';
      case OrderTransactionHistorySort.newFirst:
        return 'Newest First';
      case OrderTransactionHistorySort.oldFirst:
        return 'Oldest First';
    }
  }

  static String getSortGroup(OrderTransactionHistorySort sortType) {
    switch (sortType) {
      case OrderTransactionHistorySort.nameAsc:
      case OrderTransactionHistorySort.nameDesc:
      case OrderTransactionHistorySort.priceAsc:
      case OrderTransactionHistorySort.priceDesc:
      case OrderTransactionHistorySort.newFirst:
      case OrderTransactionHistorySort.oldFirst:
        return 'Sort By';
    }
  }

  static bool getSortStatus(
    List<TransactionHistorySortItem> sorts,
    OrderTransactionHistorySort sort,
  ) {
    if (sorts.where((element) => element.type == sort).isNotEmpty) {
      return true;
    }
    return false;
  }

  static List<OrderTransaction> sortList(
    TransactionHistorySortItem sort,
    List<OrderTransaction> transactions,
  ) {
    List<OrderTransaction> localTransactions = List.from(transactions);
    switch (sort.type) {
      case OrderTransactionHistorySort.nameAsc:
        localTransactions.sort((a, b) {
          return a.transactionType.name.compareTo(b.transactionType.name);
        });
        return localTransactions;
      case OrderTransactionHistorySort.nameDesc:
        localTransactions.sort((a, b) {
          return b.transactionType.name.compareTo(a.transactionType.name);
        });
        return localTransactions;
      case OrderTransactionHistorySort.priceAsc:
        localTransactions.sort((a, b) {
          return a.amount.compareTo(b.amount);
        });
        return localTransactions;
      case OrderTransactionHistorySort.priceDesc:
        localTransactions.sort((a, b) {
          return b.amount.compareTo(a.amount);
        });
        return localTransactions;
      case OrderTransactionHistorySort.newFirst:
        localTransactions.sort((a, b) {
          return a.dateCreated!.compareTo(b.dateCreated!);
        });
        return localTransactions;
      case OrderTransactionHistorySort.oldFirst:
        localTransactions.sort((a, b) {
          return b.dateCreated!.compareTo(a.dateCreated!);
        });
        return localTransactions;
    }
  }

  static int? sortFunction(
    OrderTransaction item1,
    OrderTransaction item2,
    TransactionHistorySortItem? sortType,
  ) {
    if (sortType != null) {
      switch (sortType.type) {
        case OrderTransactionHistorySort.nameAsc:
          return item2.transactionType.name.compareTo(
            item1.transactionType.name,
          );
        case OrderTransactionHistorySort.nameDesc:
          return item1.transactionType.name.compareTo(
            item2.transactionType.name,
          );
        case OrderTransactionHistorySort.priceAsc:
          return item2.amount.compareTo(item1.amount);
        case OrderTransactionHistorySort.priceDesc:
          return item1.amount.compareTo(item2.amount);
        case OrderTransactionHistorySort.oldFirst:
          return item2.dateCreated!.compareTo(item1.dateCreated!);
        case OrderTransactionHistorySort.newFirst:
          return item1.dateCreated!.compareTo(item2.dateCreated!);
        default:
          return 0;
      }
    }
    return 0;
  }
}
