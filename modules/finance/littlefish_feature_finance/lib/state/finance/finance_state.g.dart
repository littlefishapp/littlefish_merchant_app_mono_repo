// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FinanceState extends FinanceState {
  @override
  final bool? isLoading;
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final int? monthsTrading;
  @override
  final int? daysTrading;
  @override
  final double? totalRevenue;
  @override
  final double? totalExpenses;
  @override
  final double? totalCostOfSale;
  @override
  final double? totalDebtors;
  @override
  final double? totalCreditors;
  @override
  final double? totalInventoryValue;
  @override
  final double? financeablePortion;

  factory _$FinanceState([void Function(FinanceStateBuilder)? updates]) =>
      (FinanceStateBuilder()..update(updates))._build();

  _$FinanceState._({
    this.isLoading,
    this.hasError,
    this.errorMessage,
    this.monthsTrading,
    this.daysTrading,
    this.totalRevenue,
    this.totalExpenses,
    this.totalCostOfSale,
    this.totalDebtors,
    this.totalCreditors,
    this.totalInventoryValue,
    this.financeablePortion,
  }) : super._();
  @override
  FinanceState rebuild(void Function(FinanceStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FinanceStateBuilder toBuilder() => FinanceStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FinanceState &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        monthsTrading == other.monthsTrading &&
        daysTrading == other.daysTrading &&
        totalRevenue == other.totalRevenue &&
        totalExpenses == other.totalExpenses &&
        totalCostOfSale == other.totalCostOfSale &&
        totalDebtors == other.totalDebtors &&
        totalCreditors == other.totalCreditors &&
        totalInventoryValue == other.totalInventoryValue &&
        financeablePortion == other.financeablePortion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, monthsTrading.hashCode);
    _$hash = $jc(_$hash, daysTrading.hashCode);
    _$hash = $jc(_$hash, totalRevenue.hashCode);
    _$hash = $jc(_$hash, totalExpenses.hashCode);
    _$hash = $jc(_$hash, totalCostOfSale.hashCode);
    _$hash = $jc(_$hash, totalDebtors.hashCode);
    _$hash = $jc(_$hash, totalCreditors.hashCode);
    _$hash = $jc(_$hash, totalInventoryValue.hashCode);
    _$hash = $jc(_$hash, financeablePortion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FinanceState')
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('monthsTrading', monthsTrading)
          ..add('daysTrading', daysTrading)
          ..add('totalRevenue', totalRevenue)
          ..add('totalExpenses', totalExpenses)
          ..add('totalCostOfSale', totalCostOfSale)
          ..add('totalDebtors', totalDebtors)
          ..add('totalCreditors', totalCreditors)
          ..add('totalInventoryValue', totalInventoryValue)
          ..add('financeablePortion', financeablePortion))
        .toString();
  }
}

class FinanceStateBuilder
    implements Builder<FinanceState, FinanceStateBuilder> {
  _$FinanceState? _$v;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  int? _monthsTrading;
  int? get monthsTrading => _$this._monthsTrading;
  set monthsTrading(int? monthsTrading) =>
      _$this._monthsTrading = monthsTrading;

  int? _daysTrading;
  int? get daysTrading => _$this._daysTrading;
  set daysTrading(int? daysTrading) => _$this._daysTrading = daysTrading;

  double? _totalRevenue;
  double? get totalRevenue => _$this._totalRevenue;
  set totalRevenue(double? totalRevenue) => _$this._totalRevenue = totalRevenue;

  double? _totalExpenses;
  double? get totalExpenses => _$this._totalExpenses;
  set totalExpenses(double? totalExpenses) =>
      _$this._totalExpenses = totalExpenses;

  double? _totalCostOfSale;
  double? get totalCostOfSale => _$this._totalCostOfSale;
  set totalCostOfSale(double? totalCostOfSale) =>
      _$this._totalCostOfSale = totalCostOfSale;

  double? _totalDebtors;
  double? get totalDebtors => _$this._totalDebtors;
  set totalDebtors(double? totalDebtors) => _$this._totalDebtors = totalDebtors;

  double? _totalCreditors;
  double? get totalCreditors => _$this._totalCreditors;
  set totalCreditors(double? totalCreditors) =>
      _$this._totalCreditors = totalCreditors;

  double? _totalInventoryValue;
  double? get totalInventoryValue => _$this._totalInventoryValue;
  set totalInventoryValue(double? totalInventoryValue) =>
      _$this._totalInventoryValue = totalInventoryValue;

  double? _financeablePortion;
  double? get financeablePortion => _$this._financeablePortion;
  set financeablePortion(double? financeablePortion) =>
      _$this._financeablePortion = financeablePortion;

  FinanceStateBuilder();

  FinanceStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _monthsTrading = $v.monthsTrading;
      _daysTrading = $v.daysTrading;
      _totalRevenue = $v.totalRevenue;
      _totalExpenses = $v.totalExpenses;
      _totalCostOfSale = $v.totalCostOfSale;
      _totalDebtors = $v.totalDebtors;
      _totalCreditors = $v.totalCreditors;
      _totalInventoryValue = $v.totalInventoryValue;
      _financeablePortion = $v.financeablePortion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FinanceState other) {
    _$v = other as _$FinanceState;
  }

  @override
  void update(void Function(FinanceStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FinanceState build() => _build();

  _$FinanceState _build() {
    final _$result =
        _$v ??
        _$FinanceState._(
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          monthsTrading: monthsTrading,
          daysTrading: daysTrading,
          totalRevenue: totalRevenue,
          totalExpenses: totalExpenses,
          totalCostOfSale: totalCostOfSale,
          totalDebtors: totalDebtors,
          totalCreditors: totalCreditors,
          totalInventoryValue: totalInventoryValue,
          financeablePortion: financeablePortion,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
