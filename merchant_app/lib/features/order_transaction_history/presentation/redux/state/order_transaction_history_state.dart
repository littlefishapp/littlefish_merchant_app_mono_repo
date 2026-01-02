// package imports
import 'package:built_value/built_value.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_core/business/models/business_user.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:quiver/strings.dart';

// project imports
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_filter.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_transaction.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/data/models/filter_item.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/data/models/sort_item.dart';
import 'package:littlefish_merchant/shared/exceptions/general_error.dart';

part 'order_transaction_history_state.g.dart';

@immutable
@JsonSerializable()
abstract class OrderTransactionHistoryState
    implements
        Built<
          OrderTransactionHistoryState,
          OrderTransactionHistoryStateBuilder
        > {
  factory OrderTransactionHistoryState() => _$OrderTransactionHistoryState._(
    hasError: false,
    isLoading: false,
    hasFetchedAllOrders: false,
    hasFetchedAllTransactions: false,
    orders: const [],
    filteredOrders: const [],
    allOrders: const [],
    transactions: const [],
    filteredTransactions: const [],
    searchTransactions: const [],
    transactionFilterTypes: const [],
    transactionSortType: null,
    hasFetchedAllFilterTransactions: false,
    hasFetchedAllSearchTransactions: false,
    orderDetailsPageTabIndex: 0,
    allOrdersCount: 0,
    allFulfillmentOrdersCount: const {},
  );

  const OrderTransactionHistoryState._();

  List<Order> get orders;

  List<Order> get filteredOrders;

  List<Order> get allOrders;

  String? get ordersSearchText;

  List<Order> get displayedOrders {
    return isNotBlank(ordersSearchText) ||
            (orderFilter != null && orderFilter!.hasData())
        ? filteredOrders
        : orders;
  }

  List<OrderTransaction> get transactions;

  List<OrderTransaction> get searchTransactions;

  List<OrderTransaction> get filteredTransactions;

  List<OrderTransaction> get displayTransactions {
    if (isNotBlank(transactionSearchText)) return searchTransactions;
    return (transactionFilterTypes ?? []).isNotEmpty
        ? filteredTransactions
        : transactions;
  }

  OrderTransaction? get currentTransaction;

  Order? get currentOrder;

  OrderFilter? get orderFilter;

  String? get orderFilterType;

  String? get orderSortType;

  BusinessUser? get transactionConsultant;

  BusinessUser? get orderConsultant;

  List<TransactionHistoryFilterItem>? get transactionFilterTypes;

  TransactionHistorySortItem? get transactionSortType;

  String? get transactionSearchText;

  int? get tabIndex;

  bool get hasError;

  bool get isLoading;

  bool get hasFetchedAllOrders;

  bool get hasFetchedAllTransactions;

  bool get hasFetchedAllFilterTransactions;

  bool get hasFetchedAllSearchTransactions;

  GeneralError? get error;

  int get orderDetailsPageTabIndex;

  int get allOrdersCount;

  Map<String, dynamic> get allFulfillmentOrdersCount;

  CheckoutTransaction? get checkoutTransaction;
}
