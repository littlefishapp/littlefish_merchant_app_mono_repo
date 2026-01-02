// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_core/business/models/business_user.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/reports/inventory_overview.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/analysis_service.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/ui/analysis/reports/shared/report_vm_base.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

// remove ignore: implementation_imports

class InventoryReportVM extends StoreViewModel<AppState> with ReportVMBase {
  InventoryReportVM.fromStore(Store<AppState> store, {BuildContext? context})
    : super.fromStore(store, context: context);

  List<Customer>? customers;
  List<BusinessUser>? sellers;

  List<InventoryOverview>? reportData;

  late ReportService reportService;

  bool get hasData => reportData != null;

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
      reportService.getInventoryOverview().then((result) {
        reportData = result;

        if (result == null) {
          showMessageDialog(
            context ?? ctx!,
            'No data found, please check your filter values',
            LittleFishIcons.info,
          ).then((v) {
            toggleLoading(value: false);
          });
        } else {
          toggleLoading(value: false);
          // Navigator.of(ctx).push(MaterialPageRoute(
          //     builder: (ctxx) => InventoryReportPage(
          //           vm: this,
          //         ));
        }
      });
    };
  }

  Future<List<InventoryOverview>> getInvReport(context) {
    return reportService.getInventoryOverview().then((result) {
      reportData = result;

      if (result == null) {
        showMessageDialog(
          context,
          'No data found, please check your filter values',
          LittleFishIcons.info,
        ).then((v) {
          toggleLoading(value: false);
        });
      } else {
        toggleLoading(value: false);
        // Navigator.of(ctx).push(MaterialPageRoute(
        //     builder: (ctxx) => InventoryReportPage(
        //           vm: this,
        //         ));
      }

      return result!;
    });
  }
}
