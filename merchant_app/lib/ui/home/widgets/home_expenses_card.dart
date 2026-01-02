// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_text.dart';

// Package imports:
import 'package:syncfusion_flutter_charts/charts.dart';

// Project imports:
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart';
import 'package:littlefish_merchant/models/reports/business_summary.dart';
import 'package:littlefish_merchant/tools/palette_manager.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';

import '../../../common/presentaion/components/cards/card_neutral.dart';

class HomeExpensesCard extends StatelessWidget {
  final BusinessSummary? summary;

  const HomeExpensesCard({Key? key, required this.summary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return summary != null ? doughnutChart(context) : const SizedBox.shrink();
  }

  Widget doughnutChart(context) {
    return CardNeutral(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        height: 320,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'expenses'.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
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
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.payment, color: Colors.white),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  TextFormatter.toStringCurrency(
                    summary!.expenses ?? 0.0,
                    displayCurrency: false,
                    currencyCode: '',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 24,
                  ),
                ),
                const CommonDivider(width: 0.25),
              ],
            ),
            Expanded(
              // height: 204,
              child: SfCircularChart(
                enableMultiSelection: true,
                palette: PaletteManager.instance.getPalette(
                  customColours: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
                legend: const Legend(
                  isVisible: true,
                  position: LegendPosition.left,
                ),
                series: getDoughnutSeries(context, summary!.expensesByType),
                tooltipBehavior: TooltipBehavior(enable: true),
              ),
            ),
            const CommonDivider(),
            ButtonText(
              text: 'View Breakdown',
              onTap: (_) => showPopupDialog(
                context: context,
                content: DataTable(
                  columns: const [
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Value')),
                  ],
                  rows: (summary!.expensesByType ?? [])
                      .map(
                        (i) => DataRow(
                          cells: [
                            DataCell(Text(i.id!)),
                            DataCell(
                              Text(
                                TextFormatter.toStringCurrency(
                                  i.value,
                                  displayCurrency: false,
                                  currencyCode: '',
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DoughnutSeries<AnalysisPair, String>> getDoughnutSeries(context, data) {
    return <DoughnutSeries<AnalysisPair, String>>[
      DoughnutSeries<AnalysisPair, String>(
        explode: true,
        radius: '80%',
        explodeOffset: '10%',
        enableTooltip: true,
        sortingOrder: SortingOrder.none,
        dataSource: data,
        xValueMapper: (AnalysisPair sales, _) {
          return sales.id;
        },
        yValueMapper: (AnalysisPair sales, _) => sales.value,
        dataLabelMapper: (AnalysisPair data, _) => data.id,
      ),
    ];
  }
}
