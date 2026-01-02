import 'package:flutter/material.dart';
import 'package:littlefish_merchant/ui/business/expenses/pages/quick_refund_page.dart';
import 'package:littlefish_merchant/ui/checkout/layouts/sell_dashboard/dashboard_page.dart';
import 'package:littlefish_merchant/features/delete_account/presentation/pages/delete_account_page.dart';
import 'package:littlefish_merchant/features/invoicing/presentation/pages/invoice_create_page.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/pages/linked_devices_page.dart';
import 'package:littlefish_merchant/features/reports/reports_page.dart';
import 'package:littlefish_merchant/features/store_switching/presentation/pages/list_of_stores_page.dart';
import 'package:littlefish_merchant/features/store_switching/presentation/pages/store_added_successfully.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/pages/customer_sales_compare_report.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/pages/online_revenue_compare_report.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/pages/overview_compare_report.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/pages/payments_compare_report.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/pages/products_compare_report.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/pages/profits_compare_report.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/pages/revenue_compare_report.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/pages/staff_sales_compare_report.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/pages/tax_compare_report.dart';
import 'package:littlefish_merchant/ui/analysis/reports/sales/pages/customers_report_page.dart';
import 'package:littlefish_merchant/ui/analysis/reports/sales/pages/products_report_page.dart';
import 'package:littlefish_merchant/ui/analysis/reports/sales/pages/sales_report_page.dart';
import 'package:littlefish_merchant/ui/analytics/business_analytics_page.dart';
import 'package:littlefish_merchant/ui/business/employees/pages/employee_page.dart';
import 'package:littlefish_merchant/ui/business/employees/pages/employees_page.dart';
import 'package:littlefish_merchant/ui/business/expenses/pages/expense_page.dart';
import 'package:littlefish_merchant/ui/business/expenses/pages/expenses_page.dart';
import 'package:littlefish_merchant/ui/business/expenses/pages/refund_payment_method_page.dart';
import 'package:littlefish_merchant/ui/business/profile/pages/business_profile_create_page.dart';
import 'package:littlefish_merchant/ui/business/profile/pages/business_profile_page.dart';
import 'package:littlefish_merchant/ui/business/roles/pages/manage_roles_page.dart';
import 'package:littlefish_merchant/ui/business/users/pages/user_page.dart';
import 'package:littlefish_merchant/ui/business/users/pages/users_page.dart';
import 'package:littlefish_merchant/ui/checkout/layouts/sell_dashboard/print_batch_dialog.dart';
import 'package:littlefish_merchant/ui/checkout/layouts/sell_dashboard/print_last_receipt_dialog.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_discount_page.dart';
import 'package:littlefish_merchant/ui/checkout/layouts/library/select_products_page.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_charge_page.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_complete_page.dart';
import 'package:littlefish_merchant/ui/checkout/layouts/sell_dashboard/checkout_close_batch_dialog.dart';
import 'package:littlefish_merchant/ui/checkout/sell_page.dart';
import 'package:littlefish_merchant/ui/customers/credit_page.dart';
import 'package:littlefish_merchant/ui/customers/customers_page.dart';
import 'package:littlefish_merchant/ui/customers/pages/customer_edit_page.dart';
import 'package:littlefish_merchant/ui/customers/pages/customer_import_page.dart';
import 'package:littlefish_merchant/ui/customers/pages/customer_page.dart';
import 'package:littlefish_merchant/ui/finance/finance_page.dart';
import 'package:littlefish_merchant/ui/home/home_page.dart';
import 'package:littlefish_merchant/ui/inventory/grv/pages/stock_receivable_page.dart';
import 'package:littlefish_merchant/ui/inventory/grv/pages/stock_receivables_page.dart';
import 'package:littlefish_merchant/ui/inventory/stock_take/pages/stock_take_intro_page.dart';
import 'package:littlefish_merchant/ui/inventory/stock_take/pages/stock_take_list_page.dart';
import 'package:littlefish_merchant/ui/inventory/stock_take/pages/stock_take_page.dart';
import 'package:littlefish_merchant/ui/invoicing/invoice_page.dart';
import 'package:littlefish_merchant/ui/invoicing/invoice_select_page.dart';
import 'package:littlefish_merchant/ui/invoicing/invoices_page.dart';
import 'package:littlefish_merchant/ui/manage_users/pages/manage_users_page.dart';
import 'package:littlefish_merchant/ui/menus/inventory_menu_page.dart';
import 'package:littlefish_merchant/ui/menus/more_control_menu_page.dart';
import 'package:littlefish_merchant/ui/menus/orders_menu_page.dart';
import 'package:littlefish_merchant/ui/menus/product_menu_page.dart';
import 'package:littlefish_merchant/ui/offline/offline_page.dart';
import 'package:littlefish_merchant/ui/online_store/categories/store_categories_page.dart';
import 'package:littlefish_merchant/ui/online_store/categories/store_category_page.dart';
import 'package:littlefish_merchant/ui/online_store/online_store_router.dart';
import 'package:littlefish_merchant/ui/online_store/products/store_product_page.dart';
import 'package:littlefish_merchant/ui/online_store/promotions/pages/broadcasts/create_broadcast_page.dart';
import 'package:littlefish_merchant/ui/online_store/promotions/pages/featured/featured_store_page.dart';
import 'package:littlefish_merchant/ui/online_store/promotions/pages/posts/create_post_page.dart';
import 'package:littlefish_merchant/ui/online_store/promotions/pages/promotions/create_promotion_page.dart';
import 'package:littlefish_merchant/ui/online_store/promotions/promotions_index_screen.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/HomePage/online_store_main_home_page.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/HomePage/online_store_setup_home_page.dart';
import 'package:littlefish_merchant/ui/products/categories/widgets/product_categories_page.dart';
import 'package:littlefish_merchant/ui/products/combos/product_combos_page.dart';
import 'package:littlefish_merchant/ui/products/discounts/discounts_page.dart';
import 'package:littlefish_merchant/ui/products/discounts/pages/discount_page.dart';
import 'package:littlefish_merchant/ui/products/products/management/products_management_page.dart';
import 'package:littlefish_merchant/ui/products/products/management/stock_management_page.dart';
import 'package:littlefish_merchant/ui/products/product_discounts/pages/manage_product_discounts_page.dart';
import 'package:littlefish_merchant/ui/products/product_discounts/pages/product_discount_page.dart';
import 'package:littlefish_merchant/ui/products/products/pages/product_page.dart';
import 'package:littlefish_merchant/ui/products/products/products_page.dart';
import 'package:littlefish_merchant/ui/profile/user/pages/user_profile_page.dart';
import 'package:littlefish_merchant/ui/reports/customer_report/customer_statement_page.dart';
import 'package:littlefish_merchant/ui/reports/financial_statement/financial_statement_page.dart';
import 'package:littlefish_merchant/ui/reports/inventory_report/inventory_report_page.dart';
import 'package:littlefish_merchant/ui/reports/products/product_list_page.dart';
import 'package:littlefish_merchant/ui/reports/sales_by_product/pages/sales_by_product_report_page.dart';
import 'package:littlefish_merchant/ui/reports/store_credit_report/store_credit_report_page.dart';
import 'package:littlefish_merchant/ui/sales/sales_page.dart';
import 'package:littlefish_merchant/ui/security/no_access/security_not_allowed_page.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/add_linked_account_page.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/linked_acounts_page.dart';
import 'package:littlefish_merchant/ui/settings/pages/credit/store_credit_settings_page.dart';
import 'package:littlefish_merchant/ui/settings/pages/hardware/barcode_scanners/barcode_scanner_page.dart';
import 'package:littlefish_merchant/ui/settings/pages/hardware/printers/pages/printer_page.dart';
import 'package:littlefish_merchant/ui/settings/pages/hardware/printers/pages/printers_page.dart';
import 'package:littlefish_merchant/ui/settings/pages/loyalty/loyalty_settings_page.dart';
import 'package:littlefish_merchant/ui/settings/pages/orders/settings_orders_page.dart';
import 'package:littlefish_merchant/ui/settings/pages/payments/settings_payment_types.dart';
import 'package:littlefish_merchant/ui/settings/pages/permissions/settings_device_permissions_page.dart';
import 'package:littlefish_merchant/ui/settings/pages/tax/sales_tax_page.dart';
import 'package:littlefish_merchant/ui/settings/pages/tickets/ticket_settings_page.dart';
import 'package:littlefish_merchant/ui/settings/settings_page.dart';
import 'package:littlefish_merchant/ui/suppliers/supplier_page.dart';
import 'package:littlefish_merchant/ui/suppliers/suppliers_page.dart';
import 'package:littlefish_merchant/ui/tickets/tickets_page.dart';
import '../environment/environment_config.dart';
import '../features/invoicing/presentation/pages/invoice_landing_page.dart';
import '../features/order_fulfilment /presentation/pages/order_fulfillment_home_page.dart';
import '../features/payment_links/presentation/pages/create_payment_link_page.dart';
import '../features/payment_links/presentation/pages/get_paid_page.dart';
import '../features/payment_links/presentation/pages/payment_links_landing_page.dart';
import '../features/store_switching/presentation/pages/list_of_stores_login_flow_page.dart';
import '../ui/initial/initial_page.dart';
import '../ui/sales/pages/void_complete_page.dart';
import '../ui/security/login/login_page.dart';
import '../ui/security/login/landing_page.dart';
import '../ui/security/login/splash_page.dart';
import '../ui/online_store/orders/orders_home_page.dart';
import '../ui/security/login/login_intro_page.dart';

