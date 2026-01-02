import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core/reports/models/report.dart';
import 'package:littlefish_core/reports/models/report_settings.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/features/reports/shared/report_center_vm.dart';
import 'package:littlefish_merchant/features/reports/shared/report_viewer_page.dart';
import 'package:littlefish_reports/ui/report_center_widget.dart';

class ReportCenterV1Page extends StatelessWidget {
  static const String route = 'reports/report-center-v1';

  const ReportCenterV1Page({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    final showSideNav =
        isTablet || (AppVariables.store!.state.enableSideNavDrawer ?? false);
    return AppScaffold(
      enableProfileAction: !showSideNav,
      title: 'Report Center',
      centreTitle: false,
      hasDrawer: showSideNav,
      displayNavDrawer: showSideNav,
      body: Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.topCenter,
        child: StoreConnector<AppState, ReportCenterVM>(
          converter: (store) => ReportCenterVM.fromStore(store),
          builder: (context, vm) {
            return ReportCenterWidget(
              businessId: vm.businessId,
              // titleTextStyle: context.labelSmall('text', isBold: true).style,
              // subTitleTextStyle: context.labelXSmall('text').style,
              settings: ReportSettings(
                endpoint: vm.endPoint,
                configuration: {},
              ),
              onReportSelected: (Report report) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ReportViewerPage(item: report),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
