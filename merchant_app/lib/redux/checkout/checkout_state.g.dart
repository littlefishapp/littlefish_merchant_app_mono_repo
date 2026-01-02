// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CheckoutState extends CheckoutState {
  @override
  final Decimal? amountTendered;
  @override
  final Decimal? customAmount;
  @override
  final String? customDescription;
  @override
  final Customer? customer;
  @override
  final CheckoutDiscount? discount;
  @override
  final int? discountTabIndex;
  @override
  final int? tipTabIndex;
  @override
  final String? errorMessage;
  @override
  final bool? hasError;
  @override
  final Decimal? currentCheckoutActionAmount;
  @override
  final Decimal? withdrawalAmount;
  @override
  final Decimal? cashbackAmount;
  @override
  final Decimal? totalSaving;
  @override
  final CheckoutTip? tip;
  @override
  final Ticket? ticket;
  @override
  final enums.SortBy? sortBy;
  @override
  final enums.SortOrder? sortOrder;
  @override
  final bool? isLoading;
  @override
  final List<CheckoutCartItem>? items;
  @override
  final int? keypadIndex;
  @override
  final PaymentType? paymentType;
  @override
  final List<Refund>? refunds;
  @override
  final Decimal? totalRefund;
  @override
  final Decimal? totalRefundCost;
  @override
  final List<CheckoutCartItem>? voidedItems;
  @override
  final Refund? quickRefund;
  @override
  final double? lastTransactionNumber;
  @override
  final bool productVariantIsLoading;
  @override
  final StockProduct? productVariant;

  factory _$CheckoutState([void Function(CheckoutStateBuilder)? updates]) =>
      (CheckoutStateBuilder()..update(updates))._build();

  _$CheckoutState._({
    this.amountTendered,
    this.customAmount,
    this.customDescription,
    this.customer,
    this.discount,
    this.discountTabIndex,
    this.tipTabIndex,
    this.errorMessage,
    this.hasError,
    this.currentCheckoutActionAmount,
    this.withdrawalAmount,
    this.cashbackAmount,
    this.totalSaving,
    this.tip,
    this.ticket,
    this.sortBy,
    this.sortOrder,
    this.isLoading,
    this.items,
    this.keypadIndex,
    this.paymentType,
    this.refunds,
    this.totalRefund,
    this.totalRefundCost,
    this.voidedItems,
    this.quickRefund,
    this.lastTransactionNumber,
    required this.productVariantIsLoading,
    this.productVariant,
  }) : super._();
  @override
  CheckoutState rebuild(void Function(CheckoutStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CheckoutStateBuilder toBuilder() => CheckoutStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CheckoutState &&
        amountTendered == other.amountTendered &&
        customAmount == other.customAmount &&
        customDescription == other.customDescription &&
        customer == other.customer &&
        discount == other.discount &&
        discountTabIndex == other.discountTabIndex &&
        tipTabIndex == other.tipTabIndex &&
        errorMessage == other.errorMessage &&
        hasError == other.hasError &&
        currentCheckoutActionAmount == other.currentCheckoutActionAmount &&
        withdrawalAmount == other.withdrawalAmount &&
        cashbackAmount == other.cashbackAmount &&
        totalSaving == other.totalSaving &&
        tip == other.tip &&
        ticket == other.ticket &&
        sortBy == other.sortBy &&
        sortOrder == other.sortOrder &&
        isLoading == other.isLoading &&
        items == other.items &&
        keypadIndex == other.keypadIndex &&
        paymentType == other.paymentType &&
        refunds == other.refunds &&
        totalRefund == other.totalRefund &&
        totalRefundCost == other.totalRefundCost &&
        voidedItems == other.voidedItems &&
        quickRefund == other.quickRefund &&
        lastTransactionNumber == other.lastTransactionNumber &&
        productVariantIsLoading == other.productVariantIsLoading &&
        productVariant == other.productVariant;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, amountTendered.hashCode);
    _$hash = $jc(_$hash, customAmount.hashCode);
    _$hash = $jc(_$hash, customDescription.hashCode);
    _$hash = $jc(_$hash, customer.hashCode);
    _$hash = $jc(_$hash, discount.hashCode);
    _$hash = $jc(_$hash, discountTabIndex.hashCode);
    _$hash = $jc(_$hash, tipTabIndex.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, currentCheckoutActionAmount.hashCode);
    _$hash = $jc(_$hash, withdrawalAmount.hashCode);
    _$hash = $jc(_$hash, cashbackAmount.hashCode);
    _$hash = $jc(_$hash, totalSaving.hashCode);
    _$hash = $jc(_$hash, tip.hashCode);
    _$hash = $jc(_$hash, ticket.hashCode);
    _$hash = $jc(_$hash, sortBy.hashCode);
    _$hash = $jc(_$hash, sortOrder.hashCode);
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, keypadIndex.hashCode);
    _$hash = $jc(_$hash, paymentType.hashCode);
    _$hash = $jc(_$hash, refunds.hashCode);
    _$hash = $jc(_$hash, totalRefund.hashCode);
    _$hash = $jc(_$hash, totalRefundCost.hashCode);
    _$hash = $jc(_$hash, voidedItems.hashCode);
    _$hash = $jc(_$hash, quickRefund.hashCode);
    _$hash = $jc(_$hash, lastTransactionNumber.hashCode);
    _$hash = $jc(_$hash, productVariantIsLoading.hashCode);
    _$hash = $jc(_$hash, productVariant.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CheckoutState')
          ..add('amountTendered', amountTendered)
          ..add('customAmount', customAmount)
          ..add('customDescription', customDescription)
          ..add('customer', customer)
          ..add('discount', discount)
          ..add('discountTabIndex', discountTabIndex)
          ..add('tipTabIndex', tipTabIndex)
          ..add('errorMessage', errorMessage)
          ..add('hasError', hasError)
          ..add('currentCheckoutActionAmount', currentCheckoutActionAmount)
          ..add('withdrawalAmount', withdrawalAmount)
          ..add('cashbackAmount', cashbackAmount)
          ..add('totalSaving', totalSaving)
          ..add('tip', tip)
          ..add('ticket', ticket)
          ..add('sortBy', sortBy)
          ..add('sortOrder', sortOrder)
          ..add('isLoading', isLoading)
          ..add('items', items)
          ..add('keypadIndex', keypadIndex)
          ..add('paymentType', paymentType)
          ..add('refunds', refunds)
          ..add('totalRefund', totalRefund)
          ..add('totalRefundCost', totalRefundCost)
          ..add('voidedItems', voidedItems)
          ..add('quickRefund', quickRefund)
          ..add('lastTransactionNumber', lastTransactionNumber)
          ..add('productVariantIsLoading', productVariantIsLoading)
          ..add('productVariant', productVariant))
        .toString();
  }
}

