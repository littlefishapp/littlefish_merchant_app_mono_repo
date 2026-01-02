// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/ui/analysis/reports/sales/pages/sales_datatable.dart';
import 'package:littlefish_merchant/ui/analysis/reports/sales/view_models.dart';
import 'package:littlefish_merchant/ui/analysis/reports/sales/widgets/sales_boards.dart';
import 'package:littlefish_merchant/ui/analysis/reports/sales/widgets/sales_overview.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class SalesReportDisplay extends StatelessWidget {
  final SalesReportVM? report;

  const SalesReportDisplay({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (report!.report == null) {
      return const Center(child: Text('No Data'));
    }
    //
    return report!.isLoading!
        ? const AppProgressIndicator()
        : Container(
            color: Colors.grey.shade50,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: EnvironmentProvider.instance.isLargeDisplay!,
                  child: SizedBox(
                    height: EnvironmentProvider.instance.isLargeDisplay!
                        ? 124
                        : 84,
                    child: SalesOverview(data: report!.report),
                  ),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    // physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      Visibility(
                        visible: (report?.report?.current?.length ?? 0) > 0,
                        child: SalesBoard(
                          isTile: true,
                          title: 'Gross Sales',
                          type: BoardType.spline,
                          data: report!.getGrossSales(),
                        ),
                      ),
                      Visibility(
                        visible: (report?.report?.current?.length ?? 0) > 0,
                        child: SalesBoard(
                          isTile: true,
                          title: 'Order Count',
                          type: BoardType.bar,
                          data: report!.getSaleCounts(),
                        ),
                      ),
                      Visibility(
                        visible: (report?.report?.current?.length ?? 0) > 0,
                        child: SalesBoard(
                          isTile: true,
                          title: 'Average Order Value',
                          type: BoardType.spline,
                          data: report!.getAverageSales(),
                        ),
                      ),
                      Visibility(
                        visible:
                            (report?.report?.salesByPaymentType?.length ?? 0) >
                            0,
                        child: SalesBoard(
                          isTile: true,
                          title: 'Orders By Payment Type',
                          type: BoardType.doughnut,
                          data: report!.report?.salesByPaymentType ?? [],
                        ),
                      ),
                      Visibility(
                        visible: (report?.report?.topProducts?.length ?? 0) > 0,
                        child: SalesBoard(
                          isTile: true,
                          title: 'Top Products - Orders',
                          type: BoardType.spline,
                          data:
                              report!.report!.topProducts
                                  ?.map(
                                    (p) => AnalysisPair(
                                      id: p.name,
                                      value: p.amount,
                                    ),
                                  )
                                  .toList() ??
                              [],
                        ),
                      ),
                      Visibility(
                        visible: (report?.report?.topProducts?.length ?? 0) > 0,
                        child: SalesBoard(
                          isTile: true,
                          title: 'Top Products - Quantity',
                          type: BoardType.bar,
                          data:
                              report?.report?.topProducts
                                  ?.map(
                                    (p) => AnalysisPair(
                                      id: p.name,
                                      value: p.count,
                                    ),
                                  )
                                  .toList() ??
                              [],
                        ),
                      ),
                      Visibility(
                        visible:
                            (report?.report?.topCategories?.length ?? 0) > 0,
                        child: SalesBoard(
                          isTile: true,
                          title: 'Top Categories - Orders',
                          type: BoardType.doughnut,
                          data:
                              report!.report!.topCategories
                                  ?.map(
                                    (p) => AnalysisPair(
                                      id: p.name ?? 'Uncategorised',
                                      value: p.amount,
                                    ),
                                  )
                                  .toList() ??
                              [],
                        ),
                      ),
                      Visibility(
                        visible: (report?.report?.current?.length ?? 0) > 0,
                        child: SalesDatatable(vm: report),
                      ),
                    ],
                    // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //   childAspectRatio:
                    //       EnvironmentProvider.instance.isLargeDisplay ? 1.5 : 1,
                    //   crossAxisCount:
                    //       EnvironmentProvider.instance.isLargeDisplay ? 2 : 1,
                    //   mainAxisSpacing:
                    //       EnvironmentProvider.instance.isLargeDisplay
                    //           ? 16.0
                    //           : 4,
                    //   crossAxisSpacing:
                    //       EnvironmentProvider.instance.isLargeDisplay
                    //           ? 16.0
                    //           : 4,
                    // ),
                  ),
                ),
                Visibility(
                  visible: !EnvironmentProvider.instance.isLargeDisplay!,
                  child: SizedBox(
                    height: 84,
                    child: SalesOverview(data: report!.report),
                  ),
                ),
              ],
            ),
          );
  }
}
