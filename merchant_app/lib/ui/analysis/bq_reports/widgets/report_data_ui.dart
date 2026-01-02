// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/models/reports/bq_comparison_report.dart';
import 'package:littlefish_merchant/models/reports/bq_comparison_report_series.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/widgets/comparison_report_tab_controller.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/widgets/comparison_sales_boards.dart';
import 'package:littlefish_merchant/ui/analysis/reports/sales/widgets/sales_boards.dart';

class ReportDataUI extends StatefulWidget {
  const ReportDataUI({
    Key? key,
    required this.salesBoardTitle,
    required this.salesBoardData,
    required this.salesBoardType,
    required this.tableData,
    required this.tableDateTimeIndex,
    required this.tableHeaderText,
    required this.dataColumnHeadings,
    required this.reportType,
    this.isLoading,
  }) : super(key: key);

  final bool? isLoading;

  final String salesBoardTitle;
  final List<ComparisonBqReportSeries> salesBoardData;
  final BoardType salesBoardType;

  final List<dynamic> tableData;
  final String tableDateTimeIndex;
  final String tableHeaderText;
  final List<String>? dataColumnHeadings;
  final String? reportType;

  @override
  State<ReportDataUI> createState() => _ReportDataUIState();
}

class _ReportDataUIState extends State<ReportDataUI> {
  bool? isLoading;

  String? salesBoardTitle;
  List<ComparisonBqReportSeries>? salesBoardData;
  BoardType? salesBoardType;

  List<ComparisonBqReport>? tableData;
  String? tableDateTimeIndex;
  String? tableHeaderText;
  List<String>? dataColumnHeadings;

  late ComparisonSalesBoard salesBoard;

  late ComparisonReportTabController paginatedTable;

  @override
  void initState() {
    salesBoard = ComparisonSalesBoard(
      title: widget.salesBoardTitle,
      data: widget.salesBoardData,
      type: widget.salesBoardType,
    );

    paginatedTable = ComparisonReportTabController(
      reportData: widget.tableData,
      dateTimeIndex: widget.tableDateTimeIndex,
      headerText: widget.tableHeaderText,
      dataColumnHeadings: widget.dataColumnHeadings,
      reportType: widget.reportType,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    salesBoard = ComparisonSalesBoard(
      title: widget.salesBoardTitle,
      data: widget.salesBoardData,
      type: widget.salesBoardType,
    );

    paginatedTable = ComparisonReportTabController(
      reportData: widget.tableData,
      dateTimeIndex: widget.tableDateTimeIndex,
      headerText: widget.tableHeaderText,
      dataColumnHeadings: widget.dataColumnHeadings,
      reportType: widget.reportType,
    );

    return ListView(
      shrinkWrap: true,
      children: [
        if (widget.isLoading == true) const LinearProgressIndicator(),
        if (widget.isLoading != true) salesBoard,
        if (widget.isLoading == true) const LinearProgressIndicator(),
        if (widget.isLoading != true) paginatedTable,
      ],
    );
  }
}
