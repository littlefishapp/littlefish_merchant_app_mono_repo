import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';

class SalesSelector {
  final SalesSubType? type;
  final List<CheckoutTransaction?>? transactions;

  SalesSelector({required this.type, required this.transactions});

  List<CheckoutTransaction?> getTransactionListBySubType() {
    switch (type) {
      case SalesSubType.all:
        return _sortTransactions(transactions ?? []);
      case SalesSubType.completed:
        return _sortTransactions(_filterByStatus('complete'));
      case SalesSubType.cancelled:
        return _sortTransactions(_filterByStatus('cancelled'));
      case SalesSubType.refunded:
        return _sortTransactions(_filterByStatus('refunded'));
      case SalesSubType.withdrawals:
        return _sortTransactions(_filterByAction(SalesSubType.withdrawals));
      default:
        return [];
    }
  }

  List<CheckoutTransaction?> getFilteredTransactions() {
    if (transactions != null) {
      switch (type) {
        case SalesSubType.all:
          return transactions ?? [];
        case SalesSubType.completed:
          var tr = transactions!
              .where(
                (element) =>
                    element!.status == 'complete' &&
                    (element.withdrawalAmount == 0 ||
                        element.withdrawalAmount == null),
              )
              .toList();
          return tr;
        case SalesSubType.cancelled:
          var tr = transactions!
              .where((element) => element?.status == 'cancelled')
              .toList();
          return tr;
        case SalesSubType.refunded:
          var tr = transactions!
              .where((element) => element?.status == 'refunded')
              .toList();
          return tr;
        case SalesSubType.withdrawals:
          return transactions!
              .where(
                (element) =>
                    (element?.withdrawalAmount != 0 &&
                    element?.withdrawalAmount != null),
              )
              .toList();
        default:
          return [];
      }
    } else {
      return [];
    }
  }

  List<CheckoutTransaction?> _filterByStatus(String status) {
    List<CheckoutTransaction?>? transactions = this.transactions
        ?.where((element) => element!.status == status)
        .toList();
    if (status == 'complete') {
      transactions = transactions
          ?.where(
            (element) =>
                (element?.withdrawalAmount == 0 ||
                element?.withdrawalAmount == null),
          )
          .toList();
    }
    return transactions ?? [];
  }

  List<CheckoutTransaction?> _filterByAction(SalesSubType type) {
    switch (type) {
      case SalesSubType.withdrawals:
        List<CheckoutTransaction?>? transactionList = transactions
            ?.where(
              (element) =>
                  (element?.withdrawalAmount != 0 &&
                  element?.withdrawalAmount != null),
            )
            .toList();
        return transactionList ?? [];
      default:
        return [];
    }
  }

  List<CheckoutTransaction?> _sortTransactions(
    List<CheckoutTransaction?> transactions,
  ) {
    transactions.sort(
      (tx1, tx2) => tx2!.transactionNumber!.compareTo(tx1!.transactionNumber!),
    );
    return transactions;
  }
}
