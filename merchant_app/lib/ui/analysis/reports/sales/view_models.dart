// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:open_file/open_file.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/reports/customer_report.dart';
import 'package:littlefish_merchant/models/reports/product_report.dart';
import 'package:littlefish_merchant/models/reports/sales_report.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/analysis_service.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/analysis/reports/shared/report_vm_base.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

class SalesReportVM extends StoreViewModel with ReportVMBase {
  SalesReportVM.fromStore(Store<AppState> store) : super.fromStore(store);

  SalesReport? report;

  Function? onReportLoaded;

  late Function(bool isPdf) onDownloadReport;

  late ReportService service;

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    this.store = store;
    service = ReportService.fromStore(store!);
    isLoading ??= false;
    hasError = false;

    runReport = (ctx) async {
      if (mode == ReportMode.custom) {
        isLoading = true;
        await service
            .getSalesReportByRange(startDate, endDate)
            .then((result) {
              report = result;
              isLoading = false;
            })
            .whenComplete(() {
              isLoading = false;

              if (null != onReportLoaded) onReportLoaded!();
            });
      } else {
        isLoading = true;
        await service
            .getSalesReportByGroup(DateGroupType.values[mode!.index])
            .then((result) {
              report = result;
              isLoading = false;
            })
            .whenComplete(() {
              isLoading = false;

              if (null != onReportLoaded) onReportLoaded!();
            });
      }

      return report;
    };

    if (mode == null) {
      mode = initialMode ?? ReportMode.day;
      runReport(null);
    }

    onDownloadReport = (isPdf) async {
      try {
        var report = await service.downloadSalesReportDateRange(
          startDate,
          endDate,
          isPDF: true,
        );

        OpenFile.open(report);
      } catch (e) {
        debugPrint(e.toString());
      }
    };
  }

  List<AnalysisPair>? getGrossSales() {
    if (report == null) return null;

    switch (mode) {
      case ReportMode.day:
        return report!.current!
            .map(
              (s) => AnalysisPair(
                value: s.totalSales,
                id: TextFormatter.toShortDate(
                  dateTime: DateTime.utc(
                    s.key!.year!,
                    s.key!.month!,
                    s.key!.day!,
                    s.key!.hour!,
                  ).toLocal(),
                  format: 'hh:mm',
                ),
              ),
            )
            .toList();
      case ReportMode.week:
        return report!.current!
            .map(
              (s) => AnalysisPair(
                value: s.totalSales,
                id: TextFormatter.toShortDate(
                  dateTime: DateTime.utc(
                    s.key!.year!,
                    s.key!.month!,
                    s.key!.day!,
                  ).toLocal(),
                  format: 'dd-MMM',
                ),
              ),
            )
            .toList();
      case ReportMode.month:
        return report!.current!
            .map(
              (s) => AnalysisPair(
                value: s.totalSales,
                id: TextFormatter.toShortDate(
                  dateTime: DateTime.utc(
                    s.key!.year!,
                    s.key!.month!,
                    s.key!.day!,
                  ).toLocal(),
                  format: 'dd-MMM',
                ),
              ),
            )
            .toList();

      case ReportMode.threeMonths:
      case ReportMode.year:
      default:
        return report!.current!
            .map(
              (s) => AnalysisPair(
                value: s.totalSales,
                id: TextFormatter.toShortDate(
                  dateTime: DateTime.utc(s.key!.year!, s.key!.month!).toLocal(),
                  format: 'MMM',
                ),
              ),
            )
            .toList();
    }
  }

  List<AnalysisPair>? getSaleCounts() {
    if (report == null) return null;

    switch (mode) {
      case ReportMode.day:
        return report!.current!
            .map(
              (s) => AnalysisPair(
                value: s.saleCount,
                id: TextFormatter.toShortDate(
                  dateTime: DateTime.utc(
                    s.key!.year!,
                    s.key!.month!,
                    s.key!.day!,
                    s.key!.hour!,
                  ).toLocal(),
                  format: 'hh:mm',
                ),
              ),
            )
            .toList();
      case ReportMode.week:
        return report!.current!
            .map(
              (s) => AnalysisPair(
                value: s.saleCount,
                id: TextFormatter.toShortDate(
                  dateTime: DateTime.utc(
                    s.key!.year!,
                    s.key!.month!,
                    s.key!.day!,
                  ).toLocal(),
                  format: 'dd-MMM',
                ),
              ),
            )
            .toList();
      case ReportMode.month:
        return report!.current!
            .map(
              (s) => AnalysisPair(
                value: s.saleCount,
                id: TextFormatter.toShortDate(
                  dateTime: DateTime.utc(
                    s.key!.year!,
                    s.key!.month!,
                    s.key!.day!,
                  ).toLocal(),
                  format: 'dd-MMM',
                ),
              ),
            )
            .toList();

      case ReportMode.threeMonths:
      case ReportMode.year:
      default:
        return report!.current!
            .map(
              (s) => AnalysisPair(
                value: s.saleCount,
                id: TextFormatter.toShortDate(
                  dateTime: DateTime.utc(s.key!.year!, s.key!.month!).toLocal(),
                  format: 'MMM',
                ),
              ),
            )
            .toList();
    }
  }

  List<AnalysisPair>? getAverageSales() {
    if (report == null) return null;

    switch (mode) {
      case ReportMode.day:
        return report!.current!
            .map(
              (s) => AnalysisPair(
                value: double.parse(s.averageSale!.toStringAsFixed(2)),
                id: TextFormatter.toShortDate(
                  dateTime: DateTime.utc(
                    s.key!.year!,
                    s.key!.month!,
                    s.key!.day!,
                    s.key!.hour!,
                  ).toLocal(),
                  format: 'hh:mm',
                ),
              ),
            )
            .toList();
      case ReportMode.week:
        return report!.current!
            .map(
              (s) => AnalysisPair(
                value: double.parse(s.averageSale!.toStringAsFixed(2)),
                id: TextFormatter.toShortDate(
                  dateTime: DateTime.utc(
                    s.key!.year!,
                    s.key!.month!,
                    s.key!.day!,
                  ).toLocal(),
                  format: 'dd-MMM',
                ),
              ),
            )
            .toList();
      case ReportMode.month:
        return report!.current!
            .map(
              (s) => AnalysisPair(
                value: double.parse(s.averageSale!.toStringAsFixed(2)),
                id: TextFormatter.toShortDate(
                  dateTime: DateTime.utc(
                    s.key!.year!,
                    s.key!.month!,
                    s.key!.day!,
                  ).toLocal(),
                  format: 'dd-MMM',
                ),
              ),
            )
            .toList();

      case ReportMode.threeMonths:
      case ReportMode.year:
      default:
        return report!.current!
            .map(
              (s) => AnalysisPair(
                value: double.parse(s.averageSale!.toStringAsFixed(2)),
                id: TextFormatter.toShortDate(
                  dateTime: DateTime.utc(s.key!.year!, s.key!.month!).toLocal(),
                  format: 'MMM',
                ),
              ),
            )
            .toList();
    }
  }
}

