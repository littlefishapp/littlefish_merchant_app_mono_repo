// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StoreState extends StoreState {
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final bool? isLoading;
  @override
  final Store? store;
  @override
  final List<StoreProductCategory>? productCategories;
  @override
  final double? followerCount;
  @override
  final List<StoreProduct>? products;
  @override
  final List<CheckoutOrder>? orders;
  @override
  final List<StoreCustomer>? customers;
  @override
  final List<OrderStatus>? orderStatuses;
  @override
  final List<StoreProduct>? onsaleProducts;
  @override
  final List<StoreProduct>? featuredProducts;
  @override
  final List<StoreUser>? teamMembers;

  factory _$StoreState([void Function(StoreStateBuilder)? updates]) =>
      (StoreStateBuilder()..update(updates))._build();

  _$StoreState._({
    this.hasError,
    this.errorMessage,
    this.isLoading,
    this.store,
    this.productCategories,
    this.followerCount,
    this.products,
    this.orders,
    this.customers,
    this.orderStatuses,
    this.onsaleProducts,
    this.featuredProducts,
    this.teamMembers,
  }) : super._();
  @override
  StoreState rebuild(void Function(StoreStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StoreStateBuilder toBuilder() => StoreStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StoreState &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        isLoading == other.isLoading &&
        store == other.store &&
        productCategories == other.productCategories &&
        followerCount == other.followerCount &&
        products == other.products &&
        orders == other.orders &&
        customers == other.customers &&
        orderStatuses == other.orderStatuses &&
        onsaleProducts == other.onsaleProducts &&
        featuredProducts == other.featuredProducts &&
        teamMembers == other.teamMembers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, store.hashCode);
    _$hash = $jc(_$hash, productCategories.hashCode);
    _$hash = $jc(_$hash, followerCount.hashCode);
    _$hash = $jc(_$hash, products.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, customers.hashCode);
    _$hash = $jc(_$hash, orderStatuses.hashCode);
    _$hash = $jc(_$hash, onsaleProducts.hashCode);
    _$hash = $jc(_$hash, featuredProducts.hashCode);
    _$hash = $jc(_$hash, teamMembers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StoreState')
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('isLoading', isLoading)
          ..add('store', store)
          ..add('productCategories', productCategories)
          ..add('followerCount', followerCount)
          ..add('products', products)
          ..add('orders', orders)
          ..add('customers', customers)
          ..add('orderStatuses', orderStatuses)
          ..add('onsaleProducts', onsaleProducts)
          ..add('featuredProducts', featuredProducts)
          ..add('teamMembers', teamMembers))
        .toString();
  }
}

class StoreStateBuilder implements Builder<StoreState, StoreStateBuilder> {
  _$StoreState? _$v;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  Store? _store;
  Store? get store => _$this._store;
  set store(Store? store) => _$this._store = store;

  List<StoreProductCategory>? _productCategories;
  List<StoreProductCategory>? get productCategories =>
      _$this._productCategories;
  set productCategories(List<StoreProductCategory>? productCategories) =>
      _$this._productCategories = productCategories;

  double? _followerCount;
  double? get followerCount => _$this._followerCount;
  set followerCount(double? followerCount) =>
      _$this._followerCount = followerCount;

  List<StoreProduct>? _products;
  List<StoreProduct>? get products => _$this._products;
  set products(List<StoreProduct>? products) => _$this._products = products;

  List<CheckoutOrder>? _orders;
  List<CheckoutOrder>? get orders => _$this._orders;
  set orders(List<CheckoutOrder>? orders) => _$this._orders = orders;

  List<StoreCustomer>? _customers;
  List<StoreCustomer>? get customers => _$this._customers;
  set customers(List<StoreCustomer>? customers) =>
      _$this._customers = customers;

  List<OrderStatus>? _orderStatuses;
  List<OrderStatus>? get orderStatuses => _$this._orderStatuses;
  set orderStatuses(List<OrderStatus>? orderStatuses) =>
      _$this._orderStatuses = orderStatuses;

