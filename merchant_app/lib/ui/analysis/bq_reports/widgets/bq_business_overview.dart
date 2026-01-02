// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/models/reports/bq_overview_report.dart';
import 'package:littlefish_merchant/models/reports/report_date_range.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/pages/customer_sales_compare_report.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/pages/online_revenue_compare_report.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/pages/payments_compare_report.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/pages/products_compare_report.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/pages/profits_compare_report.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/pages/revenue_compare_report.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/pages/staff_sales_compare_report.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/pages/tax_compare_report.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import '../../../../redux/app/app_state.dart';

class BqBusinessOverview extends StatelessWidget {
  const BqBusinessOverview({Key? key, this.data, this.state, this.compareDates})
    : super(key: key);

  final AppState? state;
  final BqOverviewReport? data;
  final List<ReportDateRange>? compareDates;

  @override
  Widget build(BuildContext context) {
    return mobileLayoutList(context, data!, state!);
  }

  Column mobileLayoutList(
    context,
    BqOverviewReport data,
    AppState state,
  ) => Column(
    // shrinkWrap: true,
    // physics: BouncingScrollPhysics(),
    children: <Widget>[
      analysisItemList(
        context,
        'Total Revenue',
        TextFormatter.toStringCurrency(data.revenue ?? 0.0, currencyCode: ''),
        'revenue',
        route: BqReportingCompareRevenuePage.route,
      ),
      analysisItemList(
        context,
        'Total Sales',
        (data.sales ?? 0.0).toString(),
        'sales',
        route: BqReportingCompareRevenuePage.route,
      ),
      analysisItemList(
        context,
        'Average Ticket Size',
        TextFormatter.toStringCurrency(data.ats ?? 0.0, currencyCode: ''),
        'average ticket size',
        route: BqReportingCompareRevenuePage.route,
      ),
      const CommonDivider(),
      analysisItemList(
        context,
        'Total Profits',
        TextFormatter.toStringCurrency(data.profits ?? 0.0, currencyCode: ''),
        'profits',
        route: BqReportingCompareProfitsPage.route,
      ),
      const CommonDivider(),
      if (state.enableOnlineStore == true)
        analysisItemList(
          context,
          'Total Online Revenue',
          TextFormatter.toStringCurrency(
            data.onlineRevenue ?? 0.0,
            currencyCode: '',
          ),
          'online revenue',
          route: BqReportingCompareOnlineRevenuePage.route,
        ),
      if (state.enableOnlineStore == true)
        analysisItemList(
          context,
          'Total Online Sales',
          (data.onlineSalesCount ?? 0.0).toString(),
          'online sales',
          route: BqReportingCompareOnlineRevenuePage.route,
        ),
      // analysisItemList(
      //   context,
      //   "Average Online Ticket Size",
      //   TextFormatter.toStringCurrency(data.onlineSalesATS ?? 0.0),
      //   "average online ticket size",
      //   route: BqReportingCompareRevenuePage.route,
      // ),
      // CommonDivider(),
      // analysisItemList(
      //   context,
      //   "Total Online Profits",
      //   TextFormatter.toStringCurrency(data.onlineProfits ?? 0.0),
      //   "online profits",
      //   route: BqReportingCompareProfitsPage.route,
      // ),
      const CommonDivider(),
      if (state.enableTax == true)
        analysisItemList(
          context,
          'Total Sales Tax',
          TextFormatter.toStringCurrency(
            data.amtToTax ?? 0.0,
            currencyCode: '',
          ),
          'sales tax',
          route: BqReportingCompareTaxPage.route,
        ),
      const CommonDivider(),
      analysisItemList(
        context,
        'Payment Method',
        '${(data.payMethPercent ?? 0).round()} %',
        data.paymentMeth ?? 'No Data',
        route: BqReportingComparePaymentsPage.route,
      ),
      const CommonDivider(),
      analysisItemList(
        context,
        'Top Product',
        data.topProd ?? 'No Data',
        '#1 in Sales: ${TextFormatter.toStringCurrency(data.topProdSalesAmt ?? 0.0, currencyCode: '')}${data.topProdCategory != null ? '\nTop Category: ${data.topProdCategory!}' : ''}',
        route: BqReportingCompareProductsPage.route,
      ),
      const CommonDivider(),
      analysisItemList(
        context,
        'Top Customer',
        data.topCust ?? 'No Data',
        '#1 in Purchases: ${TextFormatter.toStringCurrency(data.topCustSalesAmt ?? 0.0, currencyCode: '')}',
        route: BqReportingCompareCustomerSalesPage.route,
      ),
      const CommonDivider(),
      if (state.enableOnlineStore == true)
        analysisItemList(
          context,
          'Sales by Staff',
          data.topStaff ?? 'No Data',
          '#1 in Sales: ${TextFormatter.toStringCurrency(data.topStaffSalesAmt ?? 0.0, currencyCode: '')}',
          route: BqReportingCompareStaffSalesPage.route,
        ),
    ],
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
        : () => Navigator.of(context).pushNamed(route, arguments: compareDates),
  );
}

// class BqBusinessOverview extends StatefulWidget {
//   const BqBusinessOverview({ Key? key }) : super(key: key);

//   @override
//   State<BqBusinessOverview> createState() => _BqBusinessOverviewState();
// }

// class _BqBusinessOverviewState extends State<BqBusinessOverview> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(

//     );
//   }
// }