class CustomersReportVM extends StoreViewModel with ReportVMBase {
  CustomersReportVM.fromStore(Store<AppState> store) : super.fromStore(store);

  CustomerReport? report;

  Function? onReportLoaded;

  late ReportService service;

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    this.store = store;
    service = ReportService.fromStore(store!);
    isLoading ??= false;
    hasError = false;

    runReport = (ctx) async {
      isLoading = true;
      await service
          .getCustomerReportByGroup(DateGroupType.values[mode!.index])
          .then((result) {
            report = result;
            isLoading = false;
          })
          .whenComplete(() {
            isLoading = false;

            if (null != onReportLoaded) onReportLoaded!();
          });

      return report;
    };

    if (mode == null) {
      mode = initialMode ?? ReportMode.day;
      runReport(null);
    }
  }
}

class ProductReportVM extends StoreViewModel with ReportVMBase {
  ProductReportVM.fromStore(Store<AppState> store) : super.fromStore(store);

  ProductReport? report;

  Function? onReportLoaded;

  @override
  // removed ignore: overridden_fields
  ReportMode? mode;

  late ReportService service;

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    this.store = store;
    service = ReportService.fromStore(store!);
    isLoading ??= false;
    hasError = false;

    runReport = (ctx) async {
      isLoading = true;

      //if (ctx != null) showProgress(context: ctx);

      if (mode == ReportMode.custom) {
        await service
            .getProductReportByGroupRange(
              startDate: startDate,
              endDate: endDate,
            )
            .then((result) {
              report = result;
              isLoading = false;
            })
            .whenComplete(() {
              isLoading = false;

              //if (ctx != null) hideProgress(ctx);
              if (null != onReportLoaded) onReportLoaded!();
            });
      } else {
        await service
            .getProductReportByGroup(DateGroupType.values[mode!.index])
            .then((result) {
              report = result;
              isLoading = false;
            })
            .whenComplete(() {
              isLoading = false;

              //if (ctx != null) hideProgress(ctx);
              if (null != onReportLoaded) onReportLoaded!();
            });
      }

      return report;
    };

    if (mode == null) {
      mode = initialMode ?? ReportMode.day;
      runReport(null);
    }
  }
}
