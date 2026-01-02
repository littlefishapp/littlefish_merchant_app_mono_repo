import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core/business/models/business_user.dart';
import 'package:littlefish_merchant/features/order_fulfilment%20/presentation/pages/order_fulfillment_home_page.dart';
import 'package:littlefish_merchant/features/reports/reports_page.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/business/roles/pages/manage_roles_page.dart';
import 'package:littlefish_merchant/ui/checkout/sell_page.dart';
import 'package:littlefish_merchant/ui/products/product_discounts/pages/manage_product_discounts_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/app_routes.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/customer/customer_actions.dart';
import 'package:littlefish_merchant/redux/expenses/expenses_actions.dart';
import 'package:littlefish_merchant/redux/user/user_state.dart';
import 'package:littlefish_merchant/tools/hex_color.dart';
import 'package:littlefish_merchant/ui/analytics/business_analytics_page.dart';
import 'package:littlefish_merchant/ui/business/employees/pages/employees_page.dart';
import 'package:littlefish_merchant/ui/business/expenses/pages/expenses_page.dart';
import 'package:littlefish_merchant/ui/business/users/pages/users_page.dart';
import 'package:littlefish_merchant/ui/customers/credit_page.dart';
import 'package:littlefish_merchant/ui/customers/customers_page.dart';
import 'package:littlefish_merchant/ui/finance/finance_page.dart';
import 'package:littlefish_merchant/ui/home/home_page.dart';
import 'package:littlefish_merchant/ui/invoicing/invoices_page.dart';
import 'package:littlefish_merchant/ui/menus/inventory_menu_page.dart';
import 'package:littlefish_merchant/ui/menus/product_menu_page.dart';
import 'package:littlefish_merchant/ui/online_store/online_store_router.dart';
import 'package:littlefish_merchant/ui/products/categories/widgets/product_categories_page.dart';
import 'package:littlefish_merchant/ui/products/combos/product_combos_page.dart';
import 'package:littlefish_merchant/ui/products/discounts/discounts_page.dart';
import 'package:littlefish_merchant/ui/products/products/products_page.dart';
import 'package:littlefish_merchant/ui/reports/financial_statement/financial_statement_page.dart';
import 'package:littlefish_merchant/ui/reports/inventory_report/inventory_report_page.dart';
import 'package:littlefish_merchant/ui/reports/sales_by_product/pages/sales_by_product_report_page.dart';
import 'package:littlefish_merchant/ui/reports/store_credit_report/store_credit_report_page.dart';
import 'package:littlefish_merchant/ui/sales/sales_page.dart';
import 'package:littlefish_merchant/ui/settings/settings_page.dart';
import 'package:littlefish_merchant/ui/suppliers/suppliers_page.dart';
import '../../../environment/environment_config.dart';
import '../../../features/invoicing/presentation/pages/invoice_landing_page.dart';
import '../../../features/payment_links/presentation/pages/payment_links_landing_page.dart';
import '../../../injector.dart';
import '../../../redux/inventory/inventory_actions.dart';
import '../../../shared/constants/permission_name_constants.dart';
import '../../../ui/manage_users/pages/manage_users_page.dart';
import '../../../ui/products/products/pages/product_page.dart';
import '../../stock/stock_take_item.dart';

class AccessManager {
  List<Module> modules = [];

  List<ModuleMenuItem> shortcuts = [];

  AppState state = AppVariables.store!.state;

