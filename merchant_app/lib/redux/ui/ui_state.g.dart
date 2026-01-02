// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UIState extends UIState {
  @override
  final String? settingUpText;
  @override
  final String? currentRoute;
  @override
  final String? previousRoute;
  @override
  final AuthUIState authUIState;
  @override
  final EmployeesUIState employeeUIState;
  @override
  final StoreUIState storeUIState;
  @override
  final BusinessUsersUIState businessUsersUIState;
  @override
  final CustomerUIState customerUIState;
  @override
  final SupplierUIState supplierUIState;
  @override
  final InventoryStockTakeUI stockTakeUI;
  @override
  final InventoryRecievableUI stockRecievableUI;
  @override
  final InvoiceUIState invoiceUIState;
  @override
  final ProductsUIState productsUIState;
  @override
  final ModifierUIState modifierUIState;
  @override
  final CategoriesUIState categoriesUIState;
  @override
  final CombosUIState combosUIState;
  @override
  final HomeUIState homeUIState;
  @override
  final BusinessExpensesUIState expensesUIState;
  @override
  final DiscountUIState discountUIState;
  @override
  final TicketUIState ticketUIState;
  @override
  final ErrorState errorState;

  factory _$UIState([void Function(UIStateBuilder)? updates]) =>
      (UIStateBuilder()..update(updates))._build();

  _$UIState._({
    this.settingUpText,
    this.currentRoute,
    this.previousRoute,
    required this.authUIState,
    required this.employeeUIState,
    required this.storeUIState,
    required this.businessUsersUIState,
    required this.customerUIState,
    required this.supplierUIState,
    required this.stockTakeUI,
    required this.stockRecievableUI,
    required this.invoiceUIState,
    required this.productsUIState,
    required this.modifierUIState,
    required this.categoriesUIState,
    required this.combosUIState,
    required this.homeUIState,
    required this.expensesUIState,
    required this.discountUIState,
    required this.ticketUIState,
    required this.errorState,
  }) : super._();
  @override
  UIState rebuild(void Function(UIStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UIStateBuilder toBuilder() => UIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UIState &&
        settingUpText == other.settingUpText &&
        currentRoute == other.currentRoute &&
        previousRoute == other.previousRoute &&
        authUIState == other.authUIState &&
        employeeUIState == other.employeeUIState &&
        storeUIState == other.storeUIState &&
        businessUsersUIState == other.businessUsersUIState &&
        customerUIState == other.customerUIState &&
        supplierUIState == other.supplierUIState &&
        stockTakeUI == other.stockTakeUI &&
        stockRecievableUI == other.stockRecievableUI &&
        invoiceUIState == other.invoiceUIState &&
        productsUIState == other.productsUIState &&
        modifierUIState == other.modifierUIState &&
        categoriesUIState == other.categoriesUIState &&
        combosUIState == other.combosUIState &&
        homeUIState == other.homeUIState &&
        expensesUIState == other.expensesUIState &&
        discountUIState == other.discountUIState &&
        ticketUIState == other.ticketUIState &&
        errorState == other.errorState;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, settingUpText.hashCode);
    _$hash = $jc(_$hash, currentRoute.hashCode);
    _$hash = $jc(_$hash, previousRoute.hashCode);
    _$hash = $jc(_$hash, authUIState.hashCode);
    _$hash = $jc(_$hash, employeeUIState.hashCode);
    _$hash = $jc(_$hash, storeUIState.hashCode);
    _$hash = $jc(_$hash, businessUsersUIState.hashCode);
    _$hash = $jc(_$hash, customerUIState.hashCode);
    _$hash = $jc(_$hash, supplierUIState.hashCode);
    _$hash = $jc(_$hash, stockTakeUI.hashCode);
    _$hash = $jc(_$hash, stockRecievableUI.hashCode);
    _$hash = $jc(_$hash, invoiceUIState.hashCode);
    _$hash = $jc(_$hash, productsUIState.hashCode);
    _$hash = $jc(_$hash, modifierUIState.hashCode);
    _$hash = $jc(_$hash, categoriesUIState.hashCode);
    _$hash = $jc(_$hash, combosUIState.hashCode);
    _$hash = $jc(_$hash, homeUIState.hashCode);
    _$hash = $jc(_$hash, expensesUIState.hashCode);
    _$hash = $jc(_$hash, discountUIState.hashCode);
    _$hash = $jc(_$hash, ticketUIState.hashCode);
    _$hash = $jc(_$hash, errorState.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UIState')
          ..add('settingUpText', settingUpText)
          ..add('currentRoute', currentRoute)
          ..add('previousRoute', previousRoute)
          ..add('authUIState', authUIState)
          ..add('employeeUIState', employeeUIState)
          ..add('storeUIState', storeUIState)
          ..add('businessUsersUIState', businessUsersUIState)
          ..add('customerUIState', customerUIState)
          ..add('supplierUIState', supplierUIState)
          ..add('stockTakeUI', stockTakeUI)
          ..add('stockRecievableUI', stockRecievableUI)
          ..add('invoiceUIState', invoiceUIState)
          ..add('productsUIState', productsUIState)
          ..add('modifierUIState', modifierUIState)
          ..add('categoriesUIState', categoriesUIState)
          ..add('combosUIState', combosUIState)
          ..add('homeUIState', homeUIState)
          ..add('expensesUIState', expensesUIState)
          ..add('discountUIState', discountUIState)
          ..add('ticketUIState', ticketUIState)
          ..add('errorState', errorState))
        .toString();
  }
}

