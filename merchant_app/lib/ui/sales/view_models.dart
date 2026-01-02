// removed ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/features/pos/data/data_source/pos_service.dart';
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund_item.dart';
import 'package:littlefish_merchant/redux/sales/sales_actions.dart';
import 'package:littlefish_merchant/ui/online_store/tools.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_actions.dart';
import 'package:littlefish_merchant/redux/sales/sales_state.dart';
import 'package:littlefish_merchant/tools/date/date_tools.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund.dart';
import 'package:littlefish_merchant/models/settings/payments/payment_type.dart';
import 'package:littlefish_merchant/redux/sales/sales_actions.dart'
    as sales_service;

class SalesVM
    extends StoreCollectionViewModel<CheckoutTransaction?, SalesState> {
  SalesVM.fromStore(Store<AppState> store) : super.fromStore(store);

  ReportMode? mode;

  DateTime get startDate {
    if (mode == ReportMode.day) return DateTime.now().toUtc();

    if (mode == ReportMode.week) return getFirstDayOfWeek();

    if (mode == ReportMode.month) return getFirstDayOfMonth();

    if (mode == ReportMode.threeMonths) return getFirstDayThreeMonths();

    if (mode == ReportMode.year) return getFirstDayOfYear();

    return DateTime.now().toUtc();
  }

  DateTime get endDate {
    if (mode == ReportMode.day) return DateTime.now().toUtc();

    if (mode == ReportMode.week) return getLastDayOfWeek();

    if (mode == ReportMode.month) return getLastDayOfMonth();

    if (mode == ReportMode.threeMonths) return getLastDayThreeMonths();

    if (mode == ReportMode.year) return getLastDayOfYear();

    return DateTime.now().toUtc();
  }

  String get dateSelectionString {
    if (mode == ReportMode.day) {
      return "Today, ${TextFormatter.toShortDate(dateTime: startDate, format: "MMM dd, yyyy")}";
    }

    if (mode == ReportMode.week) {
      return "This Week, ${TextFormatter.toShortDate(dateTime: startDate, format: "MMM dd, yyyy")} -  ${TextFormatter.toShortDate(dateTime: endDate, format: "MMM dd, yyyy")}";
    }

    if (mode == ReportMode.month) {
      return "This Month, ${TextFormatter.toShortDate(dateTime: startDate, format: "MMM dd, yyyy")} -  ${TextFormatter.toShortDate(dateTime: endDate, format: "MMM dd, yyyy")}";
    }

    if (mode == ReportMode.threeMonths) {
      return "Current 3 Months, ${TextFormatter.toShortDate(dateTime: startDate, format: "MMM dd, yyyy")} -  ${TextFormatter.toShortDate(dateTime: endDate, format: "MMM dd, yyyy")}";
    }

    if (mode == ReportMode.year) {
      return "This Year, ${TextFormatter.toShortDate(dateTime: startDate, format: "MMM dd, yyyy")} -  ${TextFormatter.toShortDate(dateTime: endDate, format: "MMM dd, yyyy")}";
    }

    return 'in progress';
  }

  double? getCurrentRefundItemQuantity(String? checkoutCartItemID) {
    RefundItem? refundItem = getCurrentRefundItem(checkoutCartItemID);
    if (refundItem != null) return refundItem.quantity;
    return null;
  }

  RefundItem? getCurrentRefundItem(String? checkoutCartItemID) {
    if (checkoutCartItemID == null || checkoutCartItemID.isEmpty) return null;
    if (currentRefund == null || currentRefund?.items == null) return null;

    int? indexOfCartItem = getRefundItemIndex(checkoutCartItemID);
    bool cartItemFound = indexOfCartItem != null && indexOfCartItem != -1;
    if (cartItemFound) {
      return currentRefund!.items?[indexOfCartItem];
    }

    return null;
  }

  int? getRefundItemIndex(String? checkoutCartItemID) {
    if (checkoutCartItemID == null || checkoutCartItemID.isEmpty) return null;

    return currentRefund?.items?.indexWhere(
      (RefundItem refundItem) =>
          refundItem.checkoutCartItemId == checkoutCartItemID,
    );
  }

  late Function(BuildContext ctx, SalesSubType type) onLoadMoreBySalesSubType;

  late Function(List<CheckoutTransaction>) onFilterTransactions;

  late Function(List<CheckoutTransaction>) onUpdateFilter;

  late Function(BuildContext ctx) onSyncSales;

  late Function(Customer customer) setCustomer;

  late List<CheckoutTransaction> itemsFiltered;

  late List<CheckoutTransaction> itemsAgglomerate;

  CheckoutTransaction? originalTransactionUnmodified;

  CheckoutTransaction? modifiedTransactionCopy;

  Refund? currentRefund;

  Customer? customer;

  late bool enableTerminalReportFiltering;

  late Function(bool value) setEnableTerminalReportFiltering;

  late List<PaymentType> refundPaymentTypes;

  late List<PaymentType> voidPaymentTypes;

  late Function() clearCustomer;

  late PosService paymentService;

  bool canDoCardPayment() {
    return paymentService.canDoCardPayment();
  }

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.salesState;
    items = state!.sequentialTransactions;
    itemsAgglomerate = state!.agglomerationTransactions;
    itemsFiltered = state!.transactionsFiltered;
    originalTransactionUnmodified = state!.originalTransactionUnmodified;
    modifiedTransactionCopy = state!.modifiedTransactionCopy;
    currentRefund = state!.currentRefund;
    enableTerminalReportFiltering = state!.enableTerminalReportFiltering;

    customer = state!.customer;

    refundPaymentTypes = store.state.appSettingsState.refundPaymentTypes;

    voidPaymentTypes = store.state.appSettingsState.voidPaymentTypes;

    paymentService = PosService.fromStore(store: store);

    setCustomer = (customer) {
      store.dispatch(SalesSetCustomerAction(customer));
      store.dispatch(
        setRefundCustomerInfo(
          customerId: customer.id!,
          customerEmail: customer.email ?? '',
          customerMobile: customer.mobileNumber ?? '',
          customerName: customer.displayName ?? '',
        ),
      );
      this.customer = customer;
    };

    setEnableTerminalReportFiltering = (value) async {
      await saveKeyToPrefsBool('enableReportFilteringByTerminalId', value);
      store.dispatch(getInitialTransactions(forceRefresh: true));
      store.dispatch(sales_service.SalesSetTerminalFilterAction(value));
    };

    isLoading = state!.isLoading;
    hasError = state!.hasError;
    errorMessage = state!.errorMessage;

    onLoadMoreBySalesSubType = (ctx, type) =>
        store.dispatch(sales_service.getNextBatchBySalesSubType(type));
    onFilterTransactions = (result) =>
        store.dispatch(sales_service.TransactionFilterLoadedAction(result));

    onUpdateFilter = (filterResult) {
      store.dispatch(
        sales_service.FilteredTransactionBatchBySalesSubTypeLoadedAction(
          filterResult,
        ),
      );
    };

    onSyncSales = (ctx) {
      store.dispatch(
        syncSales(
          completer: snackBarCompleter(ctx, 'Sync completed successfully'),
        ),
      );
    };

    clearCustomer = () {
      store.dispatch(SalesClearCustomerAction());
      customer = null;
    };
  }
}
