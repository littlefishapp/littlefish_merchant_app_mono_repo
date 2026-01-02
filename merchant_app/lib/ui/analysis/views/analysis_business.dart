import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/analysis/reports/sales/pages/sales_report_page.dart';
import 'package:littlefish_merchant/ui/reports/inventory_report/inventory_report_page.dart';
import 'package:littlefish_merchant/ui/reports/sales_by_product/pages/sales_by_product_report_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/percentage_bar.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:quiver/strings.dart';
import '../../../common/presentaion/components/cards/card_neutral.dart';
import '../../../common/presentaion/components/long_text.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import '../../../common/presentaion/components/text_tag.dart';

class BusinessOverview extends StatelessWidget {
  final BusinessOverviewCount? overview;

  final int? currentView;

  const BusinessOverview({
    Key? key,
    required this.overview,
    this.currentView = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);

    if (overview == null) {
      return Center(
        child: TextTag(
          displayText: 'No Data',
          fontSize: 36.0,
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    return overview == null
        ? const Center(child: TextTag(displayText: 'No Data', fontSize: 32))
        : currentView == 0
        ? mobileLayout(context, store, overview!)
        : mobileLayoutList(context, store, overview!);
  }

  Widget inventoryCard(double value, BuildContext context) => CardNeutral(
    child: InkWell(
      onTap: () => Navigator.of(context).pushNamed(InventoryReportPage.route),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 4, top: 8),
                  child: context.labelSmall(
                    'Inventory Retail Value'.toUpperCase(),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, right: 4),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.chevron_right,
                        // size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 4),
              child: Text(
                TextFormatter.toShortDate(
                  dateTime: DateTime.now().toUtc(),
                  format: 'MMMM yyyy',
                ),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                TextFormatter.toStringCurrency(
                  value,
                  displayCurrency: false,
                  currencyCode: '',
                ),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const Center(child: CommonDivider(width: 0.5)),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: const Center(
                child: Text(
                  'Calculated using sale price',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Container mobileLayout(context, store, BusinessOverviewCount data) =>
      Container(
        color: Colors.grey.shade50,
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: ReportProfitCard(
                refundSalesTotal: data.totalRefundedSales ?? 0,
                refundCostTotal: data.totalRefundedSalesCost ?? 0,
                expensesTotal: data.totalExpenses ?? 0,
                grossSalesTotal: data.totalSalesValue ?? 0,
                netProfit: data.totalProfit ?? 0,
                costOfGoodsSoldTotal: data.totalSalesCost ?? 0,
                discountTotal: data.totalDiscount ?? 0,
                taxTotal: data.totalTax ?? 0,
                // onTap: () =>
                //     Navigator.of(context).pushNamed(SalesReportPage.route),
              ),
            ),
            // Container(
            //     margin: const EdgeInsets.symmetric(horizontal: 12),
            //     child: inventoryCard(
            //       data.totalInventoryValue ?? 0.0,
            //       context,
            //     ),
            //   ),
            Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: GridView.count(
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 0,
                childAspectRatio: 1.5,
                shrinkWrap: true,
                children: [
                  analysisItem(
                    context,
                    'Order Count',
                    (data.salesCount ?? 0).round().toString(),
                    'total sales',
                    // route: SalesByProductReport.route,
                  ),
                  analysisItem(
                    context,
                    'Average Order Value',
                    ((data.totalSalesValue ?? 0) > 0 &&
                            (data.salesCount ?? 0) > 0)
                        ? TextFormatter.toStringCurrency(
                            data.totalSalesValue! / data.salesCount!,
                            displayCurrency: false,
                            currencyCode: '',
                          )
                        : '0',
                    'average sale',
                    // route: SalesReportPage.route,
                  ),
                  analysisItem(
                    context,
                    'Items Sold',
                    (data.totalItemsSold ?? 0).round().toString(),
                    'total sales',
                    // route: SalesByProductReport.route,
                  ),
                  analysisItem(
                    context,
                    'Average Items Sold',
                    (data.avgItemsSold ?? 0).round().toString(),
                    'average sale',
                    // route: SalesByProductReport.route,
                  ),
                  if (store.state.enableEmployee == true)
                    analysisItem(
                      context,
                      'Employee Count',
                      (data.employeeCount ?? 0).round().toString(),
                      'trusted staff',
                    ),
                ],
              ),
            ),
          ],
        ),
      );

  ListView mobileLayoutList(
    context,
    store,
    BusinessOverviewCount data,
  ) => ListView(
    shrinkWrap: true,
    physics: const BouncingScrollPhysics(),
    children: <Widget>[
      analysisItemList(
        context,
        'Net Sales',
        TextFormatter.toStringCurrency(
          (data.totalSalesValue ?? 0.0) -
              (data.totalRefundedSales ?? 0.0) -
              (data.totalDiscount ?? 0.0),
          currencyCode: '',
        ),
        'net sales',
        route: SalesReportPage.route,
      ),
      analysisItemList(
        context,
        'Total Cost of Goods Sold',
        TextFormatter.toStringCurrency(
          (data.totalSalesCost ?? 0.0) - (data.totalRefundedSalesCost ?? 0.0),
          currencyCode: '',
        ),
        'total cost of goods sold',
        route: SalesReportPage.route,
      ),
      analysisItemList(
        context,
        'Total Expenses',
        TextFormatter.toStringCurrency(
          data.totalExpenses ?? 0.0,
          currencyCode: '',
        ),
        'total expenses',
        route: SalesReportPage.route,
      ),
      analysisItemList(
        context,
        'Total Tax',
        TextFormatter.toStringCurrency(data.totalTax ?? 0.0, currencyCode: ''),
        'total tax',
        route: SalesReportPage.route,
      ),
      analysisItemList(
        context,
        'Net Profit',
        TextFormatter.toStringCurrency(
          data.totalProfit ?? 0.0,
          currencyCode: '',
        ),
        'net profit',
        route: SalesReportPage.route,
      ),
      const CommonDivider(),
      analysisItemList(
        context,
        'Order Count',
        (data.salesCount ?? 0).round().toString(),
        'total sales',
        route: SalesByProductReport.route,
      ),
      const CommonDivider(),
      analysisItemList(
        context,
        'Average Order Value',
        ((data.totalSalesValue ?? 0) > 0 && (data.salesCount ?? 0) > 0)
            ? TextFormatter.toStringCurrency(
                data.totalSalesValue! / data.salesCount!,
                currencyCode: '',
              )
            : '0',
        'average sale',
      ),
      const CommonDivider(),
      analysisItemList(
        context,
        'Items Sold',
        (data.totalItemsSold ?? 0).round().toString(),
        'items sold',
        // route: SalesByProductReport.route,
      ),
      const CommonDivider(),
      analysisItemList(
        context,
        'Average Items Sold',
        (data.avgItemsSold ?? 0).round().toString(),
        'average sale',
      ),
      const CommonDivider(),
      if (store.state.enableEmployee == true)
        analysisItemList(
          context,
          'Employee Count',
          (data.employeeCount ?? 0).round().toString(),
          'trusted staff',
        ),
    ],
  );

  // _staticValues(
  //   BuildContext context,
  //   BusinessOverviewCount data,
  // ) =>
  //     GridView.count(
  //         crossAxisCount: 2,
  //         mainAxisSpacing: 8,
  //         crossAxisSpacing: 0,
  //         childAspectRatio: 1.5,
  //         shrinkWrap: true,
  //         children: [
  //           analysisItem(
  //             context,
  //             'Customer Count',
  //             (data.customerCount ?? 0).round().toString(),
  //             'Total number of customers',
  //             route: CustomersReportPage.route,
  //           ),
  //           analysisItem(
  //             context,
  //             'Product Count',
  //             (data.productCount ?? 0).round().toString(),
  //             'Total number of products',
  //             route: ProductsReportPage.route,
  //           ),
  //           analysisItem(
  //             context,
  //             'Supplier Count',
  //             (data.supplierCount ?? 0).round().toString(),
  //             'Total number of suppliers',
  //             route: ProductsReportPage.route,
  //           ),
  //           if (AppVariables.store!.state.enableEmployee == true)
  //             analysisItem(
  //               context,
  //               'Employee Count',
  //               (data.employeeCount ?? 0).round().toString(),
  //               'trusted staff',
  //             ),
  //         ]);

  analysisItem(
    BuildContext context,
    String heading,
    String value,
    String subTitle, {
    String? route,
  }) => CardNeutral(
    child: InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: (route != null)
          ? () => Navigator.of(context).pushNamed(route)
          : () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          context.labelMedium(value),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              context.labelSmall(heading),
              if (isNotBlank(route)) const Icon(Icons.chevron_right, size: 18),
            ],
          ),
        ],
      ),
    ),
  );

  ListTile analysisItemList(
    context,
    String heading,
    String value,
    String subTitle, {
    String? route,
  }) => ListTile(
    tileColor: Theme.of(context).colorScheme.background,
    // isThreeLine: true,
    title: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          heading,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 28.0,
          ),
        ),
      ],
    ),
    trailing: route == null
        ? null
        : const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Icon(Icons.arrow_forward)],
          ),
    subtitle: LongText(subTitle, fontSize: 12),
    onTap: route == null
        ? null
        : () => Navigator.of(context).pushNamed(route, arguments: currentView),
  );
}

