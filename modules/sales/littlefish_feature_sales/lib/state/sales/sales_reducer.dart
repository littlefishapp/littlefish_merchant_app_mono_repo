// Package imports:
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund_item.dart';

// Project imports:
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_actions.dart';
import 'package:littlefish_merchant/redux/sales/sales_actions.dart';
import 'package:littlefish_merchant/redux/sales/sales_state.dart';

// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

import '../../models/sales/checkout/checkout_transaction.dart';

final salesReducer = combineReducers<SalesState>([
  TypedReducer<SalesState, SetSalesLoadingStateAction>(onSetLoading).call,
  TypedReducer<SalesState, SetSalesStateErrorAction>(onSetStateError).call,
  TypedReducer<SalesState, FilteredTransactionBatchBySalesSubTypeLoadedAction>(
    onBatchLoadedBySalesSubTypeFiltered,
  ).call,
  TypedReducer<SalesState, FilteredTransactionBatchLoadedAction>(
    onBatchLoadedFiltered,
  ).call,
  TypedReducer<SalesState, SetOriginalTransactionUnmodifiedAction>(
    onSetOriginalTransactionUnmodified,
  ).call,
  TypedReducer<SalesState, SetModifiedTransactionCopyAction>(
    onSetModifiedTransactionCopy,
  ).call,
  TypedReducer<SalesState, SetCurrentRefundAction>(
    onSetCurrentRefundAction,
  ).call,
  TypedReducer<SalesState, RemoveRefundItemFromCartAction>(
    onRemoveRefundItemFromCartAction,
  ).call,
  TypedReducer<SalesState, TransactionBatchLoadedAction>(onBatchLoaded).call,
  TypedReducer<SalesState, TransactionBatchBySalesSubTypeLoadedAction>(
    onBatchLoadedBySalesSubType,
  ).call,
  TypedReducer<SalesState, SalesSetCustomerAction>(onSetCustomer).call,
  TypedReducer<SalesState, SalesSetTerminalFilterAction>(
    onSetTerminalFilter,
  ).call,
  TypedReducer<SalesState, SalesRemoveCustomerAction>(onRemoveCustomer).call,
  TypedReducer<SalesState, SaleRefundedAction>(onItemRefunded).call,
  TypedReducer<SalesState, CheckoutPushSaleCompletedAction>(onSalePushed).call,
  TypedReducer<SalesState, CheckoutCancelledSale>(onSaleCancelled).call,
  TypedReducer<SalesState, RefundSaleAction>(onSaleRefunded).call,
  TypedReducer<SalesState, SignoutAction>(onClearState).call,
  TypedReducer<SalesState, ClearSalesStateAction>(onClearState).call,
  TypedReducer<SalesState, ClearRefundStateAction>(onClearRefundState).call,
  TypedReducer<SalesState, SaleUploadedAction>(onSaleUploaded).call,
  TypedReducer<SalesState, ClearFiltersAction>(clearFiltersData).call,
  TypedReducer<SalesState, SalesClearCustomerAction>(onClearCustomer).call,
]);

SalesState onSalePushed(
  SalesState state,
  CheckoutPushSaleCompletedAction action,
) {
  if (action.success) {
    return state.rebuild((b) {
      b.sequentialTransactions ??= [];

      b.sequentialTransactions!.add(action.transaction);
    });
  } else {
    return state;
  }
}

SalesState onSaleUploaded(SalesState state, SaleUploadedAction action) =>
    state.rebuild((b) {
      if (state.agglomerationTransactions.any((i) => i.id == action.value.id)) {
        var index = state.agglomerationTransactions.indexWhere(
          (i) => i.id == action.value.id,
        );

        state.agglomerationTransactions[index] = action.value;
      } else {
        state.agglomerationTransactions.add(action.value);
      }
    });

SalesState onSetLoading(SalesState state, SetSalesLoadingStateAction action) =>
    state.rebuild((b) => b.isLoading = action.value);

SalesState onSetStateError(SalesState state, SetSalesStateErrorAction action) =>
    state.rebuild((b) {
      b.errorMessage = action.value;
      b.hasError = true;
    });

SalesState onBatchLoaded(
  SalesState state,
  TransactionBatchLoadedAction action,
) {
  return state.rebuild((b) {
    List<CheckoutTransaction> transactions = [
      ...List.from(b.sequentialTransactions ?? []),
      ...action.value,
    ];

    transactions = transactions.toSet().toList();
    transactions.sort(
      (a, b) => (a.dateUpdated ?? a.transactionDate!).compareTo(
        b.dateUpdated ?? b.transactionDate!,
      ),
    );
    b.sequentialTransactions = transactions;
    List<CheckoutTransaction> aggTrans = List.from(
      b.agglomerationTransactions ?? [],
    );
    aggTrans.addAll(transactions);
    aggTrans = aggTrans.toSet().toList();
    aggTrans.sort(
      (a, b) => (a.dateUpdated ?? a.transactionDate!).compareTo(
        b.dateUpdated ?? b.transactionDate!,
      ),
    );
    b.agglomerationTransactions = aggTrans;
  });
}

SalesState onBatchLoadedBySalesSubType(
  SalesState state,
  TransactionBatchBySalesSubTypeLoadedAction action,
) {
  return state.rebuild((b) {
    List<CheckoutTransaction> transactions = [
      ...b.sequentialTransactions ?? [],
      ...action.value,
    ];
    b.agglomerationTransactions!.addAll(transactions);
    b.agglomerationTransactions = b.agglomerationTransactions!.toSet().toList();
    b.agglomerationTransactions!.sort(
      (a, b) => (a.dateUpdated ?? a.transactionDate!).compareTo(
        b.dateUpdated ?? b.transactionDate!,
      ),
    );
  });
}

