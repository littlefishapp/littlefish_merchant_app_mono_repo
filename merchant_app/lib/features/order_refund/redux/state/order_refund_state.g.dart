// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_refund_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RefundOrderState extends RefundOrderState {
  @override
  final Order? currentOrder;
  @override
  final List<OrderTransaction> transactions;
  @override
  final OrderTransaction? currentOrderTransaction;
  @override
  final List<OrderRefundLineItem> refundItems;
  @override
  final bool hasError;
  @override
  final bool isLoading;
  @override
  final bool canContinueToPayment;
  @override
  final PaymentType? selectedPaymentType;
  @override
  final List<PaymentType> availablePaymentTypes;
  @override
  final double currentTotalRefundPrice;
  @override
  final double orderLineItemTotalPrice;
  @override
  final double currentTotalDiscountAmount;
  @override
  final double totalAmountOutstanding;
  @override
  final double totalAmountPaid;
  @override
  final Customer? customer;
  @override
  final String? errorMessage;
  @override
  final String? transactionFailureReason;
  @override
  final bool? orderFailureDialogIsActive;
  @override
  final bool? transactionFailureDialogIsActive;
  @override
  final bool? pushFailedTrxFailureDialogIsActive;

  factory _$RefundOrderState([
    void Function(RefundOrderStateBuilder)? updates,
  ]) => (RefundOrderStateBuilder()..update(updates))._build();

  _$RefundOrderState._({
    this.currentOrder,
    required this.transactions,
    this.currentOrderTransaction,
    required this.refundItems,
    required this.hasError,
    required this.isLoading,
    required this.canContinueToPayment,
    this.selectedPaymentType,
    required this.availablePaymentTypes,
    required this.currentTotalRefundPrice,
    required this.orderLineItemTotalPrice,
    required this.currentTotalDiscountAmount,
    required this.totalAmountOutstanding,
    required this.totalAmountPaid,
    this.customer,
    this.errorMessage,
    this.transactionFailureReason,
    this.orderFailureDialogIsActive,
    this.transactionFailureDialogIsActive,
    this.pushFailedTrxFailureDialogIsActive,
  }) : super._();
  @override
  RefundOrderState rebuild(void Function(RefundOrderStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RefundOrderStateBuilder toBuilder() =>
      RefundOrderStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RefundOrderState &&
        currentOrder == other.currentOrder &&
        transactions == other.transactions &&
        currentOrderTransaction == other.currentOrderTransaction &&
        refundItems == other.refundItems &&
        hasError == other.hasError &&
        isLoading == other.isLoading &&
        canContinueToPayment == other.canContinueToPayment &&
        selectedPaymentType == other.selectedPaymentType &&
        availablePaymentTypes == other.availablePaymentTypes &&
        currentTotalRefundPrice == other.currentTotalRefundPrice &&
        orderLineItemTotalPrice == other.orderLineItemTotalPrice &&
        currentTotalDiscountAmount == other.currentTotalDiscountAmount &&
        totalAmountOutstanding == other.totalAmountOutstanding &&
        totalAmountPaid == other.totalAmountPaid &&
        customer == other.customer &&
        errorMessage == other.errorMessage &&
        transactionFailureReason == other.transactionFailureReason &&
        orderFailureDialogIsActive == other.orderFailureDialogIsActive &&
        transactionFailureDialogIsActive ==
            other.transactionFailureDialogIsActive &&
        pushFailedTrxFailureDialogIsActive ==
            other.pushFailedTrxFailureDialogIsActive;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currentOrder.hashCode);
    _$hash = $jc(_$hash, transactions.hashCode);
    _$hash = $jc(_$hash, currentOrderTransaction.hashCode);
    _$hash = $jc(_$hash, refundItems.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, canContinueToPayment.hashCode);
    _$hash = $jc(_$hash, selectedPaymentType.hashCode);
    _$hash = $jc(_$hash, availablePaymentTypes.hashCode);
    _$hash = $jc(_$hash, currentTotalRefundPrice.hashCode);
    _$hash = $jc(_$hash, orderLineItemTotalPrice.hashCode);
    _$hash = $jc(_$hash, currentTotalDiscountAmount.hashCode);
    _$hash = $jc(_$hash, totalAmountOutstanding.hashCode);
    _$hash = $jc(_$hash, totalAmountPaid.hashCode);
    _$hash = $jc(_$hash, customer.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, transactionFailureReason.hashCode);
    _$hash = $jc(_$hash, orderFailureDialogIsActive.hashCode);
    _$hash = $jc(_$hash, transactionFailureDialogIsActive.hashCode);
    _$hash = $jc(_$hash, pushFailedTrxFailureDialogIsActive.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RefundOrderState')
          ..add('currentOrder', currentOrder)
          ..add('transactions', transactions)
          ..add('currentOrderTransaction', currentOrderTransaction)
          ..add('refundItems', refundItems)
          ..add('hasError', hasError)
          ..add('isLoading', isLoading)
          ..add('canContinueToPayment', canContinueToPayment)
          ..add('selectedPaymentType', selectedPaymentType)
          ..add('availablePaymentTypes', availablePaymentTypes)
          ..add('currentTotalRefundPrice', currentTotalRefundPrice)
          ..add('orderLineItemTotalPrice', orderLineItemTotalPrice)
          ..add('currentTotalDiscountAmount', currentTotalDiscountAmount)
          ..add('totalAmountOutstanding', totalAmountOutstanding)
          ..add('totalAmountPaid', totalAmountPaid)
          ..add('customer', customer)
          ..add('errorMessage', errorMessage)
          ..add('transactionFailureReason', transactionFailureReason)
          ..add('orderFailureDialogIsActive', orderFailureDialogIsActive)
          ..add(
            'transactionFailureDialogIsActive',
            transactionFailureDialogIsActive,
          )
          ..add(
            'pushFailedTrxFailureDialogIsActive',
            pushFailedTrxFailureDialogIsActive,
          ))
        .toString();
  }
}

