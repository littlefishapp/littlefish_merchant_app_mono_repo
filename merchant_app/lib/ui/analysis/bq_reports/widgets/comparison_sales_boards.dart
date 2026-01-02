// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:syncfusion_flutter_charts/charts.dart';

// Project imports:
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart';
import 'package:littlefish_merchant/models/reports/bq_comparison_report_series.dart';
import 'package:littlefish_merchant/tools/palette_manager.dart';
import 'package:littlefish_merchant/ui/analysis/reports/sales/widgets/sales_boards.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';

import '../../../../common/presentaion/components/cards/card_neutral.dart';

class ComparisonSalesBoard extends StatelessWidget {
  final String title;

  final BoardType type;

  final List<ComparisonBqReportSeries>? data;

  final bool isTile;

  final double height;

  final Legend? legend;

  final List<String>? compareSeriesNames;

  const ComparisonSalesBoard({
    Key? key,
    required this.title,
    required this.data,
    this.type = BoardType.column,
    this.isTile = false,
    this.height = 320,
    this.legend,
    this.compareSeriesNames,
  }) : super(key: key);

  double getMaxValue(List<ComparisonBqReportSeries> data) {
    List<double> maxValuesList = [];

    for (var element in data) {
      double maxValue = 0;

      for (var ap in element.analysisPairs!) {
        if (ap.value! > maxValue) maxValue = ap.value!;
      }

      maxValuesList.add(maxValue);
    }

    return maxValuesList.map((e) => e).reduce(max);
  }

  Color getSeriesColour(context, int index) {
    List<Color> palette = [
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.secondary,
      Colors.red,
      Colors.blue,
      Colors.indigo,
      Colors.pink,
      Colors.orange,
      Colors.deepOrange,
      Colors.purple,
    ];

    return palette[index];
  }

  @override
  Widget build(BuildContext context) {
    Widget board;

    if (data == null ||
        data!.isEmpty ||
        (data!.length == 1 && data![0].analysisPairs!.isEmpty)) {
      board = SizedBox(
        height: height,
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: DecoratedText(
                title,
                alignment: Alignment.topCenter,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                textColor: Colors.grey,
              ),
            ),
            DecoratedText(
              'No Data',
              alignment: Alignment.center,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              textColor: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      );
    } else {
      board = type != BoardType.doughnut
          ? barColumnChart(context)
          : doughnutChart(context);
    }
    return isTile ? CardNeutral(child: board) : board;
  }

  Container doughnutChart(context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.25,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SfCircularChart(
        enableMultiSelection: true,
        palette: PaletteManager.instance.getPalette(
          customColours: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        title: ChartTitle(
          text: title,
          textStyle: const TextStyle(
            //fontFamily: UIStateData.primaryFontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        legend:
            legend ??
            const Legend(
              isVisible: true,
              alignment: ChartAlignment.center,
              position: LegendPosition.auto,
            ),
        series: getDoughnutSeries(context),
        tooltipBehavior: TooltipBehavior(enable: true),
      ),
    );
  }

  Container barColumnChart(context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.25,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        title: ChartTitle(
          text: title,
          textStyle: const TextStyle(
            //fontFamily: UIStateData.primaryFontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        legend: legend ?? const Legend(isVisible: false),
        primaryXAxis: const CategoryAxis(
          majorGridLines: MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: getMaxValue(data!) * 1.15,
          axisLine: const AxisLine(),
          labelFormat: '{value}',
          majorTickLines: const MajorTickLines(size: 0),
        ),
        series: getSeries(context) as dynamic,
        tooltipBehavior: TooltipBehavior(enable: true),
        palette: [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.secondary,
          Colors.red,
          Colors.blue,
          Colors.indigo,
          Colors.pink,
          Colors.orange,
          Colors.deepOrange,
          Colors.purple,
        ],
      ),
    );
  }

  List<ChartSeries<AnalysisPair, String>> getSeries(context) {
    if (type == BoardType.bar) return getBarSeries(context);

    if (type == BoardType.column) return getColumnSeries(context);

    if (type == BoardType.spline) {
      if (data!.length == 1) return getColumnSeries(context);

      if (type == BoardType.line) {
        if (data!.length == 1) return getColumnSeries(context);
      }

      if (type == BoardType.line) {
        if (data!.length > 1) return getLineSeries(context);
      }

      return getSplineSeries(context);
    }

    if (type == BoardType.doughnut) return getDoughnutSeries(context);
    return [];
  }

  List<ColumnSeries<AnalysisPair, String>> getColumnSeries(context) {
    return <ColumnSeries<AnalysisPair, String>>[
      for (var i = 0; i < data!.length; i++)
        ColumnSeries<AnalysisPair, String>(
          enableTooltip: true,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(
              //fontFamily: UIStateData.primaryFontFamily,
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 12,
            ),
          ),
          width: 0.25,
          sortingOrder: SortingOrder.none,
          dataSource: data![i].analysisPairs!,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          xValueMapper: (AnalysisPair sales, _) {
            return sales.id;
          },
          yValueMapper: (AnalysisPair sales, _) => sales.value,
          name: data![i].dateRange!.seriesName ?? 'Series $i',
        ),
    ];
  }

  List<BarSeries<AnalysisPair, String>> getBarSeries(context) {
    return <BarSeries<AnalysisPair, String>>[
      for (var i = 0; i < data!.length; i++)
        BarSeries<AnalysisPair, String>(
          enableTooltip: true,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(
              //fontFamily: UIStateData.primaryFontFamily,
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 12,
            ),
          ),
          width: 0.25,
          sortingOrder: SortingOrder.none,
          color: Theme.of(context).colorScheme.primary,
          dataSource: data![i].analysisPairs!,
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          xValueMapper: (AnalysisPair sales, _) {
            return sales.id;
          },
          yValueMapper: (AnalysisPair sales, _) => sales.value,
          name: data![i].dateRange!.seriesName ?? 'Series $i',
        ),
    ];
  }