// ignore: must_be_immutable
class ReportProfitCard extends StatelessWidget {
  final double? expensesTotal;

  final double? refundSalesTotal;

  final double? refundCostTotal;

  final double? grossSalesTotal;

  final double? discountTotal;

  final double? taxTotal;

  final double? netProfit;

  final double? costOfGoodsSoldTotal;

  final Function? onTap;

  double? _netSales;

  double? _costOfSales;
  double? _maxValue;
  bool? _isProfitable;

  ReportProfitCard({
    Key? key,
    required this.expensesTotal,
    required this.refundSalesTotal,
    required this.refundCostTotal,
    required this.grossSalesTotal,
    required this.netProfit,
    required this.discountTotal,
    required this.costOfGoodsSoldTotal,
    required this.taxTotal,
    this.onTap,
  }) : super(key: key);

  void onInitState() {
    _netSales = grossSalesTotal! - discountTotal! - refundSalesTotal!;
    _costOfSales = costOfGoodsSoldTotal! - refundCostTotal!;
    _maxValue = expensesTotal! > (_netSales ?? 0) ? expensesTotal : _netSales;
    _maxValue = costOfGoodsSoldTotal! > (_maxValue ?? 0)
        ? costOfGoodsSoldTotal!
        : _maxValue;
    _maxValue = taxTotal! > (_maxValue ?? 0) ? taxTotal! : _maxValue;
    _isProfitable = netProfit! > 0;
  }

