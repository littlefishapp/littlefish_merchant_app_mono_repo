// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SupplierState extends SupplierState {
  @override
  final bool? isLoading;
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final List<Supplier?>? suppliers;

  factory _$SupplierState([void Function(SupplierStateBuilder)? updates]) =>
      (SupplierStateBuilder()..update(updates))._build();

  _$SupplierState._({
    this.isLoading,
    this.hasError,
    this.errorMessage,
    this.suppliers,
  }) : super._();
  @override
  SupplierState rebuild(void Function(SupplierStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupplierStateBuilder toBuilder() => SupplierStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupplierState &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        suppliers == other.suppliers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, suppliers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SupplierState')
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('suppliers', suppliers))
        .toString();
  }
}

class SupplierStateBuilder
    implements Builder<SupplierState, SupplierStateBuilder> {
  _$SupplierState? _$v;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  List<Supplier?>? _suppliers;
  List<Supplier?>? get suppliers => _$this._suppliers;
  set suppliers(List<Supplier?>? suppliers) => _$this._suppliers = suppliers;

  SupplierStateBuilder();

  SupplierStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _suppliers = $v.suppliers;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SupplierState other) {
    _$v = other as _$SupplierState;
  }

  @override
  void update(void Function(SupplierStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupplierState build() => _build();

  _$SupplierState _build() {
    final _$result =
        _$v ??
        _$SupplierState._(
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          suppliers: suppliers,
        );
    replace(_$result);
    return _$result;
  }
}

class _$SupplierUIState extends SupplierUIState {
  @override
  final UIEntityState<Supplier?>? item;

  factory _$SupplierUIState([void Function(SupplierUIStateBuilder)? updates]) =>
      (SupplierUIStateBuilder()..update(updates))._build();

  _$SupplierUIState._({this.item}) : super._();
  @override
  SupplierUIState rebuild(void Function(SupplierUIStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupplierUIStateBuilder toBuilder() => SupplierUIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupplierUIState && item == other.item;
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
      r'SupplierUIState',
    )..add('item', item)).toString();
  }
}

class SupplierUIStateBuilder
    implements Builder<SupplierUIState, SupplierUIStateBuilder> {
  _$SupplierUIState? _$v;

  UIEntityState<Supplier?>? _item;
  UIEntityState<Supplier?>? get item => _$this._item;
  set item(UIEntityState<Supplier?>? item) => _$this._item = item;

  SupplierUIStateBuilder();

  SupplierUIStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _item = $v.item;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SupplierUIState other) {
    _$v = other as _$SupplierUIState;
  }

  @override
  void update(void Function(SupplierUIStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupplierUIState build() => _build();

  _$SupplierUIState _build() {
    final _$result = _$v ?? _$SupplierUIState._(item: item);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
