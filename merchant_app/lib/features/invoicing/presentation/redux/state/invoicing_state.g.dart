// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoicing_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InvoicingState extends InvoicingState {
  @override
  final BuiltList<Order> invoices;
  @override
  final CheckoutDiscount? discount;
  @override
  final double totalAmount;
  @override
  final DateTime? dueDate;
  @override
  final BuiltList<StockProduct> selectedProducts;
  @override
  final BuiltMap<String, int> selectedQuantities;
  @override
  final String notes;
  @override
  final bool isLoading;
  @override
  final bool hasError;
  @override
  final GeneralError? error;
  @override
  final int offset;
  @override
  final int limit;
  @override
  final int totalRecords;
  @override
  final bool hasMore;

  factory _$InvoicingState([void Function(InvoicingStateBuilder)? updates]) =>
      (InvoicingStateBuilder()..update(updates))._build();

  _$InvoicingState._({
    required this.invoices,
    this.discount,
    required this.totalAmount,
    this.dueDate,
    required this.selectedProducts,
    required this.selectedQuantities,
    required this.notes,
    required this.isLoading,
    required this.hasError,
    this.error,
    required this.offset,
    required this.limit,
    required this.totalRecords,
    required this.hasMore,
  }) : super._();
  @override
  InvoicingState rebuild(void Function(InvoicingStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InvoicingStateBuilder toBuilder() => InvoicingStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InvoicingState &&
        invoices == other.invoices &&
        discount == other.discount &&
        totalAmount == other.totalAmount &&
        dueDate == other.dueDate &&
        selectedProducts == other.selectedProducts &&
        selectedQuantities == other.selectedQuantities &&
        notes == other.notes &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        error == other.error &&
        offset == other.offset &&
        limit == other.limit &&
        totalRecords == other.totalRecords &&
        hasMore == other.hasMore;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, invoices.hashCode);
    _$hash = $jc(_$hash, discount.hashCode);
    _$hash = $jc(_$hash, totalAmount.hashCode);
    _$hash = $jc(_$hash, dueDate.hashCode);
    _$hash = $jc(_$hash, selectedProducts.hashCode);
    _$hash = $jc(_$hash, selectedQuantities.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jc(_$hash, offset.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jc(_$hash, totalRecords.hashCode);
    _$hash = $jc(_$hash, hasMore.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InvoicingState')
          ..add('invoices', invoices)
          ..add('discount', discount)
          ..add('totalAmount', totalAmount)
          ..add('dueDate', dueDate)
          ..add('selectedProducts', selectedProducts)
          ..add('selectedQuantities', selectedQuantities)
          ..add('notes', notes)
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('error', error)
          ..add('offset', offset)
          ..add('limit', limit)
          ..add('totalRecords', totalRecords)
          ..add('hasMore', hasMore))
        .toString();
  }
}

class InvoicingStateBuilder
    implements Builder<InvoicingState, InvoicingStateBuilder> {
  _$InvoicingState? _$v;

  ListBuilder<Order>? _invoices;
  ListBuilder<Order> get invoices => _$this._invoices ??= ListBuilder<Order>();
  set invoices(ListBuilder<Order>? invoices) => _$this._invoices = invoices;

  CheckoutDiscount? _discount;
  CheckoutDiscount? get discount => _$this._discount;
  set discount(CheckoutDiscount? discount) => _$this._discount = discount;

  double? _totalAmount;
  double? get totalAmount => _$this._totalAmount;
  set totalAmount(double? totalAmount) => _$this._totalAmount = totalAmount;

  DateTime? _dueDate;
  DateTime? get dueDate => _$this._dueDate;
  set dueDate(DateTime? dueDate) => _$this._dueDate = dueDate;

  ListBuilder<StockProduct>? _selectedProducts;
  ListBuilder<StockProduct> get selectedProducts =>
      _$this._selectedProducts ??= ListBuilder<StockProduct>();
  set selectedProducts(ListBuilder<StockProduct>? selectedProducts) =>
      _$this._selectedProducts = selectedProducts;

  MapBuilder<String, int>? _selectedQuantities;
  MapBuilder<String, int> get selectedQuantities =>
      _$this._selectedQuantities ??= MapBuilder<String, int>();
  set selectedQuantities(MapBuilder<String, int>? selectedQuantities) =>
      _$this._selectedQuantities = selectedQuantities;

  String? _notes;
  String? get notes => _$this._notes;
  set notes(String? notes) => _$this._notes = notes;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  GeneralError? _error;
  GeneralError? get error => _$this._error;
  set error(GeneralError? error) => _$this._error = error;

  int? _offset;
  int? get offset => _$this._offset;
  set offset(int? offset) => _$this._offset = offset;

  int? _limit;
  int? get limit => _$this._limit;
  set limit(int? limit) => _$this._limit = limit;

  int? _totalRecords;
  int? get totalRecords => _$this._totalRecords;
  set totalRecords(int? totalRecords) => _$this._totalRecords = totalRecords;

  bool? _hasMore;
  bool? get hasMore => _$this._hasMore;
  set hasMore(bool? hasMore) => _$this._hasMore = hasMore;

  InvoicingStateBuilder();

  InvoicingStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _invoices = $v.invoices.toBuilder();
      _discount = $v.discount;
      _totalAmount = $v.totalAmount;
      _dueDate = $v.dueDate;
      _selectedProducts = $v.selectedProducts.toBuilder();
      _selectedQuantities = $v.selectedQuantities.toBuilder();
      _notes = $v.notes;
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _error = $v.error;
      _offset = $v.offset;
      _limit = $v.limit;
      _totalRecords = $v.totalRecords;
      _hasMore = $v.hasMore;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InvoicingState other) {
    _$v = other as _$InvoicingState;
  }

  @override
  void update(void Function(InvoicingStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InvoicingState build() => _build();

  _$InvoicingState _build() {
    _$InvoicingState _$result;
    try {
      _$result =
          _$v ??
          _$InvoicingState._(
            invoices: invoices.build(),
            discount: discount,
            totalAmount: BuiltValueNullFieldError.checkNotNull(
              totalAmount,
              r'InvoicingState',
              'totalAmount',
            ),
            dueDate: dueDate,
            selectedProducts: selectedProducts.build(),
            selectedQuantities: selectedQuantities.build(),
            notes: BuiltValueNullFieldError.checkNotNull(
              notes,
              r'InvoicingState',
              'notes',
            ),
            isLoading: BuiltValueNullFieldError.checkNotNull(
              isLoading,
              r'InvoicingState',
              'isLoading',
            ),
            hasError: BuiltValueNullFieldError.checkNotNull(
              hasError,
              r'InvoicingState',
              'hasError',
            ),
            error: error,
            offset: BuiltValueNullFieldError.checkNotNull(
              offset,
              r'InvoicingState',
              'offset',
            ),
            limit: BuiltValueNullFieldError.checkNotNull(
              limit,
              r'InvoicingState',
              'limit',
            ),
            totalRecords: BuiltValueNullFieldError.checkNotNull(
              totalRecords,
              r'InvoicingState',
              'totalRecords',
            ),
            hasMore: BuiltValueNullFieldError.checkNotNull(
              hasMore,
              r'InvoicingState',
              'hasMore',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'invoices';
        invoices.build();

        _$failedField = 'selectedProducts';
        selectedProducts.build();
        _$failedField = 'selectedQuantities';
        selectedQuantities.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'InvoicingState',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
