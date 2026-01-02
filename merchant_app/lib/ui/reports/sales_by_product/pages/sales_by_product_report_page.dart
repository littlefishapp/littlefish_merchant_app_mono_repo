// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/business/business_actions.dart';
import 'package:littlefish_merchant/redux/customer/customer_actions.dart';
import 'package:littlefish_merchant/tools/billing/billing_helpers.dart';
import 'package:littlefish_merchant/tools/date/date_tools.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/analysis/reports/sales/widgets/sales_boards.dart';
import 'package:littlefish_merchant/ui/business/users/view_models.dart';
import 'package:littlefish_merchant/ui/customers/viewmodels/customer_view_models.dart';
import 'package:littlefish_merchant/ui/reports/sales_by_product/pages/sales_by_product_datatable.dart';
import 'package:littlefish_merchant/ui/reports/sales_by_product/pages/sales_by_product_filter_page.dart';
import 'package:littlefish_merchant/ui/reports/sales_by_product/viewmodels/sales_by_product_report_vm.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

import '../../../../app/theme/applied_system/applied_text_icon.dart';

class SalesByProductReport extends StatefulWidget {
  static const String route = 'reports/sales-by-product';

  const SalesByProductReport({Key? key}) : super(key: key);

  @override
  State<SalesByProductReport> createState() => _SalesByProductReportState();
}

class _SalesByProductReportState extends State<SalesByProductReport> {
  SalesByProductReportVM? vm;

  PageController? pageController;

