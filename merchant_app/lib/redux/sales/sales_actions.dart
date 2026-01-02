// Dart imports:
import 'dart:async';

// Project imports:
import 'package:littlefish_core_utils/error/models/error_codes/transaction_error_codes.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund_item.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/providers/locale_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/sales/sales_selectors.dart';
import 'package:littlefish_merchant/redux/sales/sales_state.dart';
import 'package:littlefish_merchant/services/customer_service.dart';
import 'package:littlefish_merchant/services/sales_service.dart';
import 'package:littlefish_merchant/ui/online_store/tools.dart';
// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

late SalesService service;

ThunkAction<AppState> getInitialTransactions({
  List list = const [],
  Completer? completer,
  bool forceRefresh = false,
}) {
  return (Store<AppState> store) async {
    store.dispatch(SetSalesLoadingStateAction(true));
    Future(() async {
      service = SalesService.fromStore(store);
      try {
        // gets initial transactions to populate
        List<CheckoutTransaction> transactions = [];

        if (store.state.salesState.sequentialTransactions.isEmpty ||
            forceRefresh) {
          store.dispatch(ClearSalesStateAction());

          bool enableTerminalReportFiltering =
              store.state.enableTerminalReportFiltering;
          bool deviceEnabledTerminalReportFiltering =
              await getKeyFromPrefsBool('enableReportFilteringByTerminalId') ??
              false;

          if (enableTerminalReportFiltering &&
              deviceEnabledTerminalReportFiltering) {
            String terminalId = AppVariables.deviceInfo?.terminalId ?? '';

            transactions = await service.getPagedTransactionsByTerminalId(
              terminalId: terminalId,
            );
          } else {
            transactions = await service.getPagedTransactions();
          }
        } else {
          transactions = store.state.salesState.sequentialTransactions;
        }

        //Populates transactions
        store.dispatch(
          TransactionBatchLoadedAction(transactions, fromServer: false),
        );

        store.dispatch(SetSalesLoadingStateAction(false));
        completer?.complete();
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        store.dispatch(SetSalesStateErrorAction(e.toString()));
        globalNavigatorKey.currentContext != null
            ? showErrorDialog(
                globalNavigatorKey.currentContext!,
                TransactionErrorCodes.failedToFetchTransactions,
              )
            : null;
        completer?.completeError(e, StackTrace.current);
      } finally {
        store.dispatch(SetSalesLoadingStateAction(false));
      }
    });
  };
}

ThunkAction<AppState> getNextBatchBySalesSubType(
  SalesSubType type, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(SetSalesLoadingStateAction(true));
      service = SalesService.fromStore(store);
      var state = store.state.salesState;
      try {
        bool enableTerminalReportFiltering =
            store.state.enableTerminalReportFiltering;
        bool deviceEnabledTerminalReportFiltering =
            await getKeyFromPrefsBool('enableReportFilteringByTerminalId') ??
            false;

        bool filterByTerminalId =
            enableTerminalReportFiltering &&
            deviceEnabledTerminalReportFiltering &&
            AppVariables.isPOSBuild;

        var response = filterByTerminalId
            ? await service.getPagedTransactionsBySalesSubTypeAndTerminalId(
                offset: SalesSelector(
                  type: type,
                  transactions: state.agglomerationTransactions,
                ).getTransactionListBySubType().length,
                type: type,
                terminalId: AppVariables.deviceInfo?.terminalId ?? '',
              )
            : await service.getPagedTransactionsBySalesSubType(
                offset: SalesSelector(
                  type: type,
                  transactions: state.agglomerationTransactions,
                ).getTransactionListBySubType().length,
                type: type,
              );
        store.dispatch(
          TransactionBatchLoadedAction(response, fromServer: false),
        );
        store.dispatch(SetSalesLoadingStateAction(false));
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        store.dispatch(SetSalesStateErrorAction(e.toString()));
        globalNavigatorKey.currentContext != null
            ? showErrorDialog(
                globalNavigatorKey.currentContext!,
                TransactionErrorCodes.failedToFetchTransactionsBySubType,
              )
            : null;
        store.dispatch(SetSalesLoadingStateAction(false));
        completer?.completeError(e, StackTrace.current);
      }
    });
  };
}

