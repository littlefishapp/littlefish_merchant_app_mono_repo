// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

// Project imports:
import 'package:littlefish_merchant/models/reports/product_report.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';

import '../../../../common/presentaion/components/cards/card_neutral.dart';

class ProductsOverview extends StatefulWidget {
  final ProductReport? data;

  const ProductsOverview({Key? key, required this.data}) : super(key: key);

  @override
  State<ProductsOverview> createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
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
          ? Wrap(
              children: <Widget>[
                summaryCard(
                  context,
                  title: 'Total Products',
                  value: widget.data!.totalProducts?.toDouble() ?? 0,
                  isCurrency: false,
                ),
                summaryCard(
                  context,
                  title: 'Total Units',
                  value: widget.data!.totalQuantity?.toDouble() ?? 0,
                  isCurrency: false,
                ),
                summaryCard(
                  context,
                  title: 'Average Selling Price',
                  value: widget.data!.avgSellingPrice ?? 0.0,
                  isCurrency: true,
                ),
                summaryCard(
                  context,
                  title: 'Average Cost Price',
                  value: widget.data!.avgCostPrice ?? 0.0,
                  isCurrency: true,
                ),
                summaryCard(
                  context,
                  title: 'Average Profit',
                  value: widget.data!.avgProfit ?? 0.0,
                  isCurrency: true,
                ),
                percentageCard(
                  context,
                  title: 'Average Markup',
                  value: widget.data!.avgMarkup ?? 0.0,
                ),
              ],
            )
          : PageView(
              controller: controller,
              children: <Widget>[
                summaryCard(
                  context,
                  title: 'Total Products',
                  value: widget.data!.totalProducts?.toDouble() ?? 0,
                  isCurrency: false,
                ),
                summaryCard(
                  context,
                  title: 'Total Units',
                  value: widget.data!.totalQuantity?.toDouble() ?? 0,
                  isCurrency: false,
                ),
                summaryCard(
                  context,
                  title: 'Average Selling Price',
                  value: widget.data!.avgSellingPrice ?? 0.0,
                  isCurrency: true,
                ),
                summaryCard(
                  context,
                  title: 'Average Cost Price',
                  value: widget.data!.avgCostPrice ?? 0.0,
                  isCurrency: true,
                ),
                summaryCard(
                  context,
                  title: 'Average Profit',
                  value: widget.data!.avgProfit ?? 0.0,
                  isCurrency: true,
                ),
                percentageCard(
                  context,
                  title: 'Average Markup',
                  value: widget.data!.avgMarkup ?? 0.0,
                ),
              ],
            ),
    );
  }

  Container summaryCard(
    BuildContext context, {
    required double value,
    required String title,
    bool isCurrency = true,
    double fontSize = 28.0,
  }) => Container(
    padding: const EdgeInsets.all(4),
    width: EnvironmentProvider.instance.isLargeDisplay!
        ? MediaQuery.of(context).size.width / 4.1
        : MediaQuery.of(context).size.width / 2.15,
    height: EnvironmentProvider.instance.isLargeDisplay! ? null : 96,
    child: CardNeutral(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                          : value.floor().toString(),
                    ),
                  ],
                )
              : context.labelSmall(
                  isCurrency
                      ? TextFormatter.toStringCurrency(value, currencyCode: '')
                      : value.floor().toString(),
                ),
          context.labelSmall(title),
        ],
      ),
    ),
  );

  Container percentageCard(
    BuildContext context, {
    required double value,
    required String title,
  }) => Container(
    padding: const EdgeInsets.all(4),
    width: EnvironmentProvider.instance.isLargeDisplay!
        ? MediaQuery.of(context).size.width / 4.1
        : MediaQuery.of(context).size.width / 2.15,
    height: EnvironmentProvider.instance.isLargeDisplay! ? null : 96,
    child: CardNeutral(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          context.labelSmall('$value%'),
          context.labelSmall(title),
        ],
      ),
    ),
  );
  Container detailedDisplay(context) => Container();
}
