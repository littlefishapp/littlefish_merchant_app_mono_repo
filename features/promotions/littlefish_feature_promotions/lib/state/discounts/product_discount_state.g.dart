// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_discount_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProductDiscountState extends ProductDiscountState {
  @override
  final bool? isLoading;
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final List<ProductDiscount>? discounts;
  @override
  final ProductDiscount? currentDiscount;

  factory _$ProductDiscountState([
    void Function(ProductDiscountStateBuilder)? updates,
  ]) => (ProductDiscountStateBuilder()..update(updates))._build();

  _$ProductDiscountState._({
    this.isLoading,
    this.hasError,
    this.errorMessage,
    this.discounts,
    this.currentDiscount,
  }) : super._();
  @override
  ProductDiscountState rebuild(
    void Function(ProductDiscountStateBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ProductDiscountStateBuilder toBuilder() =>
      ProductDiscountStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductDiscountState &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        discounts == other.discounts &&
        currentDiscount == other.currentDiscount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, discounts.hashCode);
    _$hash = $jc(_$hash, currentDiscount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProductDiscountState')
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('discounts', discounts)
          ..add('currentDiscount', currentDiscount))
        .toString();
  }
}

class ProductDiscountStateBuilder
    implements Builder<ProductDiscountState, ProductDiscountStateBuilder> {
  _$ProductDiscountState? _$v;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  List<ProductDiscount>? _discounts;
  List<ProductDiscount>? get discounts => _$this._discounts;
  set discounts(List<ProductDiscount>? discounts) =>
      _$this._discounts = discounts;

  ProductDiscount? _currentDiscount;
  ProductDiscount? get currentDiscount => _$this._currentDiscount;
  set currentDiscount(ProductDiscount? currentDiscount) =>
      _$this._currentDiscount = currentDiscount;

  ProductDiscountStateBuilder();

  ProductDiscountStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _discounts = $v.discounts;
      _currentDiscount = $v.currentDiscount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductDiscountState other) {
    _$v = other as _$ProductDiscountState;
  }

  @override
  void update(void Function(ProductDiscountStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductDiscountState build() => _build();

  _$ProductDiscountState _build() {
    final _$result =
        _$v ??
        _$ProductDiscountState._(
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          discounts: discounts,
          currentDiscount: currentDiscount,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDiscountState _$ProductDiscountStateFromJson(
  Map<String, dynamic> json,
) => ProductDiscountState();

Map<String, dynamic> _$ProductDiscountStateToJson(
  ProductDiscountState instance,
) => <String, dynamic>{};
