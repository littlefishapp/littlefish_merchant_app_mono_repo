// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/models/reports/customer_report.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';

import '../../../../common/presentaion/components/cards/card_neutral.dart';

class CustomersOverview extends StatefulWidget {
  final CustomerReport? data;

  const CustomersOverview({Key? key, required this.data}) : super(key: key);

  @override
  State<CustomersOverview> createState() => _CustomersOverviewState();
}

class _CustomersOverviewState extends State<CustomersOverview> {
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
      child: PageView(
        physics: const BouncingScrollPhysics(),
        controller: controller,
        children: <Widget>[
          summaryCard(
            context,
            title: 'Total Customers',
            value: (widget.data?.totalCustomers ?? 0).toDouble(),
            isCurrency: false,
          ),
          summaryCard(
            context,
            title: 'Repeat Customers',
            value: (widget.data?.activeCustomers ?? 0).toDouble(),
            isCurrency: false,
          ),
          summaryCard(
            context,
            title: 'Total Customers',
            value: (widget.data?.totalCustomers ?? 0).toDouble(),
            isCurrency: false,
          ),
          summaryCard(
            context,
            title: 'Repeat Customers',
            value: (widget.data?.activeCustomers ?? 0).toDouble(),
            isCurrency: false,
          ),
          summaryCard(
            context,
            title: 'Customer Sales',
            value: (widget.data?.customerSales?.length ?? 0) > 0
                ? (widget.data!.customerSales
                          ?.map((s) => s.totalSales)
                          .reduce((a, b) => a! + b!) ??
                      0.0)
                : 0.0,
            isCurrency: true,
          ),
          summaryCard(
            context,
            title: 'Items Purchased',
            value: (widget.data?.customerSales?.length ?? 0) > 0
                ? widget.data!.customerSales
                          ?.map((s) => s.totalSalesQuantity)
                          .reduce((a, b) => a! + b!) ??
                      0.0
                : 0.0,
            isCurrency: false,
          ),
          summaryCard(
            context,
            title: 'Non-Customer Sales',
            value: (widget.data?.nonCustomerSales?.length ?? 0) > 0
                ? widget.data?.nonCustomerSales
                          ?.map((s) => s.totalSales)
                          .reduce((a, b) => a! + b!) ??
                      0.0
                : 0.0,
            isCurrency: true,
          ),
          summaryCard(
            context,
            title: 'Non-Customer Sales Count',
            value: widget.data!.totalNonCustomerSalesCount?.toDouble() ?? 0.0,
            isCurrency: false,
          ),
        ],
      ),
    );
  }

  Container summaryCard(
    context, {
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
                    Text(
                      isCurrency
                          ? TextFormatter.toStringCurrency(
                              value,
                              displayCurrency: false,
                              currencyCode: '',
                            )
                          : value.floor().toString(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 28.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )
              : Text(
                  isCurrency
                      ? TextFormatter.toStringCurrency(value, currencyCode: '')
                      : value.floor().toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 28.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );

  Container detailedDisplay(context) => Container();
}
