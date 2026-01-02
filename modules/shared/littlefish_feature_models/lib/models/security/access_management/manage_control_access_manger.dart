import 'package:flutter/material.dart';
import 'package:littlefish_core/business/models/business_user.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/pages/linked_devices_page.dart';
import 'package:littlefish_merchant/features/reports/reports_page.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/ui/business/roles/pages/manage_roles_page.dart';

import '../../../app/app.dart';
import '../../../redux/app/app_state.dart';
import '../../../shared/constants/permission_name_constants.dart';
import '../../../tools/helpers.dart';
import '../../../ui/business/employees/pages/employees_page.dart';
import '../../../ui/business/expenses/pages/expenses_page.dart';
import '../../../ui/business/profile/pages/business_profile_page.dart';
import '../../../ui/customers/customers_page.dart';
import '../../../ui/manage_users/pages/manage_users_page.dart';
import '../../../ui/settings/pages/accounts/linked_acounts_page.dart';
import '../../../ui/settings/pages/payments/settings_payment_types.dart';
import '../../../ui/settings/pages/tax/sales_tax_page.dart';
import '../../../ui/settings/pages/tickets/ticket_settings_page.dart';
import 'module.dart';

class ManageControlAccessManager {
  List<ModuleMenuItem> menus = [];

  AppState state = AppVariables.store!.state;

  ManageControlAccessManager.fromPermissions(UserPermissions? permissions) {
    permissions ??= state.permissions;

    //Store Settings menu
    ModuleMenuItem storeSettingsMenu = ModuleMenuItem(
      allowOffline: false,
      name: 'Store Settings',
      description: 'Store details, staff, users, store credit. customers',
      icon: Icons.store,
      items: [
        if (userHasPermission(allowBusinessDetails))
          ModuleMenuItem(
            name: 'Store Details',
            route: BusinessProfilePage.route,
          ),
        if (userHasPermission(allowEmployee))
          ModuleMenuItem(name: 'Staff', route: EmployeesPage.route),
        if (userHasPermission(allowUser))
          ModuleMenuItem(name: 'Manage Users', route: ManageUsersPage.route),
        if (userHasPermission(allowRole))
          ModuleMenuItem(name: 'Manage Roles', route: ManageRolesPage.route),
        //Commented old Users/User Management Page to replace with new one
        if (userHasPermission(allowCustomer))
          ModuleMenuItem(name: 'Manage Customers', route: CustomersPage.route),
        //Code commented our as per pm's request since the feature is not yet available.
        // if (userHasPermission(allowStoreCredit))
        //   ModuleMenuItem(
        //     name: 'Store Credit',
        //     route: StoreCreditPage.route,
        //   ),
        if (userHasPermission(allowExpense))
          ModuleMenuItem(name: 'Expenses', route: ExpensesPage.route),
        if (userHasPermission(allowBusinessDetails))
          ModuleMenuItem(name: 'Tax', route: SalesTaxPage.route),
        if (userHasRole(administratorRoleName))
          ModuleMenuItem(
            name: 'Ticket Preferences',
            route: TicketSettingsPage.route,
          ),
        if (userHasPermission(allowBusinessDetails))
          ModuleMenuItem(
            name: 'Receipt Template',
            route: BusinessProfilePage.route,
          ),
      ],
    );

    late ModuleMenuItem reportingMenu = ModuleMenuItem(
      allowOffline: false,
      name: 'Reports',
      description:
          'Overview, sales report, products, stock, financial statements',
      icon: Icons.analytics,
      items: [ModuleMenuItem(name: 'Report Center', route: ReportsPage.route)],
    );

    //General Settings menu
    ModuleMenuItem generalSettingsMenu = ModuleMenuItem(
      allowOffline: false,
      name: 'General Settings',
      description:
          'Linked accounts, linked devices, payment types, about, '
          'privacy policy, terms & conditions, clear',
      icon: Icons.settings,
      items: [
        if (userHasPermission(allowPaymentTypesAndLinkedAccounts))
          ModuleMenuItem(
            name: 'Linked Accounts',
            route: LinkedAccountsPage.route,
          ),
        if (userHasPermission(allowPaymentTypesAndLinkedAccounts))
          ModuleMenuItem(
            name: 'Payment Types',
            route: SettingPaymentTypes.route,
          ),
        if ((AppVariables.store!.state.enableLinkedDevices ?? true) &&
            (userHasPermission(allowViewCurrentTerminal) ||
                userHasPermission(allowViewAllTerminals)))
          ModuleMenuItem(
            name: 'Linked Devices',
            route: LinkedDevicesPage.route,
          ),
        ModuleMenuItem(name: 'About', route: 'about'),
        ModuleMenuItem(name: 'Privacy Policy', route: 'privacy-policy'),
        ModuleMenuItem(name: 'Terms & Conditions', route: 't&cs'),
        ModuleMenuItem(name: 'Clear', route: 'clear-data'),
        if (AppVariables.store!.state.enableDeleteAccountPage == true)
          ModuleMenuItem(
            name: 'Delete Account',
            route: 'settings/delete-account',
          ),
        if (isSandbox) ModuleMenuItem(name: 'SandBox', route: 'sandbox'),
      ],
    );

    if (allStoreSettingsPermissionsDenied() == false) {
      menus.add(storeSettingsMenu);
    }

    if (allReportPermissionsDenied() == false) {
      menus.add(reportingMenu);
    }

    menus.add(generalSettingsMenu);
  }

  bool allReportPermissionsDenied() {
    if (userHasPermission(allowTransactionHistory)) {
      return false;
    }

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

  bool allStoreSettingsPermissionsDenied() {
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
