// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_transaction_history_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OrderTransactionHistoryState extends OrderTransactionHistoryState {
  @override
  final List<Order> orders;
  @override
  final List<Order> filteredOrders;
  @override
  final List<Order> allOrders;
  @override
  final String? ordersSearchText;
  @override
  final List<OrderTransaction> transactions;
  @override
  final List<OrderTransaction> searchTransactions;
  @override
  final List<OrderTransaction> filteredTransactions;
  @override
  final OrderTransaction? currentTransaction;
  @override
  final Order? currentOrder;
  @override
  final OrderFilter? orderFilter;
  @override
  final String? orderFilterType;
  @override
  final String? orderSortType;
  @override
  final BusinessUser? transactionConsultant;
  @override
  final BusinessUser? orderConsultant;
  @override
  final List<TransactionHistoryFilterItem>? transactionFilterTypes;
  @override
  final TransactionHistorySortItem? transactionSortType;
  @override
  final String? transactionSearchText;
  @override
  final int? tabIndex;
  @override
  final bool hasError;
  @override
  final bool isLoading;
  @override
  final bool hasFetchedAllOrders;
  @override
  final bool hasFetchedAllTransactions;
  @override
  final bool hasFetchedAllFilterTransactions;
  @override
  final bool hasFetchedAllSearchTransactions;
  @override
  final GeneralError? error;
  @override
  final int orderDetailsPageTabIndex;
  @override
  final int allOrdersCount;
  @override
  final Map<String, dynamic> allFulfillmentOrdersCount;
  @override
  final CheckoutTransaction? checkoutTransaction;

  factory _$OrderTransactionHistoryState([
    void Function(OrderTransactionHistoryStateBuilder)? updates,
  ]) => (OrderTransactionHistoryStateBuilder()..update(updates))._build();

  _$OrderTransactionHistoryState._({
    required this.orders,
    required this.filteredOrders,
    required this.allOrders,
    this.ordersSearchText,
    required this.transactions,
    required this.searchTransactions,
    required this.filteredTransactions,
    this.currentTransaction,
    this.currentOrder,
    this.orderFilter,
    this.orderFilterType,
    this.orderSortType,
    this.transactionConsultant,
    this.orderConsultant,
    this.transactionFilterTypes,
    this.transactionSortType,
    this.transactionSearchText,
    this.tabIndex,
    required this.hasError,
    required this.isLoading,
    required this.hasFetchedAllOrders,
    required this.hasFetchedAllTransactions,
    required this.hasFetchedAllFilterTransactions,
    required this.hasFetchedAllSearchTransactions,
    this.error,
    required this.orderDetailsPageTabIndex,
    required this.allOrdersCount,
    required this.allFulfillmentOrdersCount,
    this.checkoutTransaction,
  }) : super._();
  @override
  OrderTransactionHistoryState rebuild(
    void Function(OrderTransactionHistoryStateBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  OrderTransactionHistoryStateBuilder toBuilder() =>
      OrderTransactionHistoryStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderTransactionHistoryState &&
        orders == other.orders &&
        filteredOrders == other.filteredOrders &&
        allOrders == other.allOrders &&
        ordersSearchText == other.ordersSearchText &&
        transactions == other.transactions &&
        searchTransactions == other.searchTransactions &&
        filteredTransactions == other.filteredTransactions &&
        currentTransaction == other.currentTransaction &&
        currentOrder == other.currentOrder &&
        orderFilter == other.orderFilter &&
        orderFilterType == other.orderFilterType &&
        orderSortType == other.orderSortType &&
        transactionConsultant == other.transactionConsultant &&
        orderConsultant == other.orderConsultant &&
        transactionFilterTypes == other.transactionFilterTypes &&
        transactionSortType == other.transactionSortType &&
        transactionSearchText == other.transactionSearchText &&
        tabIndex == other.tabIndex &&
        hasError == other.hasError &&
        isLoading == other.isLoading &&
        hasFetchedAllOrders == other.hasFetchedAllOrders &&
        hasFetchedAllTransactions == other.hasFetchedAllTransactions &&
        hasFetchedAllFilterTransactions ==
            other.hasFetchedAllFilterTransactions &&
        hasFetchedAllSearchTransactions ==
            other.hasFetchedAllSearchTransactions &&
        error == other.error &&
        orderDetailsPageTabIndex == other.orderDetailsPageTabIndex &&
        allOrdersCount == other.allOrdersCount &&
        allFulfillmentOrdersCount == other.allFulfillmentOrdersCount &&
        checkoutTransaction == other.checkoutTransaction;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, filteredOrders.hashCode);
    _$hash = $jc(_$hash, allOrders.hashCode);
    _$hash = $jc(_$hash, ordersSearchText.hashCode);
    _$hash = $jc(_$hash, transactions.hashCode);
    _$hash = $jc(_$hash, searchTransactions.hashCode);
    _$hash = $jc(_$hash, filteredTransactions.hashCode);
    _$hash = $jc(_$hash, currentTransaction.hashCode);
    _$hash = $jc(_$hash, currentOrder.hashCode);
    _$hash = $jc(_$hash, orderFilter.hashCode);
    _$hash = $jc(_$hash, orderFilterType.hashCode);
    _$hash = $jc(_$hash, orderSortType.hashCode);
    _$hash = $jc(_$hash, transactionConsultant.hashCode);
    _$hash = $jc(_$hash, orderConsultant.hashCode);
    _$hash = $jc(_$hash, transactionFilterTypes.hashCode);
    _$hash = $jc(_$hash, transactionSortType.hashCode);
    _$hash = $jc(_$hash, transactionSearchText.hashCode);
    _$hash = $jc(_$hash, tabIndex.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasFetchedAllOrders.hashCode);
    _$hash = $jc(_$hash, hasFetchedAllTransactions.hashCode);
    _$hash = $jc(_$hash, hasFetchedAllFilterTransactions.hashCode);
    _$hash = $jc(_$hash, hasFetchedAllSearchTransactions.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jc(_$hash, orderDetailsPageTabIndex.hashCode);
    _$hash = $jc(_$hash, allOrdersCount.hashCode);
    _$hash = $jc(_$hash, allFulfillmentOrdersCount.hashCode);
    _$hash = $jc(_$hash, checkoutTransaction.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderTransactionHistoryState')
          ..add('orders', orders)
          ..add('filteredOrders', filteredOrders)
          ..add('allOrders', allOrders)
          ..add('ordersSearchText', ordersSearchText)
          ..add('transactions', transactions)
          ..add('searchTransactions', searchTransactions)
          ..add('filteredTransactions', filteredTransactions)
          ..add('currentTransaction', currentTransaction)
          ..add('currentOrder', currentOrder)
          ..add('orderFilter', orderFilter)
          ..add('orderFilterType', orderFilterType)
          ..add('orderSortType', orderSortType)
          ..add('transactionConsultant', transactionConsultant)
          ..add('orderConsultant', orderConsultant)
          ..add('transactionFilterTypes', transactionFilterTypes)
          ..add('transactionSortType', transactionSortType)
          ..add('transactionSearchText', transactionSearchText)
          ..add('tabIndex', tabIndex)
          ..add('hasError', hasError)
          ..add('isLoading', isLoading)
          ..add('hasFetchedAllOrders', hasFetchedAllOrders)
          ..add('hasFetchedAllTransactions', hasFetchedAllTransactions)
          ..add(
            'hasFetchedAllFilterTransactions',
            hasFetchedAllFilterTransactions,
          )
          ..add(
            'hasFetchedAllSearchTransactions',
            hasFetchedAllSearchTransactions,
          )
          ..add('error', error)
          ..add('orderDetailsPageTabIndex', orderDetailsPageTabIndex)
          ..add('allOrdersCount', allOrdersCount)
          ..add('allFulfillmentOrdersCount', allFulfillmentOrdersCount)
          ..add('checkoutTransaction', checkoutTransaction))
        .toString();
  }
}