  List<SplineSeries<AnalysisPair, String>> getSplineSeries(context) {
    return <SplineSeries<AnalysisPair, String>>[
      for (var i = 0; i < data!.length; i++)
        SplineSeries<AnalysisPair, String>(
          enableTooltip: true,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(
              //fontFamily: UIStateData.primaryFontFamily,
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 12,
            ),
          ),
          splineType: SplineType.monotonic,
          sortingOrder: SortingOrder.none,
          color: getSeriesColour(context, i),
          dataSource: data![i].analysisPairs!,
          xValueMapper: (AnalysisPair sales, _) {
            return sales.id;
          },
          yValueMapper: (AnalysisPair sales, _) => sales.value,
          name: data![i].dateRange!.seriesName ?? 'Series $i',
        ),
    ];
  }

  //Tried create a normal Line graph, instead of a Spline graph, hasn't worked/rendered correctly as of yet.
  List<LineSeries<AnalysisPair, String>> getLineSeries(context) {
    return <LineSeries<AnalysisPair, String>>[
      for (var i = 0; i < data!.length; i++)
        LineSeries<AnalysisPair, String>(
          enableTooltip: true,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(
              //fontFamily: UIStateData.primaryFontFamily,
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 12,
            ),
          ),
          sortingOrder: SortingOrder.none,
          color: Theme.of(context).colorScheme.primary,
          dataSource: data![i].analysisPairs!,
          xValueMapper: (AnalysisPair sales, _) {
            return sales.id;
          },
          yValueMapper: (AnalysisPair sales, _) => sales.value,
          name: data![i].dateRange!.seriesName ?? 'Series $i',
        ),
    ];
  }

  List<DoughnutSeries<AnalysisPair, String>> getDoughnutSeries(context) {
    return <DoughnutSeries<AnalysisPair, String>>[
      for (var i = 0; i < data!.length; i++)
        DoughnutSeries<AnalysisPair, String>(
          explode: true,
          radius: '80%',
          explodeOffset: '10%',
          enableTooltip: true,
          sortingOrder: SortingOrder.none,
          dataSource: data![i].analysisPairs!,
          xValueMapper: (AnalysisPair sales, _) {
            return sales.id;
          },
          yValueMapper: (AnalysisPair sales, _) => sales.value,
          dataLabelMapper: (AnalysisPair data, _) => data.id,
          name: data![i].dateRange!.seriesName ?? 'Series $i',
        ),
    ];
  }
}