import '../ui/checkout/pages/checkout_quick_sale_page.dart';
import '../ui/sales/pages/refund_complete_page.dart';
import '../ui/security/registration/register_page.dart';
import 'app.dart';

Map<String, dynamic> allRoutes() {
  var state = AppVariables.store!.state;
  final sellNowModuleDisabled = state.enableNewSale == EnableOption.disabled;

  Map<String, dynamic> routes = {
    '/': const SplashPage(), //general
    SplashPage.route: const SplashPage(),
    LoginIntroPage.route: const LoginIntroPage(), //general
    HomePage.route: const HomePage(), //general
    SellPage.route: sellNowModuleDisabled ? const HomePage() : const SellPage(),
    SelectProductsPage.route:
        const SelectProductsPage(), //checkout product saleß
    CheckoutDiscountPage.route: const CheckoutDiscountPage(), //sales
    CheckoutCompletePage.route: const CheckoutCompletePage(), //sales
    RefundCompletePage.route: const RefundCompletePage(),
    CustomersPage.route: const CustomersPage(), //sales + customer
    StoreCreditPage.route: const StoreCreditPage(), //sales + customer
    CustomerPage.route: const CustomerPage(), //sales + customer
    CustomerEditPage.route: const CustomerEditPage(), //sales + customer
    SalesPage.route: const SalesPage(),
    CheckoutQuickSale.route: const CheckoutQuickSale(), //sales
    SettingsPage.route: const SettingsPage(), //settings
    SettingPaymentTypes.route: const SettingPaymentTypes(), //settings
    SalesTaxPage.route: const SalesTaxPage(), //settings
    TicketSettingsPage.route: const TicketSettingsPage(), //settings
    BusinessProfileCreatePage.route:
        const BusinessProfileCreatePage(), //business
    ProductsPage.route: const ProductsPage(), //products
    ProductsManagementPage.route:
        const ProductsManagementPage(), //products management overview
    StockManagementPage.route:
        const StockManagementPage(), //stock management overview
    ProductPage.route: const ProductPage(), //products
    CheckoutChargePage.route: const CheckoutChargePage(), //sales
    EmployeesPage.route: const EmployeesPage(), //employess
    EmployeePage.route: const EmployeePage(), //employess
    UsersPage.route: const UsersPage(), //users
    UserPage.route: const UserPage(), //users
    CustomerImportPage.route: const CustomerImportPage(), //customers
    StockTakePage.route: const StockTakePage(), //inventory
    StockTakeListPage.route: const StockTakeListPage(), //inventory
    ProductCategoriesPage.route: const ProductCategoriesPage(), //products
    // ProductModifiersPage.route: ProductModifiersPage(), //products
    ProductCombosPage.route: const ProductCombosPage(), //products
    PrintersPage.route: const PrintersPage(), //sales + settings
    // BarcodeScannerPage.route: BarcodeScannerPage(), //general routes
    SettingsOrdersPage.route: const SettingsOrdersPage(), //settings
    SettingsDevicePermissionsPage.route:
        const SettingsDevicePermissionsPage(), //settings
    SuppliersPage.route: const SuppliersPage(),
    SupplierPage.route: const SupplierPage(),
    InvoicesPage.route: const InvoicesPage(),
    InvoicePage.route: const InvoicePage(),
    StoreProductPage.route: const StoreProductPage(),
    BusinessProfilePage.route: const BusinessProfilePage(), //business

    NoInternetPage.route: const NoInternetPage(), //general

    ProductsMenuPage.route: const ProductsMenuPage(),
    InventoryMenuPage.route: const InventoryMenuPage(),
    SuppliersMenuPage.route: const SuppliersMenuPage(),
    DiscountsPage.route: const DiscountsPage(),
    ManageProductDiscountsPage.route: const ManageProductDiscountsPage(),
    InvoiceSelectPage.route: const InvoiceSelectPage(),
    ExpensesPage.route: const ExpensesPage(),
    ExpensePage.route: const ExpensePage(),
    RefundPaymentMethodPage.route: const RefundPaymentMethodPage(),

    StockReceivablesPage.route: const StockReceivablesPage(), //inventory
    StockReceivablePage.route: const StockReceivablePage(), //inventory
    StockIntroPage.route: const StockIntroPage(), //inventory

    ReportsPage.route: const ReportsPage(), //analytics
    SalesReportPage.route: const SalesReportPage(), //analytics
    CustomersReportPage.route: const CustomersReportPage(), //analytics
    ProductsReportPage.route: const ProductsReportPage(), //analytics
    DiscountPage.route: const DiscountPage(),
    ProductDiscountPage.route: const ProductDiscountPage(),
    UserProfilePage.route: const UserProfilePage(), //user
    HardwarePrinterPage.route: const HardwarePrinterPage(),
    LoyaltySettingsPage.route: const LoyaltySettingsPage(),
    LinkedAccountsPage.route: const LinkedAccountsPage(),
    //LinkedDevicesPage.route: LinkedDevicesPage(),
    AddLinkedAccountPage.route: const AddLinkedAccountPage(),
    BarcodeScannerPage.route: const BarcodeScannerPage(),
    DeleteAccountPage.route: const DeleteAccountPage(),
    DashboardPage.route: const DashboardPage(),
    CheckoutCloseBatchDialog.route: const CheckoutCloseBatchDialog(),

    StoreCreditSettingsPage.route: const StoreCreditSettingsPage(),
    BusinessAnalyticsPage.route: const BusinessAnalyticsPage(),

    //Reporting
    SalesByProductReport.route: const SalesByProductReport(),
    ProductListPage.route: const ProductListPage(),
    FinancialStatementPage.route: const FinancialStatementPage(),
    CustomerStatementPage.route: const CustomerStatementPage(),
    InventoryReportPage.route: const InventoryReportPage(),
    StoreCreditReportPage.route: const StoreCreditReportPage(),

    //Finance
    FinancePage.route: const FinancePage(),

    //Orders
    TicketsPage.route: const TicketsPage(),
    OrderFulfillmentHomePage.route: const OrderFulfillmentHomePage(),

    //Get Paid
    GetPaidPage.route: const GetPaidPage(),
    PaymentLinksLandingPage.route: const PaymentLinksLandingPage(),
    CreatePaymentLinksPage.route: const CreatePaymentLinksPage(),
    InvoiceLandingPage.route: const InvoiceLandingPage(),
    InvoiceCreatePage.route: const InvoiceCreatePage(),

    // chome.HomePage.route: chome.HomePage(),

    //BQ Reporting
    BqReportingComparePaymentsPage.route:
        const BqReportingComparePaymentsPage(),
    BqReportingCompareRevenuePage.route: const BqReportingCompareRevenuePage(),
    BqReportingCompareOnlineRevenuePage.route:
        const BqReportingCompareOnlineRevenuePage(),
    BqReportingCompareTaxPage.route: const BqReportingCompareTaxPage(),
    BqReportingCompareProfitsPage.route: const BqReportingCompareProfitsPage(),
    BqReportingCompareProductsPage.route:
        const BqReportingCompareProductsPage(),
    BqReportingCompareCustomerSalesPage.route:
        const BqReportingCompareCustomerSalesPage(),
    BqReportingCompareStaffSalesPage.route:
        const BqReportingCompareStaffSalesPage(),
    BqReportingCompareOverviewPage.route:
        const BqReportingCompareOverviewPage(),

    // Online Catalog
    OnlineStoreRouterPage.route: const OnlineStoreRouterPage(),
    OrdersHomePage.route: const OrdersHomePage(),
    OnlineStoreMainHomePage.route: const OnlineStoreMainHomePage(),
    OnlineStoreSetupHomePage.route: const OnlineStoreSetupHomePage(),

    StoreCategoriesPage.route: const StoreCategoriesPage(),
    StoreCategoryPage.route: const StoreCategoryPage(),
    CreateBroadcastPage.route: const CreateBroadcastPage(),
    FeaturedStorePage.route: const FeaturedStorePage(),
    CreatePostPage.route: const CreatePostPage(),
    CreatePromotionPage.route: const CreatePromotionPage(),
    PromotionsIndexScreen.route: const PromotionsIndexScreen(),
    MoreControlMenuPage.route: const MoreControlMenuPage(),
    ManageRolesPage.route: const ManageRolesPage(),
    ManageUsersPage.route: const ManageUsersPage(),
    VoidCompletePage.route: const VoidCompletePage(),
    LinkedDevicesPage.route: LinkedDevicesPage(),

    // Store switching
    StoreAddedSuccessfully.route: const StoreAddedSuccessfully(),
    ListOfStoresPage.route: const ListOfStoresPage(),
    ListOfStoresLoginFlowPage.route: const ListOfStoresLoginFlowPage(),

    QuickRefundPage.route: const QuickRefundPage(),
    PrintLastReceiptDialogue.route: const PrintLastReceiptDialogue(),
    PrintBatchDialogue.route: const PrintBatchDialogue(),
  };

  return routes;
}

