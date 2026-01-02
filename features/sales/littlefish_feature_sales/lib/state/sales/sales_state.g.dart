// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SalesState extends SalesState {
  @override
  final bool? isLoading;
  @override
  final bool? hasError;
  @override
  final bool enableTerminalReportFiltering;
  @override
  final String? errorMessage;
  @override
  final List<CheckoutTransaction> sequentialTransactions;
  @override
  final List<CheckoutTransaction> agglomerationTransactions;
  @override
  final List<CheckoutTransaction> transactionsFiltered;
  @override
  final List<CheckoutOrder?>? onlineTransactions;
  @override
  final CheckoutTransaction? originalTransactionUnmodified;
  @override
  final CheckoutTransaction? modifiedTransactionCopy;
  @override
  final Customer? customer;
  @override
  final Refund? currentRefund;

  factory _$SalesState([void Function(SalesStateBuilder)? updates]) =>
      (SalesStateBuilder()..update(updates))._build();

  _$SalesState._({
    this.isLoading,
    this.hasError,
    required this.enableTerminalReportFiltering,
    this.errorMessage,
    required this.sequentialTransactions,
    required this.agglomerationTransactions,
    required this.transactionsFiltered,
    this.onlineTransactions,
    this.originalTransactionUnmodified,
    this.modifiedTransactionCopy,
    this.customer,
    this.currentRefund,
  }) : super._();
  @override
  SalesState rebuild(void Function(SalesStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SalesStateBuilder toBuilder() => SalesStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SalesState &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        enableTerminalReportFiltering == other.enableTerminalReportFiltering &&
        errorMessage == other.errorMessage &&
        sequentialTransactions == other.sequentialTransactions &&
        agglomerationTransactions == other.agglomerationTransactions &&
        transactionsFiltered == other.transactionsFiltered &&
        onlineTransactions == other.onlineTransactions &&
        originalTransactionUnmodified == other.originalTransactionUnmodified &&
        modifiedTransactionCopy == other.modifiedTransactionCopy &&
        customer == other.customer &&
        currentRefund == other.currentRefund;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, enableTerminalReportFiltering.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, sequentialTransactions.hashCode);
    _$hash = $jc(_$hash, agglomerationTransactions.hashCode);
    _$hash = $jc(_$hash, transactionsFiltered.hashCode);
    _$hash = $jc(_$hash, onlineTransactions.hashCode);
    _$hash = $jc(_$hash, originalTransactionUnmodified.hashCode);
    _$hash = $jc(_$hash, modifiedTransactionCopy.hashCode);
    _$hash = $jc(_$hash, customer.hashCode);
    _$hash = $jc(_$hash, currentRefund.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SalesState')
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('enableTerminalReportFiltering', enableTerminalReportFiltering)
          ..add('errorMessage', errorMessage)
          ..add('sequentialTransactions', sequentialTransactions)
          ..add('agglomerationTransactions', agglomerationTransactions)
          ..add('transactionsFiltered', transactionsFiltered)
          ..add('onlineTransactions', onlineTransactions)
          ..add('originalTransactionUnmodified', originalTransactionUnmodified)
          ..add('modifiedTransactionCopy', modifiedTransactionCopy)
          ..add('customer', customer)
          ..add('currentRefund', currentRefund))
        .toString();
  }
}

class SalesStateBuilder implements Builder<SalesState, SalesStateBuilder> {
  _$SalesState? _$v;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  bool? _enableTerminalReportFiltering;
  bool? get enableTerminalReportFiltering =>
      _$this._enableTerminalReportFiltering;
  set enableTerminalReportFiltering(bool? enableTerminalReportFiltering) =>
      _$this._enableTerminalReportFiltering = enableTerminalReportFiltering;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  List<CheckoutTransaction>? _sequentialTransactions;
  List<CheckoutTransaction>? get sequentialTransactions =>
      _$this._sequentialTransactions;
  set sequentialTransactions(
    List<CheckoutTransaction>? sequentialTransactions,
  ) => _$this._sequentialTransactions = sequentialTransactions;

