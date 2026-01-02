import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/models/reports/sales_report.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';

import '../../../../../common/presentaion/components/cards/card_neutral.dart';

class SalesOverview extends StatefulWidget {
  final SalesReport? data;

  const SalesOverview({Key? key, required this.data}) : super(key: key);

  @override
  State<SalesOverview> createState() => _SalesOverviewState();
}

class _SalesOverviewState extends State<SalesOverview> {
  bool isSummary = true;
  PageController? controller;

  @override
  void initState() {
    controller = PageController(viewportFraction: 0.6);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      child: EnvironmentProvider.instance.isLargeDisplay!
          ? ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: <Widget>[
                summaryCard(
                  context,
                  title: 'Gross Sales',
                  value: widget.data!.grossSales,
                  fontSize: 36.0,
                ),
                summaryCard(
                  context,
                  title: 'Orders',
                  value: widget.data!.sales ?? 0,
                  isCurrency: false,
                ),
                summaryCard(
                  context,
                  title: 'Average Order Value',
                  value: widget.data!.averageSale ?? 0.0,
                ),
                /*
                 TODO: (tshief-littlefishapp) We should figure out why Refunds amount is being set to a value of 0.0 and then re-add
                Ticket for re-addition below
                https://app.shortcut.com/littlefish-1/story/2542/dev-simplyblu-1-1-5-rc-2-11-21-2-24-overview-report-revenue-dashboard-refund-count-re-add-with-correct-amount
                */
                // summaryCard(
                //   context,
                //   title: "Refunds",
                //   value: widget.data!.returns ?? 0.0,
                // ),
                summaryCard(
                  context,
                  title: 'Discounts',
                  value: widget.data!.discountsAndComp ?? 0.0,
                ),
              ],
            )
          : PageView(
              controller: controller,
              children: <Widget>[
                summaryCard(
                  context,
                  title: 'Gross Sales',
                  value: widget.data!.grossSales,
                  fontSize: 36.0,
                ),
                summaryCard(
                  context,
                  title: 'Orders',
                  value: widget.data!.sales ?? 0,
                  isCurrency: false,
                ),
                summaryCard(
                  context,
                  title: 'Average Order Value',
                  value: widget.data!.averageSale ?? 0.0,
                ),
                /*
                TODO: (tshief-littlefishapp) We should figure out why Refunds amount is being set to a value of 0.0 and then re-add
                Ticket for re-addition below
                https://app.shortcut.com/littlefish-1/story/2542/dev-simplyblu-1-1-5-rc-2-11-21-2-24-overview-report-revenue-dashboard-refund-count-re-add-with-correct-amount
                */
                // summaryCard(
                //   context,
                //   title: "Refunds",
                //   value: widget.data!.returns ?? 0.0,
                // ),
                summaryCard(
                  context,
                  title: 'Discounts',
                  value: widget.data!.discountsAndComp ?? 0.0,
                ),
              ],
            ),
    );
  }

  Container summaryCard(
    BuildContext context, {
    required double? value,
    required String title,
    bool isCurrency = true,
    double fontSize = 28.0,
  }) => Container(
    padding: const EdgeInsets.all(4),
    width: EnvironmentProvider.instance.isLargeDisplay!
        ? MediaQuery.of(context).size.width / 4.1
        : MediaQuery.of(context).size.width / 2.15,
    height: EnvironmentProvider.instance.isLargeDisplay! ? null : 84,
    child: CardNeutral(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          isCurrency
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    context.labelSmall(
                      isCurrency
                          ? TextFormatter.toStringCurrency(
                              value,
                              displayCurrency: false,
                              currencyCode: '',
                            )
                          : value!.floor().toString(),
                    ),
                  ],
                )
              : context.labelSmall(
                  isCurrency
                      ? TextFormatter.toStringCurrency(value, currencyCode: '')
                      : value!.floor().toString(),
                ),
          context.labelSmall(title),
        ],
      ),
    ),
  );

  Container detailedDisplay(context) => Container();
}