  AccessManager.fromPermissions(UserPermissions? permissions) {
    permissions ??= state.permissions;

    //Manage Business modules
    ModuleMenuItem bModuleMenu = ModuleMenuItem(
      allowOffline: false,
      name: 'Manage Business',
      items: [],
    );

    bool isGuest =
        (state.businessState.businessUsers
                ?.where(
                  (element) =>
                      element.uid == state.authState.userId &&
                      element.role == UserRoleType.guest,
                )
                .length ??
            0) >
        0;

    // Overview modules
    if (state.enableOverviewHomePage == true && isGuest == false) {
      modules.add(
        Module(
          name: 'General',
          routes: generalRoutes(),
          actions: [],
          menus: [
            ModuleMenuItem(
              name: 'Overview',
              icon: Icons.home,
              route: HomePage.route,
              userMode: UserViewingMode.all,
            ),
          ],
          module: ModuleType.general,
        ),
      );
    }

    //Sell Now modules
    final enableSellNowModule = state.enableNewSale != EnableOption.disabled;
    if (enableSellNowModule) {
      modules.add(
        Module(
          name: 'Sales Module',
          routes: salesRoutes(),
          actions: salesActions(),
          menus: [
            ModuleMenuItem(
              name: 'Sell Now',
              icon: Icons.shopping_cart,
              route: SellPage.route,
              key: GlobalKey(),
              userMode: UserViewingMode.all,
            ),
          ],
          module: ModuleType.sales,
        ),
      );
    }
    //add the shortcut to sales functions
    shortcuts.addAll(salesMenu());

    //Online Store modules
    // if ((permissions?.isAdmin ?? false) ||
    //     (permissions?.manageOnline ?? false))
    // {
    if (state.enableOnlineStore == true &&
        userHasPermission(allowOnlineStore) &&
        !isGuest) {
      var onlineStoreModule = Module(
        name: 'Online Store',
        routes: onlineStoreRoutes(),
        menus: onlineStoreMenu(),
        actions: onlineStoreActions(),
        module: ModuleType.businessManagement,
      );

      modules.add(onlineStoreModule);
      shortcuts.addAll(onlineStoreMenu());
    }

    //Transaction modules
    if (userHasPermission(allowTransactionHistory)) {
      var transactionsMenu = ModuleMenuItem(
        icon: Icons.history,
        name: 'Transactions',
        route: SalesPage.route,
        allowOffline: false,
        isShortCut: true,
        userMode: UserViewingMode.all,
      );

      bModuleMenu.items!.add(transactionsMenu);
      shortcuts.add(transactionsMenu);
    }

    //TODO: Surround this with the right permissions
    ModuleMenuItem getPaidModuleMenu = ModuleMenuItem(
      allowOffline: false,
      name: 'Get Paid',
      items: [],
    );

    //TODO: Surround this with the right permissions
    if (isGuest == false) {
      var paymentLinksMenu = ModuleMenuItem(
        icon: Icons.monetization_on_outlined,
        name: 'Payment Links',
        route: PaymentLinksLandingPage.route,
        allowOffline: false,
        isShortCut: true,
        userMode: UserViewingMode.all,
      );

      if (userHasPermission(allowPaymentLink) &&
          AppVariables.enablePaymentLinks) {
        getPaidModuleMenu.items!.add(paymentLinksMenu);
        shortcuts.add(paymentLinksMenu);
      }

      //TODO: Surround this with the right permissions

      var invoicesMenu = ModuleMenuItem(
        icon: Icons.bookmark_border_outlined,
        name: 'Invoices',
        route: InvoiceLandingPage.route,
        allowOffline: false,
        isShortCut: true,
        userMode: UserViewingMode.all,
      );

      if (userHasPermission(allowInvoice) && AppVariables.enableInvoices) {
        getPaidModuleMenu.items!.add(invoicesMenu);
        shortcuts.add(invoicesMenu);
      }
    }

    //Order fulfillment modules
    if (userHasPermission(allowOrder)) {
      var ordersMenu = ModuleMenuItem(
        icon: Icons.add_business_outlined,
        name: 'Orders',
        route: OrderFulfillmentHomePage.route,
        allowOffline: false,
        isShortCut: true,
        userMode: UserViewingMode.all,
      );

      bModuleMenu.items!.add(ordersMenu);
      shortcuts.add(ordersMenu);
    }

    // Expenses modules
    if (userHasPermission(allowExpense)) {
      var expensesModule = Module(
        name: 'Expenses Module',
        routes: expensesRoutes(),
        actions: expensesActions(),
        menus: expensesMenuCreate(),
        module: ModuleType.expenseManagement,
      );

      modules.add(expensesModule);
      bModuleMenu.items!.addAll(expensesMenu());
      shortcuts.addAll(expensesMenu());
    }

    // product management modules
    if (userHasPermission(allowProduct) && !isGuest) {
      var productsModule = Module(
        name: 'Products Module',
        routes: productRoutes(),
        actions: productActions(),
        menus: productsMenu(state, AppVariables.store!.state.viewMode),
        module: ModuleType.productManagement,
      );

      modules.add(productsModule);
      shortcuts.add(
        ModuleMenuItem(
          icon: Icons.library_books,
          name: 'Products & Services',
          route: ProductsPage.route,
          key: GlobalKey(),
        ),
      );
    }

    //Business Modules
    if ((allBusinessManagementPermissionDenied() == false)) {
      Module businessModule = Module(
        name: 'Business Module',
        menus: [bModuleMenu],
        actions: [],
        module: ModuleType.businessManagement,
      );
      modules.add(businessModule);
    }

    if (isGuest == false &&
        !allGetPaidPermissionsDenied() &&
        AppVariables.enableGetPaid) {
      //Get Paid Module
      Module getPaidModule = Module(
        name: 'Get Paid Module',
        menus: [getPaidModuleMenu],
        actions: [],
        module: ModuleType.getPaid,
      );
      modules.add(getPaidModule);
    }
    // customer modules
    if (userHasPermission(allowCustomer)) {
      bModuleMenu.items!.addAll(customersMenu(state));
      shortcuts.addAll(customersMenu(state));

      modules.add(
        Module(
          name: 'Customers Module',
          routes: customerRoutes(),
          actions: customerActions(),
          // menus: customersMenu(),
          module: ModuleType.customerManagement,
        ),
      );
    }

    //Employee modules
    if (AppVariables.enableEmployees) {
      {
        bModuleMenu.items!.addAll(employeeMenu());

        shortcuts.addAll(employeeMenu());

        modules.add(
          Module(
            name: 'Employees Module',
            routes: employeeRoutes(),
            actions: employeeActions(),
            // menus: employeeMenu(),
            module: ModuleType.employeeManagement,
          ),
        );
      }
    }

    // User modules
    if (userHasPermission(allowUser)) {
      {
        bModuleMenu.items!.addAll(usersMenu());

        shortcuts.addAll(usersMenu());

        modules.add(
          Module(
            name: 'Users Module',
            routes: userRoutes(),
            actions: userActions(),
            // menus: usersMenu(),
            module: ModuleType.userManagement,
          ),
        );
      }
    }
    //Roles module
    if ((userHasPermission(allowRole))) {
      bModuleMenu.items!.addAll(rolesMenu());

      shortcuts.addAll(rolesMenu());

      modules.add(
        Module(
          name: 'Roles Module',
          actions: rolesActions(),
          module: ModuleType.roleManagement,
        ),
      );
    }

    //Suppliers module
    if (state.enablesuppliersModule ?? true) {
      if (userHasPermission(allowSupplier)) {
        bModuleMenu.items!.addAll(supplierMenu());

        shortcuts.add(
          ModuleMenuItem(
            icon: MdiIcons.truckDelivery,
            name: 'Suppliers',
            route: SuppliersPage.route,
          ),
        );

        modules.add(
          Module(
            name: 'Suppliers Module',
            routes: supplierRoutes(),
            actions: supplierActions(),
            // menus: supplierMenu(),
            module: ModuleType.supplierManagement,
          ),
        );
      }
    }

    //Inventory module
    if (userHasPermission(allowInventoryStock)) {
      modules.add(
        Module(
          name: 'Inventory Module',
          routes: inventoryRoutes(),
          actions: inventoryActions(),
          menus: inventoryMenu(),
          module: ModuleType.inventoryManagement,
        ),
      );

      shortcuts.addAll(inventoryMenu());
    }

    //Finance module
    if (userHasPermission(allowReportOverview)) {
      if (state.enableFinance == true) {
        //available in the said region
        var financeModule = Module(
          name: 'Finance',
          module: ModuleType.finance,
          routes: financeRoutes(),
          menus: financeMenu(),
        );
        shortcuts.addAll(financeMenu());

        modules.add(financeModule);
      }
    }

    //Reporting modules
    if (allReportPermissionDenied() == false) {
      modules.add(
        Module(
          name: 'Reporting Module',
          menus: [
            ModuleMenuItem(
              name: 'Reports',
              icon: Icons.bar_chart,
              route: ReportsPage.route,
              key: GlobalKey(),
              userMode: UserViewingMode.all,
            ),
          ],

          // routes: inventoryRoutes(),
          // actions: inventoryActions(),
          // menus: reportMenu(state),
          module: ModuleType.analytics,
        ),
      );
    }

    // Settings modules
    modules.add(
      Module(
        name: 'Settings',
        routes: settingsRoutes(),
        actions: [],
        menus: settingsMenu(),
        module: ModuleType.businessManagement,
      ),
    );
  }

