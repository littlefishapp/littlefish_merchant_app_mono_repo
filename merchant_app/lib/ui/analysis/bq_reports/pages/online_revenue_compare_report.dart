// Flutter imports:
// remove ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/reports/report_date_range.dart';
import 'package:littlefish_merchant/tools/billing/billing_helpers.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/viewmodels/revenue_report_viewmodel.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/widgets/date_range_selector.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/widgets/date_series_bar.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/widgets/download_dropdown.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/widgets/report_data_ui.dart';
import 'package:littlefish_merchant/ui/analysis/reports/sales/widgets/sales_boards.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_tabbed_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_tabbar.dart';

class BqReportingCompareOnlineRevenuePage extends StatefulWidget {
  static const String route = 'bq/reporting/online_revenue/compare';

  const BqReportingCompareOnlineRevenuePage({Key? key}) : super(key: key);

  @override
  State<BqReportingCompareOnlineRevenuePage> createState() =>
      _BqReportingCompareOnlineRevenuePage();
}

class _BqReportingCompareOnlineRevenuePage
    extends State<BqReportingCompareOnlineRevenuePage>
    with SingleTickerProviderStateMixin {
  late RevenueReportVM vm;

  GlobalKey<AppTabBarState> tabKey = GlobalKey();

  TabController? controller;

  int? _lastIndex;

  int? get currentIndex => controller?.index;

  late List<ReportDateRange>? compareDates = [];

  String tableheaderText = 'Online Revenue';

  late List<String> tableHeadings;

  bool? modalRouteAvailable;

  _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    vm = RevenueReportVM.fromStore(AppVariables.store!)
      ..onReportLoaded = () {
        _rebuild();
      };

    vm.isOnline = true;

    tableHeadings = ['Revenue', 'Sales', 'ATS'];

    controller = TabController(initialIndex: 0, length: 4, vsync: this);

    controller!.addListener(() {
      if (!controller!.indexIsChanging && _lastIndex != currentIndex) {
        _lastIndex = currentIndex;
        var index = controller!.index;
        var mode = '';
        if (index == 0) mode = 'report_hour';
        if (index == 1) mode = 'report_day';
        if (index == 2) mode = 'report_week';
        if (index == 3) mode = 'report_month';

        if (isNotPremium(mode)) {
          showPopupDialog(
            defaultPadding: false,
            context: context,
            content: billingNavigationHelper(isModal: true),
          );
          controller!.animateTo(0);
        } else {}
      }
    });

    vm.runReport(null);
    compareDates = vm.compareDates;

    modalRouteAvailable = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments is List &&
        modalRouteAvailable!) {
      vm.compareDates =
          ModalRoute.of(context)!.settings.arguments as List<ReportDateRange>;
      modalRouteAvailable = false;
      vm.runReport(null);
      compareDates = vm.compareDates;
    }

    return AppScaffold(
      title: 'Online Revenue',
      actions: [
        DownloadDropDown(
          serviceFunction: vm.downloadReport,
          requestData2: vm.report!.reportDictionary,
        ),
      ],
      body: Column(
        children: <Widget>[
          DateSeriesBar(
            compareDates: compareDates ?? <ReportDateRange>[],
            dateRangeSelectorHandler: dateRangeSelectedHandler,
            onSeriesDeleted: onSeriesDeleted,
          ),
          const CommonDivider(),
          Expanded(
            child: AppTabBar(
              key: tabKey,
              scrollable: true,
              intialIndex: vm.mode!.index,
              controller: controller,
              onTabChanged: (index) {},
              tabs: [
                TabBarItem(
                  text: 'Hour',
                  content: ReportDataUI(
                    salesBoardTitle: 'Revenue By Hour',
                    salesBoardData: vm.toAnalysisPairList('H'),
                    salesBoardType: BoardType.spline,
                    tableHeaderText: tableheaderText,
                    tableData: vm.report!.reportDictionary!['H']!,
                    tableDateTimeIndex: 'Hour',
                    dataColumnHeadings: tableHeadings,
                    reportType: 'Rev',
                    isLoading: vm.isLoading,
                  ),
                ),
                TabBarItem(
                  text: 'Day',
                  content: ReportDataUI(
                    salesBoardTitle: 'Revenue By Day',
                    salesBoardData: vm.toAnalysisPairList('D'),
                    salesBoardType: BoardType.spline,
                    tableHeaderText: tableheaderText,
                    tableData: vm.report!.reportDictionary!['D']!,
                    tableDateTimeIndex: 'Day',
                    dataColumnHeadings: tableHeadings,
                    reportType: 'Rev',
                    isLoading: vm.isLoading,
                  ),
                ),
                TabBarItem(
                  text: 'Week',
                  content: ReportDataUI(
                    salesBoardTitle: 'Revenue By Week',
                    salesBoardData: vm.toAnalysisPairList('W'),
                    salesBoardType: BoardType.column,
                    tableHeaderText: tableheaderText,
                    tableData: vm.report!.reportDictionary!['W']!,
                    tableDateTimeIndex: 'Week',
                    dataColumnHeadings: tableHeadings,
                    reportType: 'Rev',
                    isLoading: vm.isLoading,
                  ),
                ),
                TabBarItem(
                  text: 'Month',
                  content: ReportDataUI(
                    salesBoardTitle: 'Revenue By Month',
                    salesBoardData: vm.toAnalysisPairList('M'),
                    salesBoardType: BoardType.column,
                    tableHeaderText: tableheaderText,
                    tableData: vm.report!.reportDictionary!['M']!,
                    tableDateTimeIndex: 'Month',
                    dataColumnHeadings: tableHeadings,
                    reportType: 'Rev',
                    isLoading: vm.isLoading,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  dateRangeSelectedHandler(int i, bool updateSeriesFlag) async {
    var dates = await showPopupDialog(
      context: context,
      content: updateSeriesFlag
          ? DateRangeSelector(
              startDate: DateTime.parse(compareDates![i].startDate!),
              endDate: DateTime.parse(compareDates![i].endDate!),
              index: i,
            )
          : const DateRangeSelector(),
    );

    if (dates != null) {
      compareDates = vm.dateRangeSelectorHandler(context, dates);
    }
    if (mounted) setState(() {});
  }

  onSeriesDeleted(int i) {
    compareDates!.removeAt(i);
    vm.runReport(context);
    if (mounted) setState(() {});
  }
}
