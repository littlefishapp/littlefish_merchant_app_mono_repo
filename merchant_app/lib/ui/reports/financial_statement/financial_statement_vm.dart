// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/reports/business_financials_view.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/analysis_service.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/ui/analysis/reports/shared/report_vm_base.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart'
    as an;

class FinancialStatementVM extends StoreViewModel<AppState> with ReportVMBase {
  FinancialStatementVM.fromStore(Store<AppState> store, {BuildContext? context})
    : super.fromStore(store, context: context);

  BusinessFinancialsView? reportData;

  late ReportService reportService;
  bool get hasData => reportData != null;
  Function? getDistinctAnalysisPairs;

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    this.store = store;
    state = store!.state;
    reportService = ReportService.fromStore(store);

    isLoading ??= false;

    if (mode == null) {
      changeDates(
        DateTime.now().toUtc().add(const Duration(days: -30)),
        DateTime.now().toUtc(),
      );
      mode = ReportMode.month;
    }

    runReport = (ctx) async {
      toggleLoading(value: true);

      await reportService
          .getBusinessFinancialStatement(startDate: startDate, endDate: endDate)
          .then((result) {
            reportData = result;

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
            if (reportLoaded != null) reportLoaded!(reportData);
          });

      return reportData;
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