  //end of adding modules

  List<ModuleAction> getAllQuickActions() {
    List<ModuleAction> result = [];

    for (var m in modules) {
      if (m.actions == null || m.actions!.isEmpty) continue;

      if (!m.actions!.any((a) => a.isQuickAction!)) continue;

      if (m.actions != null) {
        result.addAll(m.actions!.where((a) => a.isQuickAction!));
      }
    }

    return result;
  }

  List<ModuleMenuItem> getAllMenuOptions() {
    List<ModuleMenuItem> result = [];

    var state = AppVariables.store!.state;

    for (var m in modules) {
      if (m.menus == null || m.menus!.isEmpty) continue;

      if (m.menus != null) {
        if (state.viewMode == UserViewingMode.full) {
          result.addAll(m.menus!);
        } else {
          for (var menu in m.menus!) {
            if (menu.userMode == UserViewingMode.all ||
                menu.userMode == state.viewMode) {
              result.add(menu);
            } else if (menu.items != null && menu.items!.isNotEmpty) {
              result.addAll(
                menu.items!.where(
                  (subMenu) =>
                      subMenu.userMode == UserViewingMode.all ||
                      subMenu.userMode == state.viewMode,
                ),
              );
            }
          }
        }
      }
    }

    return result;
  }

  List<ModuleMenuItem> getShortcuts() => shortcuts;

