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
import 'package:littlefish_merchant/models/reports/bq_profits_report.dart';
import 'package:littlefish_merchant/models/reports/bq_report_date_range.dart';
import 'package:littlefish_merchant/models/reports/bq_report_dictionary.dart';
import 'package:littlefish_merchant/models/reports/report_date_range.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/bq_report_service.dart';
import 'package:littlefish_merchant/ui/analysis/reports/shared/report_vm_base.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

class ProfitsReportVM extends StoreViewModel with ReportVMBase {
  ProfitsReportVM.fromStore(Store<AppState> store) : super.fromStore(store);

  late BqReportService service;

  List<ReportDateRange> compareDates = [];

  String? reportFilter;

  BqReportDictionary? report = BqReportDictionary(
    reportDictionary: {'H': [], 'D': [], 'W': [], 'M': []},
  );

  Function? onReportLoaded;

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    this.store = store;
    service = BqReportService.fromStore(store!);
    isLoading ??= false;
    hasError = false;

    runReport = (ctx) async {
      isLoading = true;

      int counter = 0;

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

      report!.reportDictionary!.forEach((key, value) async {
        await service
            .getProfitsReportByFilterCompare(
              businessId: this.store!.state.businessId,
              series: series,
              filter: key,
            )
            .then((result) {
              report!.reportDictionary![key] = result as List<dynamic>;
            })
            .whenComplete(() {
              counter++;
              if (counter == report!.reportDictionary!.length) {
                isLoading = false;
                if (null != onReportLoaded) onReportLoaded!();
              }
            });
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

      if (compareDates.map((e) => e.seriesName).contains(seriesName) == false) {
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

      report!.reportDictionary!.forEach((key, value) {
        report!.reportDictionary![key]!.removeAt(dates.seriesNo!);
      });
    }

    report!.reportDictionary!.forEach((key, value) {
      reportFilter = key;
      runReport(context);
    });

    onReportLoaded!();

    return compareDates;
  }

  List<ComparisonBqReportSeries> toAnalysisPairList(String filter) {
    return report!.reportDictionary![filter]!.map((compareReport) {
      return ComparisonBqReportSeries(
        dateRange: BqReportDateRange(
          seriesName: compareReport.seriesName,
          startDate: compareReport.startDate,
          endDate: compareReport.endDate,
        ),
        seriesNo: compareReport.seriesNo,
        analysisPairs: (compareReport.reportResponse as List<BqProfitsReport>)
            .map((e) {
              return AnalysisPair(
                id: e.dateTimeIndex.toString(),
                value: e.profits,
              );
            })
            .toList(),
      );
    }).toList();
  }

  downloadReport(String fileType, Map<String, List<dynamic>> reportData) async {
    BqBusDetailsRequest busDetails = BqBusDetailsRequest(
      busName: store!.state.businessState.profile!.name,
      businessId: store!.state.businessId,
      userEmail: store!.state.currentUser!.email,
    );

    String filePath = await service.downloadProfitsReport(
      fileType,
      reportData,
      busDetails,
    );

    OpenFile.open(filePath);
  }
}
