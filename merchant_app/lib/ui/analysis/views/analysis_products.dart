// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// Project imports:
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/analysis_service.dart';
import 'package:littlefish_merchant/tools/palette_manager.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class TopProductsView extends StatelessWidget {
  const TopProductsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    var service = AnalysisService(
      baseUrl: store.state.reportsUrl,
      businessId: store.state.businessId,
      token: store.state.token,
      store: store,
    );

    return FutureBuilder<ProductTopTen>(
      future: service.getTopProducts(),
      builder: (ctx, snapshot) =>
          snapshot.connectionState != ConnectionState.done
          ? const AppProgressIndicator()
          : snapshot.data?.mostProfit != null &&
                snapshot.data!.mostProfit!.isNotEmpty
          ? ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                mostSoldProducts(context, snapshot.data!),
                const CommonDivider(),
                mostProfitable(context, true, snapshot.data!),
              ],
            )
          : const Text('no data'),
    );
  }

  Container mostSoldProducts(context, ProductTopTen data) => Container(
    height: MediaQuery.of(context).size.height / 2,
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    child: SfCircularChart(
      legend: const Legend(isVisible: true),
      palette: PaletteManager.instance.getPalette(
        customColours: [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.secondary,
        ],
      ),
      title: const ChartTitle(
        text: 'Top 5 Products - Most Sold',
        // alignment: ChartAlignment.near,
        textStyle: TextStyle(
          //fontFamily: UIStateData.primaryFontFamily,
          fontWeight: FontWeight.bold,
        ),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: getRadialSeries(
        context,
        data.mostSold!..sort((a, b) {
          return a.value!.compareTo(b.value!);
        }),
      ),
    ),
  );

  Container mostProfitable(context, bool isTileView, ProductTopTen data) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        title: const ChartTitle(
          text: 'Top 5 Products - Most Profitable',
          // alignment: ChartAlignment.near,
          textStyle: TextStyle(
            //fontFamily: UIStateData.primaryFontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        legend: Legend(isVisible: !isTileView),
        primaryXAxis: const CategoryAxis(
          majorGridLines: MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          minimum: data.mostProfit?.map((c) => c.value!).reduce(max) ?? 80,
          maximum: data.mostProfit?.map((c) => c.value!).reduce(min) ?? 30,
          axisLine: const AxisLine(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          labelFormat: '{value}',
          majorTickLines: const MajorTickLines(size: 0),
        ),
        series: getVerticalData(context, isTileView, data),
        tooltipBehavior: TooltipBehavior(enable: true),
      ),
    );
  }

  List<RadialBarSeries<AnalysisPair, String>> getRadialSeries(
    context,
    List<AnalysisPair>? data,
  ) {
    return <RadialBarSeries<AnalysisPair, String>>[
      RadialBarSeries<AnalysisPair, String>(
        animationDuration: 560,
        maximumValue: data?.map((c) => c.value!).reduce(max) ?? 80,
        enableTooltip: true,
        sortingOrder: SortingOrder.descending,
        gap: '10%',
        radius: '100%',
        dataSource: data,
        cornerStyle: CornerStyle.bothCurve,
        innerRadius: '50%',
        xValueMapper: (AnalysisPair item, _) => item.id,
        yValueMapper: (AnalysisPair item, _) => item.value,
        pointRadiusMapper: (AnalysisPair item, _) => '100%',
        pointColorMapper: (AnalysisPair item, index) => colors(context)[index],
        legendIconType: LegendIconType.circle,
        dataLabelMapper: (AnalysisPair data, _) => data.id,
      ),
    ];
  }

  List<Color> colors(context) => <Color>[
    Theme.of(context).colorScheme.primary,
    Colors.blue,
    Colors.orange,
    Colors.pink,
    Colors.indigo,
  ];

  List<BarSeries<AnalysisPair, String>> getVerticalData(
    context,
    bool isTileView,
    ProductTopTen data,
  ) {
    return <BarSeries<AnalysisPair, String>>[
      BarSeries<AnalysisPair, String>(
        enableTooltip: true,
        isTrackVisible: false,
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(
            //fontFamily: UIStateData.primaryFontFamily,
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        sortingOrder: SortingOrder.ascending,
        borderColor: Colors.red,
        color: Theme.of(context).colorScheme.primary,
        dataSource: data.mostProfit!,
        xValueMapper: (AnalysisPair sales, _) {
          //debugPrint(sales.id ?? "no name");
          return sales.id;
        },
        yValueMapper: (AnalysisPair sales, _) => sales.value,
      ),
    ];
  }
}
