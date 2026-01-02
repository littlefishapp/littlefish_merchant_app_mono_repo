// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

// Project imports:
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/common/presentaion/components/percentage_bar.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';

import '../../../common/presentaion/components/cards/card_neutral.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

// ignore: must_be_immutable
class HomeProfitCard extends StatelessWidget {
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

  HomeProfitCard({
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
                      context.labelSmall(
                        'Profit and Loss'.toUpperCase(),
                        alignLeft: true,
                        isBold: true,
                      ),
                      context.labelXSmall(
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
                  context.labelMedium(
                    TextFormatter.toStringCurrency(netProfit),
                    isBold: true,
                  ),
                  context.labelXSmall('Net Profit'),
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
