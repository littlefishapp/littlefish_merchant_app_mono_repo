// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SearchState extends SearchState {
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final StoreSearchParams? storeSearchParams;
  @override
  final ProductSearchParams? productSearchParams;
  @override
  final OrderSearchParams? orderSearchParams;
  @override
  final List<DocumentSnapshot<Object?>>? productResults;

  factory _$SearchState([void Function(SearchStateBuilder)? updates]) =>
      (SearchStateBuilder()..update(updates))._build();

  _$SearchState._({
    this.hasError,
    this.errorMessage,
    this.storeSearchParams,
    this.productSearchParams,
    this.orderSearchParams,
    this.productResults,
  }) : super._();
  @override
  SearchState rebuild(void Function(SearchStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchStateBuilder toBuilder() => SearchStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchState &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        storeSearchParams == other.storeSearchParams &&
        productSearchParams == other.productSearchParams &&
        orderSearchParams == other.orderSearchParams &&
        productResults == other.productResults;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, storeSearchParams.hashCode);
    _$hash = $jc(_$hash, productSearchParams.hashCode);
    _$hash = $jc(_$hash, orderSearchParams.hashCode);
    _$hash = $jc(_$hash, productResults.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SearchState')
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('storeSearchParams', storeSearchParams)
          ..add('productSearchParams', productSearchParams)
          ..add('orderSearchParams', orderSearchParams)
          ..add('productResults', productResults))
        .toString();
  }
}

class SearchStateBuilder implements Builder<SearchState, SearchStateBuilder> {
  _$SearchState? _$v;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  StoreSearchParams? _storeSearchParams;
  StoreSearchParams? get storeSearchParams => _$this._storeSearchParams;
  set storeSearchParams(StoreSearchParams? storeSearchParams) =>
      _$this._storeSearchParams = storeSearchParams;

  ProductSearchParams? _productSearchParams;
  ProductSearchParams? get productSearchParams => _$this._productSearchParams;
  set productSearchParams(ProductSearchParams? productSearchParams) =>
      _$this._productSearchParams = productSearchParams;

  OrderSearchParams? _orderSearchParams;
  OrderSearchParams? get orderSearchParams => _$this._orderSearchParams;
  set orderSearchParams(OrderSearchParams? orderSearchParams) =>
      _$this._orderSearchParams = orderSearchParams;

  List<DocumentSnapshot<Object?>>? _productResults;
  List<DocumentSnapshot<Object?>>? get productResults => _$this._productResults;
  set productResults(List<DocumentSnapshot<Object?>>? productResults) =>
      _$this._productResults = productResults;

  SearchStateBuilder();

  SearchStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _storeSearchParams = $v.storeSearchParams;
      _productSearchParams = $v.productSearchParams;
      _orderSearchParams = $v.orderSearchParams;
      _productResults = $v.productResults;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchState other) {
    _$v = other as _$SearchState;
  }

  @override
  void update(void Function(SearchStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchState build() => _build();

  _$SearchState _build() {
    final _$result =
        _$v ??
        _$SearchState._(
          hasError: hasError,
          errorMessage: errorMessage,
          storeSearchParams: storeSearchParams,
          productSearchParams: productSearchParams,
          orderSearchParams: orderSearchParams,
          productResults: productResults,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
