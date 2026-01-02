// Flutter imports:
// remove ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/reports/report_date_range.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/viewmodels/customer_sales_report_viewmodel.dart';
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

class BqReportingCompareCustomerSalesPage extends StatefulWidget {
  static const String route = 'bq/reporting/customer_sales/compare';

  const BqReportingCompareCustomerSalesPage({Key? key}) : super(key: key);

  @override
  State<BqReportingCompareCustomerSalesPage> createState() =>
      _BqReportingCompareCustomerSalesPageState();
}

class _BqReportingCompareCustomerSalesPageState
    extends State<BqReportingCompareCustomerSalesPage>
    with SingleTickerProviderStateMixin {
  late CustomerSalesReportVM vm;
  late Future<dynamic> reportResult;

  late List<ReportDateRange>? compareDates = [];

  ComparisonReportTabController? paginatedTable;

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
    vm = CustomerSalesReportVM.fromStore(AppVariables.store!)
      ..onReportLoaded = () {
        _rebuild();
      };

    modalRouteAvailable = true;

    reportResult = vm.runReport(null);
    compareDates = vm.compareDates;
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
      title: 'Customer Purchases',
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
            const CommonDivider(),
            vm.isLoading == true
                ? const Column(
                    children: [SizedBox(height: 100), AppProgressIndicator()],
                  )
                : body(),
          ],
        ),
      ),
    );
  }

  Column body() {
    compareDates = vm.compareDates;
    paginatedTable = ComparisonReportTabController(
      reportData: vm.report!,
      dateTimeIndex: 'Name',
      headerText: 'Customer Purchases',
      dataColumnHeadings: const ['Amount', 'Quanitity'],
      reportType: 'Customer Purchases',
      setParentTabIndex: _setTabIndex,
      tabIndex: currentTabIndex,
    );
    return Column(
      // shrinkWrap: true,
      children: <Widget>[
        SalesboardPageViewController(
          title: '',
          showTabHeaders: false,
          reportData: vm.toAnalysisPairList(),
          dynamicData: vm.report!,
          type: BoardType.doughnut,
          setParentTabIndex: _setTabIndex,
          tabIndex: currentTabIndex,
          height: 240,
        ),
        paginatedTable!,
      ],
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
