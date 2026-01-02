// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:littlefish_merchant/tools/palette_manager.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../common/presentaion/components/cards/card_neutral.dart';
import '../../../features/ecommerce_shared/models/shared/analysis_pair.dart';
import '../../../common/presentaion/components/decorated_text.dart';

class SalesBoard extends StatelessWidget {
  final String title;

  final BoardType type;

  final List<AnalysisPair> data;

  final bool isTile;

  final double height;

  final Legend? legend;

  const SalesBoard({
    Key? key,
    required this.title,
    required this.data,
    this.type = BoardType.column,
    this.isTile = false,
    this.height = 320,
    this.legend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget board;

    if (data.isEmpty) {
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
            // fontFamily: Theme.of(context).fo,
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
            // //fontFamily: UIStateData.primaryFontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        legend: legend ?? const Legend(isVisible: false),
        primaryXAxis: const CategoryAxis(
          majorGridLines: MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: data.map((c) => c.value!).reduce(max),
          axisLine: const AxisLine(),
          labelFormat: '{value}',
          majorTickLines: const MajorTickLines(size: 0),
        ),
        series: getSeries(context) as dynamic,
        tooltipBehavior: TooltipBehavior(enable: true),
      ),
    );
  }

  List<ChartSeries<AnalysisPair, String>> getSeries(context) {
    if (type == BoardType.bar) return getBarSeries(context);

    if (type == BoardType.column) return getColumnSeries(context);

    if (type == BoardType.spline) {
      if (data.length == 1) return getColumnSeries(context);

      return getSplineSeries(context);
    }

    if (type == BoardType.doughnut) return getDoughnutSeries(context);
    return [];
  }

