// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProductState extends ProductState {
  @override
  final Map<String, List<StockProduct>>? productVariants;
  @override
  final bool? isLoading;
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final SortBy? sortBy;
  @override
  final SortOrder? sortOrder;
  @override
  final FullProduct? productWithOptions;
  @override
  final List<StockCategory>? categories;
  @override
  final List<StockProduct>? products;
  @override
  final List<FullProduct> fullProducts;
  @override
  final List<ProductModifier>? modifiers;
  @override
  final List<ProductCombo>? productCombos;
  @override
  final List<ProductOptionAttribute> allOptionAttributes;
  @override
  final int? tabIndex;

  factory _$ProductState([void Function(ProductStateBuilder)? updates]) =>
      (ProductStateBuilder()..update(updates))._build();

  _$ProductState._({
    this.productVariants,
    this.isLoading,
    this.hasError,
    this.errorMessage,
    this.sortBy,
    this.sortOrder,
    this.productWithOptions,
    this.categories,
    this.products,
    required this.fullProducts,
    this.modifiers,
    this.productCombos,
    required this.allOptionAttributes,
    this.tabIndex,
  }) : super._();
  @override
  ProductState rebuild(void Function(ProductStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductStateBuilder toBuilder() => ProductStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductState &&
        productVariants == other.productVariants &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        sortBy == other.sortBy &&
        sortOrder == other.sortOrder &&
        productWithOptions == other.productWithOptions &&
        categories == other.categories &&
        products == other.products &&
        fullProducts == other.fullProducts &&
        modifiers == other.modifiers &&
        productCombos == other.productCombos &&
        allOptionAttributes == other.allOptionAttributes &&
        tabIndex == other.tabIndex;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, productVariants.hashCode);
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, sortBy.hashCode);
    _$hash = $jc(_$hash, sortOrder.hashCode);
    _$hash = $jc(_$hash, productWithOptions.hashCode);
    _$hash = $jc(_$hash, categories.hashCode);
    _$hash = $jc(_$hash, products.hashCode);
    _$hash = $jc(_$hash, fullProducts.hashCode);
    _$hash = $jc(_$hash, modifiers.hashCode);
    _$hash = $jc(_$hash, productCombos.hashCode);
    _$hash = $jc(_$hash, allOptionAttributes.hashCode);
    _$hash = $jc(_$hash, tabIndex.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProductState')
          ..add('productVariants', productVariants)
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('sortBy', sortBy)
          ..add('sortOrder', sortOrder)
          ..add('productWithOptions', productWithOptions)
          ..add('categories', categories)
          ..add('products', products)
          ..add('fullProducts', fullProducts)
          ..add('modifiers', modifiers)
          ..add('productCombos', productCombos)
          ..add('allOptionAttributes', allOptionAttributes)
          ..add('tabIndex', tabIndex))
        .toString();
  }
}

