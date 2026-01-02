// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/business/business_actions.dart';
import 'package:littlefish_merchant/redux/customer/customer_actions.dart';
import 'package:littlefish_merchant/tools/billing/billing_helpers.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/business/users/view_models.dart';
import 'package:littlefish_merchant/ui/customers/viewmodels/customer_view_models.dart';
import 'package:littlefish_merchant/ui/reports/customer_overview/customer_data_table.dart';
import 'package:littlefish_merchant/ui/reports/customer_overview/customer_filter_page.dart';
import 'package:littlefish_merchant/ui/reports/customer_overview/customer_statement_vm.dart';
import 'package:littlefish_merchant/ui/reports/shared/widgets/summary_card.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class CustomerStatementPage extends StatefulWidget {
  static const route = 'reports/customer-statement';

  const CustomerStatementPage({Key? key}) : super(key: key);

  @override
  State<CustomerStatementPage> createState() => _CustomerStatementPageState();
}

class _CustomerStatementPageState extends State<CustomerStatementPage> {
  CustomerStatementVM? vm;
  GlobalKey<AutoCompleteTextFieldState<Customer>>? filterkey;
  PageController? pageController;

  @override
  void initState() {
    pageController = PageController(viewportFraction: 0.6, initialPage: 0);
    filterkey = GlobalKey<AutoCompleteTextFieldState<Customer>>();
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
            CustomerStatementVM.fromStore(
                StoreProvider.of(context),
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
        return _layout();
      },
    );

    return result;
  }

  AppScaffold _layout() => AppScaffold(
    title: 'Customer Statement',
    displayFloat: vm!.isLoading! || !vm!.hasData ? false : true,
    floatIcon: Icons.search,
    floatAction: () {
      showPopupDialog(context: context, content: CustomerFilterPage(vm));
    },
    floatLocation: FloatingActionButtonLocation.endTop,
    body: vm!.isLoading!
        ? const AppProgressIndicator()
        : !vm!.hasData
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CustomerFilterPage(vm, showHeader: false),
          )
        : EnvironmentProvider.instance.isLargeDisplay!
        ? _bodyTablet(context, vm!)
        : _bodyMobile(context, vm!),
  );

  ListView _bodyMobile(BuildContext context, CustomerStatementVM vm) =>
      ListView(
        physics: const BouncingScrollPhysics(),
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
                    vm.dateSelectionString,
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
                    vm.selectDateRange(context).then((dates) {
                      if (dates != null) {
                        vm.changeDates(dates[0], dates[1]);
                        vm.changeMode(ReportMode.custom);
                        vm.runReport(context);
                        vm.getNextPage(context);

                        if (mounted) setState(() {});
                      }
                    });
                  }
                },
              ),
            ),
          ),
          SizedBox(
            height: 120,
            child: Container(
              color: Colors.grey.shade50,
              child: PageView(
                controller: pageController,
                children: <Widget>[
                  SummaryCard(
                    context,
                    value:
                        vm.reportData?.totalSaleValue?.toStringAsFixed(2) ??
                        0 as String,
                    title: 'Total Purchased',
                  ),
                  SummaryCard(
                    context,
                    value:
                        vm.reportData?.lastSaleValue?.toStringAsFixed(2) ??
                        0 as String,
                    title: 'Last Purchase Amount',
                  ),
                  SummaryCard(
                    context,
                    value:
                        vm.reportData?.avgSaleValue?.toStringAsFixed(2) ??
                        0 as String,
                    title: 'Average Purchase Amount',
                  ),
                  SummaryCard(
                    context,
                    value: TextFormatter.toShortDate(
                      dateTime: vm.reportData?.lastPurchaseDate,
                    ).toString(),
                    title: 'Last Purchase Date',
                    isString: true,
                  ),
                  // SummaryCard(context,
                  //     value: vm.reportData?.favoriteItem?.id ?? 'None',
                  //     title: 'Most Bought Item',
                  //     isNotCurrency: true,
                  //     isString: true),
                ],
              ),
            ),
          ),
          const CommonDivider(),
          CustomerDataTable(vm: vm),
        ],
      );

  ListView _bodyTablet(BuildContext context, CustomerStatementVM vm) =>
      ListView(
        physics: const BouncingScrollPhysics(),
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
                    vm.dateSelectionString,
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
                    vm.selectDateRange(context).then((dates) {
                      if (dates != null) {
                        vm.changeDates(dates[0], dates[1]);
                        vm.changeMode(ReportMode.custom);
                        vm.runReport(context);
                        vm.getNextPage(context);

                        if (mounted) setState(() {});
                      }
                    });
                  }
                },
              ),
            ),
          ),
          SizedBox(
            height: 120,
            child: Container(
              color: Colors.grey.shade50,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  SummaryCard(
                    context,
                    value:
                        vm.reportData?.totalSaleValue?.toStringAsFixed(2) ??
                        0 as String,
                    title: 'Total Purchased',
                  ),
                  SummaryCard(
                    context,
                    value:
                        vm.reportData?.lastSaleValue?.toStringAsFixed(2) ??
                        0 as String,
                    title: 'Last Purchase Amount',
                  ),
                  SummaryCard(
                    context,
                    value:
                        vm.reportData?.avgSaleValue?.toStringAsFixed(2) ??
                        0 as String,
                    title: 'Average Purchase Amount',
                  ),
                  SummaryCard(
                    context,
                    value: TextFormatter.toShortDate(
                      dateTime: vm.reportData?.lastPurchaseDate,
                    ),
                    title: 'Last Purchase Date',
                    isString: true,
                  ),
                  // SummaryCard(context,
                  //     value: vm.reportData?.favoriteItem?.id ?? 'None',
                  //     title: 'Most Bought Item',
                  //     isNotCurrency: true,
                  //     isString: true),
                ],
              ),
            ),
          ),
          const CommonDivider(),
          CustomerDataTable(vm: vm),
        ],
      );
}