  List<ColumnSeries<AnalysisPair, String>> getColumnSeries(context) {
    return <ColumnSeries<AnalysisPair, String>>[
      ColumnSeries<AnalysisPair, String>(
        enableTooltip: true,
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(
            // //fontFamily: UIStateData.primaryFontFamily,
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 12,
          ),
        ),
        width: 0.25,
        sortingOrder: SortingOrder.none,
        color: Theme.of(context).colorScheme.primary,
        dataSource: data,
        xValueMapper: (AnalysisPair sales, _) {
          return sales.id;
        },
        yValueMapper: (AnalysisPair sales, _) => sales.value,
      ),
    ];
  }

  List<BarSeries<AnalysisPair, String>> getBarSeries(context) {
    return <BarSeries<AnalysisPair, String>>[
      BarSeries<AnalysisPair, String>(
        enableTooltip: true,
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(
            // //fontFamily: UIStateData.primaryFontFamily,
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 12,
          ),
        ),
        width: 0.25,
        sortingOrder: SortingOrder.none,
        color: Theme.of(context).colorScheme.primary,
        dataSource: data,
        xValueMapper: (AnalysisPair sales, _) {
          return sales.id;
        },
        yValueMapper: (AnalysisPair sales, _) => sales.value,
      ),
    ];
  }

  List<SplineSeries<AnalysisPair, String>> getSplineSeries(context) {
    return <SplineSeries<AnalysisPair, String>>[
      SplineSeries<AnalysisPair, String>(
        enableTooltip: true,
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(
            // //fontFamily: UIStateData.primaryFontFamily,
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 12,
          ),
        ),
        splineType: SplineType.monotonic,
        // gradient: LinearGradient(colors: [
        //   Theme.of(context).colorScheme.primary,
        //   Theme.of(context).colorScheme.secondary,
        // ]),
        sortingOrder: SortingOrder.none,
        color: Theme.of(context).colorScheme.primary,
        dataSource: data,
        xValueMapper: (AnalysisPair sales, _) {
          return sales.id;
        },
        yValueMapper: (AnalysisPair sales, _) => sales.value,
      ),
    ];
  }

  List<DoughnutSeries<AnalysisPair, String>> getDoughnutSeries(context) {
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

class Chart extends StatelessWidget {
  final String title;

  final BoardType type;

  final Map<String, List<AnalysisPair>> series;

  final bool isTile;

  final double height;

  final Legend? legend;

  final Color? primaryColor;

  const Chart({
    Key? key,
    required this.title,
    required this.series,
    this.type = BoardType.column,
    this.isTile = false,
    this.height = 320,
    this.legend,
    this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget board;

    if (series.isEmpty) {
      board = SizedBox(
        height: height,
        child: Stack(
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
            // fontFamily: Theme.of(context).fo,
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
            // //fontFamily: UIStateData.primaryFontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        legend: legend ?? const Legend(isVisible: false),
        primaryXAxis: const CategoryAxis(
          majorGridLines: MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: series.values
              .expand((element) => element)
              .map((e) => e.value!)
              .map((c) => c)
              .reduce(max),
          axisLine: const AxisLine(),
          labelFormat: '{value}',
          majorTickLines: const MajorTickLines(size: 0),
        ),
        series: getSeries(context) as dynamic,
        tooltipBehavior: TooltipBehavior(enable: true),
      ),
    );
  }

  List<ChartSeries<AnalysisPair, String>> getSeries(context) {
    if (type == BoardType.bar) return getBarSeries(context);

    if (type == BoardType.column) return getColumnSeries(context);

    if (type == BoardType.spline) {
      // if (this.series.length == 1) return getColumnSeries(context);

      return getSplineSeries(context);
    }

    if (type == BoardType.doughnut) return getDoughnutSeries(context);
    return [];
  }

  List<ColumnSeries<AnalysisPair, String>> getColumnSeries(context) {
    List<ColumnSeries<AnalysisPair, String>> result = [];

    series.forEach((key, value) {
      result.add(
        ColumnSeries<AnalysisPair, String>(
          enableTooltip: true,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(
              // //fontFamily: UIStateData.primaryFontFamily,
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 12,
            ),
          ),
          width: 0.25,
          sortingOrder: SortingOrder.none,
          color: Theme.of(context).colorScheme.primary,
          name: key,
          dataSource: value,
          xValueMapper: (AnalysisPair sales, _) {
            return sales.id;
          },
          yValueMapper: (AnalysisPair sales, _) => sales.value,
        ),
      );
    });

    return result;
  }

  List<BarSeries<AnalysisPair, String>> getBarSeries(context) {
    List<BarSeries<AnalysisPair, String>> result = [];

    series.forEach((key, value) {
      result.add(
        BarSeries<AnalysisPair, String>(
          enableTooltip: true,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(
              // //fontFamily: UIStateData.primaryFontFamily,
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 12,
            ),
          ),
          width: 0.25,
          sortingOrder: SortingOrder.none,
          color: primaryColor ?? Theme.of(context).colorScheme.primary,
          name: key,
          dataSource: value,
          xValueMapper: (AnalysisPair sales, _) {
            return sales.id;
          },
          yValueMapper: (AnalysisPair sales, _) => sales.value,
        ),
      );
    });

    return result;
  }

  List<SplineSeries<AnalysisPair, String>> getSplineSeries(context) {
    List<SplineSeries<AnalysisPair, String>> result = [];

    series.forEach((key, value) {
      result.add(
        SplineSeries<AnalysisPair, String>(
          // enableTooltip: true,
          // dataLabelSettings: DataLabelSettings(
          //   isVisible: true,
          //   textStyle: TextStyle(
          //     color: Theme.of(context).colorScheme.secondary,
          //     fontSize: 12,
          //   ),
          // ),
          splineType: SplineType.monotonic,
          name: key,
          // gradient: LinearGradient(colors: [
          //   Theme.of(context).colorScheme.primary,
          //   Theme.of(context).colorScheme.secondary,
          // ]),
          sortingOrder: SortingOrder.none,
          color: primaryColor ?? Theme.of(context).colorScheme.primary,
          dataSource: value,
          xValueMapper: (AnalysisPair sales, _) {
            return sales.id;
          },
          yValueMapper: (AnalysisPair sales, _) => sales.value,
        ),
      );
    });
    return result;
  }

  List<DoughnutSeries<AnalysisPair, String>> getDoughnutSeries(context) {
    List<DoughnutSeries<AnalysisPair, String>> result = [];

    series.forEach((key, value) {
      result.add(
        DoughnutSeries<AnalysisPair, String>(
          explode: true,
          radius: '80%',
          explodeOffset: '10%',
          name: series.length > 1 ? key : null,
          enableTooltip: true,
          sortingOrder: SortingOrder.none,
          dataSource: value,
          xValueMapper: (AnalysisPair item, _) {
            return item.id;
          },
          yValueMapper: (AnalysisPair item, _) => item.value,
          dataLabelMapper: (AnalysisPair item, _) => item.id,
        ),
      );
    });

    return result;
  }
}

enum BoardType { column, bar, doughnut, spline }
