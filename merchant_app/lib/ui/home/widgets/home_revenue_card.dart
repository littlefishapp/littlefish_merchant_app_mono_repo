// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/components/cards/card_square_flat.dart';

// Package imports:
import 'package:syncfusion_flutter_charts/charts.dart';

// Project imports:
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart';
import 'package:littlefish_merchant/models/reports/business_summary.dart';
import 'package:littlefish_merchant/tools/palette_manager.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';

class HomeRevenueCard extends StatelessWidget {
  final BusinessSummary? summary;

  const HomeRevenueCard({Key? key, required this.summary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return summary != null ? doughnutChart(context) : const SizedBox();
  }

  Widget doughnutChart(BuildContext context) {
    return CardSquareFlat(
      margin: EdgeInsets.zero,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        height: 320,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: context.labelXSmall(
                'Sales By Payment Type',
                alignLeft: true,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: context.headingSmall(
                TextFormatter.toStringCurrency(summary?.revenue ?? 0),
                isBold: true,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: context.labelXSmall('Payments Breakdown', isBold: true),
            ),
            Expanded(
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
                series: getDoughnutSeries(context, summary!.salesByPaymentType),
                tooltipBehavior: TooltipBehavior(enable: true),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: ButtonSecondary(
                buttonTextSize: PrimaryButtonTextSize.small,
                onTap: (_) => showPopupDialog(
                  context: context,
                  useNewModal: true,
                  content: DataTable(
                    columns: const [
                      DataColumn(label: Text('Type')),
                      DataColumn(label: Text('Value')),
                    ],
                    rows: (summary!.salesByPaymentType ?? [])
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
                text: 'VIEW BREAKDOWN',
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

  bool areColoursEqual(Color color1, Color color2) {
    return color1.value == color2.value;
  }
}
