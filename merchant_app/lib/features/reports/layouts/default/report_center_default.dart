import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/environment/environment_config.dart';
import 'package:littlefish_merchant/models/security/access_management/module.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/features/reports/shared/report_center_vm.dart';
import 'package:littlefish_merchant/shared/constants/permission_name_constants.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/analytics/business_analytics_page.dart';
import 'package:littlefish_merchant/ui/reports/financial_statement/financial_statement_page.dart';
import 'package:littlefish_merchant/ui/reports/inventory_report/inventory_report_page.dart';
import 'package:littlefish_merchant/ui/reports/sales_by_product/pages/sales_by_product_report_page.dart';
import 'package:littlefish_merchant/ui/sales/sales_page.dart';

class ReportCenterDefaultPage extends StatelessWidget {
  static const String route = 'reports/report-center-default';

  const ReportCenterDefaultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Report Center',
      displayAppBar: true,
      centreTitle: false,
      hasDrawer: AppVariables.store!.state.enableSideNavDrawer!,
      displayNavDrawer: AppVariables.store!.state.enableSideNavDrawer!,
      body: Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.topCenter,
        child: StoreConnector<AppState, ReportCenterVM>(
          converter: (store) => ReportCenterVM.fromStore(store),
          builder: (context, vm) {
            final items = getOptions(vm.state!);

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return getMenuItem(context, item);
              },
            );
          },
        ),
      ),
    );
  }

  ListTile getMenuItem(BuildContext context, ModuleMenuItem item) {
    return ListTile(
      title: Text(item.name ?? 'Unknown'),
      subtitle: Text(item.description ?? ''),
      trailing: Icon(
        Platform.isIOS ? Icons.arrow_forward_ios : Icons.arrow_forward,
      ),
      onTap: () {
        if (item.route != null) {
          Navigator.of(context).pushNamed(item.route ?? '.');
        }
      },
    );
  }

  List<ModuleMenuItem> getOptions(AppState state) {
    final enableTransactionsV2 =
        state.enableTransactions != EnableOption.enabledForV2;
    final enableTransactionsV1 =
        state.enableTransactions != EnableOption.enabledForV1;

    return [
      if (userHasPermission(allowReportOverview))
        ModuleMenuItem(
          name: 'Overview',
          description: 'View your business performance',
          route: BusinessAnalyticsPage.route,
        ),
      if (userHasPermission(allowReportSale))
        ModuleMenuItem(
          name: 'Sales Report',
          description: 'View your sales performance',
          route: SalesByProductReport.route,
        ),
      if (userHasPermission(allowReportStock))
        ModuleMenuItem(
          name: 'Stock',
          description: 'View your stock',
          route: InventoryReportPage.route,
        ),
      if (userHasPermission(allowReportFinancialStatement) &&
          enableTransactionsV2)
        ModuleMenuItem(
          name: 'Financial Statements',
          description: 'View your financial statements',
          route: FinancialStatementPage.route,
        )
      else if (userHasPermission(allowTransactionHistory) &&
          enableTransactionsV1)
        ModuleMenuItem(
          name: 'Past Transactions',
          description: 'View your past transactions',
          route: SalesPage.route,
        ),
    ];
  }
}