class UIStateBuilder implements Builder<UIState, UIStateBuilder> {
  _$UIState? _$v;

  String? _settingUpText;
  String? get settingUpText => _$this._settingUpText;
  set settingUpText(String? settingUpText) =>
      _$this._settingUpText = settingUpText;

  String? _currentRoute;
  String? get currentRoute => _$this._currentRoute;
  set currentRoute(String? currentRoute) => _$this._currentRoute = currentRoute;

  String? _previousRoute;
  String? get previousRoute => _$this._previousRoute;
  set previousRoute(String? previousRoute) =>
      _$this._previousRoute = previousRoute;

  AuthUIStateBuilder? _authUIState;
  AuthUIStateBuilder get authUIState =>
      _$this._authUIState ??= AuthUIStateBuilder();
  set authUIState(AuthUIStateBuilder? authUIState) =>
      _$this._authUIState = authUIState;

  EmployeesUIStateBuilder? _employeeUIState;
  EmployeesUIStateBuilder get employeeUIState =>
      _$this._employeeUIState ??= EmployeesUIStateBuilder();
  set employeeUIState(EmployeesUIStateBuilder? employeeUIState) =>
      _$this._employeeUIState = employeeUIState;

  StoreUIStateBuilder? _storeUIState;
  StoreUIStateBuilder get storeUIState =>
      _$this._storeUIState ??= StoreUIStateBuilder();
  set storeUIState(StoreUIStateBuilder? storeUIState) =>
      _$this._storeUIState = storeUIState;

  BusinessUsersUIStateBuilder? _businessUsersUIState;
  BusinessUsersUIStateBuilder get businessUsersUIState =>
      _$this._businessUsersUIState ??= BusinessUsersUIStateBuilder();
  set businessUsersUIState(BusinessUsersUIStateBuilder? businessUsersUIState) =>
      _$this._businessUsersUIState = businessUsersUIState;

  CustomerUIStateBuilder? _customerUIState;
  CustomerUIStateBuilder get customerUIState =>
      _$this._customerUIState ??= CustomerUIStateBuilder();
  set customerUIState(CustomerUIStateBuilder? customerUIState) =>
      _$this._customerUIState = customerUIState;

  SupplierUIStateBuilder? _supplierUIState;
  SupplierUIStateBuilder get supplierUIState =>
      _$this._supplierUIState ??= SupplierUIStateBuilder();
  set supplierUIState(SupplierUIStateBuilder? supplierUIState) =>
      _$this._supplierUIState = supplierUIState;

  InventoryStockTakeUIBuilder? _stockTakeUI;
  InventoryStockTakeUIBuilder get stockTakeUI =>
      _$this._stockTakeUI ??= InventoryStockTakeUIBuilder();
  set stockTakeUI(InventoryStockTakeUIBuilder? stockTakeUI) =>
      _$this._stockTakeUI = stockTakeUI;

  InventoryRecievableUIBuilder? _stockRecievableUI;
  InventoryRecievableUIBuilder get stockRecievableUI =>
      _$this._stockRecievableUI ??= InventoryRecievableUIBuilder();
  set stockRecievableUI(InventoryRecievableUIBuilder? stockRecievableUI) =>
      _$this._stockRecievableUI = stockRecievableUI;