Map bqReportingRoutes() {
  var routes = {
    BqReportingComparePaymentsPage.route:
        const BqReportingComparePaymentsPage(),
    BqReportingCompareRevenuePage.route: const BqReportingCompareRevenuePage(),
    BqReportingCompareOnlineRevenuePage.route:
        const BqReportingCompareOnlineRevenuePage(),
    BqReportingCompareTaxPage.route: const BqReportingCompareTaxPage(),
    BqReportingCompareProfitsPage.route: const BqReportingCompareProfitsPage(),
    BqReportingCompareProductsPage.route:
        const BqReportingCompareProductsPage(),
    BqReportingCompareCustomerSalesPage.route:
        const BqReportingCompareCustomerSalesPage(),
    BqReportingCompareStaffSalesPage.route:
        const BqReportingCompareStaffSalesPage(),
    BqReportingCompareOverviewPage.route:
        const BqReportingCompareOverviewPage(),
  };

  return routes;
}

Map<String, Widget> generalRoutes() {
  var routes = {
    '/': const SplashPage(),
    SplashPage.route: const SplashPage(),
    HomePage.route: const HomePage(),
    BarcodeScannerPage.route: const BarcodeScannerPage(),
    NoInternetPage.route: const NoInternetPage(),
    UserProfilePage.route: const UserProfilePage(),
  };

  return routes;
}

