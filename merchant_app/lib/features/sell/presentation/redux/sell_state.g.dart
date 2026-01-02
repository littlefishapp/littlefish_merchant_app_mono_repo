// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sell_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SellState extends SellState {
  @override
  final Order? currentOrder;
  @override
  final OrderTransaction? currentOrderTransaction;
  @override
  final bool hasError;
  @override
  final bool canContinueToPayment;
  @override
  final String? orderId;
  @override
  final List<OrderLineItem> items;
  @override
  final FinancialStatus financialStatus;
  @override
  final OrderStatus orderStatus;
  @override
  final List<String> tags;
  @override
  final bool isLoading;
  @override
  final String? searchText;
  @override
  final double orderTotalTipAmount;
  @override
  final double transactionTipAmount;
  @override
  final PaymentType? selectedPaymentType;
  @override
  final List<PaymentType> availablePaymentTypes;
  @override
  final int tipTabIndex;
  @override
  final double orderTotalWithdrawalAmount;
  @override
  final double transactionWithdrawalAmount;
  @override
  final double currentTotalPrice;
  @override
  final double subtotalPrice;
  @override
  final double totalAmountOutstanding;
  @override
  final double totalAmountPaid;
  @override
  final int discountTabIndex;
  @override
  final double totalDiscount;
  @override
  final OrderDiscount? cartDiscount;
  @override
  final int checkoutTabIndex;
  @override
  final double totalTax;
  @override
  final List<OrderTransaction> transactions;
  @override
  final SortBy? sortBy;
  @override
  final SortOrder? sortOrder;
  @override
  final List<Order> drafts;
  @override
  final Customer? customer;
  @override
  final CheckoutTip? checkoutTip;
  @override
  final double? cashbackAmount;
  @override
  final String? errorMessage;
  @override
  final String? transactionFailureReason;
  @override
  final PurchasePaymentMethodPageState uiState;
  @override
  final bool? orderFailureDialogIsActive;
  @override
  final bool? transactionFailureDialogIsActive;
  @override
  final bool? pushFailedTrxFailureDialogIsActive;
  @override
  final OrderTransactionType orderTransactionType;

  factory _$SellState([void Function(SellStateBuilder)? updates]) =>
      (SellStateBuilder()..update(updates))._build();

  _$SellState._({
    this.currentOrder,
    this.currentOrderTransaction,
    required this.hasError,
    required this.canContinueToPayment,
    this.orderId,
    required this.items,
    required this.financialStatus,
    required this.orderStatus,
    required this.tags,
    required this.isLoading,
    this.searchText,
    required this.orderTotalTipAmount,
    required this.transactionTipAmount,
    this.selectedPaymentType,
    required this.availablePaymentTypes,
    required this.tipTabIndex,
    required this.orderTotalWithdrawalAmount,
    required this.transactionWithdrawalAmount,
    required this.currentTotalPrice,
    required this.subtotalPrice,
    required this.totalAmountOutstanding,
    required this.totalAmountPaid,
    required this.discountTabIndex,
    required this.totalDiscount,
    this.cartDiscount,
    required this.checkoutTabIndex,
    required this.totalTax,
    required this.transactions,
    this.sortBy,
    this.sortOrder,
    required this.drafts,
    this.customer,
    this.checkoutTip,
    this.cashbackAmount,
    this.errorMessage,
    this.transactionFailureReason,
    required this.uiState,
    this.orderFailureDialogIsActive,
    this.transactionFailureDialogIsActive,
    this.pushFailedTrxFailureDialogIsActive,
    required this.orderTransactionType,
  }) : super._();
  @override
  SellState rebuild(void Function(SellStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SellStateBuilder toBuilder() => SellStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SellState &&
        currentOrder == other.currentOrder &&
        currentOrderTransaction == other.currentOrderTransaction &&
        hasError == other.hasError &&
        canContinueToPayment == other.canContinueToPayment &&
        orderId == other.orderId &&
        items == other.items &&
        financialStatus == other.financialStatus &&
        orderStatus == other.orderStatus &&
        tags == other.tags &&
        isLoading == other.isLoading &&
        searchText == other.searchText &&
        orderTotalTipAmount == other.orderTotalTipAmount &&
        transactionTipAmount == other.transactionTipAmount &&
        selectedPaymentType == other.selectedPaymentType &&
        availablePaymentTypes == other.availablePaymentTypes &&
        tipTabIndex == other.tipTabIndex &&
        orderTotalWithdrawalAmount == other.orderTotalWithdrawalAmount &&
        transactionWithdrawalAmount == other.transactionWithdrawalAmount &&
        currentTotalPrice == other.currentTotalPrice &&
        subtotalPrice == other.subtotalPrice &&
        totalAmountOutstanding == other.totalAmountOutstanding &&
        totalAmountPaid == other.totalAmountPaid &&
        discountTabIndex == other.discountTabIndex &&
        totalDiscount == other.totalDiscount &&
        cartDiscount == other.cartDiscount &&
        checkoutTabIndex == other.checkoutTabIndex &&
        totalTax == other.totalTax &&
        transactions == other.transactions &&
        sortBy == other.sortBy &&
        sortOrder == other.sortOrder &&
        drafts == other.drafts &&
        customer == other.customer &&
        checkoutTip == other.checkoutTip &&
        cashbackAmount == other.cashbackAmount &&
        errorMessage == other.errorMessage &&
        transactionFailureReason == other.transactionFailureReason &&
        uiState == other.uiState &&
        orderFailureDialogIsActive == other.orderFailureDialogIsActive &&
        transactionFailureDialogIsActive ==
            other.transactionFailureDialogIsActive &&
        pushFailedTrxFailureDialogIsActive ==
            other.pushFailedTrxFailureDialogIsActive &&
        orderTransactionType == other.orderTransactionType;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currentOrder.hashCode);
    _$hash = $jc(_$hash, currentOrderTransaction.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, canContinueToPayment.hashCode);
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, financialStatus.hashCode);
    _$hash = $jc(_$hash, orderStatus.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, searchText.hashCode);
    _$hash = $jc(_$hash, orderTotalTipAmount.hashCode);
    _$hash = $jc(_$hash, transactionTipAmount.hashCode);
    _$hash = $jc(_$hash, selectedPaymentType.hashCode);
    _$hash = $jc(_$hash, availablePaymentTypes.hashCode);
    _$hash = $jc(_$hash, tipTabIndex.hashCode);
    _$hash = $jc(_$hash, orderTotalWithdrawalAmount.hashCode);
    _$hash = $jc(_$hash, transactionWithdrawalAmount.hashCode);
    _$hash = $jc(_$hash, currentTotalPrice.hashCode);
    _$hash = $jc(_$hash, subtotalPrice.hashCode);
    _$hash = $jc(_$hash, totalAmountOutstanding.hashCode);
    _$hash = $jc(_$hash, totalAmountPaid.hashCode);
    _$hash = $jc(_$hash, discountTabIndex.hashCode);
    _$hash = $jc(_$hash, totalDiscount.hashCode);
    _$hash = $jc(_$hash, cartDiscount.hashCode);
    _$hash = $jc(_$hash, checkoutTabIndex.hashCode);
    _$hash = $jc(_$hash, totalTax.hashCode);
    _$hash = $jc(_$hash, transactions.hashCode);
    _$hash = $jc(_$hash, sortBy.hashCode);
    _$hash = $jc(_$hash, sortOrder.hashCode);
    _$hash = $jc(_$hash, drafts.hashCode);
    _$hash = $jc(_$hash, customer.hashCode);
    _$hash = $jc(_$hash, checkoutTip.hashCode);
    _$hash = $jc(_$hash, cashbackAmount.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, transactionFailureReason.hashCode);
    _$hash = $jc(_$hash, uiState.hashCode);
    _$hash = $jc(_$hash, orderFailureDialogIsActive.hashCode);
    _$hash = $jc(_$hash, transactionFailureDialogIsActive.hashCode);
    _$hash = $jc(_$hash, pushFailedTrxFailureDialogIsActive.hashCode);
    _$hash = $jc(_$hash, orderTransactionType.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SellState')
          ..add('currentOrder', currentOrder)
          ..add('currentOrderTransaction', currentOrderTransaction)
          ..add('hasError', hasError)
          ..add('canContinueToPayment', canContinueToPayment)
          ..add('orderId', orderId)
          ..add('items', items)
          ..add('financialStatus', financialStatus)
          ..add('orderStatus', orderStatus)
          ..add('tags', tags)
          ..add('isLoading', isLoading)
          ..add('searchText', searchText)
          ..add('orderTotalTipAmount', orderTotalTipAmount)
          ..add('transactionTipAmount', transactionTipAmount)
          ..add('selectedPaymentType', selectedPaymentType)
          ..add('availablePaymentTypes', availablePaymentTypes)
          ..add('tipTabIndex', tipTabIndex)
          ..add('orderTotalWithdrawalAmount', orderTotalWithdrawalAmount)
          ..add('transactionWithdrawalAmount', transactionWithdrawalAmount)
          ..add('currentTotalPrice', currentTotalPrice)
          ..add('subtotalPrice', subtotalPrice)
          ..add('totalAmountOutstanding', totalAmountOutstanding)
          ..add('totalAmountPaid', totalAmountPaid)
          ..add('discountTabIndex', discountTabIndex)
          ..add('totalDiscount', totalDiscount)
          ..add('cartDiscount', cartDiscount)
          ..add('checkoutTabIndex', checkoutTabIndex)
          ..add('totalTax', totalTax)
          ..add('transactions', transactions)
          ..add('sortBy', sortBy)
          ..add('sortOrder', sortOrder)
          ..add('drafts', drafts)
          ..add('customer', customer)
          ..add('checkoutTip', checkoutTip)
          ..add('cashbackAmount', cashbackAmount)
          ..add('errorMessage', errorMessage)
          ..add('transactionFailureReason', transactionFailureReason)
          ..add('uiState', uiState)
          ..add('orderFailureDialogIsActive', orderFailureDialogIsActive)
          ..add(
            'transactionFailureDialogIsActive',
            transactionFailureDialogIsActive,
          )
          ..add(
            'pushFailedTrxFailureDialogIsActive',
            pushFailedTrxFailureDialogIsActive,
          )
          ..add('orderTransactionType', orderTransactionType))
        .toString();
  }
}

