// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/ui/analysis/reports/customers/customers_overview.dart';
import 'package:littlefish_merchant/ui/analysis/reports/sales/view_models.dart';
import 'package:littlefish_merchant/ui/analysis/reports/sales/widgets/sales_boards.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class CustomersReportDisplay extends StatelessWidget {
  final CustomersReportVM? report;

  const CustomersReportDisplay({Key? key, required this.report})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (report!.report == null ||
        (report!.report!.customerSales == null ||
            report!.report!.customerSales!.isEmpty)) {
      return const Center(child: Text('No Data'));
    }

    return report!.isLoading!
        ? const AppProgressIndicator()
        : Container(
            color: Colors.grey.shade50,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio:
                          EnvironmentProvider.instance.isLargeDisplay!
                          ? 1.5
                          : 0.95,
                      crossAxisCount:
                          EnvironmentProvider.instance.isLargeDisplay! ? 2 : 1,
                      mainAxisSpacing:
                          EnvironmentProvider.instance.isLargeDisplay!
                          ? 16.0
                          : 4,
                      crossAxisSpacing:
                          EnvironmentProvider.instance.isLargeDisplay!
                          ? 16.0
                          : 4,
                    ),
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: <Widget>[
                      Visibility(
                        visible:
                            (report!.report?.customerSales?.length ?? 0) > 0,
                        child: SalesBoard(
                          isTile: true,
                          type: BoardType.doughnut,
                          data: [
                            if (report!.report!.customerSales!.isNotEmpty)
                              AnalysisPair(
                                id: 'Repeat Customers',
                                value:
                                    report!.report!.customerSales
                                        ?.map((s) => s.totalSales)
                                        .reduce((a, b) => a! + b!) ??
                                    0.0,
                              ),
                            if (report!.report!.nonCustomerSales!.isNotEmpty)
                              AnalysisPair(
                                id: 'Unknown Customers',
                                value:
                                    report!.report!.nonCustomerSales
                                        ?.map((s) => s.totalSales)
                                        .reduce(
                                          (a, b) => (a ?? 0.0) + (b ?? 0.0),
                                        ) ??
                                    0.0,
                              ),
                          ],
                          title: 'Customers - Overview',
                        ),
                      ),
                      Visibility(
                        visible:
                            (report!.report?.topCustomersByPurchases?.length ??
                                0) >
                            0,
                        child: SalesBoard(
                          isTile: true,
                          type: BoardType.spline,
                          data:
                              report!.report?.topCustomersByPurchases
                                  ?.map(
                                    (x) => AnalysisPair(
                                      id: x.name,
                                      value: x.amount!.toDouble(),
                                    ),
                                  )
                                  .toList() ??
                              [],
                          title: 'Top Customers - Purchase Trend',
                        ),
                      ),
                      Visibility(
                        visible:
                            (report!.report?.topCustomersByPurchases?.length ??
                                0) >
                            0,
                        child: SalesBoard(
                          isTile: true,
                          type: BoardType.doughnut,
                          data:
                              report!.report?.topCustomersByPurchases
                                  ?.map(
                                    (x) => AnalysisPair(
                                      id: x.name,
                                      value: x.amount!.toDouble(),
                                    ),
                                  )
                                  .toList() ??
                              [],
                          title: 'Top Customers - Sales',
                        ),
                      ),
                      Visibility(
                        visible:
                            (report!.report?.topCustomersByQuantity?.length ??
                                0) >
                            0,
                        child: SalesBoard(
                          isTile: true,
                          type: BoardType.bar,
                          data:
                              report!.report?.topCustomersByQuantity
                                  ?.map(
                                    (x) => AnalysisPair(
                                      id: x.name,
                                      value: x.count!.toDouble(),
                                    ),
                                  )
                                  .toList() ??
                              [],
                          title: 'Top Customers - Items',
                        ),
                      ),
                      Visibility(
                        visible:
                            (report!.report?.topCustomersByVisits?.length ??
                                0) >
                            0,
                        child: SalesBoard(
                          isTile: true,
                          type: BoardType.spline,
                          data:
                              report!.report?.topCustomersByVisits
                                  ?.map(
                                    (x) => AnalysisPair(
                                      id: x.name,
                                      value: x.amount,
                                    ),
                                  )
                                  .toList() ??
                              [],
                          title: 'Top Visits - Purchases',
                        ),
                      ),
                      Visibility(
                        visible:
                            (report!.report?.topCustomersByVisits?.length ??
                                0) >
                            0,
                        child: SalesBoard(
                          isTile: true,
                          type: BoardType.bar,
                          data:
                              report!.report?.topCustomersByVisits
                                  ?.map(
                                    (x) => AnalysisPair(
                                      id: x.name,
                                      value: x.visits!.toDouble(),
                                    ),
                                  )
                                  .toList() ??
                              [],
                          title: 'Top Visits - Count',
                        ),
                      ),
                    ],
                  ),
                ),
                EnvironmentProvider.instance.isLargeDisplay!
                    ? Container()
                    : SizedBox(
                        height: 84,
                        child: CustomersOverview(data: report!.report),
                      ),
              ],
            ),
          );
  }
}
