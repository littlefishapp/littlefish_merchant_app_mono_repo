import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core/reports/models/report.dart';
import 'package:littlefish_core/reports/models/report_settings.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/components/cards/card_square_flat.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/features/reports/shared/report_center_vm.dart';
import 'package:littlefish_reports/ui/report_viewer_widget.dart';

class ReportViewerPage extends StatefulWidget {
  final Report item;

  const ReportViewerPage({super.key, required this.item});

  @override
  State<ReportViewerPage> createState() => _ReportViewerPageState();
}

class _ReportViewerPageState extends State<ReportViewerPage> {
  final reportViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    final showSideNav =
        isTablet || (AppVariables.store!.state.enableSideNavDrawer ?? false);
    return AppScaffold(
      title: widget.item.name,
      enableProfileAction: !showSideNav,
      hasDrawer: false,
      displayNavDrawer: false,
      centreTitle: false,
      // actions: [
      //   IconButton(
      //     icon: const Icon(Icons.download),
      //     onPressed: () {
      //       reportViewerKey.currentState?.downloadPdf();
      //     },
      //   ),
      // ],
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        alignment: Alignment.topCenter,
        child: StoreConnector<AppState, ReportCenterVM>(
          converter: (store) => ReportCenterVM.fromStore(store),
          builder: (context, vm) {
            return CardSquareFlat(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: ReportViewerWidget(
                  key: reportViewerKey,
                  report: widget.item,
                  businessId: vm.businessId,
                  settings: ReportSettings(
                    endpoint: vm.endPoint,
                    configuration: {},
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