  @override
  void initState() {
    pageController = EnvironmentProvider.instance.isLargeDisplay!
        ? PageController(viewportFraction: 0.98, initialPage: 0)
        : PageController(viewportFraction: 0.85, initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var result = StoreConnector<AppState, List<dynamic>>(
      onInit: (store) {
        store.dispatch(initializeCustomers());
        store.dispatch(getUsers());
      },
      converter: (Store store) => [
        CustomersViewModel.fromStore(store as Store<AppState>),
        UsersListVM.fromStore(store),
      ],
      builder: (BuildContext context, List<dynamic> custVm) {
        vm ??=
            SalesByProductReportVM.fromStore(
                StoreProvider.of<AppState>(context),
                context: context,
              )
              ..reportLoaded = (report) {
                if (mounted) setState(() {});
              }
              ..onLoadingChanged = () {
                if (mounted) setState(() {});
              };

        vm!.customers = custVm[0].items;
        vm!.sellers = custVm[1].items;
        return EnvironmentProvider.instance.isLargeDisplay!
            ? _layoutTablet()
            : _layoutMobile();
      },
    );

    return result;
  }

  Widget _layoutMobile() => AppScaffold(
    title: 'Sales by Product',
    // displayFloat: vm.isLoading || !vm.hasData ? false : true,
    actions: vm!.isLoading! || !vm!.hasData
        ? []
        : [
            IconButton(
              icon: Icon(MdiIcons.filePdfBox),
              onPressed: () => vm!.onDownloadReport(context, true),
              color: Theme.of(context).colorScheme.onBackground,
            ),
            // IconButton(
            //   icon: Icon(MdiIcons.fileExcel),
            //   onPressed: () => vm.onDownloadReport(false),
            // ),
            IconButton(
              icon: Icon(
                Icons.search,
                color: Theme.of(
                  context,
                ).extension<AppliedTextIcon>()?.inversePrimary,
              ),
              onPressed: () => showPopupDialog(
                context: context,
                content: SalesByProductFilterPage(vm),
              ),
            ),
          ],
    floatIcon: Icons.search,
    // floatAction: () {
    //   showPopupDialog(
    //       context: context, content: SalesByProductFilterPage(vm));
    // },
    floatLocation: FloatingActionButtonLocation.endTop,
    body: vm!.isLoading!
        ? const AppProgressIndicator()
        : !vm!.hasData
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SalesByProductFilterPage(
              vm,
              showHeader: false,
              // parentContext: context,
            ),
          )
        : ListView(
            children: <Widget>[
              SizedBox(
                height: 60,
                child: Container(
                  color: Colors.white,
                  child: MaterialButton(
                    elevation: 4,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        vm!.dateSelectionString,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (isNotPremium('report_custom')) {
                        showPopupDialog(
                          defaultPadding: false,
                          context: context,
                          content: billingNavigationHelper(isModal: true),
                        );
                      } else {
                        vm!.selectDateRange(context).then((dates) {
                          if (dates != null) {
                            vm!.changeDates(dates[0], dates[1]);
                            vm!.changeMode(ReportMode.custom);
                            vm!.runReport(context);
                            vm!.getNextPage(context);

                            if (mounted) setState(() {});
                          }
                        });
                      }
                    },
                  ),
                ),
              ),
              const CommonDivider(),
              SizedBox(
                height: 240,
                child: Container(
                  color: Colors.grey.shade50,
                  child: PageView(
                    controller: pageController,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        child: SalesBoard(
                          isTile: true,
                          type: BoardType.doughnut,
                          data:
                              vm!.getDistinctAnalysisPairs!(
                                vm!.salesReport?.salesByPaymentType,
                              ) ??
                              [],
                          title: 'Sales by Payment Type',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        child: SalesBoard(
                          isTile: true,
                          type: BoardType.spline,
                          data: vm!.salesReport?.current
                              ?.map(
                                (s) => AnalysisPair(
                                  value: double.parse(
                                    s.totalSales!.toStringAsFixed(2),
                                  ),
                                  id: TextFormatter.toShortDate(
                                    dateTime: customToUTC(
                                      s.key!.year!,
                                      s.key?.month,
                                      s.key?.day,
                                    ),
                                    format: 'dd-MMM',
                                  ),
                                ),
                              )
                              .toList(),
                          title: 'Gross Sales',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const CommonDivider(),
              SalesByProductDatatable(vm: vm),
            ],
          ),
  );

  AppScaffold _layoutTablet() => AppScaffold(
    enableProfileAction: false,
    title: 'Sales by Product',
    displayFloat: vm!.isLoading! || !vm!.hasData ? false : true,
    floatIcon: Icons.search,
    floatAction: () {
      showPopupDialog(context: context, content: SalesByProductFilterPage(vm));
    },
    floatLocation: FloatingActionButtonLocation.endTop,
    body: vm!.isLoading!
        ? const AppProgressIndicator()
        : !vm!.hasData
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SalesByProductFilterPage(
              vm,
              showHeader: false,
              // parentContext: context,
            ),
          )
        : ListView(
            children: <Widget>[
              SizedBox(
                height: 60,
                child: Container(
                  color: Colors.white,
                  child: MaterialButton(
                    elevation: 4,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        vm!.dateSelectionString,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (isNotPremium('report_custom')) {
                        showPopupDialog(
                          defaultPadding: false,
                          context: context,
                          content: billingNavigationHelper(isModal: true),
                        );
                      } else {
                        vm!.selectDateRange(context).then((dates) {
                          if (dates != null) {
                            vm!.changeDates(dates[0], dates[1]);
                            vm!.changeMode(ReportMode.custom);
                            vm!.runReport(context);
                            vm!.getNextPage(context);

                            if (mounted) setState(() {});
                          }
                        });
                      }
                    },
                  ),
                ),
              ),
              const CommonDivider(),
              SizedBox(
                height: 240,
                child: Container(
                  color: Colors.grey.shade50,
                  child: PageView(
                    controller: pageController,
                    physics: const BouncingScrollPhysics(),
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              child: SalesBoard(
                                isTile: true,
                                type: BoardType.doughnut,
                                data: vm!.salesReport?.salesByPaymentType ?? [],
                                title: 'Sales by Payment Type',
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              child: SalesBoard(
                                isTile: true,
                                type: BoardType.spline,
                                data: vm!.salesReport?.current
                                    ?.map(
                                      (s) => AnalysisPair(
                                        value: double.parse(
                                          s.averageSale!.toStringAsFixed(2),
                                        ),
                                        id: TextFormatter.toShortDate(
                                          dateTime: DateTime.utc(
                                            s.key!.year!,
                                            s.key!.month!,
                                            s.key!.day!,
                                          ).toLocal(),
                                          format: 'dd',
                                        ),
                                      ),
                                    )
                                    .toList(),
                                title: 'Gross Sales',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const CommonDivider(),
              SalesByProductDatatable(vm: vm),
            ],
          ),
  );
}