class ProductStateBuilder
    implements Builder<ProductState, ProductStateBuilder> {
  _$ProductState? _$v;

  Map<String, List<StockProduct>>? _productVariants;
  Map<String, List<StockProduct>>? get productVariants =>
      _$this._productVariants;
  set productVariants(Map<String, List<StockProduct>>? productVariants) =>
      _$this._productVariants = productVariants;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  SortBy? _sortBy;
  SortBy? get sortBy => _$this._sortBy;
  set sortBy(SortBy? sortBy) => _$this._sortBy = sortBy;

  SortOrder? _sortOrder;
  SortOrder? get sortOrder => _$this._sortOrder;
  set sortOrder(SortOrder? sortOrder) => _$this._sortOrder = sortOrder;

  FullProduct? _productWithOptions;
  FullProduct? get productWithOptions => _$this._productWithOptions;
  set productWithOptions(FullProduct? productWithOptions) =>
      _$this._productWithOptions = productWithOptions;

  List<StockCategory>? _categories;
  List<StockCategory>? get categories => _$this._categories;
  set categories(List<StockCategory>? categories) =>
      _$this._categories = categories;

  List<StockProduct>? _products;
  List<StockProduct>? get products => _$this._products;
  set products(List<StockProduct>? products) => _$this._products = products;

  List<FullProduct>? _fullProducts;
  List<FullProduct>? get fullProducts => _$this._fullProducts;
  set fullProducts(List<FullProduct>? fullProducts) =>
      _$this._fullProducts = fullProducts;

  List<ProductModifier>? _modifiers;
  List<ProductModifier>? get modifiers => _$this._modifiers;
  set modifiers(List<ProductModifier>? modifiers) =>
      _$this._modifiers = modifiers;

  List<ProductCombo>? _productCombos;
  List<ProductCombo>? get productCombos => _$this._productCombos;
  set productCombos(List<ProductCombo>? productCombos) =>
      _$this._productCombos = productCombos;

  List<ProductOptionAttribute>? _allOptionAttributes;
  List<ProductOptionAttribute>? get allOptionAttributes =>
      _$this._allOptionAttributes;
  set allOptionAttributes(List<ProductOptionAttribute>? allOptionAttributes) =>
      _$this._allOptionAttributes = allOptionAttributes;

  int? _tabIndex;
  int? get tabIndex => _$this._tabIndex;
  set tabIndex(int? tabIndex) => _$this._tabIndex = tabIndex;

  ProductStateBuilder();

  ProductStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _productVariants = $v.productVariants;
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _sortBy = $v.sortBy;
      _sortOrder = $v.sortOrder;
      _productWithOptions = $v.productWithOptions;
      _categories = $v.categories;
      _products = $v.products;
      _fullProducts = $v.fullProducts;
      _modifiers = $v.modifiers;
      _productCombos = $v.productCombos;
      _allOptionAttributes = $v.allOptionAttributes;
      _tabIndex = $v.tabIndex;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductState other) {
    _$v = other as _$ProductState;
  }

  @override
  void update(void Function(ProductStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductState build() => _build();

  _$ProductState _build() {
    final _$result =
        _$v ??
        _$ProductState._(
          productVariants: productVariants,
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          sortBy: sortBy,
          sortOrder: sortOrder,
          productWithOptions: productWithOptions,
          categories: categories,
          products: products,
          fullProducts: BuiltValueNullFieldError.checkNotNull(
            fullProducts,
            r'ProductState',
            'fullProducts',
          ),
          modifiers: modifiers,
          productCombos: productCombos,
          allOptionAttributes: BuiltValueNullFieldError.checkNotNull(
            allOptionAttributes,
            r'ProductState',
            'allOptionAttributes',
          ),
          tabIndex: tabIndex,
        );
    replace(_$result);
    return _$result;
  }
}

class _$ProductsUIState extends ProductsUIState {
  @override
  final StockProduct? item;

  factory _$ProductsUIState([void Function(ProductsUIStateBuilder)? updates]) =>
      (ProductsUIStateBuilder()..update(updates))._build();

  _$ProductsUIState._({this.item}) : super._();
  @override
  ProductsUIState rebuild(void Function(ProductsUIStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductsUIStateBuilder toBuilder() => ProductsUIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductsUIState && item == other.item;
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
      r'ProductsUIState',
    )..add('item', item)).toString();
  }
}

class ProductsUIStateBuilder
    implements Builder<ProductsUIState, ProductsUIStateBuilder> {
  _$ProductsUIState? _$v;

  StockProduct? _item;
  StockProduct? get item => _$this._item;
  set item(StockProduct? item) => _$this._item = item;

  ProductsUIStateBuilder();

  ProductsUIStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _item = $v.item;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductsUIState other) {
    _$v = other as _$ProductsUIState;
  }

  @override
  void update(void Function(ProductsUIStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductsUIState build() => _build();

  _$ProductsUIState _build() {
    final _$result = _$v ?? _$ProductsUIState._(item: item);
    replace(_$result);
    return _$result;
  }
}

class _$ModifierUIState extends ModifierUIState {
  @override
  final ProductModifier? item;

  factory _$ModifierUIState([void Function(ModifierUIStateBuilder)? updates]) =>
      (ModifierUIStateBuilder()..update(updates))._build();

  _$ModifierUIState._({this.item}) : super._();
  @override
  ModifierUIState rebuild(void Function(ModifierUIStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ModifierUIStateBuilder toBuilder() => ModifierUIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ModifierUIState && item == other.item;
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
      r'ModifierUIState',
    )..add('item', item)).toString();
  }
}

