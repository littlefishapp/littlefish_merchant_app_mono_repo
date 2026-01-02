// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:syncfusion_flutter_charts/charts.dart';

// Project imports:
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart';
import 'package:littlefish_merchant/tools/palette_manager.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';

import '../../../../../common/presentaion/components/cards/card_neutral.dart';

class SalesBoard extends StatelessWidget {
  final String title;

  final BoardType type;

  final List<AnalysisPair>? data;

  final bool isTile;

  final double height;

  final bool useDirectHeight;

  final Legend? legend;

  const SalesBoard({
    Key? key,
    required this.title,
    required this.data,
    this.type = BoardType.column,
    this.isTile = false,
    this.useDirectHeight = false,
    this.height = 320,
    this.legend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget board;

    if (data == null || data!.isEmpty) {
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
      height: useDirectHeight
          ? height
          : MediaQuery.of(context).size.height / 2.25,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SfCircularChart(
        enableMultiSelection: true,
        palette: PaletteManager.instance.getPalette(
          customColours: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ), //chartPallete,
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
        zoomPanBehavior: data!.length <= 5
            ? null
            : type == BoardType.column
            ? ZoomPanBehavior(
                enablePinching: true,
                zoomMode: ZoomMode.x,
                enablePanning: true,
              )
            : type == BoardType.bar
            ? ZoomPanBehavior(
                enablePinching: true,
                zoomMode: ZoomMode.y,
                enablePanning: true,
              )
            : null,
        title: ChartTitle(
          text: title,
          textStyle: const TextStyle(
            //fontFamily: UIStateData.primaryFontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        legend: legend ?? const Legend(isVisible: false),
        primaryXAxis: CategoryAxis(
          interval: 1,
          labelRotation: type == BoardType.column ? 45 : 0,
          maximumLabelWidth: type == BoardType.column
              ? MediaQuery.of(context).size.width * (15 / 100)
              : MediaQuery.of(context).size.width * (3 / 15),
          majorGridLines: const MajorGridLines(width: 0),
          autoScrollingDelta: type != BoardType.bar ? 5 : 5,
          autoScrollingMode: AutoScrollingMode.start,
        ),
        primaryYAxis: NumericAxis(
          maximum: (data?.map((c) => c.value!).reduce(max))! * 1.1,
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
            //fontFamily: UIStateData.primaryFontFamily,
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 12,
          ),
        ),
        width: 0.25,
        sortingOrder: SortingOrder.none,
        color: Theme.of(context).colorScheme.primary,
        dataSource: data!,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
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
            //fontFamily: UIStateData.primaryFontFamily,
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 12,
          ),
        ),
        width: 0.25,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        sortingOrder: SortingOrder.none,
        color: Theme.of(context).colorScheme.primary,
        dataSource: data!,
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
            //fontFamily: UIStateData.primaryFontFamily,
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 12,
          ),
        ),
        splineType: SplineType.monotonic,
        markerSettings: const MarkerSettings(isVisible: true),
        sortingOrder: SortingOrder.none,
        color: Theme.of(context).colorScheme.primary,
        dataSource: data!,
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

enum BoardType { column, bar, doughnut, spline, line }