Map<String, Widget> salesRoutes() {
  var routes = {
    CheckoutCompletePage.route: const CheckoutCompletePage(),
    CheckoutChargePage.route: const CheckoutChargePage(),
    SellPage.route: const SellPage(),
    SelectProductsPage.route: const SelectProductsPage(),
    CheckoutDiscountPage.route: const CheckoutDiscountPage(),
    PrintersPage.route: const PrintersPage(),
    CustomersPage.route: const CustomersPage(),
    StoreCreditPage.route: const StoreCreditPage(),
    CustomerPage.route: const CustomerPage(),
    SalesPage.route: const SalesPage(),
    TicketsPage.route: const TicketsPage(),
  };

  return routes;
}

Map<String, Widget> customerRoutes() {
  var routes = {
    CustomersPage.route: const CustomersPage(),
    StoreCreditPage.route: const StoreCreditPage(),
    CustomerPage.route: const CustomerPage(),
    CustomerImportPage.route: const CustomerImportPage(),
    CustomerEditPage.route: const CustomerEditPage(),
  };

  return routes;
}

Map<String, Widget> financeRoutes() {
  var routes = {FinancePage.route: const FinancePage()};

  return routes;
}

Map<String, Widget> onlineStoreRoutes() {
  var routes = {
    OnlineStoreRouterPage.route: const OnlineStoreRouterPage(),
    OnlineStoreMainHomePage.route: const OnlineStoreMainHomePage(),
    OnlineStoreSetupHomePage.route: const OnlineStoreSetupHomePage(),
    StoreProductPage.route: const StoreProductPage(),
  };

  return routes;
}

