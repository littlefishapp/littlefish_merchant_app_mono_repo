// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InventoryState extends InventoryState {
  @override
  final bool? isLoading;
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final List<StockRun>? stockRuns;
  @override
  final List<GoodsRecievedVoucher>? grvs;

  factory _$InventoryState([void Function(InventoryStateBuilder)? updates]) =>
      (InventoryStateBuilder()..update(updates))._build();

  _$InventoryState._({
    this.isLoading,
    this.hasError,
    this.errorMessage,
    this.stockRuns,
    this.grvs,
  }) : super._();
  @override
  InventoryState rebuild(void Function(InventoryStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InventoryStateBuilder toBuilder() => InventoryStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InventoryState &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        stockRuns == other.stockRuns &&
        grvs == other.grvs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, stockRuns.hashCode);
    _$hash = $jc(_$hash, grvs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InventoryState')
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('stockRuns', stockRuns)
          ..add('grvs', grvs))
        .toString();
  }
}

class InventoryStateBuilder
    implements Builder<InventoryState, InventoryStateBuilder> {
  _$InventoryState? _$v;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  List<StockRun>? _stockRuns;
  List<StockRun>? get stockRuns => _$this._stockRuns;
  set stockRuns(List<StockRun>? stockRuns) => _$this._stockRuns = stockRuns;

  List<GoodsRecievedVoucher>? _grvs;
  List<GoodsRecievedVoucher>? get grvs => _$this._grvs;
  set grvs(List<GoodsRecievedVoucher>? grvs) => _$this._grvs = grvs;

  InventoryStateBuilder();

  InventoryStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _stockRuns = $v.stockRuns;
      _grvs = $v.grvs;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InventoryState other) {
    _$v = other as _$InventoryState;
  }

  @override
  void update(void Function(InventoryStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InventoryState build() => _build();

  _$InventoryState _build() {
    final _$result =
        _$v ??
        _$InventoryState._(
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          stockRuns: stockRuns,
          grvs: grvs,
        );
    replace(_$result);
    return _$result;
  }
}

class _$InventoryStockTakeUI extends InventoryStockTakeUI {
  @override
  final bool? isLoading;
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final StockRun? stockTakeRun;

  factory _$InventoryStockTakeUI([
    void Function(InventoryStockTakeUIBuilder)? updates,
  ]) => (InventoryStockTakeUIBuilder()..update(updates))._build();

  _$InventoryStockTakeUI._({
    this.isLoading,
    this.hasError,
    this.errorMessage,
    this.stockTakeRun,
  }) : super._();
  @override
  InventoryStockTakeUI rebuild(
    void Function(InventoryStockTakeUIBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  InventoryStockTakeUIBuilder toBuilder() =>
      InventoryStockTakeUIBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InventoryStockTakeUI &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        stockTakeRun == other.stockTakeRun;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, stockTakeRun.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InventoryStockTakeUI')
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('stockTakeRun', stockTakeRun))
        .toString();
  }
}

class InventoryStockTakeUIBuilder
    implements Builder<InventoryStockTakeUI, InventoryStockTakeUIBuilder> {
  _$InventoryStockTakeUI? _$v;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  StockRun? _stockTakeRun;
  StockRun? get stockTakeRun => _$this._stockTakeRun;
  set stockTakeRun(StockRun? stockTakeRun) =>
      _$this._stockTakeRun = stockTakeRun;

  InventoryStockTakeUIBuilder();

  InventoryStockTakeUIBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _stockTakeRun = $v.stockTakeRun;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InventoryStockTakeUI other) {
    _$v = other as _$InventoryStockTakeUI;
  }

  @override
  void update(void Function(InventoryStockTakeUIBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InventoryStockTakeUI build() => _build();

  _$InventoryStockTakeUI _build() {
    final _$result =
        _$v ??
        _$InventoryStockTakeUI._(
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          stockTakeRun: stockTakeRun,
        );
    replace(_$result);
    return _$result;
  }
}

class _$InventoryRecievableUI extends InventoryRecievableUI {
  @override
  final bool? isLoading;
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final GoodsRecievedVoucher? item;

  factory _$InventoryRecievableUI([
    void Function(InventoryRecievableUIBuilder)? updates,
  ]) => (InventoryRecievableUIBuilder()..update(updates))._build();

  _$InventoryRecievableUI._({
    this.isLoading,
    this.hasError,
    this.errorMessage,
    this.item,
  }) : super._();
  @override
  InventoryRecievableUI rebuild(
    void Function(InventoryRecievableUIBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  InventoryRecievableUIBuilder toBuilder() =>
      InventoryRecievableUIBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InventoryRecievableUI &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        item == other.item;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, item.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InventoryRecievableUI')
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('item', item))
        .toString();
  }
}

class InventoryRecievableUIBuilder
    implements Builder<InventoryRecievableUI, InventoryRecievableUIBuilder> {
  _$InventoryRecievableUI? _$v;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  GoodsRecievedVoucher? _item;
  GoodsRecievedVoucher? get item => _$this._item;
  set item(GoodsRecievedVoucher? item) => _$this._item = item;

  InventoryRecievableUIBuilder();

  InventoryRecievableUIBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _item = $v.item;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InventoryRecievableUI other) {
    _$v = other as _$InventoryRecievableUI;
  }

  @override
  void update(void Function(InventoryRecievableUIBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InventoryRecievableUI build() => _build();

  _$InventoryRecievableUI _build() {
    final _$result =
        _$v ??
        _$InventoryRecievableUI._(
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          item: item,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryState _$InventoryStateFromJson(Map<String, dynamic> json) =>
    InventoryState();

Map<String, dynamic> _$InventoryStateToJson(InventoryState instance) =>
    <String, dynamic>{};
