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
import 'package:littlefish_merchant/models/reports/bq_payments_comparison_report.dart';
import 'package:littlefish_merchant/models/reports/bq_payments_report.dart';
import 'package:littlefish_merchant/models/reports/bq_report_date_range.dart';
import 'package:littlefish_merchant/models/reports/report_date_range.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/bq_report_service.dart';
import 'package:littlefish_merchant/ui/analysis/reports/shared/report_vm_base.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart'
    as an;

class PaymentsReportVM extends StoreViewModel with ReportVMBase {
  PaymentsReportVM.fromStore(Store<AppState> store) : super.fromStore(store);

  List<PaymentsComparisonReport> report = [];

  Function? onReportLoaded;

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
          .getPaymentsReportByFilterCompare(
            businessId: this.store!.state.businessId,
            series: series,
          )
          .then((result) {
            report = result ?? [];
            for (var i = 0; i < report.length; i++) {
              report[i].reportResponse = getDistinctPaymentsReport(
                report[i].reportResponse,
              );
            }
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
      report.removeAt(dates.seriesNo!);
    }

    if (compareDates.isNotEmpty) {
      runReport(context);
    }

    onReportLoaded!();

    return compareDates;
  }

  List<ComparisonBqReportSeries> toAnalysisPairList() {
    return report.map((compareReport) {
      return ComparisonBqReportSeries(
        dateRange: BqReportDateRange(
          seriesName: compareReport.seriesName,
          startDate: compareReport.startDate,
          endDate: compareReport.endDate,
        ),
        seriesNo: compareReport.seriesNo,
        analysisPairs: getDistinctAnalysisPairs(
          (compareReport.reportResponse as List<BqPaymentsReport>).map((e) {
            return AnalysisPair(id: e.paymentType, value: e.amount);
          }).toList(),
        ),
      );
    }).toList();
  }

  downloadReport(
    String fileType,
    List<PaymentsComparisonReport> reportData,
  ) async {
    BqBusDetailsRequest busDetails = BqBusDetailsRequest(
      busName: store!.state.businessState.profile!.name,
      businessId: store!.state.businessId,
      userEmail: store!.state.currentUser!.email,
    );

    String filePath = await service.downloadPaymentTypeReport(
      fileType,
      reportData,
      busDetails,
    );

    OpenFile.open(filePath);
  }

  List<AnalysisPair> getDistinctAnalysisPairs(List<an.AnalysisPair> data) {
    if (data
        .where((element) => element.id!.toLowerCase() == 'card')
        .toList()
        .isNotEmpty) {
      double cardCountValue = 0;

      for (var element in data) {
        if (element.id!.toLowerCase() == 'card') {
          cardCountValue = cardCountValue + (element.value ?? 0);
        }
      }

      data.removeWhere((element) => element.id!.toLowerCase() == 'card');
      data.add(an.AnalysisPair(id: 'Card', value: cardCountValue));
    }

    if (data
        .where((element) => element.id!.toLowerCase() == 'cash')
        .toList()
        .isNotEmpty) {
      double cashCountValue = 0;

      for (var element in data) {
        if (element.id!.toLowerCase() == 'cash') {
          cashCountValue = cashCountValue + (element.value ?? 0);
        }
      }

      data.removeWhere((element) => element.id!.toLowerCase() == 'cash');
      data.add(an.AnalysisPair(id: 'Cash', value: cashCountValue));
    }

    return data;
  }

  List<BqPaymentsReport>? getDistinctPaymentsReport(
    List<BqPaymentsReport>? data,
  ) {
    if (data != null) {
      if (data
          .where((element) => element.paymentType!.toLowerCase() == 'card')
          .toList()
          .isNotEmpty) {
        double cardCountQty = 0;
        double cardCountAmt = 0;
        double cardCountPerc = 0;

        for (var element in data) {
          if (element.paymentType!.toLowerCase() == 'card') {
            cardCountQty = cardCountQty + (element.qty ?? 0);
            cardCountAmt = cardCountAmt + (element.amount ?? 0);
            cardCountPerc = cardCountPerc + (element.percentage ?? 0);
          }
        }

        data.removeWhere(
          (element) => element.paymentType!.toLowerCase() == 'card',
        );
        data.add(
          BqPaymentsReport(
            paymentType: 'Card',
            qty: cardCountQty,
            amount: cardCountAmt,
            percentage: cardCountPerc,
          ),
        );
      }

      if (data
          .where((element) => element.paymentType!.toLowerCase() == 'cash')
          .toList()
          .isNotEmpty) {
        double cashCountQty = 0;
        double cashCountAmt = 0;
        double cashCountPerc = 0;

        for (var element in data) {
          if (element.paymentType!.toLowerCase() == 'cash') {
            cashCountQty = cashCountQty + (element.qty ?? 0);
            cashCountAmt = cashCountAmt + (element.amount ?? 0);
            cashCountPerc = cashCountPerc + (element.percentage ?? 0);
          }
        }

        data.removeWhere(
          (element) => element.paymentType!.toLowerCase() == 'cash',
        );
        data.add(
          BqPaymentsReport(
            paymentType: 'Cash',
            qty: cashCountQty,
            amount: cashCountAmt,
            percentage: cashCountPerc,
          ),
        );
      }
    }

    return data;
  }
}
