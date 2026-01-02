// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_receipt_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OrderReceiptState extends OrderReceiptState {
  @override
  final bool isLoading;
  @override
  final bool hasSent;
  @override
  final GeneralError? error;
  @override
  final Customer? customer;
  @override
  final Order? currentOrder;
  @override
  final OrderTransaction? currentTransaction;

  factory _$OrderReceiptState([
    void Function(OrderReceiptStateBuilder)? updates,
  ]) => (OrderReceiptStateBuilder()..update(updates))._build();

  _$OrderReceiptState._({
    required this.isLoading,
    required this.hasSent,
    this.error,
    this.customer,
    this.currentOrder,
    this.currentTransaction,
  }) : super._();
  @override
  OrderReceiptState rebuild(void Function(OrderReceiptStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderReceiptStateBuilder toBuilder() =>
      OrderReceiptStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderReceiptState &&
        isLoading == other.isLoading &&
        hasSent == other.hasSent &&
        error == other.error &&
        customer == other.customer &&
        currentOrder == other.currentOrder &&
        currentTransaction == other.currentTransaction;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasSent.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jc(_$hash, customer.hashCode);
    _$hash = $jc(_$hash, currentOrder.hashCode);
    _$hash = $jc(_$hash, currentTransaction.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderReceiptState')
          ..add('isLoading', isLoading)
          ..add('hasSent', hasSent)
          ..add('error', error)
          ..add('customer', customer)
          ..add('currentOrder', currentOrder)
          ..add('currentTransaction', currentTransaction))
        .toString();
  }
}

class OrderReceiptStateBuilder
    implements Builder<OrderReceiptState, OrderReceiptStateBuilder> {
  _$OrderReceiptState? _$v;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasSent;
  bool? get hasSent => _$this._hasSent;
  set hasSent(bool? hasSent) => _$this._hasSent = hasSent;

  GeneralError? _error;
  GeneralError? get error => _$this._error;
  set error(GeneralError? error) => _$this._error = error;

  Customer? _customer;
  Customer? get customer => _$this._customer;
  set customer(Customer? customer) => _$this._customer = customer;

  Order? _currentOrder;
  Order? get currentOrder => _$this._currentOrder;
  set currentOrder(Order? currentOrder) => _$this._currentOrder = currentOrder;

  OrderTransaction? _currentTransaction;
  OrderTransaction? get currentTransaction => _$this._currentTransaction;
  set currentTransaction(OrderTransaction? currentTransaction) =>
      _$this._currentTransaction = currentTransaction;

  OrderReceiptStateBuilder();

  OrderReceiptStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _hasSent = $v.hasSent;
      _error = $v.error;
      _customer = $v.customer;
      _currentOrder = $v.currentOrder;
      _currentTransaction = $v.currentTransaction;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderReceiptState other) {
    _$v = other as _$OrderReceiptState;
  }

  @override
  void update(void Function(OrderReceiptStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderReceiptState build() => _build();

  _$OrderReceiptState _build() {
    final _$result =
        _$v ??
        _$OrderReceiptState._(
          isLoading: BuiltValueNullFieldError.checkNotNull(
            isLoading,
            r'OrderReceiptState',
            'isLoading',
          ),
          hasSent: BuiltValueNullFieldError.checkNotNull(
            hasSent,
            r'OrderReceiptState',
            'hasSent',
          ),
          error: error,
          customer: customer,
          currentOrder: currentOrder,
          currentTransaction: currentTransaction,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderReceiptState _$OrderReceiptStateFromJson(Map<String, dynamic> json) =>
    OrderReceiptState();

Map<String, dynamic> _$OrderReceiptStateToJson(OrderReceiptState instance) =>
    <String, dynamic>{};