class OrderTransactionHistoryStateBuilder
    implements
        Builder<
          OrderTransactionHistoryState,
          OrderTransactionHistoryStateBuilder
        > {
  _$OrderTransactionHistoryState? _$v;

  List<Order>? _orders;
  List<Order>? get orders => _$this._orders;
  set orders(List<Order>? orders) => _$this._orders = orders;

  List<Order>? _filteredOrders;
  List<Order>? get filteredOrders => _$this._filteredOrders;
  set filteredOrders(List<Order>? filteredOrders) =>
      _$this._filteredOrders = filteredOrders;

  List<Order>? _allOrders;
  List<Order>? get allOrders => _$this._allOrders;
  set allOrders(List<Order>? allOrders) => _$this._allOrders = allOrders;

  String? _ordersSearchText;
  String? get ordersSearchText => _$this._ordersSearchText;
  set ordersSearchText(String? ordersSearchText) =>
      _$this._ordersSearchText = ordersSearchText;

  List<OrderTransaction>? _transactions;
  List<OrderTransaction>? get transactions => _$this._transactions;
  set transactions(List<OrderTransaction>? transactions) =>
      _$this._transactions = transactions;

  List<OrderTransaction>? _searchTransactions;
  List<OrderTransaction>? get searchTransactions => _$this._searchTransactions;
  set searchTransactions(List<OrderTransaction>? searchTransactions) =>
      _$this._searchTransactions = searchTransactions;

  List<OrderTransaction>? _filteredTransactions;
  List<OrderTransaction>? get filteredTransactions =>
      _$this._filteredTransactions;
  set filteredTransactions(List<OrderTransaction>? filteredTransactions) =>
      _$this._filteredTransactions = filteredTransactions;

  OrderTransaction? _currentTransaction;
  OrderTransaction? get currentTransaction => _$this._currentTransaction;
  set currentTransaction(OrderTransaction? currentTransaction) =>
      _$this._currentTransaction = currentTransaction;

  Order? _currentOrder;
  Order? get currentOrder => _$this._currentOrder;
  set currentOrder(Order? currentOrder) => _$this._currentOrder = currentOrder;

  OrderFilter? _orderFilter;
  OrderFilter? get orderFilter => _$this._orderFilter;
  set orderFilter(OrderFilter? orderFilter) =>
      _$this._orderFilter = orderFilter;

  String? _orderFilterType;
  String? get orderFilterType => _$this._orderFilterType;
  set orderFilterType(String? orderFilterType) =>
      _$this._orderFilterType = orderFilterType;

  String? _orderSortType;
  String? get orderSortType => _$this._orderSortType;
  set orderSortType(String? orderSortType) =>
      _$this._orderSortType = orderSortType;

  BusinessUser? _transactionConsultant;
  BusinessUser? get transactionConsultant => _$this._transactionConsultant;
  set transactionConsultant(BusinessUser? transactionConsultant) =>
      _$this._transactionConsultant = transactionConsultant;

  BusinessUser? _orderConsultant;
  BusinessUser? get orderConsultant => _$this._orderConsultant;
  set orderConsultant(BusinessUser? orderConsultant) =>
      _$this._orderConsultant = orderConsultant;

  List<TransactionHistoryFilterItem>? _transactionFilterTypes;
  List<TransactionHistoryFilterItem>? get transactionFilterTypes =>
      _$this._transactionFilterTypes;
  set transactionFilterTypes(
    List<TransactionHistoryFilterItem>? transactionFilterTypes,
  ) => _$this._transactionFilterTypes = transactionFilterTypes;

  TransactionHistorySortItem? _transactionSortType;
  TransactionHistorySortItem? get transactionSortType =>
      _$this._transactionSortType;
  set transactionSortType(TransactionHistorySortItem? transactionSortType) =>
      _$this._transactionSortType = transactionSortType;

  String? _transactionSearchText;
  String? get transactionSearchText => _$this._transactionSearchText;
  set transactionSearchText(String? transactionSearchText) =>
      _$this._transactionSearchText = transactionSearchText;

  int? _tabIndex;
  int? get tabIndex => _$this._tabIndex;
  set tabIndex(int? tabIndex) => _$this._tabIndex = tabIndex;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasFetchedAllOrders;
  bool? get hasFetchedAllOrders => _$this._hasFetchedAllOrders;
  set hasFetchedAllOrders(bool? hasFetchedAllOrders) =>
      _$this._hasFetchedAllOrders = hasFetchedAllOrders;

  bool? _hasFetchedAllTransactions;
  bool? get hasFetchedAllTransactions => _$this._hasFetchedAllTransactions;
  set hasFetchedAllTransactions(bool? hasFetchedAllTransactions) =>
      _$this._hasFetchedAllTransactions = hasFetchedAllTransactions;

  bool? _hasFetchedAllFilterTransactions;
  bool? get hasFetchedAllFilterTransactions =>
      _$this._hasFetchedAllFilterTransactions;
  set hasFetchedAllFilterTransactions(bool? hasFetchedAllFilterTransactions) =>
      _$this._hasFetchedAllFilterTransactions = hasFetchedAllFilterTransactions;

  bool? _hasFetchedAllSearchTransactions;
  bool? get hasFetchedAllSearchTransactions =>
      _$this._hasFetchedAllSearchTransactions;
  set hasFetchedAllSearchTransactions(bool? hasFetchedAllSearchTransactions) =>
      _$this._hasFetchedAllSearchTransactions = hasFetchedAllSearchTransactions;

  GeneralError? _error;
  GeneralError? get error => _$this._error;
  set error(GeneralError? error) => _$this._error = error;

  int? _orderDetailsPageTabIndex;
  int? get orderDetailsPageTabIndex => _$this._orderDetailsPageTabIndex;
  set orderDetailsPageTabIndex(int? orderDetailsPageTabIndex) =>
      _$this._orderDetailsPageTabIndex = orderDetailsPageTabIndex;

  int? _allOrdersCount;
  int? get allOrdersCount => _$this._allOrdersCount;
  set allOrdersCount(int? allOrdersCount) =>
      _$this._allOrdersCount = allOrdersCount;

  Map<String, dynamic>? _allFulfillmentOrdersCount;
  Map<String, dynamic>? get allFulfillmentOrdersCount =>
      _$this._allFulfillmentOrdersCount;
  set allFulfillmentOrdersCount(
    Map<String, dynamic>? allFulfillmentOrdersCount,
  ) => _$this._allFulfillmentOrdersCount = allFulfillmentOrdersCount;

  CheckoutTransaction? _checkoutTransaction;
  CheckoutTransaction? get checkoutTransaction => _$this._checkoutTransaction;
  set checkoutTransaction(CheckoutTransaction? checkoutTransaction) =>
      _$this._checkoutTransaction = checkoutTransaction;

  OrderTransactionHistoryStateBuilder();

  OrderTransactionHistoryStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orders = $v.orders;
      _filteredOrders = $v.filteredOrders;
      _allOrders = $v.allOrders;
      _ordersSearchText = $v.ordersSearchText;
      _transactions = $v.transactions;
      _searchTransactions = $v.searchTransactions;
      _filteredTransactions = $v.filteredTransactions;
      _currentTransaction = $v.currentTransaction;
      _currentOrder = $v.currentOrder;
      _orderFilter = $v.orderFilter;
      _orderFilterType = $v.orderFilterType;
      _orderSortType = $v.orderSortType;
      _transactionConsultant = $v.transactionConsultant;
      _orderConsultant = $v.orderConsultant;
      _transactionFilterTypes = $v.transactionFilterTypes;
      _transactionSortType = $v.transactionSortType;
      _transactionSearchText = $v.transactionSearchText;
      _tabIndex = $v.tabIndex;
      _hasError = $v.hasError;
      _isLoading = $v.isLoading;
      _hasFetchedAllOrders = $v.hasFetchedAllOrders;
      _hasFetchedAllTransactions = $v.hasFetchedAllTransactions;
      _hasFetchedAllFilterTransactions = $v.hasFetchedAllFilterTransactions;
      _hasFetchedAllSearchTransactions = $v.hasFetchedAllSearchTransactions;
      _error = $v.error;
      _orderDetailsPageTabIndex = $v.orderDetailsPageTabIndex;
      _allOrdersCount = $v.allOrdersCount;
      _allFulfillmentOrdersCount = $v.allFulfillmentOrdersCount;
      _checkoutTransaction = $v.checkoutTransaction;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderTransactionHistoryState other) {
    _$v = other as _$OrderTransactionHistoryState;
  }

  @override
  void update(void Function(OrderTransactionHistoryStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderTransactionHistoryState build() => _build();

  _$OrderTransactionHistoryState _build() {
    final _$result =
        _$v ??
        _$OrderTransactionHistoryState._(
          orders: BuiltValueNullFieldError.checkNotNull(
            orders,
            r'OrderTransactionHistoryState',
            'orders',
          ),
          filteredOrders: BuiltValueNullFieldError.checkNotNull(
            filteredOrders,
            r'OrderTransactionHistoryState',
            'filteredOrders',
          ),
          allOrders: BuiltValueNullFieldError.checkNotNull(
            allOrders,
            r'OrderTransactionHistoryState',
            'allOrders',
          ),
          ordersSearchText: ordersSearchText,
          transactions: BuiltValueNullFieldError.checkNotNull(
            transactions,
            r'OrderTransactionHistoryState',
            'transactions',
          ),
          searchTransactions: BuiltValueNullFieldError.checkNotNull(
            searchTransactions,
            r'OrderTransactionHistoryState',
            'searchTransactions',
          ),
          filteredTransactions: BuiltValueNullFieldError.checkNotNull(
            filteredTransactions,
            r'OrderTransactionHistoryState',
            'filteredTransactions',
          ),
          currentTransaction: currentTransaction,
          currentOrder: currentOrder,
          orderFilter: orderFilter,
          orderFilterType: orderFilterType,
          orderSortType: orderSortType,
          transactionConsultant: transactionConsultant,
          orderConsultant: orderConsultant,
          transactionFilterTypes: transactionFilterTypes,
          transactionSortType: transactionSortType,
          transactionSearchText: transactionSearchText,
          tabIndex: tabIndex,
          hasError: BuiltValueNullFieldError.checkNotNull(
            hasError,
            r'OrderTransactionHistoryState',
            'hasError',
          ),
          isLoading: BuiltValueNullFieldError.checkNotNull(
            isLoading,
            r'OrderTransactionHistoryState',
            'isLoading',
          ),
          hasFetchedAllOrders: BuiltValueNullFieldError.checkNotNull(
            hasFetchedAllOrders,
            r'OrderTransactionHistoryState',
            'hasFetchedAllOrders',
          ),
          hasFetchedAllTransactions: BuiltValueNullFieldError.checkNotNull(
            hasFetchedAllTransactions,
            r'OrderTransactionHistoryState',
            'hasFetchedAllTransactions',
          ),
          hasFetchedAllFilterTransactions:
              BuiltValueNullFieldError.checkNotNull(
                hasFetchedAllFilterTransactions,
                r'OrderTransactionHistoryState',
                'hasFetchedAllFilterTransactions',
              ),
          hasFetchedAllSearchTransactions:
              BuiltValueNullFieldError.checkNotNull(
                hasFetchedAllSearchTransactions,
                r'OrderTransactionHistoryState',
                'hasFetchedAllSearchTransactions',
              ),
          error: error,
          orderDetailsPageTabIndex: BuiltValueNullFieldError.checkNotNull(
            orderDetailsPageTabIndex,
            r'OrderTransactionHistoryState',
            'orderDetailsPageTabIndex',
          ),
          allOrdersCount: BuiltValueNullFieldError.checkNotNull(
            allOrdersCount,
            r'OrderTransactionHistoryState',
            'allOrdersCount',
          ),
          allFulfillmentOrdersCount: BuiltValueNullFieldError.checkNotNull(
            allFulfillmentOrdersCount,
            r'OrderTransactionHistoryState',
            'allFulfillmentOrdersCount',
          ),
          checkoutTransaction: checkoutTransaction,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderTransactionHistoryState _$OrderTransactionHistoryStateFromJson(
  Map<String, dynamic> json,
) => OrderTransactionHistoryState();

Map<String, dynamic> _$OrderTransactionHistoryStateToJson(
  OrderTransactionHistoryState instance,
) => <String, dynamic>{};
