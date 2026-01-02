// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Project imports:
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/billing/billing_helpers.dart';
import 'package:littlefish_merchant/ui/analysis/reports/sales/view_models.dart';
import 'package:littlefish_merchant/ui/analysis/reports/sales/widgets/sales_report_display.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_tabbed_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_tabbar.dart';

class SalesReportPage extends StatefulWidget {
  static const String route = 'dashboard/revenue';

  const SalesReportPage({Key? key}) : super(key: key);

  @override
  State<SalesReportPage> createState() => _SalesReportPageState();
}

class _SalesReportPageState extends State<SalesReportPage>
    with SingleTickerProviderStateMixin {
  SalesReportVM? vm;

  GlobalKey<AppTabBarState> tabKey = GlobalKey();

  TabController? controller;
  int? _lastIndex;

  int? get currentIndex => controller?.index;

  @override
  void initState() {
    controller = TabController(initialIndex: 0, length: 6, vsync: this);
    controller!.addListener(() {
      if (!controller!.indexIsChanging && _lastIndex != currentIndex) {
        _lastIndex = currentIndex;
        var index = controller!.index;
        var mode = '';
        if (index == 0) mode = 'report_day';
        if (index == 1) mode = 'report_week';
        if (index == 2) mode = 'report_month';
        if (index == 3) mode = 'report_3_month';
        if (index == 4) mode = 'report_year';
        if (index == 5) mode = 'report_custom';

        if (isNotPremium(mode)) {
          showPopupDialog(
            defaultPadding: false,
            context: context,
            content: billingNavigationHelper(isModal: true),
          );
          controller!.animateTo(0);
        } else {
          vm!.changeMode(ReportMode.values[index]);
          vm!.runReport(context);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);

    vm ??= SalesReportVM.fromStore(store)
      ..initialMode = ReportMode
          .values[((ModalRoute.of(context)!.settings.arguments as int?) ?? 0)]
      ..onReportLoaded = () {
        var index = vm!.mode!.index;

        if (index != tabKey.currentState?.controller?.index) {
          tabKey.currentState?.controller?.animateTo(index);
        }

        if (mounted) setState(() {});
      }
      ..mode = ReportMode
          .values[((ModalRoute.of(context)!.settings.arguments as int?) ?? 0)];

    return AppScaffold(
      title: 'Revenue Dashboard',
      actions: <Widget>[
        IconButton(
          color: Colors.white,
          icon: Icon(MdiIcons.filePdfBox),
          onPressed: () => vm!.onDownloadReport(true),
        ),
        // IconButton(
        //   icon: Icon(MdiIcons.fileExcel),
        //   onPressed: () => vm.onDownloadReport(false),
        // )
      ],
      body: vm!.isLoading!
          ? const AppProgressIndicator()
          : Column(
              children: <Widget>[
                SizedBox(
                  height: 60,
                  child: Container(
                    color: Colors.grey.shade50,
                    child: MaterialButton(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          vm!.dateSelectionString,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if (isNotPremium('report_custom')) {
                          showPopupDialog(
                            defaultPadding: false,
                            context: context,
                            content: billingNavigationHelper(isModal: true),
                          );
                        } else {
                          vm!.selectDateRange(context).then((dates) {
                            if (dates != null) {
                              vm!.changeDates(dates[0], dates[1]);
                              vm!.changeMode(ReportMode.custom);

                              vm!.runReport(context);
                              if (mounted) setState(() {});
                            }
                          });
                        }
                      },
                    ),
                  ),
                ),
                const CommonDivider(),
                Expanded(
                  child: AppTabBar(
                    key: tabKey,
                    scrollable: true,
                    controller: controller,
                    intialIndex: vm!.mode!.index,
                    onTabChanged: (index) {
                      vm!.mode = ReportMode.values[index];
                      vm!.runReport(context).then((result) {
                        if (mounted) setState(() {});
                      });
                    },
                    tabs: [
                      TabBarItem(
                        text: '1d',
                        content: SalesReportDisplay(report: vm),
                      ),
                      TabBarItem(
                        text: '1w',
                        content: SalesReportDisplay(report: vm),
                      ),
                      TabBarItem(
                        text: '1m',
                        content: SalesReportDisplay(report: vm),
                      ),
                      TabBarItem(
                        text: '3m',
                        content: SalesReportDisplay(report: vm),
                      ),
                      TabBarItem(
                        text: '1y',
                        content: SalesReportDisplay(report: vm),
                      ),
                      TabBarItem(
                        icon: Icons.search,
                        content: SalesReportDisplay(report: vm),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