  bool allReportPermissionDenied() {
    if (userHasPermission(allowReportFinancialStatement)) {
      return false;
    }

    if (userHasPermission(allowReportStock)) {
      return false;
    }

    if (userHasPermission(allowReportProduct)) {
      return false;
    }

    if (userHasPermission(allowReportSale)) {
      return false;
    }

    if (userHasPermission(allowReportOverview)) {
      return false;
    }

    return true;
  }

  bool allBusinessManagementPermissionDenied() {
    if (userHasPermission(allowTransactionHistory)) {
      return false;
    }

    if (userHasPermission(allowBusinessDetails)) {
      return false;
    }

    if (userHasPermission(allowUser)) {
      return false;
    }

    if (userHasPermission(allowEmployee)) {
      return false;
    }

    if (userHasPermission(allowCustomer)) {
      return false;
    }

    if (userHasPermission(allowStoreCredit)) {
      return false;
    }

    if (userHasPermission(allowExpense)) {
      return false;
    }

    if (userHasPermission(allowSetAndGetParkedCart)) {
      return false;
    }

    return true;
  }
}

bool allGetPaidPermissionsDenied() {
  if (userHasPermission(allowInvoice)) {
    return false;
  }

  if (userHasPermission(allowPaymentLink)) {
    return false;
  }

  return true;
}

class Module {
  Module({this.actions, this.menus, this.module, this.name, this.routes});

  String? name;

  ModuleType? module;

  Map<String, Widget>? routes;

  List<ModuleMenuItem>? menus;

  List<ModuleAction>? actions;
}

enum ModuleType {
  general,
  businessManagement,
  customerManagement,
  employeeManagement,
  userManagement,
  roleManagement,
  productManagement,
  supplierManagement,
  inventoryManagement,
  analytics,
  sales,
  expenseManagement,
  finance,
  reporting,
  getPaid,
}

class ModuleMenuItem {
  String? name;

  String? description;

  bool allowOffline;

  IconData? icon;

  String? route;

  bool specialItem;

  bool isShortCut;

  List<ModuleMenuItem>? items;

  UserViewingMode userMode;

  Key? key;

  ModuleMenuItem({
    this.description,
    this.icon,
    this.name,
    this.route,
    this.allowOffline = false,
    this.items,
    this.specialItem = false,
    this.isShortCut = false,
    this.userMode = UserViewingMode.full,
    this.key,
  });

  @override
  String toString() {
    return '$name';
  }
}

class ModuleAction {
  bool? isQuickAction;

  bool allowOffline;

  String? name;

  IconData? icon;

  Color? color;

  bool overrideColor;

  String? route;

  Key? key;

  String iconString = '';

  Function(BuildContext context)? action;

  ModuleAction({
    this.color,
    this.icon,
    this.isQuickAction,
    this.name,
    this.route,
    this.action,
    this.overrideColor = false,
    this.allowOffline = false,
    this.iconString = '',
    this.key,
  });
}

//Finance

List<ModuleMenuItem> financeMenu() => <ModuleMenuItem>[
  ModuleMenuItem(
    icon: MdiIcons.handball,
    name: 'Finance',
    route: FinancePage.route,
  ),
];