class SellStateBuilder implements Builder<SellState, SellStateBuilder> {
  _$SellState? _$v;

  Order? _currentOrder;
  Order? get currentOrder => _$this._currentOrder;
  set currentOrder(Order? currentOrder) => _$this._currentOrder = currentOrder;

  OrderTransaction? _currentOrderTransaction;
  OrderTransaction? get currentOrderTransaction =>
      _$this._currentOrderTransaction;
  set currentOrderTransaction(OrderTransaction? currentOrderTransaction) =>
      _$this._currentOrderTransaction = currentOrderTransaction;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  bool? _canContinueToPayment;
  bool? get canContinueToPayment => _$this._canContinueToPayment;
  set canContinueToPayment(bool? canContinueToPayment) =>
      _$this._canContinueToPayment = canContinueToPayment;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  List<OrderLineItem>? _items;
  List<OrderLineItem>? get items => _$this._items;
  set items(List<OrderLineItem>? items) => _$this._items = items;

  FinancialStatus? _financialStatus;
  FinancialStatus? get financialStatus => _$this._financialStatus;
  set financialStatus(FinancialStatus? financialStatus) =>
      _$this._financialStatus = financialStatus;

  OrderStatus? _orderStatus;
  OrderStatus? get orderStatus => _$this._orderStatus;
  set orderStatus(OrderStatus? orderStatus) =>
      _$this._orderStatus = orderStatus;

