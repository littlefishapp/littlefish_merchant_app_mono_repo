// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:open_file/open_file.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/reports/bq_bus_details_request.dart';
import 'package:littlefish_merchant/models/reports/bq_comparison_report_series.dart';
import 'package:littlefish_merchant/models/reports/bq_products_comparison_report.dart';
import 'package:littlefish_merchant/models/reports/bq_products_report.dart';
import 'package:littlefish_merchant/models/reports/bq_report_date_range.dart';
import 'package:littlefish_merchant/models/reports/report_date_range.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/bq_report_service.dart';
import 'package:littlefish_merchant/ui/analysis/reports/shared/report_vm_base.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

class ProductsReportVM extends StoreViewModel with ReportVMBase {
  ProductsReportVM.fromStore(Store<AppState> store) : super.fromStore(store);

  List<ProductsComparisonReport>? report = [];

  Function? onReportLoaded;

  Function? runPaymentsReportCompare;

  late BqReportService service;

  List<ReportDateRange> compareDates = [];

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    this.store = store;
    service = BqReportService.fromStore(store!);
    isLoading ??= false;
    hasError = false;

    runReport = (ctx) async {
      isLoading = true;

      if (compareDates.isEmpty) {
        mode = ReportMode.month;
        ReportDateRange initialDateRange = ReportDateRange(
          startDate: startDate.toUtc().toString(),
          endDate: endDate.toUtc().toString(),
          seriesName: 'This Month',
          seriesNo: 0,
          mode: ReportMode.month,
        );
        compareDates.add(initialDateRange);
      }

      List<BqReportDateRange> series = compareDates.map((e) {
        return BqReportDateRange(
          seriesName: e.seriesName,
          startDate: e.startDate,
          endDate: e.endDate,
        );
      }).toList();

      await service
          .getProductsReportCompare(
            businessId: this.store!.state.businessId,
            series: series,
          )
          .then((result) {
            report = result;
          })
          .whenComplete(() {
            isLoading = false;
            if (null != onReportLoaded) onReportLoaded!();
          });
    };

    mode ??= initialMode ?? ReportMode.day;
  }

  List<ReportDateRange> dateRangeSelectorHandler(
    context,
    ReportDateRange dates,
  ) {
    if (dates.isDeleted == false) {
      changeDates(
        DateTime.parse(dates.startDate!),
        DateTime.parse(dates.endDate!),
      );

      changeMode(dates.mode ?? ReportMode.custom);

      String? seriesName = dates.seriesName != null
          ? dates.seriesName!.replaceFirst('Custom, ', '')
          : dateSelectionString;

      if (compareDates.map((e) => e.seriesName).contains(dates.seriesName) ==
          false) {
        ReportDateRange dateRange = ReportDateRange(
          seriesName: seriesName,
          seriesNo: dates.seriesNo,
          mode: dates.mode ?? ReportMode.custom,
          startDate: dates.startDate,
          endDate: dates.endDate,
        );

        if (dates.seriesNo == null) {
          compareDates.add(dateRange);
        } else {
          compareDates[dates.seriesNo!] = dateRange;
        }
      } else {
        showErrorDialog(context, 'Date range already exists');
      }
    }

    if (dates.isDeleted!) {
      compareDates.removeAt(dates.seriesNo!);
      report!.removeAt(dates.seriesNo!);
    }

    if (compareDates.isNotEmpty) {
      runReport(context);
    }

    onReportLoaded!();

    return compareDates;
  }

  List<ComparisonBqReportSeries> toAnalysisPairList() {
    return report!.map((compareReport) {
      return ComparisonBqReportSeries(
        dateRange: BqReportDateRange(
          seriesName: compareReport.seriesName,
          startDate: compareReport.startDate,
          endDate: compareReport.endDate,
        ),
        seriesNo: compareReport.seriesNo,
        analysisPairs: (compareReport.reportResponse as List<BqProductsReport>)
            .map((e) {
              return AnalysisPair(
                id: e.productName.toString(),
                value: e.amount,
              );
            })
            .toList(),
      );
    }).toList();
  }

  downloadReport(
    String fileType,
    List<ProductsComparisonReport> reportData,
  ) async {
    BqBusDetailsRequest busDetails = BqBusDetailsRequest(
      busName: store!.state.businessState.profile!.name,
      businessId: store!.state.businessId,
      userEmail: store!.state.currentUser!.email,
    );

    String filePath = await service.downloadProductsReport(
      fileType,
      reportData,
      busDetails,
    );

    OpenFile.open(filePath);
  }
}
