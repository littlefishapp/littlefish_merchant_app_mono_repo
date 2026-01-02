// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discounts_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DiscountState extends DiscountState {
  @override
  final bool? isLoading;
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final List<CheckoutDiscount>? discounts;

  factory _$DiscountState([void Function(DiscountStateBuilder)? updates]) =>
      (DiscountStateBuilder()..update(updates))._build();

  _$DiscountState._({
    this.isLoading,
    this.hasError,
    this.errorMessage,
    this.discounts,
  }) : super._();
  @override
  DiscountState rebuild(void Function(DiscountStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DiscountStateBuilder toBuilder() => DiscountStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DiscountState &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        discounts == other.discounts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, discounts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DiscountState')
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('discounts', discounts))
        .toString();
  }
}

class DiscountStateBuilder
    implements Builder<DiscountState, DiscountStateBuilder> {
  _$DiscountState? _$v;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  List<CheckoutDiscount>? _discounts;
  List<CheckoutDiscount>? get discounts => _$this._discounts;
  set discounts(List<CheckoutDiscount>? discounts) =>
      _$this._discounts = discounts;

  DiscountStateBuilder();

  DiscountStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _discounts = $v.discounts;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DiscountState other) {
    _$v = other as _$DiscountState;
  }

  @override
  void update(void Function(DiscountStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DiscountState build() => _build();

  _$DiscountState _build() {
    final _$result =
        _$v ??
        _$DiscountState._(
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          discounts: discounts,
        );
    replace(_$result);
    return _$result;
  }
}

class _$DiscountUIState extends DiscountUIState {
  @override
  final CheckoutDiscount? item;

  factory _$DiscountUIState([void Function(DiscountUIStateBuilder)? updates]) =>
      (DiscountUIStateBuilder()..update(updates))._build();

  _$DiscountUIState._({this.item}) : super._();
  @override
  DiscountUIState rebuild(void Function(DiscountUIStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DiscountUIStateBuilder toBuilder() => DiscountUIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DiscountUIState && item == other.item;
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
      r'DiscountUIState',
    )..add('item', item)).toString();
  }
}

class DiscountUIStateBuilder
    implements Builder<DiscountUIState, DiscountUIStateBuilder> {
  _$DiscountUIState? _$v;

  CheckoutDiscount? _item;
  CheckoutDiscount? get item => _$this._item;
  set item(CheckoutDiscount? item) => _$this._item = item;

  DiscountUIStateBuilder();

  DiscountUIStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _item = $v.item;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DiscountUIState other) {
    _$v = other as _$DiscountUIState;
  }

  @override
  void update(void Function(DiscountUIStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DiscountUIState build() => _build();

  _$DiscountUIState _build() {
    final _$result = _$v ?? _$DiscountUIState._(item: item);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiscountState _$DiscountStateFromJson(Map<String, dynamic> json) =>
    DiscountState();

Map<String, dynamic> _$DiscountStateToJson(DiscountState instance) =>
    <String, dynamic>{};