  List<String>? _tags;
  List<String>? get tags => _$this._tags;
  set tags(List<String>? tags) => _$this._tags = tags;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  String? _searchText;
  String? get searchText => _$this._searchText;
  set searchText(String? searchText) => _$this._searchText = searchText;

  double? _orderTotalTipAmount;
  double? get orderTotalTipAmount => _$this._orderTotalTipAmount;
  set orderTotalTipAmount(double? orderTotalTipAmount) =>
      _$this._orderTotalTipAmount = orderTotalTipAmount;

  double? _transactionTipAmount;
  double? get transactionTipAmount => _$this._transactionTipAmount;
  set transactionTipAmount(double? transactionTipAmount) =>
      _$this._transactionTipAmount = transactionTipAmount;

  PaymentType? _selectedPaymentType;
  PaymentType? get selectedPaymentType => _$this._selectedPaymentType;
  set selectedPaymentType(PaymentType? selectedPaymentType) =>
      _$this._selectedPaymentType = selectedPaymentType;

  List<PaymentType>? _availablePaymentTypes;
  List<PaymentType>? get availablePaymentTypes => _$this._availablePaymentTypes;
  set availablePaymentTypes(List<PaymentType>? availablePaymentTypes) =>
      _$this._availablePaymentTypes = availablePaymentTypes;

