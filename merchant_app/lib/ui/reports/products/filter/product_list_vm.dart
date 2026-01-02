// Flutter imports:

import 'package:flutter/material.dart';

// Package imports:
import 'package:open_file/open_file.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/reports/number_filter.dart';
import 'package:littlefish_merchant/models/reports/paged_products.dart';
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/analysis_service.dart';
import 'package:littlefish_merchant/ui/analysis/reports/shared/report_vm_base.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

class ProductListVM extends StoreViewModel<AppState> with ReportVMBase {
  ProductListVM.fromStore(Store<AppState> store, {BuildContext? context})
    : super.fromStore(store, context: context);

  List<StockProduct> get products => state?.productState.products ?? [];
  List<StockCategory>? get categories => state?.productState.categories;

  List<StockCategory> selectedCategories = [];
  List<StockProduct> selectedProducts = [];
  NumberFilter marginFilter = NumberFilter(filterType: null);

  late Function(List<StockCategory> value) onSelectCategory;
  late Function(List<StockProduct> value) onSelectProduct;
  Function(NumberFilter value)? onSelectFilter;
  Function(int value)? onLimitChange;
  late Function(int value) onOffsetChange;
  late Function(bool isPDF) downloadProductList;

  int limit = 10;
  int offset = 0;

  late Function(BuildContext context) getNextPage;

  late ReportService reportService;

  List<AnalysisPair>? productSummary;
  PagedProducts? tableData;

  bool get hasData => productSummary != null;

  dynamic reportData;

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    this.store = store;
    state = store!.state;
    reportService = ReportService.fromStore(store);

    isLoading ??= false;

    onSelectCategory = (value) => selectedCategories = value;
    onSelectProduct = (value) => selectedProducts = value;
    onSelectFilter = (value) => marginFilter = value;
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
          .getProductSummary(
            products: (selectedProducts.map((p) => p.id)).toList(),
            categories: (selectedCategories.map((p) => p.id)).toList(),
            marginFilter: marginFilter.filterType == null ? null : marginFilter,
          )
          .then((result) {
            productSummary = result;

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
            if (reportLoaded != null) reportLoaded!(productSummary);
          });

      return productSummary;
    };

    getNextPage = (ctx) async {
      if (tableData != null) tableData!.count = -1;

      await reportService
          .getProductListFiltered(
            limit: products.length,
            offset: offset,
            categories: (selectedCategories.map((p) => p.id)).toList(),
            products: (selectedProducts.map((p) => p.id)).toList(),
            marginFilter: marginFilter.filterType == null ? null : marginFilter,
          )
          .then((result) {
            tableData = result;
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
            if (reportLoaded != null) reportLoaded!(tableData);
            return tableData;
          });
    };

    downloadProductList = (isPDF) async {
      try {
        var report = await reportService.downloadProductsList(isPDF: isPDF);
        if (report.isNotEmpty) {
          OpenFile.open(report);
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    };
  }
}