//Reports / Dashboard
List<ModuleAction> analyticsActions() => <ModuleAction>[
  ModuleAction(
    color: HexColor('#faa521'),
    overrideColor: true,
    icon: Icons.bar_chart,
    isQuickAction: true,
    name: 'Reports',
    route: BusinessAnalyticsPage.route,
    allowOffline: false,
  ),
];

List<ModuleAction> onlineStoreActions() => <ModuleAction>[
  ModuleAction(
    overrideColor: true,
    icon: Icons.screen_search_desktop_outlined,
    isQuickAction: false,
    name: 'Online Store',
    route: OnlineStoreRouterPage.route,
    allowOffline: false,
  ),
];

List<ModuleAction> ordersActions() => <ModuleAction>[
  ModuleAction(
    overrideColor: true,
    icon: Icons.add_business_outlined,
    isQuickAction: false,
    name: 'Orders',
    route: OrderFulfillmentHomePage.route,
    allowOffline: false,
  ),
];

//SALES / CHECKOUT
List<ModuleAction> salesActions() => <ModuleAction>[
  ModuleAction(
    color: HexColor('#faa521'),
    overrideColor: true,
    icon: Icons.shopping_cart,
    isQuickAction: false,
    name: 'Sell Now',
    route: SellPage.route,
    allowOffline: true,
  ),
  if (userHasPermission(allowTransactionHistory))
    ModuleAction(
      color: Colors.red,
      icon: Icons.history,
      isQuickAction: false,
      name: 'Transactions',
      route: SalesPage.route,
      allowOffline: false,
    ),
];

List<ModuleMenuItem> salesMenu() => <ModuleMenuItem>[
  ModuleMenuItem(
    icon: Icons.shopping_cart,
    name: 'Sell Now',
    route: SellPage.route,
    allowOffline: true,
    specialItem: true,
    key: GlobalKey(),
  ),
];

//PRODUCT MANAGEMENT
List<ModuleAction> productActions() => <ModuleAction>[
  ModuleAction(
    color: Colors.blue,
    icon: MdiIcons.plus,
    isQuickAction: true,
    name: 'Add Product',
    route: ProductPage.route,
  ),
];

List<ModuleMenuItem> productsMenu(
  AppState state,
  UserViewingMode? viewingMode,
) => viewingMode == UserViewingMode.pointOfSale
    ? [
        ModuleMenuItem(
          icon: Icons.library_books,
          name: 'Products',
          route: ProductsPage.route,
          key: GlobalKey(),
          userMode: UserViewingMode.all,
        ),
      ]
    : <ModuleMenuItem>[
        ModuleMenuItem(
          name: 'Manage Items',
          route: ProductsMenuPage.route,
          key: GlobalKey(),
          items: [
            ModuleMenuItem(
              icon: Icons.library_books,
              name: 'Products',
              route: ProductsPage.route,
              userMode: UserViewingMode.all,
            ),
            ModuleMenuItem(
              icon: MdiIcons.tagMultiple,
              name: 'Categories',
              route: ProductCategoriesPage.route,
              userMode: UserViewingMode.all,
            ),
            if (state.enableAdvancedReporting == true)
              ModuleMenuItem(
                icon: Icons.developer_board,
                name: 'Combos',
                route: ProductCombosPage.route,
                userMode: UserViewingMode.all,
              ),
            // ModuleMenuItem(
            //   icon: Icons.track_changes,
            //   name: "Modifiers",
            //   route: ProductModifiersPage.route,
            //   userMode: UserViewingMode.all,
            // ),
            if (AppVariables.store!.state.enableDiscounts == true)
              if (AppVariables.store!.state.permissions?.giveDiscounts ==
                      true &&
                  userHasPermission(allowDiscountOnProduct))
                ModuleMenuItem(
                  icon: Icons.low_priority,
                  name: 'Product Discounts',
                  route: ManageProductDiscountsPage.route,
                  userMode: UserViewingMode.all,
                ),
            if (AppVariables.store!.state.enableDiscountSettings == true &&
                userHasPermission(allowDiscountSettings))
              ModuleMenuItem(
                icon: Icons.low_priority,
                name: 'Discounts',
                route: DiscountsPage.route,
                userMode: UserViewingMode.all,
              ),
          ],
        ),
      ];