  @override
  Widget build(BuildContext context) {
    _netSales ??= grossSalesTotal! - discountTotal! - refundSalesTotal!;
    _costOfSales = costOfGoodsSoldTotal! - refundCostTotal!;
    if (_maxValue == null) {
      _maxValue = expensesTotal! > (_netSales ?? 0) ? expensesTotal : _netSales;

      _maxValue = costOfGoodsSoldTotal! > (_maxValue ?? 0)
          ? costOfGoodsSoldTotal!
          : _maxValue;
      _maxValue = taxTotal! > (_maxValue ?? 0) ? taxTotal! : _maxValue;
    }
    _isProfitable ??= netProfit! > 0;
    final showTotalSales = (_netSales ?? 0.0) >= 0.0;
    final showCostOfSales = (_costOfSales ?? 0.0) > 0.0;
    final showExpenses = (expensesTotal ?? 0.0) > 0.0;
    final showTax = (taxTotal ?? 0.0) > 0.0;

    return CardNeutral(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          onTap!();
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      context.labelSmall('Profit and Loss'.toUpperCase()),
                      LongText(
                        TextFormatter.toShortDate(
                          dateTime: DateTime.now().toUtc(),
                          format: 'MMMM yyyy',
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _isProfitable!
                          ? Theme.of(context).colorScheme.primary
                          : Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      _isProfitable!
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    TextFormatter.toStringCurrency(
                      netProfit,
                      displayCurrency: false,
                      currencyCode: '',
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _isProfitable!
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.red,
                      fontSize: 24,
                    ),
                  ),
                  const LongText('Net Profit'),
                  const SizedBox(height: 4),
                  const CommonDivider(width: 0.25),
                ],
              ),
              if (showTotalSales)
                PercentageBar(
                  context: context,
                  percentage: _maxValue! <= 0
                      ? 0
                      : _netSales == _maxValue
                      ? 1
                      : _netSales! /
                            (_costOfSales! + expensesTotal! + taxTotal!),
                  value: _netSales!,
                  title: 'NET SALES',
                ),
              const CommonDivider(),
              if (showCostOfSales)
                PercentageBar(
                  context: context,
                  percentage: _maxValue! <= 0
                      ? 0
                      : _costOfSales == _maxValue
                      ? 1
                      : _costOfSales! /
                            (_netSales! + expensesTotal! + taxTotal!),
                  value: (_costOfSales ?? 0),
                  title: 'COST OF GOODS SOLD',
                ),
              const CommonDivider(),
              if (showExpenses)
                PercentageBar(
                  context: context,
                  percentage: _maxValue! <= 0
                      ? 0
                      : expensesTotal == _maxValue
                      ? 1
                      : expensesTotal! /
                            (_netSales! + _costOfSales! + taxTotal!),
                  value: expensesTotal ?? 0.0,
                  title: 'EXPENSES',
                ),
              if (showTax)
                PercentageBar(
                  context: context,
                  percentage: _maxValue! <= 0
                      ? 0
                      : taxTotal == _maxValue
                      ? 1
                      : taxTotal! /
                            (_netSales! + _costOfSales! + expensesTotal!),
                  value: taxTotal ?? 0.0,
                  title: 'TAX',
                ),
              const CommonDivider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(LittleFishIcons.info, color: Colors.grey),
                  const SizedBox(width: 4),
                  LongText(
                    _isProfitable!
                        ? 'You Are Making Money'.toUpperCase()
                        : 'You Are Losing Money'.toUpperCase(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