  List<StoreProduct>? _onsaleProducts;
  List<StoreProduct>? get onsaleProducts => _$this._onsaleProducts;
  set onsaleProducts(List<StoreProduct>? onsaleProducts) =>
      _$this._onsaleProducts = onsaleProducts;

  List<StoreProduct>? _featuredProducts;
  List<StoreProduct>? get featuredProducts => _$this._featuredProducts;
  set featuredProducts(List<StoreProduct>? featuredProducts) =>
      _$this._featuredProducts = featuredProducts;

  List<StoreUser>? _teamMembers;
  List<StoreUser>? get teamMembers => _$this._teamMembers;
  set teamMembers(List<StoreUser>? teamMembers) =>
      _$this._teamMembers = teamMembers;

  StoreStateBuilder();

  StoreStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _isLoading = $v.isLoading;
      _store = $v.store;
      _productCategories = $v.productCategories;
      _followerCount = $v.followerCount;
      _products = $v.products;
      _orders = $v.orders;
      _customers = $v.customers;
      _orderStatuses = $v.orderStatuses;
      _onsaleProducts = $v.onsaleProducts;
      _featuredProducts = $v.featuredProducts;
      _teamMembers = $v.teamMembers;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StoreState other) {
    _$v = other as _$StoreState;
  }

  @override
  void update(void Function(StoreStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StoreState build() => _build();

  _$StoreState _build() {
    final _$result =
        _$v ??
        _$StoreState._(
          hasError: hasError,
          errorMessage: errorMessage,
          isLoading: isLoading,
          store: store,
          productCategories: productCategories,
          followerCount: followerCount,
          products: products,
          orders: orders,
          customers: customers,
          orderStatuses: orderStatuses,
          onsaleProducts: onsaleProducts,
          featuredProducts: featuredProducts,
          teamMembers: teamMembers,
        );
    replace(_$result);
    return _$result;
  }
}

class _$StoreUIState extends StoreUIState {
  @override
  final bool? isLoading;
  @override
  final bool? isSearchingProducts;
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final StoreProductCategory? selectedCategory;
  @override
  final List<String>? subCategories;
  @override
  final String? selectedSubCategory;
  @override
  final Promotion? selectedPromotion;
  @override
  final List<StoreProduct>? categoryProducts;
  @override
  final List<StoreProduct>? subCategoryProducts;
  @override
  final List<StoreProductType>? storeProductTypeOptions;
  @override
  final List<List<StoreAttribute>>? storeAttributeOptions;
  @override
  final List<StoreProductType>? selectedStoreProductTypes;
  @override
  final List<StoreAttribute>? selectedStoreAttributes;
  @override
  final StoreSubtype? selectedStoreSubtype;
  @override
  final StoreType? selectedStoreType;
  @override
  final StoreProduct? item;
  @override
  final List<CheckoutOrder>? selectedOrders;
  @override
  final String? selectedOrderStatus;
  @override
  final int? selectedOrderIndex;
  @override
  final int? currentNavIndex;
  @override
  final SortBy? sortProductsBy;
  @override
  final SortOrder? sortProductsOrder;

  factory _$StoreUIState([void Function(StoreUIStateBuilder)? updates]) =>
      (StoreUIStateBuilder()..update(updates))._build();

  _$StoreUIState._({
    this.isLoading,
    this.isSearchingProducts,
    this.hasError,
    this.errorMessage,
    this.selectedCategory,
    this.subCategories,
    this.selectedSubCategory,
    this.selectedPromotion,
    this.categoryProducts,
    this.subCategoryProducts,
    this.storeProductTypeOptions,
    this.storeAttributeOptions,
    this.selectedStoreProductTypes,
    this.selectedStoreAttributes,
    this.selectedStoreSubtype,
    this.selectedStoreType,
    this.item,
    this.selectedOrders,
    this.selectedOrderStatus,
    this.selectedOrderIndex,
    this.currentNavIndex,
    this.sortProductsBy,
    this.sortProductsOrder,
  }) : super._();
  @override
  StoreUIState rebuild(void Function(StoreUIStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StoreUIStateBuilder toBuilder() => StoreUIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StoreUIState &&
        isLoading == other.isLoading &&
        isSearchingProducts == other.isSearchingProducts &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        selectedCategory == other.selectedCategory &&
        subCategories == other.subCategories &&
        selectedSubCategory == other.selectedSubCategory &&
        selectedPromotion == other.selectedPromotion &&
        categoryProducts == other.categoryProducts &&
        subCategoryProducts == other.subCategoryProducts &&
        storeProductTypeOptions == other.storeProductTypeOptions &&
        storeAttributeOptions == other.storeAttributeOptions &&
        selectedStoreProductTypes == other.selectedStoreProductTypes &&
        selectedStoreAttributes == other.selectedStoreAttributes &&
        selectedStoreSubtype == other.selectedStoreSubtype &&
        selectedStoreType == other.selectedStoreType &&
        item == other.item &&
        selectedOrders == other.selectedOrders &&
        selectedOrderStatus == other.selectedOrderStatus &&
        selectedOrderIndex == other.selectedOrderIndex &&
        currentNavIndex == other.currentNavIndex &&
        sortProductsBy == other.sortProductsBy &&
        sortProductsOrder == other.sortProductsOrder;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, isSearchingProducts.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, selectedCategory.hashCode);
    _$hash = $jc(_$hash, subCategories.hashCode);
    _$hash = $jc(_$hash, selectedSubCategory.hashCode);
    _$hash = $jc(_$hash, selectedPromotion.hashCode);
    _$hash = $jc(_$hash, categoryProducts.hashCode);
    _$hash = $jc(_$hash, subCategoryProducts.hashCode);
    _$hash = $jc(_$hash, storeProductTypeOptions.hashCode);
    _$hash = $jc(_$hash, storeAttributeOptions.hashCode);
    _$hash = $jc(_$hash, selectedStoreProductTypes.hashCode);
    _$hash = $jc(_$hash, selectedStoreAttributes.hashCode);
    _$hash = $jc(_$hash, selectedStoreSubtype.hashCode);
    _$hash = $jc(_$hash, selectedStoreType.hashCode);
    _$hash = $jc(_$hash, item.hashCode);
    _$hash = $jc(_$hash, selectedOrders.hashCode);
    _$hash = $jc(_$hash, selectedOrderStatus.hashCode);
    _$hash = $jc(_$hash, selectedOrderIndex.hashCode);
    _$hash = $jc(_$hash, currentNavIndex.hashCode);
    _$hash = $jc(_$hash, sortProductsBy.hashCode);
    _$hash = $jc(_$hash, sortProductsOrder.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StoreUIState')
          ..add('isLoading', isLoading)
          ..add('isSearchingProducts', isSearchingProducts)
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('selectedCategory', selectedCategory)
          ..add('subCategories', subCategories)
          ..add('selectedSubCategory', selectedSubCategory)
          ..add('selectedPromotion', selectedPromotion)
          ..add('categoryProducts', categoryProducts)
          ..add('subCategoryProducts', subCategoryProducts)
          ..add('storeProductTypeOptions', storeProductTypeOptions)
          ..add('storeAttributeOptions', storeAttributeOptions)
          ..add('selectedStoreProductTypes', selectedStoreProductTypes)
          ..add('selectedStoreAttributes', selectedStoreAttributes)
          ..add('selectedStoreSubtype', selectedStoreSubtype)
          ..add('selectedStoreType', selectedStoreType)
          ..add('item', item)
          ..add('selectedOrders', selectedOrders)
          ..add('selectedOrderStatus', selectedOrderStatus)
          ..add('selectedOrderIndex', selectedOrderIndex)
          ..add('currentNavIndex', currentNavIndex)
          ..add('sortProductsBy', sortProductsBy)
          ..add('sortProductsOrder', sortProductsOrder))
        .toString();
  }
}

class StoreUIStateBuilder
    implements Builder<StoreUIState, StoreUIStateBuilder> {
  _$StoreUIState? _$v;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _isSearchingProducts;
  bool? get isSearchingProducts => _$this._isSearchingProducts;
  set isSearchingProducts(bool? isSearchingProducts) =>
      _$this._isSearchingProducts = isSearchingProducts;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  StoreProductCategory? _selectedCategory;
  StoreProductCategory? get selectedCategory => _$this._selectedCategory;
  set selectedCategory(StoreProductCategory? selectedCategory) =>
      _$this._selectedCategory = selectedCategory;

  List<String>? _subCategories;
  List<String>? get subCategories => _$this._subCategories;
  set subCategories(List<String>? subCategories) =>
      _$this._subCategories = subCategories;

  String? _selectedSubCategory;
  String? get selectedSubCategory => _$this._selectedSubCategory;
  set selectedSubCategory(String? selectedSubCategory) =>
      _$this._selectedSubCategory = selectedSubCategory;

  Promotion? _selectedPromotion;
  Promotion? get selectedPromotion => _$this._selectedPromotion;
  set selectedPromotion(Promotion? selectedPromotion) =>
      _$this._selectedPromotion = selectedPromotion;

  List<StoreProduct>? _categoryProducts;
  List<StoreProduct>? get categoryProducts => _$this._categoryProducts;
  set categoryProducts(List<StoreProduct>? categoryProducts) =>
      _$this._categoryProducts = categoryProducts;

  List<StoreProduct>? _subCategoryProducts;
  List<StoreProduct>? get subCategoryProducts => _$this._subCategoryProducts;
  set subCategoryProducts(List<StoreProduct>? subCategoryProducts) =>
      _$this._subCategoryProducts = subCategoryProducts;

  List<StoreProductType>? _storeProductTypeOptions;
  List<StoreProductType>? get storeProductTypeOptions =>
      _$this._storeProductTypeOptions;
  set storeProductTypeOptions(
    List<StoreProductType>? storeProductTypeOptions,
  ) => _$this._storeProductTypeOptions = storeProductTypeOptions;

  List<List<StoreAttribute>>? _storeAttributeOptions;
  List<List<StoreAttribute>>? get storeAttributeOptions =>
      _$this._storeAttributeOptions;
  set storeAttributeOptions(
    List<List<StoreAttribute>>? storeAttributeOptions,
  ) => _$this._storeAttributeOptions = storeAttributeOptions;

  List<StoreProductType>? _selectedStoreProductTypes;
  List<StoreProductType>? get selectedStoreProductTypes =>
      _$this._selectedStoreProductTypes;
  set selectedStoreProductTypes(
    List<StoreProductType>? selectedStoreProductTypes,
  ) => _$this._selectedStoreProductTypes = selectedStoreProductTypes;

  List<StoreAttribute>? _selectedStoreAttributes;
  List<StoreAttribute>? get selectedStoreAttributes =>
      _$this._selectedStoreAttributes;
  set selectedStoreAttributes(List<StoreAttribute>? selectedStoreAttributes) =>
      _$this._selectedStoreAttributes = selectedStoreAttributes;

  StoreSubtype? _selectedStoreSubtype;
  StoreSubtype? get selectedStoreSubtype => _$this._selectedStoreSubtype;
  set selectedStoreSubtype(StoreSubtype? selectedStoreSubtype) =>
      _$this._selectedStoreSubtype = selectedStoreSubtype;

  StoreType? _selectedStoreType;
  StoreType? get selectedStoreType => _$this._selectedStoreType;
  set selectedStoreType(StoreType? selectedStoreType) =>
      _$this._selectedStoreType = selectedStoreType;

  StoreProduct? _item;
  StoreProduct? get item => _$this._item;
  set item(StoreProduct? item) => _$this._item = item;

  List<CheckoutOrder>? _selectedOrders;
  List<CheckoutOrder>? get selectedOrders => _$this._selectedOrders;
  set selectedOrders(List<CheckoutOrder>? selectedOrders) =>
      _$this._selectedOrders = selectedOrders;

  String? _selectedOrderStatus;
  String? get selectedOrderStatus => _$this._selectedOrderStatus;
  set selectedOrderStatus(String? selectedOrderStatus) =>
      _$this._selectedOrderStatus = selectedOrderStatus;

  int? _selectedOrderIndex;
  int? get selectedOrderIndex => _$this._selectedOrderIndex;
  set selectedOrderIndex(int? selectedOrderIndex) =>
      _$this._selectedOrderIndex = selectedOrderIndex;

  int? _currentNavIndex;
  int? get currentNavIndex => _$this._currentNavIndex;
  set currentNavIndex(int? currentNavIndex) =>
      _$this._currentNavIndex = currentNavIndex;

  SortBy? _sortProductsBy;
  SortBy? get sortProductsBy => _$this._sortProductsBy;
  set sortProductsBy(SortBy? sortProductsBy) =>
      _$this._sortProductsBy = sortProductsBy;

  SortOrder? _sortProductsOrder;
  SortOrder? get sortProductsOrder => _$this._sortProductsOrder;
  set sortProductsOrder(SortOrder? sortProductsOrder) =>
      _$this._sortProductsOrder = sortProductsOrder;

  StoreUIStateBuilder();

  StoreUIStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _isSearchingProducts = $v.isSearchingProducts;
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _selectedCategory = $v.selectedCategory;
      _subCategories = $v.subCategories;
      _selectedSubCategory = $v.selectedSubCategory;
      _selectedPromotion = $v.selectedPromotion;
      _categoryProducts = $v.categoryProducts;
      _subCategoryProducts = $v.subCategoryProducts;
      _storeProductTypeOptions = $v.storeProductTypeOptions;
      _storeAttributeOptions = $v.storeAttributeOptions;
      _selectedStoreProductTypes = $v.selectedStoreProductTypes;
      _selectedStoreAttributes = $v.selectedStoreAttributes;
      _selectedStoreSubtype = $v.selectedStoreSubtype;
      _selectedStoreType = $v.selectedStoreType;
      _item = $v.item;
      _selectedOrders = $v.selectedOrders;
      _selectedOrderStatus = $v.selectedOrderStatus;
      _selectedOrderIndex = $v.selectedOrderIndex;
      _currentNavIndex = $v.currentNavIndex;
      _sortProductsBy = $v.sortProductsBy;
      _sortProductsOrder = $v.sortProductsOrder;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StoreUIState other) {
    _$v = other as _$StoreUIState;
  }

  @override
  void update(void Function(StoreUIStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StoreUIState build() => _build();

  _$StoreUIState _build() {
    final _$result =
        _$v ??
        _$StoreUIState._(
          isLoading: isLoading,
          isSearchingProducts: isSearchingProducts,
          hasError: hasError,
          errorMessage: errorMessage,
          selectedCategory: selectedCategory,
          subCategories: subCategories,
          selectedSubCategory: selectedSubCategory,
          selectedPromotion: selectedPromotion,
          categoryProducts: categoryProducts,
          subCategoryProducts: subCategoryProducts,
          storeProductTypeOptions: storeProductTypeOptions,
          storeAttributeOptions: storeAttributeOptions,
          selectedStoreProductTypes: selectedStoreProductTypes,
          selectedStoreAttributes: selectedStoreAttributes,
          selectedStoreSubtype: selectedStoreSubtype,
          selectedStoreType: selectedStoreType,
          item: item,
          selectedOrders: selectedOrders,
          selectedOrderStatus: selectedOrderStatus,
          selectedOrderIndex: selectedOrderIndex,
          currentNavIndex: currentNavIndex,
          sortProductsBy: sortProductsBy,
          sortProductsOrder: sortProductsOrder,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