Map<String, Widget> storeCreditRoutes() {
  var routes = {
    StoreCreditPage.route: const StoreCreditPage(),
    StoreCreditReportPage.route: const StoreCreditReportPage(),
  };

  return routes;
}

Map<String, Widget> settingsRoutes() {
  var routes = {
    SettingsPage.route: const SettingsPage(),
    SettingPaymentTypes.route: const SettingPaymentTypes(),
    SalesTaxPage.route: const SalesTaxPage(),
    TicketSettingsPage.route: const TicketSettingsPage(),
    PrintersPage.route: const PrintersPage(),
    SettingsOrdersPage.route: const SettingsOrdersPage(),
    SettingsDevicePermissionsPage.route: const SettingsDevicePermissionsPage(),
    StoreCreditSettingsPage.route: const StoreCreditSettingsPage(),
    LinkedAccountsPage.route: const LinkedAccountsPage(),
  };

  return routes;
}

Map<String, Widget> businessRoutes() {
  var routes = {
    BusinessProfileCreatePage.route: const BusinessProfileCreatePage(),
    BusinessProfilePage.route: const BusinessProfilePage(),
  };

  return routes;
}

Map<String, Widget> userRoutes() {
  var routes = {
    UsersPage.route: const UsersPage(),
    UserPage.route: const UserPage(),
    UserProfilePage.route: const UserProfilePage(),
  };

  return routes;
}

