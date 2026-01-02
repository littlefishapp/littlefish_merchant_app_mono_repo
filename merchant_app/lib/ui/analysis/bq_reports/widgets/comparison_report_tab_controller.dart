// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/ui/analysis/bq_reports/classes/comparison_report_data_source.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';

class ComparisonReportTabController extends StatefulWidget {
  const ComparisonReportTabController({
    Key? key,
    required this.reportData,
    this.dateTimeIndex,
    this.headerText,
    this.dataColumnHeadings,
    this.reportType,
    this.setParentTabIndex,
    this.tabIndex,
  }) : super(key: key);

  final List<dynamic> reportData;
  final String? headerText;
  final String? dateTimeIndex;
  final List<String>? dataColumnHeadings;
  final String? reportType;
  final Function? setParentTabIndex;
  final int? tabIndex;

  @override
  State<ComparisonReportTabController> createState() =>
      _ComparisonReportTabController();
}

class _ComparisonReportTabController
    extends State<ComparisonReportTabController>
    with TickerProviderStateMixin {
  late List<dynamic> reportData;
  String? headerText;
  String? dateTimeIndex;
  List<String>? dataColumnHeadings;
  late TabController controller;
  int tabIndex = 0;

  Function? reloadPage;

  @override
  void initState() {
    tabIndex = widget.tabIndex ?? tabIndex;
    reportData = widget.reportData;

    if ((reportData.length - 1) < tabIndex) {
      tabIndex = 0;
    }

    controller = TabController(
      length: reportData.isEmpty ? 1 : reportData.length,
      vsync: this,
      initialIndex: tabIndex,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return reportData.isEmpty
        ? Center(
            child: DecoratedText(
              'No Data',
              alignment: Alignment.center,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              textColor: Theme.of(context).colorScheme.primary,
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TabBar(
                isScrollable: true,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: Theme.of(context).colorScheme.secondary,
                controller: controller,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Colors.grey,
                onTap: (index) {
                  setState(() {
                    if ((reportData.length - 1) < index) {
                      tabIndex = 0;
                    }

                    tabIndex = index;

                    if (widget.setParentTabIndex != null) {
                      widget.setParentTabIndex!(tabIndex);
                    }
                  });
                },
                tabs: reportData
                    .map(
                      (e) => Text(e.seriesName!, textAlign: TextAlign.center),
                    )
                    .toList(),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: PaginatedDataTable(
                  header: Text(widget.headerText!),
                  availableRowsPerPage: const [10],
                  columns: <DataColumn>[
                    DataColumn(label: Text(widget.dateTimeIndex!)),
                    ...widget.dataColumnHeadings!.map(
                      (e) => DataColumn(label: Text(e)),
                    ),
                  ],
                  source: ComparisonReportDataSource(
                    reportData[tabIndex].reportResponse,
                    widget.reportType,
                  ),
                ),
              ),
            ],
          );
  }
}
