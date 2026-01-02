// Flutter imports:

import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/reports/report_date_range.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/viewmodels/payments_report_viewmodel.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/widgets/comparison_report_tab_controller.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/widgets/date_range_selector.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/widgets/date_series_bar.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/widgets/download_dropdown.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/widgets/salesboard_page_view_controller.dart';
import 'package:littlefish_merchant/ui/analysis/reports/sales/widgets/sales_boards.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class BqReportingComparePaymentsPage extends StatefulWidget {
  static const String route = 'bq/reporting/payments/compare';

  const BqReportingComparePaymentsPage({Key? key}) : super(key: key);

  @override
  State<BqReportingComparePaymentsPage> createState() =>
      _BqReportingComparePaymentsPageState();
}

class _BqReportingComparePaymentsPageState
    extends State<BqReportingComparePaymentsPage>
    with SingleTickerProviderStateMixin {
  late PaymentsReportVM vm;

  late List<ReportDateRange>? compareDates = [];

  String tableheaderText = 'Payments';

  late List<String> tableHeadings = ['Revenue', 'Profits'];

  late ComparisonReportTabController paginatedTable;

  int currentTabIndex = 0;

  bool? modalRouteAvailable;

  _rebuild() {
    if (mounted) setState(() {});
  }

  _setTabIndex(int index) {
    currentTabIndex = index;
    _rebuild();
  }

  @override
  void initState() {
    vm = PaymentsReportVM.fromStore(AppVariables.store!)
      ..onReportLoaded = () {
        _rebuild();
      };

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

    paginatedTable = ComparisonReportTabController(
      reportData: vm.report,
      dateTimeIndex: 'Type',
      headerText: 'Payment Type',
      dataColumnHeadings: const ['Quanitity', '%', 'Amount'],
      reportType: 'Payments',
      setParentTabIndex: _setTabIndex,
      tabIndex: currentTabIndex,
    );

    return AppScaffold(
      title: 'Payments',
      actions: [
        DownloadDropDown(
          serviceFunction: vm.downloadReport,
          requestData: vm.report,
        ),
      ],
      floatLocation: FloatingActionButtonLocation.endDocked,
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          DateSeriesBar(
            compareDates: compareDates ?? <ReportDateRange>[],
            dateRangeSelectorHandler: dateRangeSelectedHandler,
            onSeriesDeleted: onSeriesDeleted,
          ),
          const CommonDivider(),
          vm.isLoading == true
              ? const Column(
                  children: [SizedBox(height: 60), AppProgressIndicator()],
                )
              : Column(
                  children: [
                    SalesboardPageViewController(
                      title: '',
                      reportData: vm.toAnalysisPairList(),
                      dynamicData: vm.report,
                      type: BoardType.doughnut,
                      setParentTabIndex: _setTabIndex,
                      tabIndex: currentTabIndex,
                      height: 240,
                    ),
                    paginatedTable,
                  ],
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