  List<CheckoutTransaction>? _agglomerationTransactions;
  List<CheckoutTransaction>? get agglomerationTransactions =>
      _$this._agglomerationTransactions;
  set agglomerationTransactions(
    List<CheckoutTransaction>? agglomerationTransactions,
  ) => _$this._agglomerationTransactions = agglomerationTransactions;

  List<CheckoutTransaction>? _transactionsFiltered;
  List<CheckoutTransaction>? get transactionsFiltered =>
      _$this._transactionsFiltered;
  set transactionsFiltered(List<CheckoutTransaction>? transactionsFiltered) =>
      _$this._transactionsFiltered = transactionsFiltered;

  List<CheckoutOrder?>? _onlineTransactions;
  List<CheckoutOrder?>? get onlineTransactions => _$this._onlineTransactions;
  set onlineTransactions(List<CheckoutOrder?>? onlineTransactions) =>
      _$this._onlineTransactions = onlineTransactions;

  CheckoutTransaction? _originalTransactionUnmodified;
  CheckoutTransaction? get originalTransactionUnmodified =>
      _$this._originalTransactionUnmodified;
  set originalTransactionUnmodified(
    CheckoutTransaction? originalTransactionUnmodified,
  ) => _$this._originalTransactionUnmodified = originalTransactionUnmodified;

  CheckoutTransaction? _modifiedTransactionCopy;
  CheckoutTransaction? get modifiedTransactionCopy =>
      _$this._modifiedTransactionCopy;
  set modifiedTransactionCopy(CheckoutTransaction? modifiedTransactionCopy) =>
      _$this._modifiedTransactionCopy = modifiedTransactionCopy;

  Customer? _customer;
  Customer? get customer => _$this._customer;
  set customer(Customer? customer) => _$this._customer = customer;

  Refund? _currentRefund;
  Refund? get currentRefund => _$this._currentRefund;
  set currentRefund(Refund? currentRefund) =>
      _$this._currentRefund = currentRefund;

  SalesStateBuilder();

  SalesStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _enableTerminalReportFiltering = $v.enableTerminalReportFiltering;
      _errorMessage = $v.errorMessage;
      _sequentialTransactions = $v.sequentialTransactions;
      _agglomerationTransactions = $v.agglomerationTransactions;
      _transactionsFiltered = $v.transactionsFiltered;
      _onlineTransactions = $v.onlineTransactions;
      _originalTransactionUnmodified = $v.originalTransactionUnmodified;
      _modifiedTransactionCopy = $v.modifiedTransactionCopy;
      _customer = $v.customer;
      _currentRefund = $v.currentRefund;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SalesState other) {
    _$v = other as _$SalesState;
  }

  @override
  void update(void Function(SalesStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SalesState build() => _build();

  _$SalesState _build() {
    final _$result =
        _$v ??
        _$SalesState._(
          isLoading: isLoading,
          hasError: hasError,
          enableTerminalReportFiltering: BuiltValueNullFieldError.checkNotNull(
            enableTerminalReportFiltering,
            r'SalesState',
            'enableTerminalReportFiltering',
          ),
          errorMessage: errorMessage,
          sequentialTransactions: BuiltValueNullFieldError.checkNotNull(
            sequentialTransactions,
            r'SalesState',
            'sequentialTransactions',
          ),
          agglomerationTransactions: BuiltValueNullFieldError.checkNotNull(
            agglomerationTransactions,
            r'SalesState',
            'agglomerationTransactions',
          ),
          transactionsFiltered: BuiltValueNullFieldError.checkNotNull(
            transactionsFiltered,
            r'SalesState',
            'transactionsFiltered',
          ),
          onlineTransactions: onlineTransactions,
          originalTransactionUnmodified: originalTransactionUnmodified,
          modifiedTransactionCopy: modifiedTransactionCopy,
          customer: customer,
          currentRefund: currentRefund,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesState _$SalesStateFromJson(Map<String, dynamic> json) => SalesState();

Map<String, dynamic> _$SalesStateToJson(SalesState instance) =>
    <String, dynamic>{};