//CUSTOMER MANAGEMENT
List<ModuleAction> customerActions() => <ModuleAction>[
  ModuleAction(
    color: Colors.orange,
    icon: Icons.person_add,
    isQuickAction: false,
    name: 'New Customer',
    action: (context) => StoreProvider.of<AppState>(
      context,
    ).dispatch(createCustomer(context: context)),
  ),
  ModuleAction(
    color: Colors.red,
    icon: Icons.people,
    isQuickAction: false,
    name: 'Customers',
    route: CustomersPage.route,
  ),
];

List<ModuleMenuItem> customersMenu(AppState state) => <ModuleMenuItem>[
  ModuleMenuItem(
    icon: Icons.people,
    name: 'Customers',
    route: CustomersPage.route,
    userMode: UserViewingMode.all,
  ),
  if (state.enableStoreCredit == true)
    ModuleMenuItem(
      icon: Icons.credit_card,
      name: 'Store Credit',
      route: StoreCreditPage.route,
      userMode: UserViewingMode.all,
    ),
];

List<ModuleMenuItem> creditMenu(AppState state) => <ModuleMenuItem>[
  if (state.enableStoreCredit == true)
    ModuleMenuItem(
      icon: Icons.credit_card,
      name: 'Store Credit',
      route: StoreCreditPage.route,
      userMode: UserViewingMode.all,
    ),
];

//EMPLOYEE MANAGEMENT
List<ModuleAction> employeeActions() => <ModuleAction>[
  ModuleAction(
    color: Colors.red,
    icon: MdiIcons.badgeAccount,
    isQuickAction: false,
    name: 'Employees',
    route: EmployeesPage.route,
  ),
];

List<ModuleMenuItem> employeeMenu() => <ModuleMenuItem>[
  ModuleMenuItem(
    icon: MdiIcons.badgeAccount,
    name: 'Employees',
    route: EmployeesPage.route,
    userMode: UserViewingMode.full,
  ),
];

//USER MANAGEMENT
List<ModuleAction> userActions() => <ModuleAction>[
  ModuleAction(
    color: Colors.red,
    icon: MdiIcons.badgeAccountHorizontal,
    isQuickAction: false,
    name: 'Users',
    route: UsersPage.route,
  ),
];

List<ModuleMenuItem> usersMenu() => <ModuleMenuItem>[
  ModuleMenuItem(
    icon: MdiIcons.badgeAccountHorizontal,
    name: 'Users',
    //route: UsersPage.route,
    route: ManageUsersPage.route,
    userMode: UserViewingMode.all,
  ),
];

List<ModuleAction> rolesActions() => <ModuleAction>[
  ModuleAction(
    color: Colors.red,
    icon: MdiIcons.monitorAccount,
    isQuickAction: false,
    name: 'Roles',
    route: ManageRolesPage.route,
  ),
];

List<ModuleMenuItem> rolesMenu() => <ModuleMenuItem>[
  ModuleMenuItem(
    icon: MdiIcons.monitorAccount,
    name: 'Roles',
    route: ManageRolesPage.route,
    userMode: UserViewingMode.all,
  ),
];

//SUPPLIER MANAGEMENT
List<ModuleAction> supplierActions() => <ModuleAction>[
  ModuleAction(
    color: Colors.red,
    icon: MdiIcons.truckDelivery,
    isQuickAction: false,
    name: 'Suppliers',
    route: SuppliersPage.route,
  ),
  ModuleAction(
    color: Colors.red,
    icon: MdiIcons.receipt,
    isQuickAction: false,
    name: 'Invoices',
    route: InvoicesPage.route,
  ),
];

List<ModuleMenuItem> supplierMenu() => <ModuleMenuItem>[
  ModuleMenuItem(
    icon: MdiIcons.truckDelivery,
    name: 'Suppliers',
    route: SuppliersPage.route,
    userMode: UserViewingMode.full,
  ),
  ModuleMenuItem(
    icon: MdiIcons.receipt,
    name: 'Supplier Invoices',
    route: InvoicesPage.route,
    userMode: UserViewingMode.full,
  ),
];

//SUPPLIER MANAGEMENT
List<ModuleAction> expensesActions() => <ModuleAction>[
  ModuleAction(
    color: Colors.orange,
    icon: MdiIcons.accountCash,
    isQuickAction: false,
    name: 'New Expense',
    action: (context) =>
        StoreProvider.of<AppState>(context).dispatch(createExpense(context)),
  ),
  ModuleAction(
    color: Colors.red,
    icon: MdiIcons.accountCash,
    isQuickAction: false,
    name: 'Expenses',
    route: ExpensesPage.route,
  ),
];

