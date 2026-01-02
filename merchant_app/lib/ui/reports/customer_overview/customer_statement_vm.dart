// Flutter imports:
// removed ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:littlefish_core/business/models/business_user.dart';

// Package imports:
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/reports/customer_overview.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/analysis_service.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/ui/analysis/reports/shared/report_vm_base.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

class CustomerStatementVM extends StoreViewModel<AppState> with ReportVMBase {
  CustomerStatementVM.fromStore(Store<AppState> store, {BuildContext? context})
    : super.fromStore(store, context: context);

  List<Customer>? customers;
  List<BusinessUser>? sellers;

  CustomerOverview? reportData;
  Customer? selectedCustomer;
  late Function(Customer value) onSelectCustomer;

  List<BusinessUser> selectedSeller = [];

  late Function(BuildContext context) getNextPage;

  late Function(List<BusinessUser> value) onSelectSeller;
  Function(int value)? onLimitChange;
  late Function(int value) onOffsetChange;

  int limit = 10;
  int offset = 0;

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

    onSelectSeller = (value) => selectedSeller = value;
    onLimitChange = (value) => limit = value;
    onOffsetChange = (value) => offset = value;
    onSelectCustomer = (value) => selectedCustomer = value;

    runReport = (ctx) async {
      if (selectedCustomer == null) {
        showMessageDialog(
          context ?? ctx!,
          'Please select a customer',
          LittleFishIcons.info,
        );

        return null;
      } else {
        toggleLoading(value: true);

        reportService
            .getCustomerStatement(
              customerId: selectedCustomer?.id,
              limit: 10,
              offset: offset,
              startDate: startDate,
              endDate: endDate,
              sellers: (selectedSeller.map((p) => p.uid)).toList(),
            )
            .then((result) {
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
              toggleLoading(value: false);

              if (reportLoaded != null) reportLoaded!(reportData);
            });

        return reportData;
      }
    };
  }
}