ThunkAction<AppState> getFilteredBatch(
  String textFilter, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      service = SalesService.fromStore(store);
      store.dispatch(
        FilteredTransactionBatchLoadedAction([], fromServer: true),
      );
      try {
        List<CheckoutTransaction> response = [];

        store.dispatch(SetSalesLoadingStateAction(true));

        bool enableTerminalReportFiltering =
            store.state.enableTerminalReportFiltering;
        bool deviceEnabledTerminalReportFiltering =
            await getKeyFromPrefsBool('enableReportFilteringByTerminalId') ??
            false;

        bool filterByTerminalId =
            enableTerminalReportFiltering &&
            deviceEnabledTerminalReportFiltering &&
            AppVariables.isPOSBuild;

        response = filterByTerminalId
            ? await service.getPagedFilteredTransactionsByTerminalId(
                offset: 0,
                textFilter: textFilter,
                terminalId: AppVariables.deviceInfo?.terminalId ?? '',
              )
            : await service.getPagedFilteredTransactions(
                offset: 0,
                textFilter: textFilter,
              );
        store.dispatch(
          FilteredTransactionBatchLoadedAction(response, fromServer: true),
        );
        store.dispatch(SetSalesLoadingStateAction(false));
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        store.dispatch(
          FilteredTransactionBatchLoadedAction([], fromServer: true),
        );
        globalNavigatorKey.currentContext != null
            ? showErrorDialog(
                globalNavigatorKey.currentContext!,
                TransactionErrorCodes.failedToFetchFilteredTransactions,
              )
            : null;
        store.dispatch(SetSalesStateErrorAction(e.toString()));
        store.dispatch(SetSalesLoadingStateAction(false));
        completer?.completeError(e, StackTrace.current);
      }
    });
  };
}

ThunkAction<AppState> getFilteredBatchBySalesSubType(
  SalesSubType type,
  String textFilter, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      service = SalesService.fromStore(store);
      store.dispatch(SetSalesLoadingStateAction(true));
      try {
        bool enableTerminalReportFiltering =
            store.state.enableTerminalReportFiltering;
        bool deviceEnabledTerminalReportFiltering =
            await getKeyFromPrefsBool('enableReportFilteringByTerminalId') ??
            false;

        bool filterByTerminalId =
            enableTerminalReportFiltering &&
            deviceEnabledTerminalReportFiltering &&
            AppVariables.isPOSBuild;
        var result = filterByTerminalId
            ? await service
                  .getPagedFilteredTransactionsBySalesSubTypeAndTerminalId(
                    offset: 0,
                    type: type,
                    textFilter: textFilter,
                    terminalId: AppVariables.deviceInfo?.terminalId ?? '',
                  )
            : await service.getPagedFilteredTransactionsBySalesSubType(
                offset: 0,
                type: type,
                textFilter: textFilter,
              );
        store.dispatch(
          FilteredTransactionBatchBySalesSubTypeLoadedAction(
            result,
            fromServer: true,
          ),
        );
        store.dispatch(SetSalesLoadingStateAction(false));
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        globalNavigatorKey.currentContext != null
            ? showErrorDialog(
                globalNavigatorKey.currentContext!,
                TransactionErrorCodes
                    .failedToFetchFilteredTransactionsBySubType,
              )
            : null;
        store.dispatch(SetSalesStateErrorAction(e.toString()));
        store.dispatch(SetSalesLoadingStateAction(false));
        completer?.completeError(e, StackTrace.current);
      }
    });
  };
}

class SaleUploadedAction {
  CheckoutTransaction value;

  SaleUploadedAction(this.value);
}

class TransactionBatchLoadedAction {
  List<CheckoutTransaction> value;

  bool fromServer;

  TransactionBatchLoadedAction(this.value, {this.fromServer = false});
}

class TransactionFilterLoadedAction {
  List<CheckoutTransaction> value;

  bool fromServer;

  TransactionFilterLoadedAction(this.value, {this.fromServer = false});
}

class TransactionBatchBySalesSubTypeLoadedAction {
  List<CheckoutTransaction> value;

  bool fromServer;

