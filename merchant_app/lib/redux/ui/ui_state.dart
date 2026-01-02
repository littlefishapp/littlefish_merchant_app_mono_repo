import 'package:flutter/foundation.dart';
import 'package:built_value/built_value.dart';
import 'package:littlefish_merchant/features/errors/presentation/redux/error_state.dart';
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/redux/auth/auth_state.dart';
import 'package:littlefish_merchant/redux/business/business_state.dart';
import 'package:littlefish_merchant/redux/customer/customer_state.dart';
import 'package:littlefish_merchant/redux/discounts/discounts_state.dart';
import 'package:littlefish_merchant/redux/expenses/expenses_state.dart';
import 'package:littlefish_merchant/redux/inventory/inventory_state.dart';
import 'package:littlefish_merchant/redux/invoice/invoice_state.dart';
import 'package:littlefish_merchant/redux/product/product_state.dart';
import 'package:littlefish_merchant/redux/store/store_state.dart';
import 'package:littlefish_merchant/redux/suppliers/supplier_state.dart';
import 'package:littlefish_merchant/redux/tickets/ticket_state.dart';

part 'ui_state.g.dart';

@immutable
abstract class UIState implements Built<UIState, UIStateBuilder> {
  const UIState._();

  factory UIState() => _$UIState._(
    employeeUIState: EmployeesUIState(),
    customerUIState: CustomerUIState(),
    supplierUIState: SupplierUIState(),
    stockTakeUI: InventoryStockTakeUI(),
    authUIState: AuthUIState(),
    invoiceUIState: InvoiceUIState(),
    stockRecievableUI: InventoryRecievableUI(),
    businessUsersUIState: BusinessUsersUIState(),
    productsUIState: ProductsUIState(),
    modifierUIState: ModifierUIState(),
    categoriesUIState: CategoriesUIState(),
    combosUIState: CombosUIState(),
    homeUIState: HomeUIState(),
    expensesUIState: BusinessExpensesUIState(),
    discountUIState: DiscountUIState(),
    ticketUIState: TicketUIState(),
    storeUIState: StoreUIState(),
    errorState: ErrorState(),
    // hardwareUIState: HardwareUIStateState(),
  );

  String? get settingUpText;

  String? get currentRoute;

  String? get previousRoute;

  AuthUIState get authUIState;

  EmployeesUIState get employeeUIState;

  StoreUIState get storeUIState;

  BusinessUsersUIState get businessUsersUIState;

  CustomerUIState get customerUIState;

  SupplierUIState get supplierUIState;

  InventoryStockTakeUI get stockTakeUI;

  InventoryRecievableUI get stockRecievableUI;

  InvoiceUIState get invoiceUIState;

  ProductsUIState get productsUIState;

  ModifierUIState get modifierUIState;

  CategoriesUIState get categoriesUIState;

  CombosUIState get combosUIState;

  HomeUIState get homeUIState;

  BusinessExpensesUIState get expensesUIState;

  DiscountUIState get discountUIState;

  TicketUIState get ticketUIState;

  ErrorState get errorState;

  // @nullable
  // HardwareUIStateState get hardwareUIState;
}

@immutable
abstract class HomeUIState implements Built<HomeUIState, HomeUIStateBuilder> {
  const HomeUIState._();

  factory HomeUIState() => _$HomeUIState._(
    overview: BusinessOverviewCount(),
    isLoading: false,
    hasError: false,
    errorMessage: null,
    mode: ReportMode.day,
    homeUIIndex: 0,
  );

  BusinessOverviewCount? get overview;
  ReportMode? get mode;
  bool? get isLoading;
  bool? get hasError;
  String? get errorMessage;
  int? get homeUIIndex;
}
