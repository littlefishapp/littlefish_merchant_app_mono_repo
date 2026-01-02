// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ExpensesState extends ExpensesState {
  @override
  final bool? isLoading;
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final List<BusinessExpense>? expenses;

  factory _$ExpensesState([void Function(ExpensesStateBuilder)? updates]) =>
      (ExpensesStateBuilder()..update(updates))._build();

  _$ExpensesState._({
    this.isLoading,
    this.hasError,
    this.errorMessage,
    this.expenses,
  }) : super._();
  @override
  ExpensesState rebuild(void Function(ExpensesStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExpensesStateBuilder toBuilder() => ExpensesStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExpensesState &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        expenses == other.expenses;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, expenses.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExpensesState')
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('expenses', expenses))
        .toString();
  }
}

class ExpensesStateBuilder
    implements Builder<ExpensesState, ExpensesStateBuilder> {
  _$ExpensesState? _$v;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  List<BusinessExpense>? _expenses;
  List<BusinessExpense>? get expenses => _$this._expenses;
  set expenses(List<BusinessExpense>? expenses) => _$this._expenses = expenses;

  ExpensesStateBuilder();

  ExpensesStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _expenses = $v.expenses;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExpensesState other) {
    _$v = other as _$ExpensesState;
  }

  @override
  void update(void Function(ExpensesStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExpensesState build() => _build();

  _$ExpensesState _build() {
    final _$result =
        _$v ??
        _$ExpensesState._(
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          expenses: expenses,
        );
    replace(_$result);
    return _$result;
  }
}

class _$BusinessExpensesUIState extends BusinessExpensesUIState {
  @override
  final BusinessExpense? item;
  @override
  final Customer? customer;

  factory _$BusinessExpensesUIState([
    void Function(BusinessExpensesUIStateBuilder)? updates,
  ]) => (BusinessExpensesUIStateBuilder()..update(updates))._build();

  _$BusinessExpensesUIState._({this.item, this.customer}) : super._();
  @override
  BusinessExpensesUIState rebuild(
    void Function(BusinessExpensesUIStateBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  BusinessExpensesUIStateBuilder toBuilder() =>
      BusinessExpensesUIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BusinessExpensesUIState &&
        item == other.item &&
        customer == other.customer;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, item.hashCode);
    _$hash = $jc(_$hash, customer.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BusinessExpensesUIState')
          ..add('item', item)
          ..add('customer', customer))
        .toString();
  }
}

class BusinessExpensesUIStateBuilder
    implements
        Builder<BusinessExpensesUIState, BusinessExpensesUIStateBuilder> {
  _$BusinessExpensesUIState? _$v;

  BusinessExpense? _item;
  BusinessExpense? get item => _$this._item;
  set item(BusinessExpense? item) => _$this._item = item;

  Customer? _customer;
  Customer? get customer => _$this._customer;
  set customer(Customer? customer) => _$this._customer = customer;

  BusinessExpensesUIStateBuilder();

  BusinessExpensesUIStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _item = $v.item;
      _customer = $v.customer;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BusinessExpensesUIState other) {
    _$v = other as _$BusinessExpensesUIState;
  }

  @override
  void update(void Function(BusinessExpensesUIStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BusinessExpensesUIState build() => _build();

  _$BusinessExpensesUIState _build() {
    final _$result =
        _$v ?? _$BusinessExpensesUIState._(item: item, customer: customer);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