List<ModuleMenuItem> expensesMenuCreate() => <ModuleMenuItem>[
  // ModuleMenuItem(
  //   icon: MdiIcons.accountCash,
  //   name: "New Expense",
  //   route: ExpensePage.route,
  // ),
];

List<ModuleMenuItem> expensesMenu() => <ModuleMenuItem>[
  ModuleMenuItem(
    icon: MdiIcons.accountCash,
    name: 'Expenses',
    route: ExpensesPage.route,
    userMode: UserViewingMode.full,
  ),
];

//Inventory Routes
List<ModuleAction> inventoryActions() => <ModuleAction>[
  if (AppVariables.store!.state.enableReceivedStock ?? false)
    ModuleAction(
      color: Colors.blue,
      icon: MdiIcons.truckOutline,
      isQuickAction: false,
      name: 'Receive Stock',
      action: (context) => StoreProvider.of<AppState>(
        context,
      ).dispatch(newGoodsRecievable(context)),
    ),
  if (AppVariables.store!.state.enableStockTake ?? true)
    ModuleAction(
      color: Colors.red,
      icon: MdiIcons.clipboardCheckOutline,
      isQuickAction: true,
      name: 'Stock Take',
      action: (context) => StoreProvider.of<AppState>(
        context,
      ).dispatch(newStockTake(context: context, type: StockRunType.reCount)),
    ),
];

List<ModuleMenuItem> inventoryMenu() => <ModuleMenuItem>[
  ModuleMenuItem(
    icon: MdiIcons.cupboard,
    name: 'Stock',
    route: InventoryMenuPage.route,
    userMode: UserViewingMode.all,
  ),
];

//Analytics

List<ModuleMenuItem> analyticsMenu() => <ModuleMenuItem>[
  ModuleMenuItem(
    icon: Icons.developer_board,
    name: 'Overview',
    allowOffline: false,
    route: BusinessAnalyticsPage.route,
    userMode: UserViewingMode.all,
  ),
];

//Reports
List<ModuleMenuItem> reportMenu(AppState state) => <ModuleMenuItem>[
  ModuleMenuItem(
    icon: MdiIcons.cupboard,
    name: 'Reporting',
    key: GlobalKey(),
    items: [
      if (userHasPermission(allowReportOverview))
        ModuleMenuItem(
          icon: Icons.developer_board,
          name: 'Overview',
          allowOffline: false,
          route: BusinessAnalyticsPage.route,
          userMode: UserViewingMode.all,
        ),
      if (userHasPermission(allowReportSale))
        ModuleMenuItem(
          icon: Icons.point_of_sale,
          route: SalesByProductReport.route,
          name: 'Sales Report',
          userMode: UserViewingMode.full,
        ),
      if (userHasPermission(allowReportStock))
        ModuleMenuItem(
          icon: Icons.add_shopping_cart,
          route: InventoryReportPage.route,
          name: 'Stock',
          userMode: UserViewingMode.full,
        ),
      if (state.enableStoreCredit == true &&
          userHasPermission(allowStoreCredit))
        ModuleMenuItem(
          icon: Icons.payment,
          route: StoreCreditReportPage.route,
          name: 'Store Credit',
          userMode: UserViewingMode.full,
        ),
      if (state.enableFinancialStatements == true &&
          userHasPermission(allowReportFinancialStatement))
        ModuleMenuItem(
          icon: Icons.attach_money,
          route: FinancialStatementPage.route,
          name: 'Financial Statement',
          userMode: UserViewingMode.full,
        ),
    ],
  ),
];

//SETTINGS MANAGEMENT

List<ModuleMenuItem> settingsMenu() => <ModuleMenuItem>[
  ModuleMenuItem(
    icon: Icons.settings,
    name: 'Settings',
    route: SettingsPage.route,
    userMode: UserViewingMode.all,
  ),
];

//SETTINGS MANAGEMENT
List<ModuleMenuItem> onlineStoreMenu() => <ModuleMenuItem>[
  ModuleMenuItem(
    icon: Icons.screen_search_desktop_outlined,
    name: 'Online Store',
    route: OnlineStoreRouterPage.route,
    userMode: UserViewingMode.all,
  ),
];
