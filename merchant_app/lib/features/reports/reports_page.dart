import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/features/reports/layouts/default/report_center_default.dart';
import 'package:littlefish_merchant/features/reports/layouts/v2/report_center_v2.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/features/reports/shared/report_center_vm.dart';
import 'package:littlefish_merchant/features/reports/layouts/v1/mobile/report_center_v1.dart';

class ReportsPage extends StatefulWidget {
  static const String route = 'app/reports';

  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ReportCenterVM>(
      builder: ((context, vm) {
        switch (vm.layout) {
          case 'default':
            return const ReportCenterDefaultPage();
          case 'v1':
            return const ReportCenterV1Page();
          case 'v2':
            return const ReportCenterV2Page();
          default:
            return const ReportCenterDefaultPage();
        }
      }),
      converter: (store) => ReportCenterVM.fromStore(store),
    );
  }
}
