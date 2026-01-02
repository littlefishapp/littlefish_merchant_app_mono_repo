// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/ui/analysis/reports/products/products_overview.dart';
import 'package:littlefish_merchant/ui/analysis/reports/sales/view_models.dart';
import 'package:littlefish_merchant/ui/analysis/reports/sales/widgets/sales_boards.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class ProductReportDisplay extends StatelessWidget {
  final ProductReportVM? report;

  const ProductReportDisplay({Key? key, required this.report})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (report!.isLoading ?? false) {
      return const Center(child: AppProgressIndicator());
    } else if (report!.report == null ||
        (report!.report!.totalProducts == 0 ||
            report!.report!.totalProducts == null)) {
      return const Center(child: Text('No Data'));
    }

    return Container(
      color: Colors.grey.shade50,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        children: <Widget>[
          Visibility(
            visible: EnvironmentProvider.instance.isLargeDisplay!,
            child: SizedBox(
              height: 84,
              child: ProductsOverview(data: report!.report),
            ),
          ),
          Expanded(
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: EnvironmentProvider.instance.isLargeDisplay!
                    ? 1.25
                    : 1,
                crossAxisCount: EnvironmentProvider.instance.isLargeDisplay!
                    ? 2
                    : 1,
                mainAxisSpacing: EnvironmentProvider.instance.isLargeDisplay!
                    ? 16.0
                    : 4,
                crossAxisSpacing: EnvironmentProvider.instance.isLargeDisplay!
                    ? 16.0
                    : 4,
              ),
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                SalesBoard(
                  isTile: true,
                  type: BoardType.doughnut,
                  data:
                      report!.report!.mostProfitableProduct
                          ?.map((r) => AnalysisPair(id: r.name, value: r.count))
                          .toList() ??
                      [],
                  title: 'Products - Overview',
                ),
                SalesBoard(
                  isTile: true,
                  type: BoardType.bar,
                  data:
                      report!.report!.mostSoldProduct
                          ?.map(
                            (r) => AnalysisPair(id: r.name, value: r.amount),
                          )
                          .toList() ??
                      [],
                  title: 'Products - Most Sold',
                ),
                SalesBoard(
                  isTile: true,
                  type: BoardType.column,
                  data:
                      report!.report!.mostProfitableProduct
                          ?.map((r) => AnalysisPair(id: r.name, value: r.count))
                          .toList() ??
                      [],
                  title: 'Products - Total Sold',
                ),
                SalesBoard(
                  isTile: true,
                  type: BoardType.bar,
                  data:
                      report!.report!.mostProfitableProduct
                          ?.map(
                            (r) => AnalysisPair(id: r.name, value: r.amount),
                          )
                          .toList() ??
                      [],
                  title: 'Products - Profits',
                ),
              ],
            ),
          ),
          Visibility(
            visible: !EnvironmentProvider.instance.isLargeDisplay!,
            child: SizedBox(
              height: 84,
              child: ProductsOverview(data: report!.report),
            ),
          ),
        ],
      ),
    );
  }
}