  TransactionBatchBySalesSubTypeLoadedAction(
    this.value, {
    this.fromServer = false,
  });
}

class FilteredTransactionBatchLoadedAction {
  List<CheckoutTransaction> value;

  bool fromServer;

  FilteredTransactionBatchLoadedAction(this.value, {this.fromServer = false});
}

class FilteredTransactionBatchBySalesSubTypeLoadedAction {
  List<CheckoutTransaction> value;

  bool fromServer;

  FilteredTransactionBatchBySalesSubTypeLoadedAction(
    this.value, {
    this.fromServer = false,
  });
}

class SetSalesLoadingStateAction {
  bool value;

  SetSalesLoadingStateAction(this.value);
}

class SetSalesStateErrorAction {
  String value;

  SetSalesStateErrorAction(this.value);
}

class ClearSalesStateAction {}

class ClearFiltersAction {}

///Refund Journey Actions

ThunkAction<AppState> initialiseCurrentRefund({
  required CheckoutTransaction transaction,
}) {
  return (Store<AppState> store) {
    store.dispatch(ClearRefundStateAction());
    Refund refund = Refund(
      items: [],
      totalRefund: 0,
      totalRefundCost: 0,
      checkoutTransactionId: transaction.id!,
      countryCode: LocaleProvider.instance.countryCode,
      currencyCode: LocaleProvider.instance.currencyCode,
      customerEmail: transaction.customerEmail,
      customerId: transaction.customerId,
      customerMobile: transaction.customerMobile,
      customerName: transaction.customerName,
      isOnline: null,
      deviceId: null,
      paymentType: null,
      totalItems: 0,
      transactionDate: null,
      transactionNumber: null,
      sellerId: store.state.userProfile!.userId,
      sellerName: store.state.userProfile!.firstName,
    );

    store.dispatch(SetCurrentRefundAction(refund));
  };
}

ThunkAction<AppState> addNewItemToBeRefunded({
  required RefundItem item,
  Completer? completer,
}) {
  return (Store<AppState> store) {
    SalesState state = store.state.salesState;

    if (state.currentRefund == null) {
      store.dispatch(
        SetSalesStateErrorAction(
          'Failed adding item to be refunded. Please try again.',
        ),
      );
      return;
    }

    Refund currentRefund = Refund.copy(state.currentRefund!);
    currentRefund.items?.add(item);
    currentRefund.totalItems = _getRefundTotalItems(currentRefund);
    currentRefund.totalRefundCost = _getRefundCost(currentRefund);
    currentRefund.totalRefund = _getRefundValue(currentRefund);
    store.dispatch(SetCurrentRefundAction(currentRefund));
  };
}

ThunkAction<AppState> discardCurrentRefund({Completer? completer}) {
  return (Store<AppState> store) {
    SalesState state = store.state.salesState;
    if (state.currentRefund == null) return;

    Refund currentRefund = Refund.copy(state.currentRefund!);
    currentRefund.items = [];
    currentRefund.totalItems = 0;
    currentRefund.totalRefund = 0;
    currentRefund.totalRefundCost = 0.0;
    store.dispatch(SetCurrentRefundAction(currentRefund));
  };
}

ThunkAction<AppState> updateItemToBeRefunded({
  Completer? completer,
  required RefundItem item,
}) {
  return (Store<AppState> store) {
    SalesState state = store.state.salesState;
    if (state.currentRefund == null || state.currentRefund?.items == null) {
      store.dispatch(
        SetSalesStateErrorAction(
          'Failed updating refund item. Please try again.',
        ),
      );
      return;
    }

    Refund currentRefund = Refund.copy(state.currentRefund!);
    int refundItemIndex = currentRefund.items!.indexWhere(
      (refundItem) => refundItem.checkoutCartItemId == item.checkoutCartItemId,
    );
    bool refundItemFound = refundItemIndex > -1;

    if (refundItemFound == false) {
      // refund item not found, add item
      store.dispatch(addNewItemToBeRefunded(item: item));
      return;
    }

    currentRefund.items?[refundItemIndex] = item;
    currentRefund.totalItems = _getRefundTotalItems(currentRefund);
    currentRefund.totalRefund = _getRefundValue(currentRefund);
    currentRefund.totalRefundCost = _getRefundCost(currentRefund);
    store.dispatch(SetCurrentRefundAction(currentRefund));
  };
}