  InvoiceUIStateBuilder? _invoiceUIState;
  InvoiceUIStateBuilder get invoiceUIState =>
      _$this._invoiceUIState ??= InvoiceUIStateBuilder();
  set invoiceUIState(InvoiceUIStateBuilder? invoiceUIState) =>
      _$this._invoiceUIState = invoiceUIState;

  ProductsUIStateBuilder? _productsUIState;
  ProductsUIStateBuilder get productsUIState =>
      _$this._productsUIState ??= ProductsUIStateBuilder();
  set productsUIState(ProductsUIStateBuilder? productsUIState) =>
      _$this._productsUIState = productsUIState;

  ModifierUIStateBuilder? _modifierUIState;
  ModifierUIStateBuilder get modifierUIState =>
      _$this._modifierUIState ??= ModifierUIStateBuilder();
  set modifierUIState(ModifierUIStateBuilder? modifierUIState) =>
      _$this._modifierUIState = modifierUIState;

  CategoriesUIStateBuilder? _categoriesUIState;
  CategoriesUIStateBuilder get categoriesUIState =>
      _$this._categoriesUIState ??= CategoriesUIStateBuilder();
  set categoriesUIState(CategoriesUIStateBuilder? categoriesUIState) =>
      _$this._categoriesUIState = categoriesUIState;

  CombosUIStateBuilder? _combosUIState;
  CombosUIStateBuilder get combosUIState =>
      _$this._combosUIState ??= CombosUIStateBuilder();
  set combosUIState(CombosUIStateBuilder? combosUIState) =>
      _$this._combosUIState = combosUIState;

  HomeUIStateBuilder? _homeUIState;
  HomeUIStateBuilder get homeUIState =>
      _$this._homeUIState ??= HomeUIStateBuilder();
  set homeUIState(HomeUIStateBuilder? homeUIState) =>
      _$this._homeUIState = homeUIState;

  BusinessExpensesUIStateBuilder? _expensesUIState;
  BusinessExpensesUIStateBuilder get expensesUIState =>
      _$this._expensesUIState ??= BusinessExpensesUIStateBuilder();
  set expensesUIState(BusinessExpensesUIStateBuilder? expensesUIState) =>
      _$this._expensesUIState = expensesUIState;

  DiscountUIStateBuilder? _discountUIState;
  DiscountUIStateBuilder get discountUIState =>
      _$this._discountUIState ??= DiscountUIStateBuilder();
  set discountUIState(DiscountUIStateBuilder? discountUIState) =>
      _$this._discountUIState = discountUIState;

  TicketUIStateBuilder? _ticketUIState;
  TicketUIStateBuilder get ticketUIState =>
      _$this._ticketUIState ??= TicketUIStateBuilder();
  set ticketUIState(TicketUIStateBuilder? ticketUIState) =>
      _$this._ticketUIState = ticketUIState;

  ErrorStateBuilder? _errorState;
  ErrorStateBuilder get errorState =>
      _$this._errorState ??= ErrorStateBuilder();
  set errorState(ErrorStateBuilder? errorState) =>
      _$this._errorState = errorState;

  UIStateBuilder();

  UIStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _settingUpText = $v.settingUpText;
      _currentRoute = $v.currentRoute;
      _previousRoute = $v.previousRoute;
      _authUIState = $v.authUIState.toBuilder();
      _employeeUIState = $v.employeeUIState.toBuilder();
      _storeUIState = $v.storeUIState.toBuilder();
      _businessUsersUIState = $v.businessUsersUIState.toBuilder();
      _customerUIState = $v.customerUIState.toBuilder();
      _supplierUIState = $v.supplierUIState.toBuilder();
      _stockTakeUI = $v.stockTakeUI.toBuilder();
      _stockRecievableUI = $v.stockRecievableUI.toBuilder();
      _invoiceUIState = $v.invoiceUIState.toBuilder();
      _productsUIState = $v.productsUIState.toBuilder();
      _modifierUIState = $v.modifierUIState.toBuilder();
      _categoriesUIState = $v.categoriesUIState.toBuilder();
      _combosUIState = $v.combosUIState.toBuilder();
      _homeUIState = $v.homeUIState.toBuilder();
      _expensesUIState = $v.expensesUIState.toBuilder();
      _discountUIState = $v.discountUIState.toBuilder();
      _ticketUIState = $v.ticketUIState.toBuilder();
      _errorState = $v.errorState.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UIState other) {
    _$v = other as _$UIState;
  }

  @override
  void update(void Function(UIStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UIState build() => _build();

  _$UIState _build() {
    _$UIState _$result;
    try {
      _$result =
          _$v ??
          _$UIState._(
            settingUpText: settingUpText,
            currentRoute: currentRoute,
            previousRoute: previousRoute,
            authUIState: authUIState.build(),
            employeeUIState: employeeUIState.build(),
            storeUIState: storeUIState.build(),
            businessUsersUIState: businessUsersUIState.build(),
            customerUIState: customerUIState.build(),
            supplierUIState: supplierUIState.build(),
            stockTakeUI: stockTakeUI.build(),
            stockRecievableUI: stockRecievableUI.build(),
            invoiceUIState: invoiceUIState.build(),
            productsUIState: productsUIState.build(),
            modifierUIState: modifierUIState.build(),
            categoriesUIState: categoriesUIState.build(),
            combosUIState: combosUIState.build(),
            homeUIState: homeUIState.build(),
            expensesUIState: expensesUIState.build(),
            discountUIState: discountUIState.build(),
            ticketUIState: ticketUIState.build(),
            errorState: errorState.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'authUIState';
        authUIState.build();
        _$failedField = 'employeeUIState';
        employeeUIState.build();
        _$failedField = 'storeUIState';
        storeUIState.build();
        _$failedField = 'businessUsersUIState';
        businessUsersUIState.build();
        _$failedField = 'customerUIState';
        customerUIState.build();
        _$failedField = 'supplierUIState';
        supplierUIState.build();
        _$failedField = 'stockTakeUI';
        stockTakeUI.build();
        _$failedField = 'stockRecievableUI';
        stockRecievableUI.build();
        _$failedField = 'invoiceUIState';
        invoiceUIState.build();
        _$failedField = 'productsUIState';
        productsUIState.build();
        _$failedField = 'modifierUIState';
        modifierUIState.build();
        _$failedField = 'categoriesUIState';
        categoriesUIState.build();
        _$failedField = 'combosUIState';
        combosUIState.build();
        _$failedField = 'homeUIState';
        homeUIState.build();
        _$failedField = 'expensesUIState';
        expensesUIState.build();
        _$failedField = 'discountUIState';
        discountUIState.build();
        _$failedField = 'ticketUIState';
        ticketUIState.build();
        _$failedField = 'errorState';
        errorState.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'UIState',
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

class _$HomeUIState extends HomeUIState {
  @override
  final BusinessOverviewCount? overview;
  @override
  final ReportMode? mode;
  @override
  final bool? isLoading;
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final int? homeUIIndex;

  factory _$HomeUIState([void Function(HomeUIStateBuilder)? updates]) =>
      (HomeUIStateBuilder()..update(updates))._build();

  _$HomeUIState._({
    this.overview,
    this.mode,
    this.isLoading,
    this.hasError,
    this.errorMessage,
    this.homeUIIndex,
  }) : super._();
  @override
  HomeUIState rebuild(void Function(HomeUIStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HomeUIStateBuilder toBuilder() => HomeUIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HomeUIState &&
        overview == other.overview &&
        mode == other.mode &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        homeUIIndex == other.homeUIIndex;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, overview.hashCode);
    _$hash = $jc(_$hash, mode.hashCode);
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, homeUIIndex.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HomeUIState')
          ..add('overview', overview)
          ..add('mode', mode)
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('homeUIIndex', homeUIIndex))
        .toString();
  }
}

class HomeUIStateBuilder implements Builder<HomeUIState, HomeUIStateBuilder> {
  _$HomeUIState? _$v;

  BusinessOverviewCount? _overview;
  BusinessOverviewCount? get overview => _$this._overview;
  set overview(BusinessOverviewCount? overview) => _$this._overview = overview;

  ReportMode? _mode;
  ReportMode? get mode => _$this._mode;
  set mode(ReportMode? mode) => _$this._mode = mode;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  int? _homeUIIndex;
  int? get homeUIIndex => _$this._homeUIIndex;
  set homeUIIndex(int? homeUIIndex) => _$this._homeUIIndex = homeUIIndex;

  HomeUIStateBuilder();

  HomeUIStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _overview = $v.overview;
      _mode = $v.mode;
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _homeUIIndex = $v.homeUIIndex;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HomeUIState other) {
    _$v = other as _$HomeUIState;
  }

  @override
  void update(void Function(HomeUIStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HomeUIState build() => _build();

  _$HomeUIState _build() {
    final _$result =
        _$v ??
        _$HomeUIState._(
          overview: overview,
          mode: mode,
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          homeUIIndex: homeUIIndex,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
