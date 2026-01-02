// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotions_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PromotionsState extends PromotionsState {
  @override
  final bool? isLoading;
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final List<Promotion>? items;

  factory _$PromotionsState([void Function(PromotionsStateBuilder)? updates]) =>
      (PromotionsStateBuilder()..update(updates))._build();

  _$PromotionsState._({
    this.isLoading,
    this.hasError,
    this.errorMessage,
    this.items,
  }) : super._();
  @override
  PromotionsState rebuild(void Function(PromotionsStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PromotionsStateBuilder toBuilder() => PromotionsStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PromotionsState &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PromotionsState')
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('items', items))
        .toString();
  }
}

class PromotionsStateBuilder
    implements Builder<PromotionsState, PromotionsStateBuilder> {
  _$PromotionsState? _$v;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  List<Promotion>? _items;
  List<Promotion>? get items => _$this._items;
  set items(List<Promotion>? items) => _$this._items = items;

  PromotionsStateBuilder();

  PromotionsStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _items = $v.items;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PromotionsState other) {
    _$v = other as _$PromotionsState;
  }

  @override
  void update(void Function(PromotionsStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PromotionsState build() => _build();

  _$PromotionsState _build() {
    final _$result =
        _$v ??
        _$PromotionsState._(
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          items: items,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