Map<String, Widget> supplierRoutes() {
  var routes = {
    SupplierPage.route: const SupplierPage(),
    SuppliersPage.route: const SuppliersPage(),
    SuppliersMenuPage.route: const SuppliersMenuPage(),
    InvoiceSelectPage.route: const InvoiceSelectPage(),
    InvoicePage.route: const InvoicePage(),
    InvoicesPage.route: const InvoicesPage(),
  };

  return routes;
}

Map<String, Widget> expensesRoutes() {
  var routes = {
    ExpensesPage.route: const ExpensesPage(),
    ExpensePage.route: const ExpensePage(),
    RefundPaymentMethodPage.route: const RefundPaymentMethodPage(),
  };

  return routes;
}

Map<String, Widget> employeeRoutes() {
  var routes = {
    EmployeesPage.route: const EmployeesPage(),
    EmployeePage.route: const EmployeePage(),
  };

  return routes;
}

Map<String, Widget> productRoutes() {
  var routes = {
    ProductsPage.route: const ProductsPage(),
    ProductPage.route: const ProductPage(),
    ProductCategoriesPage.route: const ProductCategoriesPage(),
    // ProductModifiersPage.route: ProductModifiersPage(),
    ProductCombosPage.route: const ProductCombosPage(),
    DiscountsPage.route: const DiscountsPage(),
    DiscountPage.route: const DiscountPage(),
    ProductDiscountPage.route: const ProductDiscountPage(),
  };

  return routes;
}

Map<String, Widget> inventoryRoutes() {
  var routes = {
    StockTakePage.route: const StockTakePage(),
    StockTakeListPage.route: const StockTakeListPage(),
    StockReceivablesPage.route: const StockReceivablesPage(),
    StockReceivablePage.route: const StockReceivablePage(),
  };

  return routes;
}

Map<String, Widget> analyticsRoutes() {
  var routes = {
    SalesReportPage.route: const SalesReportPage(),
    CustomersReportPage.route: const CustomersReportPage(),
    ProductsReportPage.route: const ProductsReportPage(),
    BusinessAnalyticsPage.route: const BusinessAnalyticsPage(),
  };

  return routes;
}

Map<String, WidgetBuilder> baseRoutes() => {
  InitialPage.route: (BuildContext context) => const InitialPage(),
  LandingPage.route: (BuildContext context) => const LandingPage(),
  LoginPage.route: (BuildContext context) => const LoginPage(),
  RegisterPage.route: (BuildContext context) => const RegisterPage(),
  OfflinePage.route: (BuildContext context) => const OfflinePage(),
  SecurityNotAllowedPage.route: (BuildContext context) =>
      const SecurityNotAllowedPage(),
  NoInternetPage.route: (BuildContext context) => const NoInternetPage(),
};
