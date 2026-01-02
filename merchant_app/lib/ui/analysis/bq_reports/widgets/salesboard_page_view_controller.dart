// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/models/reports/bq_comparison_report_series.dart';
import 'package:littlefish_merchant/ui/analysis/reports/sales/widgets/sales_boards.dart';

class SalesboardPageViewController extends StatefulWidget {
  const SalesboardPageViewController({
    Key? key,
    required this.title,
    required this.type,
    required this.reportData,
    required this.dynamicData,
    this.setParentTabIndex,
    this.showTabHeaders = true,
    this.tabIndex,
    this.height,
  }) : super(key: key);

  final String title;

  final BoardType type;

  final bool showTabHeaders;

  final double? height;

  final List<ComparisonBqReportSeries>? reportData;

  final List<dynamic>? dynamicData;

  final Function? setParentTabIndex;

  final int? tabIndex;

  @override
  State<SalesboardPageViewController> createState() =>
      _SalesboardPageViewController();
}

class _SalesboardPageViewController
    extends State<SalesboardPageViewController> {
  int tabIndex = 0;

  Function? reloadPage;

  late PageController controller;

  @override
  void initState() {
    controller = PageController(viewportFraction: 0.7, initialPage: tabIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    tabIndex = widget.tabIndex ?? tabIndex;

    if (controller.hasClients) {
      if (controller.page != tabIndex) {
        controller.animateToPage(
          tabIndex,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeIn,
        );
      }
    }

    return SizedBox(
      height: widget.height ?? 320,
      child: PageView.builder(
        controller: controller,
        physics: const BouncingScrollPhysics(),
        itemCount: widget.reportData?.length ?? 0,
        itemBuilder: ((context, index) => SalesBoard(
          title: widget.title,
          data: widget.reportData![index].analysisPairs,
          type: BoardType.doughnut,
        )),
      ),
    );
  }
}
