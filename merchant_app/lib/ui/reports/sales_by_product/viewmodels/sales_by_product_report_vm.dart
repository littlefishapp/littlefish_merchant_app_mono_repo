import 'package:flutter/material.dart';
import 'package:littlefish_core/business/models/business_user.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/reports/number_filter.dart';
import 'package:littlefish_merchant/models/reports/paged_checkout_transaction_view.dart';
import 'package:littlefish_merchant/models/reports/sales_report.dart';

import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/analysis_service.dart';
import 'package:littlefish_merchant/ui/analysis/reports/shared/report_vm_base.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart'
    as an;

import '../../../../app/custom_route.dart';
import '../../../../common/presentaion/pages/pdf_viewer/local_pdf_viewer_page.dart';
import '../../../../models/reports/paged_product_sales_summary_view.dart';

class SalesByProductReportVM extends StoreViewModel<AppState>
    with ReportVMBase {
  SalesByProductReportVM.fromStore(
    Store<AppState> store, {
    BuildContext? context,
  }) : super.fromStore(store, context: context);

  List<StockProduct> get products => state?.productState.products ?? [];
  List<StockCategory> get categories => state?.productState.categories ?? [];
  List<Customer>? customers;
  List<BusinessUser>? sellers;

  List<StockCategory> selectedCategories = [];
  List<StockProduct> selectedProducts = [];
  List<Customer> selectedCustomer = [];
  List<BusinessUser> selectedSeller = [];
  NumberFilter marginFilter = NumberFilter(filterType: null);

  late Function(List<StockCategory> value) onSelectCategory;
  late Function(List<StockProduct> value) onSelectProduct;
  late Function(List<Customer> value) onSelectCustomer;
  late Function(List<BusinessUser> value) onSelectSeller;
  Function(NumberFilter value)? onSelectFilter;
  Function(int value)? onLimitChange;
  late Function(int value) onOffsetChange;
  late Function(BuildContext context, bool isPdf) onDownloadReport;

  int limit = 10;
  int offset = 0;

  late Function(BuildContext context) getNextPage;

  late ReportService reportService;

  Function? getDistinctAnalysisPairs;

  SalesReport? salesReport;
  PagedCheckoutTransactionView? tableData;
  PagedProductSalesSummaryView? summaryTableData;

  bool get hasData => salesReport != null;

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    this.store = store;
    state = store!.state;
    reportService = ReportService.fromStore(store);
    // store.dispatch(action)

    isLoading ??= false;

    onSelectCategory = (value) => selectedCategories = value;
    onSelectProduct = (value) => selectedProducts = value;
    onSelectFilter = (value) => marginFilter = value;
    onSelectCustomer = (value) => selectedCustomer = value;
    onSelectSeller = (value) => selectedSeller = value;
    onLimitChange = (value) => limit = value;
    onOffsetChange = (value) => offset = value;

    if (mode == null) {
      changeDates(
        DateTime.now().toUtc().add(const Duration(days: -30)),
        DateTime.now().toUtc(),
      );
      mode = ReportMode.month;
    }

    //do logic here for all report pulls / data loads
    runReport = (ctx) async {
      toggleLoading(value: true);

      await reportService
          .getSalesByProductReportFiltered(
            startDate: startDate,
            endDate: endDate,
            products: (selectedProducts.map((p) => p.id)).toList(),
            categories: (selectedCategories.map((p) => p.id)).toList(),
            customers: (selectedCustomer.map((p) => p.id)).toList(),
            sellers: (selectedSeller.map((p) => p.uid)).toList(),
          )
          .then((result) {
            salesReport = result;

            if (result == null) {
              showMessageDialog(
                context ?? ctx!,
                'No data found, please try again',
                LittleFishIcons.info,
              ).then((v) {
                toggleLoading(value: false);
              });
            } else {
              toggleLoading(value: false);
            }
          })
          .catchError((error) {
            showMessageDialog(
              context ?? ctx!,
              'Something went wrong',
              LittleFishIcons.error,
            ).then((v) {
              toggleLoading(value: false);
            });

            reportCheckedError(error, trace: StackTrace.current);
          })
          .whenComplete(() {
            if (reportLoaded != null) reportLoaded!(salesReport);
          });

      return salesReport;
    };

    getNextPage = (ctx) async {
      // toggleLoading(value: true);

      if (summaryTableData != null) summaryTableData!.count = -1;

      await reportService
          .getProductSalesSummaryFiltered(
            startDate: startDate,
            endDate: endDate,
            products: (selectedProducts.map((p) => p.id)).toList(),
            categories: (selectedCategories.map((p) => p.id)).toList(),
            customers: (selectedCustomer.map((p) => p.id)).toList(),
            sellers: (selectedSeller.map((p) => p.uid)).toList(),
          )
          .then((result) {
            summaryTableData = result;
          })
          .catchError((error) {
            showMessageDialog(
              context ?? ctx,
              'Something went wrong',
              LittleFishIcons.error,
            ).then((v) {});

            reportCheckedError(error, trace: StackTrace.current);
            // TODO(lampian): fix
          })
          .whenComplete(() {
            if (reportLoaded != null) reportLoaded!(summaryTableData);
            return summaryTableData;
          });
    };

    onDownloadReport = (context, isPDF) async {
      try {
        var report = await reportService.downloadSalesReportDateRange(
          startDate,
          endDate,
          isPDF: isPDF,
        );
        if (context.mounted) {
          Navigator.of(context).push(
            CustomRoute(
              builder: (ctx) => LocalPdfViewerPage(
                title: 'Pdf report',
                path: report,
                pdfSource: PdfSource.isFile,
              ),
            ),
          );
        }
        // OpenFile.open(report);
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
      }
    };

    getDistinctAnalysisPairs = (List<an.AnalysisPair> data) {
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
    };
  }
}