class RefundOrderStateBuilder
    implements Builder<RefundOrderState, RefundOrderStateBuilder> {
  _$RefundOrderState? _$v;

  Order? _currentOrder;
  Order? get currentOrder => _$this._currentOrder;
  set currentOrder(Order? currentOrder) => _$this._currentOrder = currentOrder;

  List<OrderTransaction>? _transactions;
  List<OrderTransaction>? get transactions => _$this._transactions;
  set transactions(List<OrderTransaction>? transactions) =>
      _$this._transactions = transactions;

  OrderTransaction? _currentOrderTransaction;
  OrderTransaction? get currentOrderTransaction =>
      _$this._currentOrderTransaction;
  set currentOrderTransaction(OrderTransaction? currentOrderTransaction) =>
      _$this._currentOrderTransaction = currentOrderTransaction;

  List<OrderRefundLineItem>? _refundItems;
  List<OrderRefundLineItem>? get refundItems => _$this._refundItems;
  set refundItems(List<OrderRefundLineItem>? refundItems) =>
      _$this._refundItems = refundItems;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _canContinueToPayment;
  bool? get canContinueToPayment => _$this._canContinueToPayment;
  set canContinueToPayment(bool? canContinueToPayment) =>
      _$this._canContinueToPayment = canContinueToPayment;

  PaymentType? _selectedPaymentType;
  PaymentType? get selectedPaymentType => _$this._selectedPaymentType;
  set selectedPaymentType(PaymentType? selectedPaymentType) =>
      _$this._selectedPaymentType = selectedPaymentType;

  List<PaymentType>? _availablePaymentTypes;
  List<PaymentType>? get availablePaymentTypes => _$this._availablePaymentTypes;
  set availablePaymentTypes(List<PaymentType>? availablePaymentTypes) =>
      _$this._availablePaymentTypes = availablePaymentTypes;

  double? _currentTotalRefundPrice;
  double? get currentTotalRefundPrice => _$this._currentTotalRefundPrice;
  set currentTotalRefundPrice(double? currentTotalRefundPrice) =>
      _$this._currentTotalRefundPrice = currentTotalRefundPrice;

  double? _orderLineItemTotalPrice;
  double? get orderLineItemTotalPrice => _$this._orderLineItemTotalPrice;
  set orderLineItemTotalPrice(double? orderLineItemTotalPrice) =>
      _$this._orderLineItemTotalPrice = orderLineItemTotalPrice;

  double? _currentTotalDiscountAmount;
  double? get currentTotalDiscountAmount => _$this._currentTotalDiscountAmount;
  set currentTotalDiscountAmount(double? currentTotalDiscountAmount) =>
      _$this._currentTotalDiscountAmount = currentTotalDiscountAmount;

  double? _totalAmountOutstanding;
  double? get totalAmountOutstanding => _$this._totalAmountOutstanding;
  set totalAmountOutstanding(double? totalAmountOutstanding) =>
      _$this._totalAmountOutstanding = totalAmountOutstanding;

  double? _totalAmountPaid;
  double? get totalAmountPaid => _$this._totalAmountPaid;
  set totalAmountPaid(double? totalAmountPaid) =>
      _$this._totalAmountPaid = totalAmountPaid;

  Customer? _customer;
  Customer? get customer => _$this._customer;
  set customer(Customer? customer) => _$this._customer = customer;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  String? _transactionFailureReason;
  String? get transactionFailureReason => _$this._transactionFailureReason;
  set transactionFailureReason(String? transactionFailureReason) =>
      _$this._transactionFailureReason = transactionFailureReason;

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

  RefundOrderStateBuilder();

  RefundOrderStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currentOrder = $v.currentOrder;
      _transactions = $v.transactions;
      _currentOrderTransaction = $v.currentOrderTransaction;
      _refundItems = $v.refundItems;
      _hasError = $v.hasError;
      _isLoading = $v.isLoading;
      _canContinueToPayment = $v.canContinueToPayment;
      _selectedPaymentType = $v.selectedPaymentType;
      _availablePaymentTypes = $v.availablePaymentTypes;
      _currentTotalRefundPrice = $v.currentTotalRefundPrice;
      _orderLineItemTotalPrice = $v.orderLineItemTotalPrice;
      _currentTotalDiscountAmount = $v.currentTotalDiscountAmount;
      _totalAmountOutstanding = $v.totalAmountOutstanding;
      _totalAmountPaid = $v.totalAmountPaid;
      _customer = $v.customer;
      _errorMessage = $v.errorMessage;
      _transactionFailureReason = $v.transactionFailureReason;
      _orderFailureDialogIsActive = $v.orderFailureDialogIsActive;
      _transactionFailureDialogIsActive = $v.transactionFailureDialogIsActive;
      _pushFailedTrxFailureDialogIsActive =
          $v.pushFailedTrxFailureDialogIsActive;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RefundOrderState other) {
    _$v = other as _$RefundOrderState;
  }

  @override
  void update(void Function(RefundOrderStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RefundOrderState build() => _build();

  _$RefundOrderState _build() {
    final _$result =
        _$v ??
        _$RefundOrderState._(
          currentOrder: currentOrder,
          transactions: BuiltValueNullFieldError.checkNotNull(
            transactions,
            r'RefundOrderState',
            'transactions',
          ),
          currentOrderTransaction: currentOrderTransaction,
          refundItems: BuiltValueNullFieldError.checkNotNull(
            refundItems,
            r'RefundOrderState',
            'refundItems',
          ),
          hasError: BuiltValueNullFieldError.checkNotNull(
            hasError,
            r'RefundOrderState',
            'hasError',
          ),
          isLoading: BuiltValueNullFieldError.checkNotNull(
            isLoading,
            r'RefundOrderState',
            'isLoading',
          ),
          canContinueToPayment: BuiltValueNullFieldError.checkNotNull(
            canContinueToPayment,
            r'RefundOrderState',
            'canContinueToPayment',
          ),
          selectedPaymentType: selectedPaymentType,
          availablePaymentTypes: BuiltValueNullFieldError.checkNotNull(
            availablePaymentTypes,
            r'RefundOrderState',
            'availablePaymentTypes',
          ),
          currentTotalRefundPrice: BuiltValueNullFieldError.checkNotNull(
            currentTotalRefundPrice,
            r'RefundOrderState',
            'currentTotalRefundPrice',
          ),
          orderLineItemTotalPrice: BuiltValueNullFieldError.checkNotNull(
            orderLineItemTotalPrice,
            r'RefundOrderState',
            'orderLineItemTotalPrice',
          ),
          currentTotalDiscountAmount: BuiltValueNullFieldError.checkNotNull(
            currentTotalDiscountAmount,
            r'RefundOrderState',
            'currentTotalDiscountAmount',
          ),
          totalAmountOutstanding: BuiltValueNullFieldError.checkNotNull(
            totalAmountOutstanding,
            r'RefundOrderState',
            'totalAmountOutstanding',
          ),
          totalAmountPaid: BuiltValueNullFieldError.checkNotNull(
            totalAmountPaid,
            r'RefundOrderState',
            'totalAmountPaid',
          ),
          customer: customer,
          errorMessage: errorMessage,
          transactionFailureReason: transactionFailureReason,
          orderFailureDialogIsActive: orderFailureDialogIsActive,
          transactionFailureDialogIsActive: transactionFailureDialogIsActive,
          pushFailedTrxFailureDialogIsActive:
              pushFailedTrxFailureDialogIsActive,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefundOrderState _$RefundOrderStateFromJson(Map<String, dynamic> json) =>
    RefundOrderState();

Map<String, dynamic> _$RefundOrderStateToJson(RefundOrderState instance) =>
    <String, dynamic>{};
