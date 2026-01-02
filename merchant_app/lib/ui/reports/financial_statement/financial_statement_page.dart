// Flutter imports:
import 'package:flutter/material.dart';
import 'dart:math';
// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/tools/billing/billing_helpers.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/reports/financial_statement/financial_statement_vm.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class FinancialStatementPage extends StatefulWidget {
  static const route = 'report/financial-statement';

  const FinancialStatementPage({Key? key}) : super(key: key);

  @override
  State<FinancialStatementPage> createState() => _FinancialStatementPageState();
}

class _FinancialStatementPageState extends State<FinancialStatementPage> {
  FinancialStatementVM? vm;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    vm ??=
        FinancialStatementVM.fromStore(
            StoreProvider.of(context),
            context: context,
          )
          ..reportLoaded = (report) {
            if (mounted) setState(() {});
          }
          ..onLoadingChanged = () {
            if (mounted) setState(() {});
          };

    return _layout(context);
  }

  AppScaffold _layout(BuildContext context) {
    return AppScaffold(
      title: 'Financial Statement',
      body: vm!.isLoading!
          ? const AppProgressIndicator()
          : Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Container(
                        height: 60,
                        color: Colors.grey.shade50,
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

                                  if (mounted) setState(() {});
                                }
                              });
                            }
                          },
                        ),
                      ),
                      if (vm!.hasData) ...financialBreakdown(vm!),
                    ],
                  ),
                ),
                ...vm!.hasData ? [] : noData(),
              ],
            ),
    );
  }

  List<Widget> financialBreakdown(FinancialStatementVM vm) {
    double netSales = 0;
    double grossSales = 0;
    double costOfGoodsSold = 0;
    double grossProfit = 0;
    double grossProfitMargin = 0;
    double netProfit = 0;
    double netProfitMargin = 0;
    if (vm.reportData != null) {
      grossSales = (vm.reportData!.totalRevenue ?? 0);
      netSales =
          ((vm.reportData!.totalRevenue ?? 0) -
          (vm.reportData!.totalRefundedSales ?? 0) -
          (vm.reportData!.totalDiscount ?? 0));
      costOfGoodsSold =
          ((vm.reportData!.totalSalesCost ?? 0) -
          (vm.reportData!.totalRefundedSalesCost ?? 0));
      grossProfit = netSales - costOfGoodsSold;
      grossProfitMargin = grossProfit / netSales * 100;
      netProfit =
          grossProfit -
          (vm.reportData!.totalExpenses ?? 0) -
          (vm.reportData!.totalTax ?? 0);
      netProfitMargin = netProfit / netSales * 100;
    }
    return [
      const CommonDivider(),
      revenueSection(netSales, grossSales, vm),
      const CommonDivider(),
      //Cost of sales
      costOfSalesSection(costOfGoodsSold, vm),
      const CommonDivider(),
      //Gross Profit
      ListTile(
        tileColor: Theme.of(context).colorScheme.background,
        title: const Text(
          'Gross Profit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Container(
          margin: const EdgeInsets.only(right: 40),
          child: Text(
            TextFormatter.toStringCurrency(
              grossProfit,
              displayCurrency: false,
              currencyCode: '',
            ),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      const CommonDivider(),
      //Gross Profit %
      ListTile(
        tileColor: Theme.of(context).colorScheme.background,
        title: const Text(
          'Gross Profit Margin',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Container(
          margin: const EdgeInsets.only(right: 40),
          child: Text(
            '${roundDouble(grossProfitMargin, 1)} %',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      const CommonDivider(),
      //Expenses
      expenses(vm),
      const CommonDivider(),
      tax(vm),
      const CommonDivider(),
      //Net Profit
      ListTile(
        tileColor: Theme.of(context).colorScheme.background,
        title: const Text(
          'Net Profit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Container(
          margin: const EdgeInsets.only(right: 40),
          child: Text(
            TextFormatter.toStringCurrency(
              netProfit,
              displayCurrency: false,
              currencyCode: '',
            ),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      const CommonDivider(),
      //Profit Margin
      ListTile(
        tileColor: Theme.of(context).colorScheme.background,
        title: const Text(
          'Net Profit Margin',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Container(
          margin: const EdgeInsets.only(right: 40),
          child: Text(
            '${roundDouble(netProfitMargin, 1)} %',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      const CommonDivider(),
    ];
  }

  Widget revenueSection(
    double netSales,
    double grossSales,
    FinancialStatementVM vm,
  ) => //Net Revenue
  ExpansionTile(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text('Net Sales'),
        Text(
          TextFormatter.toStringCurrency(
            netSales,
            displayCurrency: false,
            currencyCode: '',
          ),
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
    children: [
      //Total Sales
      ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text('Gross Sales'),
            Text(
              TextFormatter.toStringCurrency(
                grossSales,
                displayCurrency: false,
                currencyCode: '',
              ),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        children: setAnalysisPairs(
          vm.getDistinctAnalysisPairs!(vm.reportData!.paymentType!),
        ),
      ),
      const CommonDivider(),
      //Refunds
      ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text('Refunds'),
            Text(
              TextFormatter.toStringCurrency(
                vm.reportData!.totalRefundedSales,
                displayCurrency: false,
                currencyCode: '',
              ),
              style: TextStyle(
                color: Colors.red.shade500,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        children: setAnalysisPairs(
          vm.getDistinctAnalysisPairs!(vm.reportData!.refundPaymentType!),
        ),
      ),
      const CommonDivider(),
      //Discounts
      ListTile(
        tileColor: Theme.of(context).colorScheme.background,
        title: const Text('Discounts'),
        trailing: Container(
          margin: const EdgeInsets.only(right: 40),
          child: Text(
            TextFormatter.toStringCurrency(
              vm.reportData!.totalDiscount,
              displayCurrency: false,
              currencyCode: '',
            ),
            style: TextStyle(color: Colors.red.shade500, fontSize: 16),
          ),
        ),
      ),
    ],
  );

  Widget costOfSalesSection(double costOfSales, FinancialStatementVM vm) =>
      ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text('Cost of Goods Sold'),
            Text(
              TextFormatter.toStringCurrency(
                costOfSales,
                displayCurrency: false,
                currencyCode: '',
              ),
              style: TextStyle(
                color: Colors.red.shade500,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        children: [
          //Cost of Sales
          ListTile(
            tileColor: Theme.of(context).colorScheme.background,
            title: const Text('Cost of Goods Sold'),
            trailing: Container(
              margin: const EdgeInsets.only(right: 40),
              child: Text(
                TextFormatter.toStringCurrency(
                  vm.reportData!.totalSalesCost,
                  displayCurrency: false,
                  currencyCode: '',
                ),
                style: TextStyle(color: Colors.red.shade500, fontSize: 16),
              ),
            ),
          ),
          const CommonDivider(),
          //refunded Cost of Sales
          ListTile(
            tileColor: Theme.of(context).colorScheme.background,
            title: const Text('Refunded Cost of Sales'),
            trailing: Container(
              margin: const EdgeInsets.only(right: 40),
              child: Text(
                TextFormatter.toStringCurrency(
                  vm.reportData!.totalRefundedSalesCost,
                  displayCurrency: false,
                  currencyCode: '',
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      );

  Widget expenses(FinancialStatementVM vm) => ExpansionTile(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text('Expenses'),
        Text(
          TextFormatter.toStringCurrency(
            (vm.reportData!.totalExpenses ?? 0),
            displayCurrency: false,
            currencyCode: '',
          ),
          style: TextStyle(
            color: Colors.red.shade500,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
    children: [
      //Operating Expenses
      ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Operating Expenses'),
            Text(
              TextFormatter.toStringCurrency(
                vm.reportData!.totalExpenses,
                displayCurrency: false,
                currencyCode: '',
              ),
              style: TextStyle(color: Colors.red.shade500),
            ),
          ],
        ),
        children: setAnalysisPairs(vm.reportData!.expenseType!),
      ),
    ],
  );

  Widget tax(FinancialStatementVM vm) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      title: const Text('Tax', style: TextStyle(fontWeight: FontWeight.bold)),
      trailing: Container(
        margin: const EdgeInsets.only(right: 40),
        child: Text(
          TextFormatter.toStringCurrency(
            vm.reportData!.totalTax,
            displayCurrency: false,
            currencyCode: '',
          ),
          style: TextStyle(
            color: Colors.red.shade500,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  List<Widget> noData() {
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ButtonSecondary(
            text: 'Run Report',
            onTap: (c) {
              vm!.runReport(context);
              if (mounted) setState(() {});
            },
          ),
        ),
      ),
      const SizedBox(height: 32),
    ];
  }

  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    if (mod != 0) {
      return ((value * mod).round().toDouble() / mod);
    } else {
      return 0;
    }
  }

  double getPercentage(double profit, double revenue) {
    if (revenue != 0) {
      return roundDouble((profit / revenue) * 100, 1);
    } else {
      return 0;
    }
  }

  List<ListTile> setAnalysisPairs(List<AnalysisPair> items) {
    return items.map((item) {
      return ListTile(
        tileColor: Theme.of(context).colorScheme.background,
        title: Text('${item.id}'),
        dense: true,
        trailing: Text(
          TextFormatter.toStringCurrency(
            item.value,
            displayCurrency: false,
            currencyCode: '',
          ),
        ),
      );
    }).toList();
  }
}

enum PercentageType { profitMargin, grossProfit }