double _getRefundCost(Refund? refund) {
  if (refund == null || refund.items == null || refund.items!.isEmpty) {
    return 0;
  }
  double refundCost = 0;
  refund.items?.forEach((RefundItem item) {
    refundCost += _getTotalCostForRefundItem(item);
  });

  return refundCost;
}

double _getRefundValue(Refund refund) {
  if (refund.items == null || refund.items!.isEmpty) {
    return 0;
  }
  double refundValue = 0;
  refund.items?.forEach((RefundItem item) {
    refundValue += _getTotalValueForRefundItem(item);
  });

  return refundValue;
}

// int? _getRefundItemIndex(String checkoutCartItemID, Refund refund) {
//   if (checkoutCartItemID.isEmpty) return null;

//   return refund.items?.indexWhere((RefundItem refundItem) =>
//       refundItem.checkoutCartItemId == checkoutCartItemID);
// }

double _getRefundTotalItems(Refund refund) {
  if (refund.items == null || refund.items!.isEmpty) {
    return 0;
  }
  double totalItems = 0;
  for (var item in refund.items!) {
    totalItems += item.quantity ?? 0;
  }

  return totalItems;
}

double _getTotalValueForRefundItem(RefundItem refundItem) {
  if (refundItem.quantity == null || refundItem.itemValue == null) return 0;

  return refundItem.quantity! * refundItem.itemValue!;
}

double _getTotalCostForRefundItem(RefundItem refundItem) {
  if (refundItem.quantity == null || refundItem.itemCost == null) return 0;

  return refundItem.quantity! * refundItem.itemCost!;
}

ThunkAction<AppState> setRefundCustomerInfo({
  required String customerId,
  required String customerName,
  required String customerEmail,
  required String customerMobile,
}) {
  return (Store<AppState> store) {
    SalesState state = store.state.salesState;
    if (state.currentRefund == null) return;

    Refund refund = Refund.copy(state.currentRefund!);
    refund.customerId = customerId;
    refund.customerName = customerName;
    refund.customerEmail = customerEmail;
    refund.customerMobile = customerMobile;
    store.dispatch(SetCurrentRefundAction(refund));
  };
}

ThunkAction<AppState> getAndSetCustomerByID({required String customerId}) {
  return (Store<AppState> store) async {
    Future(() async {
      // SalesState state = store.state.salesState;

      // try find customer in state
      Customer? customer = store.state.customerstate.getCustomerById(
        id: customerId,
      );

      if (customer != null) {
        // customer in state
        store.dispatch(SalesSetCustomerAction(customer));
      } else {
        // customer not in state
        // try get customer from API
        var custService = CustomerService(
          store: store,
          baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
          token: store.state.authState.token,
          businessId: store.state.currentBusinessId,
        );

        customer = await custService.getDeletedCustomerById(
          customerId: customerId,
        );

        if (customer != null) {
          store.dispatch(SalesSetCustomerAction(customer));
        }
      }
    });
  };
}

class SetCurrentRefundAction {
  Refund? value;

  SetCurrentRefundAction(this.value);
}

class ClearRefundStateAction {}

class RemoveRefundItemFromCartAction {
  RefundItem? value;

  RemoveRefundItemFromCartAction(this.value);
}

class SaleRefundedAction {
  CheckoutTransaction value;

  SaleRefundedAction(this.value);
}

class SalesRemoveCustomerAction {
  SalesRemoveCustomerAction();
}

class SalesSetCustomerAction {
  Customer? value;

  SalesSetCustomerAction(this.value);
}

class SalesSetTerminalFilterAction {
  bool? value;

  SalesSetTerminalFilterAction(this.value);
}

class SetModifiedTransactionCopyAction {
  CheckoutTransaction? value;

  SetModifiedTransactionCopyAction(this.value);
}

class SetOriginalTransactionUnmodifiedAction {
  CheckoutTransaction? value;

  SetOriginalTransactionUnmodifiedAction(this.value);
}

class SalesClearCustomerAction {
  SalesClearCustomerAction();
}
