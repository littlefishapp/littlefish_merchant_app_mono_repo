// Flutter imports:
// remove ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/reports/bq_overview_report.dart';
import 'package:littlefish_merchant/models/reports/report_date_range.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/viewmodels/overview_report_viewmodel.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/widgets/bq_business_overview.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/widgets/comparison_report_tab_controller.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/widgets/date_range_selector.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/widgets/date_series_bar.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/widgets/download_dropdown.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/widgets/overview_tab_bar.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_tabbar.dart';

class BqReportingCompareOverviewPage extends StatefulWidget {
  static const String route = 'bq/reporting/overview/compare';

  const BqReportingCompareOverviewPage({Key? key}) : super(key: key);

  @override
  State<BqReportingCompareOverviewPage> createState() =>
      _BqReportingCompareCustomerSalesPage();
}

class _BqReportingCompareCustomerSalesPage
    extends State<BqReportingCompareOverviewPage>
    with SingleTickerProviderStateMixin {
  late OverviewReportVM vm;

  late List<ReportDateRange>? compareDates = [];

  late ComparisonReportTabController paginatedTable;

  int currentTabIndex = 0;

  int counter = 0;

  GlobalKey<AppTabBarState> tabKey = GlobalKey();

  _rebuild() {
    if (mounted) setState(() {});
  }

  _setTabIndex(int index) {
    currentTabIndex = index;
    _rebuild();
  }

  @override
  void initState() {
    vm = OverviewReportVM.fromStore(AppVariables.store!)
      ..onReportLoaded = () {
        _rebuild();
      };

    vm.runReport(null);

    compareDates = vm.compareDates;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if ((vm.report!.length - 1) < currentTabIndex) {
      currentTabIndex = 0;
    }
    return AppScaffold(
      title: 'Sales Overview',
      actions: [
        DownloadDropDown(
          serviceFunction: vm.downloadReport,
          requestData: vm.report!,
        ),
      ],
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            DateSeriesBar(
              compareDates: compareDates ?? <ReportDateRange>[],
              dateRangeSelectorHandler: dateRangeSelectedHandler,
              onSeriesDeleted: onSeriesDeleted,
            ),
            // CommonDivider(),
            // CommonDivider(),
            if (vm.isLoading == false && vm.report?.isEmpty == false)
              SizedBox(
                height: 48,
                child: OverviewTabBar(
                  reportData: vm.report,
                  currentTabIndex: currentTabIndex,
                  setParentTabIndex: _setTabIndex,
                  isloading: vm.isLoading,
                ),
              ),
            vm.isLoading == false
                ? vm.report!.isNotEmpty
                      ? BqBusinessOverview(
                          data:
                              vm
                                  .report![currentTabIndex]
                                  .reportResponse!
                                  .isNotEmpty
                              ? vm.report![currentTabIndex].reportResponse![0]
                              : BqOverviewReport(),
                          compareDates: compareDates,
                          state: vm.store!.state,
                        )
                      : SizedBox(
                          height: 320,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: const DecoratedText(
                                  '',
                                  alignment: Alignment.topCenter,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  textColor: Colors.grey,
                                ),
                              ),
                              DecoratedText(
                                'No Data',
                                alignment: Alignment.center,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                textColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                              ),
                            ],
                          ),
                        )
                : const Column(
                    children: [SizedBox(height: 60), AppProgressIndicator()],
                  ),
          ],
        ),
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

/*
                TabBarItem(
                  text:
                      compareDates![i].seriesName!.replaceFirst("Custom, ", ""),
                  content: vm.report!.isNotEmpty
                      ? BqBusinessOverview(
                          data: vm.report![i].reportResponse!.isNotEmpty
                              ? vm.report![i].reportResponse![0]
                              : BqOverviewReport(),
                        )
                      : Container(
                          height: 320,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                child: DecoratedText(
                                  "",
                                  alignment: Alignment.topCenter,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  textColor: Colors.grey,
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 8),
                              ),
                              DecoratedText(
                                "No Data",
                                alignment: Alignment.center,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                textColor:
                                    Theme.of(context).colorScheme.primary,
                              )
                            ],
                          ),
                        ),
                ),
*/
