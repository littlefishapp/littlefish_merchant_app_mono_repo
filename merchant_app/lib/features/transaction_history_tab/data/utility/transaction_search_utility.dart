import 'package:littlefish_merchant/features/order_common/data/model/order_transaction.dart';

class TransactionSearchUtility {
  static List<OrderTransaction> searchList(
    String searchText,
    List<OrderTransaction> transactions,
  ) {
    List<OrderTransaction> localTransactions = List.from(transactions);
    List<OrderTransaction> searchTransactions = [];

    var transNum = localTransactions
        .where(
          (element) =>
              element.transactionNumber.toString().contains(searchText),
        )
        .toList();
    searchTransactions.addAll(transNum);
    var amount = localTransactions
        .where((element) => element.amount.toString().contains(searchText))
        .toList();
    searchTransactions.addAll(amount);
    var customerName = localTransactions
        .where(
          (element) =>
              element.customer.firstName.toString().contains(searchText),
        )
        .toList();
    searchTransactions.addAll(customerName);

    return searchTransactions.toSet().toList();
  }
}
