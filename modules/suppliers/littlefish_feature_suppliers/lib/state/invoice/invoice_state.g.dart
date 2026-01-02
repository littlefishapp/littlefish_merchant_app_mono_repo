// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InvoiceState extends InvoiceState {
  @override
  final bool? isLoading;
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final List<SupplierInvoice>? invoices;

  factory _$InvoiceState([void Function(InvoiceStateBuilder)? updates]) =>
      (InvoiceStateBuilder()..update(updates))._build();

  _$InvoiceState._({
    this.isLoading,
    this.hasError,
    this.errorMessage,
    this.invoices,
  }) : super._();
  @override
  InvoiceState rebuild(void Function(InvoiceStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InvoiceStateBuilder toBuilder() => InvoiceStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InvoiceState &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        invoices == other.invoices;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, invoices.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InvoiceState')
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('invoices', invoices))
        .toString();
  }
}

class InvoiceStateBuilder
    implements Builder<InvoiceState, InvoiceStateBuilder> {
  _$InvoiceState? _$v;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  List<SupplierInvoice>? _invoices;
  List<SupplierInvoice>? get invoices => _$this._invoices;
  set invoices(List<SupplierInvoice>? invoices) => _$this._invoices = invoices;

  InvoiceStateBuilder();

  InvoiceStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _invoices = $v.invoices;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InvoiceState other) {
    _$v = other as _$InvoiceState;
  }

  @override
  void update(void Function(InvoiceStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InvoiceState build() => _build();

  _$InvoiceState _build() {
    final _$result =
        _$v ??
        _$InvoiceState._(
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          invoices: invoices,
        );
    replace(_$result);
    return _$result;
  }
}

class _$InvoiceUIState extends InvoiceUIState {
  @override
  final UIEntityState<SupplierInvoice?>? item;

  factory _$InvoiceUIState([void Function(InvoiceUIStateBuilder)? updates]) =>
      (InvoiceUIStateBuilder()..update(updates))._build();

  _$InvoiceUIState._({this.item}) : super._();
  @override
  InvoiceUIState rebuild(void Function(InvoiceUIStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InvoiceUIStateBuilder toBuilder() => InvoiceUIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InvoiceUIState && item == other.item;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, item.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'InvoiceUIState',
    )..add('item', item)).toString();
  }
}

class InvoiceUIStateBuilder
    implements Builder<InvoiceUIState, InvoiceUIStateBuilder> {
  _$InvoiceUIState? _$v;

  UIEntityState<SupplierInvoice?>? _item;
  UIEntityState<SupplierInvoice?>? get item => _$this._item;
  set item(UIEntityState<SupplierInvoice?>? item) => _$this._item = item;

  InvoiceUIStateBuilder();

  InvoiceUIStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _item = $v.item;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InvoiceUIState other) {
    _$v = other as _$InvoiceUIState;
  }

  @override
  void update(void Function(InvoiceUIStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InvoiceUIState build() => _build();

  _$InvoiceUIState _build() {
    final _$result = _$v ?? _$InvoiceUIState._(item: item);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceState _$InvoiceStateFromJson(Map<String, dynamic> json) =>
    InvoiceState();

Map<String, dynamic> _$InvoiceStateToJson(InvoiceState instance) =>
    <String, dynamic>{};