class CheckoutStateBuilder
    implements Builder<CheckoutState, CheckoutStateBuilder> {
  _$CheckoutState? _$v;

  Decimal? _amountTendered;
  Decimal? get amountTendered => _$this._amountTendered;
  set amountTendered(Decimal? amountTendered) =>
      _$this._amountTendered = amountTendered;

  Decimal? _customAmount;
  Decimal? get customAmount => _$this._customAmount;
  set customAmount(Decimal? customAmount) =>
      _$this._customAmount = customAmount;

  String? _customDescription;
  String? get customDescription => _$this._customDescription;
  set customDescription(String? customDescription) =>
      _$this._customDescription = customDescription;

  Customer? _customer;
  Customer? get customer => _$this._customer;
  set customer(Customer? customer) => _$this._customer = customer;

  CheckoutDiscount? _discount;
  CheckoutDiscount? get discount => _$this._discount;
  set discount(CheckoutDiscount? discount) => _$this._discount = discount;

  int? _discountTabIndex;
  int? get discountTabIndex => _$this._discountTabIndex;
  set discountTabIndex(int? discountTabIndex) =>
      _$this._discountTabIndex = discountTabIndex;

  int? _tipTabIndex;
  int? get tipTabIndex => _$this._tipTabIndex;
  set tipTabIndex(int? tipTabIndex) => _$this._tipTabIndex = tipTabIndex;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  Decimal? _currentCheckoutActionAmount;
  Decimal? get currentCheckoutActionAmount =>
      _$this._currentCheckoutActionAmount;
  set currentCheckoutActionAmount(Decimal? currentCheckoutActionAmount) =>
      _$this._currentCheckoutActionAmount = currentCheckoutActionAmount;

  Decimal? _withdrawalAmount;
  Decimal? get withdrawalAmount => _$this._withdrawalAmount;
  set withdrawalAmount(Decimal? withdrawalAmount) =>
      _$this._withdrawalAmount = withdrawalAmount;

  Decimal? _cashbackAmount;
  Decimal? get cashbackAmount => _$this._cashbackAmount;
  set cashbackAmount(Decimal? cashbackAmount) =>
      _$this._cashbackAmount = cashbackAmount;

  Decimal? _totalSaving;
  Decimal? get totalSaving => _$this._totalSaving;
  set totalSaving(Decimal? totalSaving) => _$this._totalSaving = totalSaving;

  CheckoutTip? _tip;
  CheckoutTip? get tip => _$this._tip;
  set tip(CheckoutTip? tip) => _$this._tip = tip;

  Ticket? _ticket;
  Ticket? get ticket => _$this._ticket;
  set ticket(Ticket? ticket) => _$this._ticket = ticket;

  enums.SortBy? _sortBy;
  enums.SortBy? get sortBy => _$this._sortBy;
  set sortBy(enums.SortBy? sortBy) => _$this._sortBy = sortBy;

  enums.SortOrder? _sortOrder;
  enums.SortOrder? get sortOrder => _$this._sortOrder;
  set sortOrder(enums.SortOrder? sortOrder) => _$this._sortOrder = sortOrder;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  List<CheckoutCartItem>? _items;
  List<CheckoutCartItem>? get items => _$this._items;
  set items(List<CheckoutCartItem>? items) => _$this._items = items;

  int? _keypadIndex;
  int? get keypadIndex => _$this._keypadIndex;
  set keypadIndex(int? keypadIndex) => _$this._keypadIndex = keypadIndex;

  PaymentType? _paymentType;
  PaymentType? get paymentType => _$this._paymentType;
  set paymentType(PaymentType? paymentType) =>
      _$this._paymentType = paymentType;

  List<Refund>? _refunds;
  List<Refund>? get refunds => _$this._refunds;
  set refunds(List<Refund>? refunds) => _$this._refunds = refunds;

  Decimal? _totalRefund;
  Decimal? get totalRefund => _$this._totalRefund;
  set totalRefund(Decimal? totalRefund) => _$this._totalRefund = totalRefund;

  Decimal? _totalRefundCost;
  Decimal? get totalRefundCost => _$this._totalRefundCost;
  set totalRefundCost(Decimal? totalRefundCost) =>
      _$this._totalRefundCost = totalRefundCost;

  List<CheckoutCartItem>? _voidedItems;
  List<CheckoutCartItem>? get voidedItems => _$this._voidedItems;
  set voidedItems(List<CheckoutCartItem>? voidedItems) =>
      _$this._voidedItems = voidedItems;

  Refund? _quickRefund;
  Refund? get quickRefund => _$this._quickRefund;
  set quickRefund(Refund? quickRefund) => _$this._quickRefund = quickRefund;

  double? _lastTransactionNumber;
  double? get lastTransactionNumber => _$this._lastTransactionNumber;
  set lastTransactionNumber(double? lastTransactionNumber) =>
      _$this._lastTransactionNumber = lastTransactionNumber;

  bool? _productVariantIsLoading;
  bool? get productVariantIsLoading => _$this._productVariantIsLoading;
  set productVariantIsLoading(bool? productVariantIsLoading) =>
      _$this._productVariantIsLoading = productVariantIsLoading;

  StockProduct? _productVariant;
  StockProduct? get productVariant => _$this._productVariant;
  set productVariant(StockProduct? productVariant) =>
      _$this._productVariant = productVariant;

  CheckoutStateBuilder();

  CheckoutStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amountTendered = $v.amountTendered;
      _customAmount = $v.customAmount;
      _customDescription = $v.customDescription;
      _customer = $v.customer;
      _discount = $v.discount;
      _discountTabIndex = $v.discountTabIndex;
      _tipTabIndex = $v.tipTabIndex;
      _errorMessage = $v.errorMessage;
      _hasError = $v.hasError;
      _currentCheckoutActionAmount = $v.currentCheckoutActionAmount;
      _withdrawalAmount = $v.withdrawalAmount;
      _cashbackAmount = $v.cashbackAmount;
      _totalSaving = $v.totalSaving;
      _tip = $v.tip;
      _ticket = $v.ticket;
      _sortBy = $v.sortBy;
      _sortOrder = $v.sortOrder;
      _isLoading = $v.isLoading;
      _items = $v.items;
      _keypadIndex = $v.keypadIndex;
      _paymentType = $v.paymentType;
      _refunds = $v.refunds;
      _totalRefund = $v.totalRefund;
      _totalRefundCost = $v.totalRefundCost;
      _voidedItems = $v.voidedItems;
      _quickRefund = $v.quickRefund;
      _lastTransactionNumber = $v.lastTransactionNumber;
      _productVariantIsLoading = $v.productVariantIsLoading;
      _productVariant = $v.productVariant;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CheckoutState other) {
    _$v = other as _$CheckoutState;
  }

  @override
  void update(void Function(CheckoutStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CheckoutState build() => _build();

  _$CheckoutState _build() {
    final _$result =
        _$v ??
        _$CheckoutState._(
          amountTendered: amountTendered,
          customAmount: customAmount,
          customDescription: customDescription,
          customer: customer,
          discount: discount,
          discountTabIndex: discountTabIndex,
          tipTabIndex: tipTabIndex,
          errorMessage: errorMessage,
          hasError: hasError,
          currentCheckoutActionAmount: currentCheckoutActionAmount,
          withdrawalAmount: withdrawalAmount,
          cashbackAmount: cashbackAmount,
          totalSaving: totalSaving,
          tip: tip,
          ticket: ticket,
          sortBy: sortBy,
          sortOrder: sortOrder,
          isLoading: isLoading,
          items: items,
          keypadIndex: keypadIndex,
          paymentType: paymentType,
          refunds: refunds,
          totalRefund: totalRefund,
          totalRefundCost: totalRefundCost,
          voidedItems: voidedItems,
          quickRefund: quickRefund,
          lastTransactionNumber: lastTransactionNumber,
          productVariantIsLoading: BuiltValueNullFieldError.checkNotNull(
            productVariantIsLoading,
            r'CheckoutState',
            'productVariantIsLoading',
          ),
          productVariant: productVariant,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutState _$CheckoutStateFromJson(Map<String, dynamic> json) =>
    CheckoutState();

Map<String, dynamic> _$CheckoutStateToJson(CheckoutState instance) =>
    <String, dynamic>{};
