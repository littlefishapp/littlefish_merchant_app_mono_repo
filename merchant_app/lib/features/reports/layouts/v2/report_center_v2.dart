import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/features/getapp/get_app_widget.dart';
import 'package:littlefish_merchant/models/security/access_management/module.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/features/reports/shared/report_center_vm.dart';
import 'package:littlefish_merchant/shared/constants/permission_name_constants.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/analytics/business_analytics_page.dart';
import 'package:littlefish_merchant/ui/reports/financial_statement/financial_statement_page.dart';

import '../../../../app/theme/applied_system/applied_text_icon.dart';

class ReportCenterV2Page extends StatelessWidget {
  static const String route = 'reports/report-center-v2';

  const ReportCenterV2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Report Center',
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
            return ListView(
              children: [
                const GetAppWidget(key: Key('report-center-v2-download-app')),
                const CommonDivider(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  alignment: Alignment.centerLeft,
                  child: context.labelLarge(
                    'Basic Reports',
                    isBold: true,
                    alignLeft: true,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: context.labelSmall(
                    'A list of basic reports',
                    alignLeft: true,
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return getMenuItem(context, item);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  ListTile getMenuItem(BuildContext context, ModuleMenuItem item) {
    return ListTile(
      //contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      title: context.labelSmall(
        item.name ?? 'Unknown',
        isBold: true,
        alignLeft: true,
        color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
      ),
      subtitle: context.labelXSmall(
        item.description ?? '',
        alignLeft: true,
        color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
      ),
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
    return [
      if (userHasPermission(allowReportOverview))
        ModuleMenuItem(
          name: 'Overview',
          description: 'View your business performance',
          route: BusinessAnalyticsPage.route,
        ),
      // TODO(Michael): Leaving this commented for now, if it is still not needed after some time, remove it.
      // if (userHasPermission(allowReportSale))
      //   ModuleMenuItem(
      //     name: 'Sales Report',
      //     description: 'View your sales performance',
      //     route: SalesByProductReport.route,
      //   ),
      // if (userHasPermission(allowReportStock))
      //   ModuleMenuItem(
      //     name: 'Stock',
      //     description: 'View your stock',
      //     route: InventoryReportPage.route,
      //   ),
      if (userHasPermission(allowReportFinancialStatement))
        ModuleMenuItem(
          name: 'Financial Statements',
          description: 'View your financial statements',
          route: FinancialStatementPage.route,
        ),
    ];
  }
}