  int? _tipTabIndex;
  int? get tipTabIndex => _$this._tipTabIndex;
  set tipTabIndex(int? tipTabIndex) => _$this._tipTabIndex = tipTabIndex;

  double? _orderTotalWithdrawalAmount;
  double? get orderTotalWithdrawalAmount => _$this._orderTotalWithdrawalAmount;
  set orderTotalWithdrawalAmount(double? orderTotalWithdrawalAmount) =>
      _$this._orderTotalWithdrawalAmount = orderTotalWithdrawalAmount;

  double? _transactionWithdrawalAmount;
  double? get transactionWithdrawalAmount =>
      _$this._transactionWithdrawalAmount;
  set transactionWithdrawalAmount(double? transactionWithdrawalAmount) =>
      _$this._transactionWithdrawalAmount = transactionWithdrawalAmount;

  double? _currentTotalPrice;
  double? get currentTotalPrice => _$this._currentTotalPrice;
  set currentTotalPrice(double? currentTotalPrice) =>
      _$this._currentTotalPrice = currentTotalPrice;

  double? _subtotalPrice;
  double? get subtotalPrice => _$this._subtotalPrice;
  set subtotalPrice(double? subtotalPrice) =>
      _$this._subtotalPrice = subtotalPrice;

  double? _totalAmountOutstanding;
  double? get totalAmountOutstanding => _$this._totalAmountOutstanding;
  set totalAmountOutstanding(double? totalAmountOutstanding) =>
      _$this._totalAmountOutstanding = totalAmountOutstanding;

  double? _totalAmountPaid;
  double? get totalAmountPaid => _$this._totalAmountPaid;
  set totalAmountPaid(double? totalAmountPaid) =>
      _$this._totalAmountPaid = totalAmountPaid;

  int? _discountTabIndex;
  int? get discountTabIndex => _$this._discountTabIndex;
  set discountTabIndex(int? discountTabIndex) =>
      _$this._discountTabIndex = discountTabIndex;

  double? _totalDiscount;
  double? get totalDiscount => _$this._totalDiscount;
  set totalDiscount(double? totalDiscount) =>
      _$this._totalDiscount = totalDiscount;

  OrderDiscount? _cartDiscount;
  OrderDiscount? get cartDiscount => _$this._cartDiscount;
  set cartDiscount(OrderDiscount? cartDiscount) =>
      _$this._cartDiscount = cartDiscount;

  int? _checkoutTabIndex;
  int? get checkoutTabIndex => _$this._checkoutTabIndex;
  set checkoutTabIndex(int? checkoutTabIndex) =>
      _$this._checkoutTabIndex = checkoutTabIndex;

  double? _totalTax;
  double? get totalTax => _$this._totalTax;
  set totalTax(double? totalTax) => _$this._totalTax = totalTax;

  List<OrderTransaction>? _transactions;
  List<OrderTransaction>? get transactions => _$this._transactions;
  set transactions(List<OrderTransaction>? transactions) =>
      _$this._transactions = transactions;

  SortBy? _sortBy;
  SortBy? get sortBy => _$this._sortBy;
  set sortBy(SortBy? sortBy) => _$this._sortBy = sortBy;

  SortOrder? _sortOrder;
  SortOrder? get sortOrder => _$this._sortOrder;
  set sortOrder(SortOrder? sortOrder) => _$this._sortOrder = sortOrder;

  List<Order>? _drafts;
  List<Order>? get drafts => _$this._drafts;
  set drafts(List<Order>? drafts) => _$this._drafts = drafts;

  Customer? _customer;
  Customer? get customer => _$this._customer;
  set customer(Customer? customer) => _$this._customer = customer;

  CheckoutTip? _checkoutTip;
  CheckoutTip? get checkoutTip => _$this._checkoutTip;
  set checkoutTip(CheckoutTip? checkoutTip) =>
      _$this._checkoutTip = checkoutTip;

  double? _cashbackAmount;
  double? get cashbackAmount => _$this._cashbackAmount;
  set cashbackAmount(double? cashbackAmount) =>
      _$this._cashbackAmount = cashbackAmount;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  String? _transactionFailureReason;
  String? get transactionFailureReason => _$this._transactionFailureReason;
  set transactionFailureReason(String? transactionFailureReason) =>
      _$this._transactionFailureReason = transactionFailureReason;