class ModifierUIStateBuilder
    implements Builder<ModifierUIState, ModifierUIStateBuilder> {
  _$ModifierUIState? _$v;

  ProductModifier? _item;
  ProductModifier? get item => _$this._item;
  set item(ProductModifier? item) => _$this._item = item;

  ModifierUIStateBuilder();

  ModifierUIStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _item = $v.item;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ModifierUIState other) {
    _$v = other as _$ModifierUIState;
  }

  @override
  void update(void Function(ModifierUIStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ModifierUIState build() => _build();

  _$ModifierUIState _build() {
    final _$result = _$v ?? _$ModifierUIState._(item: item);
    replace(_$result);
    return _$result;
  }
}

class _$CategoriesUIState extends CategoriesUIState {
  @override
  final StockCategory? item;

  factory _$CategoriesUIState([
    void Function(CategoriesUIStateBuilder)? updates,
  ]) => (CategoriesUIStateBuilder()..update(updates))._build();

  _$CategoriesUIState._({this.item}) : super._();
  @override
  CategoriesUIState rebuild(void Function(CategoriesUIStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CategoriesUIStateBuilder toBuilder() =>
      CategoriesUIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CategoriesUIState && item == other.item;
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
      r'CategoriesUIState',
    )..add('item', item)).toString();
  }
}

class CategoriesUIStateBuilder
    implements Builder<CategoriesUIState, CategoriesUIStateBuilder> {
  _$CategoriesUIState? _$v;

  StockCategory? _item;
  StockCategory? get item => _$this._item;
  set item(StockCategory? item) => _$this._item = item;

  CategoriesUIStateBuilder();

  CategoriesUIStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _item = $v.item;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CategoriesUIState other) {
    _$v = other as _$CategoriesUIState;
  }

  @override
  void update(void Function(CategoriesUIStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CategoriesUIState build() => _build();

  _$CategoriesUIState _build() {
    final _$result = _$v ?? _$CategoriesUIState._(item: item);
    replace(_$result);
    return _$result;
  }
}

class _$CombosUIState extends CombosUIState {
  @override
  final ProductCombo? item;

  factory _$CombosUIState([void Function(CombosUIStateBuilder)? updates]) =>
      (CombosUIStateBuilder()..update(updates))._build();

  _$CombosUIState._({this.item}) : super._();
  @override
  CombosUIState rebuild(void Function(CombosUIStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CombosUIStateBuilder toBuilder() => CombosUIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CombosUIState && item == other.item;
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
      r'CombosUIState',
    )..add('item', item)).toString();
  }
}

class CombosUIStateBuilder
    implements Builder<CombosUIState, CombosUIStateBuilder> {
  _$CombosUIState? _$v;

  ProductCombo? _item;
  ProductCombo? get item => _$this._item;
  set item(ProductCombo? item) => _$this._item = item;

  CombosUIStateBuilder();

  CombosUIStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _item = $v.item;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CombosUIState other) {
    _$v = other as _$CombosUIState;
  }

  @override
  void update(void Function(CombosUIStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CombosUIState build() => _build();

  _$CombosUIState _build() {
    final _$result = _$v ?? _$CombosUIState._(item: item);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductState _$ProductStateFromJson(Map<String, dynamic> json) =>
    ProductState();

Map<String, dynamic> _$ProductStateToJson(ProductState instance) =>
    <String, dynamic>{};