SalesState clearFiltersData(SalesState state, ClearFiltersAction action) {
  return state.rebuild((b) {
    b.transactionsFiltered = [];
  });
}

SalesState onBatchLoadedBySalesSubTypeFiltered(
  SalesState state,
  FilteredTransactionBatchBySalesSubTypeLoadedAction action,
) {
  return state.rebuild((b) {
    List<CheckoutTransaction> transactionsToAdd = [];
    b.transactionsFiltered = [];

    if (b.transactionsFiltered != null) {
      for (var transaction in action.value) {
        if (!b.transactionsFiltered!.contains(transaction)) {
          transactionsToAdd.add(transaction);
        }
      }
      b.transactionsFiltered!.addAll(transactionsToAdd);
      b.transactionsFiltered!.sort(
        (a, b) => (b.dateUpdated ?? b.transactionDate!).compareTo(
          a.dateUpdated ?? a.transactionDate!,
        ),
      );
    } else {
      b.transactionsFiltered = List.from(action.value);
    }
    return b.transactionsFiltered;
  });
}

SalesState onBatchLoadedFiltered(
  SalesState state,
  FilteredTransactionBatchLoadedAction action,
) {
  return state.rebuild((b) {
    b.transactionsFiltered = [];
    if (action.value.isEmpty) {
      return b.transactionsFiltered;
    }
    return b.transactionsFiltered
      ?..addAll(action.value)
      ..sort((a, b) => b.transactionNumber!.compareTo(a.transactionNumber!));
  });
}

SalesState onClearState(SalesState state, dynamic action) => state.rebuild((b) {
  b.sequentialTransactions = [];
  b.agglomerationTransactions = [];
  b.transactionsFiltered = [];
  b.currentRefund = null;
  b.originalTransactionUnmodified = null;
  b.modifiedTransactionCopy = null;
  b.customer = null;
});

SalesState onSaleCancelled(SalesState state, CheckoutCancelledSale action) =>
    state.rebuild((b) {
      action.value.deleted = true;
      action.value.status = 'cancelled';

      if (state.sequentialTransactions.any((i) => i.id == action.value.id)) {
        var index = state.sequentialTransactions.indexWhere(
          (i) => i.id == action.value.id,
        );

        state.sequentialTransactions[index] = action.value;
      }
    });

SalesState onSaleRefunded(SalesState state, RefundSaleAction action) =>
    state.rebuild((b) {
      final index = b.sequentialTransactions!.indexWhere(
        (element) => element.id == action.value.id,
      );
      b.currentRefund?.transactionNumber = action.refund.transactionNumber;

      b.sequentialTransactions![index] = action.value;
      b.agglomerationTransactions = b.agglomerationTransactions!
          .where((element) => element.hashCode == action.value.hashCode)
          .map((e) => action.value)
          .toList();
    });

SalesState onItemRefunded(SalesState state, SaleRefundedAction action) =>
    state.rebuild((b) {
      if (state.sequentialTransactions.any((i) => i.id == action.value.id)) {
        var index = state.sequentialTransactions.indexWhere(
          (i) => i.id == action.value.id,
        );

        state.sequentialTransactions[index] = action.value;
      }
    });

SalesState onRemoveRefundItemFromCartAction(
  SalesState state,
  RemoveRefundItemFromCartAction action,
) => state.rebuild((b) {
  b.currentRefund?.totalItems =
      (b.currentRefund?.totalItems ?? 0) - (action.value?.quantity ?? 0);
  b.currentRefund?.totalRefundCost =
      (b.currentRefund?.totalRefundCost ?? 0) -
      (action.value?.itemCost ?? 0) * (action.value?.quantity ?? 0);
  b.currentRefund?.totalRefund =
      (b.currentRefund?.totalRefund ?? 0) -
      (action.value?.itemValue ?? 0) * (action.value?.quantity ?? 0);
  b.currentRefund?.items?.removeWhere(
    (RefundItem item) => item == action.value,
  );
});

SalesState onClearRefundState(SalesState state, dynamic action) =>
    state.rebuild((b) {
      b.currentRefund = null;
      b.originalTransactionUnmodified = null;
      b.modifiedTransactionCopy = null;
      b.customer = null;
    });

SalesState onSetCurrentRefundAction(
  SalesState state,
  SetCurrentRefundAction action,
) => state.rebuild((b) => b.currentRefund = action.value);

SalesState onSetCustomer(SalesState state, SalesSetCustomerAction action) =>
    state.rebuild((b) => b.customer = action.value);
SalesState onSetTerminalFilter(
  SalesState state,
  SalesSetTerminalFilterAction action,
) => state.rebuild(
  (b) => b.enableTerminalReportFiltering = action.value ?? false,
);

SalesState onRemoveCustomer(
  SalesState state,
  SalesRemoveCustomerAction action,
) => state.rebuild((b) {
  // remove customer from state
  b.customer = null;
  // remove customer from current refund
  b.currentRefund?.customerEmail = null;
  b.currentRefund?.customerId = null;
  b.currentRefund?.customerMobile = null;
  b.currentRefund?.customerName = null;
});

SalesState onSetModifiedTransactionCopy(
  SalesState state,
  SetModifiedTransactionCopyAction action,
) => state.rebuild((b) => b.modifiedTransactionCopy = action.value);

SalesState onSetOriginalTransactionUnmodified(
  SalesState state,
  SetOriginalTransactionUnmodifiedAction action,
) => state.rebuild((b) => b.originalTransactionUnmodified = action.value);

SalesState onClearCustomer(SalesState state, SalesClearCustomerAction action) =>
    state.rebuild((b) => b.customer = null);