  PurchasePaymentMethodPageState? _uiState;
  PurchasePaymentMethodPageState? get uiState => _$this._uiState;
  set uiState(PurchasePaymentMethodPageState? uiState) =>
      _$this._uiState = uiState;

  bool? _orderFailureDialogIsActive;
  bool? get orderFailureDialogIsActive => _$this._orderFailureDialogIsActive;
  set orderFailureDialogIsActive(bool? orderFailureDialogIsActive) =>
      _$this._orderFailureDialogIsActive = orderFailureDialogIsActive;

  bool? _transactionFailureDialogIsActive;
  bool? get transactionFailureDialogIsActive =>
      _$this._transactionFailureDialogIsActive;
  set transactionFailureDialogIsActive(
    bool? transactionFailureDialogIsActive,
  ) => _$this._transactionFailureDialogIsActive =
      transactionFailureDialogIsActive;

  bool? _pushFailedTrxFailureDialogIsActive;
  bool? get pushFailedTrxFailureDialogIsActive =>
      _$this._pushFailedTrxFailureDialogIsActive;
  set pushFailedTrxFailureDialogIsActive(
    bool? pushFailedTrxFailureDialogIsActive,
  ) => _$this._pushFailedTrxFailureDialogIsActive =
      pushFailedTrxFailureDialogIsActive;

  OrderTransactionType? _orderTransactionType;
  OrderTransactionType? get orderTransactionType =>
      _$this._orderTransactionType;
  set orderTransactionType(OrderTransactionType? orderTransactionType) =>
      _$this._orderTransactionType = orderTransactionType;

  SellStateBuilder();

  SellStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currentOrder = $v.currentOrder;
      _currentOrderTransaction = $v.currentOrderTransaction;
      _hasError = $v.hasError;
      _canContinueToPayment = $v.canContinueToPayment;
      _orderId = $v.orderId;
      _items = $v.items;
      _financialStatus = $v.financialStatus;
      _orderStatus = $v.orderStatus;
      _tags = $v.tags;
      _isLoading = $v.isLoading;
      _searchText = $v.searchText;
      _orderTotalTipAmount = $v.orderTotalTipAmount;
      _transactionTipAmount = $v.transactionTipAmount;
      _selectedPaymentType = $v.selectedPaymentType;
      _availablePaymentTypes = $v.availablePaymentTypes;
      _tipTabIndex = $v.tipTabIndex;
      _orderTotalWithdrawalAmount = $v.orderTotalWithdrawalAmount;
      _transactionWithdrawalAmount = $v.transactionWithdrawalAmount;
      _currentTotalPrice = $v.currentTotalPrice;
      _subtotalPrice = $v.subtotalPrice;
      _totalAmountOutstanding = $v.totalAmountOutstanding;
      _totalAmountPaid = $v.totalAmountPaid;
      _discountTabIndex = $v.discountTabIndex;
      _totalDiscount = $v.totalDiscount;
      _cartDiscount = $v.cartDiscount;
      _checkoutTabIndex = $v.checkoutTabIndex;
      _totalTax = $v.totalTax;
      _transactions = $v.transactions;
      _sortBy = $v.sortBy;
      _sortOrder = $v.sortOrder;
      _drafts = $v.drafts;
      _customer = $v.customer;
      _checkoutTip = $v.checkoutTip;
      _cashbackAmount = $v.cashbackAmount;
      _errorMessage = $v.errorMessage;
      _transactionFailureReason = $v.transactionFailureReason;
      _uiState = $v.uiState;
      _orderFailureDialogIsActive = $v.orderFailureDialogIsActive;
      _transactionFailureDialogIsActive = $v.transactionFailureDialogIsActive;
      _pushFailedTrxFailureDialogIsActive =
          $v.pushFailedTrxFailureDialogIsActive;
      _orderTransactionType = $v.orderTransactionType;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SellState other) {
    _$v = other as _$SellState;
  }

  @override
  void update(void Function(SellStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SellState build() => _build();

  _$SellState _build() {
    final _$result =
        _$v ??
        _$SellState._(
          currentOrder: currentOrder,
          currentOrderTransaction: currentOrderTransaction,
          hasError: BuiltValueNullFieldError.checkNotNull(
            hasError,
            r'SellState',
            'hasError',
          ),
          canContinueToPayment: BuiltValueNullFieldError.checkNotNull(
            canContinueToPayment,
            r'SellState',
            'canContinueToPayment',
          ),
          orderId: orderId,
          items: BuiltValueNullFieldError.checkNotNull(
            items,
            r'SellState',
            'items',
          ),
          financialStatus: BuiltValueNullFieldError.checkNotNull(
            financialStatus,
            r'SellState',
            'financialStatus',
          ),
          orderStatus: BuiltValueNullFieldError.checkNotNull(
            orderStatus,
            r'SellState',
            'orderStatus',
          ),
          tags: BuiltValueNullFieldError.checkNotNull(
            tags,
            r'SellState',
            'tags',
          ),
          isLoading: BuiltValueNullFieldError.checkNotNull(
            isLoading,
            r'SellState',
            'isLoading',
          ),
          searchText: searchText,
          orderTotalTipAmount: BuiltValueNullFieldError.checkNotNull(
            orderTotalTipAmount,
            r'SellState',
            'orderTotalTipAmount',
          ),
          transactionTipAmount: BuiltValueNullFieldError.checkNotNull(
            transactionTipAmount,
            r'SellState',
            'transactionTipAmount',
          ),
          selectedPaymentType: selectedPaymentType,
          availablePaymentTypes: BuiltValueNullFieldError.checkNotNull(
            availablePaymentTypes,
            r'SellState',
            'availablePaymentTypes',
          ),
          tipTabIndex: BuiltValueNullFieldError.checkNotNull(
            tipTabIndex,
            r'SellState',
            'tipTabIndex',
          ),
          orderTotalWithdrawalAmount: BuiltValueNullFieldError.checkNotNull(
            orderTotalWithdrawalAmount,
            r'SellState',
            'orderTotalWithdrawalAmount',
          ),
          transactionWithdrawalAmount: BuiltValueNullFieldError.checkNotNull(
            transactionWithdrawalAmount,
            r'SellState',
            'transactionWithdrawalAmount',
          ),
          currentTotalPrice: BuiltValueNullFieldError.checkNotNull(
            currentTotalPrice,
            r'SellState',
            'currentTotalPrice',
          ),
          subtotalPrice: BuiltValueNullFieldError.checkNotNull(
            subtotalPrice,
            r'SellState',
            'subtotalPrice',
          ),
          totalAmountOutstanding: BuiltValueNullFieldError.checkNotNull(
            totalAmountOutstanding,
            r'SellState',
            'totalAmountOutstanding',
          ),
          totalAmountPaid: BuiltValueNullFieldError.checkNotNull(
            totalAmountPaid,
            r'SellState',
            'totalAmountPaid',
          ),
          discountTabIndex: BuiltValueNullFieldError.checkNotNull(
            discountTabIndex,
            r'SellState',
            'discountTabIndex',
          ),
          totalDiscount: BuiltValueNullFieldError.checkNotNull(
            totalDiscount,
            r'SellState',
            'totalDiscount',
          ),
          cartDiscount: cartDiscount,
          checkoutTabIndex: BuiltValueNullFieldError.checkNotNull(
            checkoutTabIndex,
            r'SellState',
            'checkoutTabIndex',
          ),
          totalTax: BuiltValueNullFieldError.checkNotNull(
            totalTax,
            r'SellState',
            'totalTax',
          ),
          transactions: BuiltValueNullFieldError.checkNotNull(
            transactions,
            r'SellState',
            'transactions',
          ),
          sortBy: sortBy,
          sortOrder: sortOrder,
          drafts: BuiltValueNullFieldError.checkNotNull(
            drafts,
            r'SellState',
            'drafts',
          ),
          customer: customer,
          checkoutTip: checkoutTip,
          cashbackAmount: cashbackAmount,
          errorMessage: errorMessage,
          transactionFailureReason: transactionFailureReason,
          uiState: BuiltValueNullFieldError.checkNotNull(
            uiState,
            r'SellState',
            'uiState',
          ),
          orderFailureDialogIsActive: orderFailureDialogIsActive,
          transactionFailureDialogIsActive: transactionFailureDialogIsActive,
          pushFailedTrxFailureDialogIsActive:
              pushFailedTrxFailureDialogIsActive,
          orderTransactionType: BuiltValueNullFieldError.checkNotNull(
            orderTransactionType,
            r'SellState',
            'orderTransactionType',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SellState _$SellStateFromJson(Map<String, dynamic> json) => SellState();

Map<String, dynamic> _$SellStateToJson(SellState instance) =>
    <String, dynamic>{};
