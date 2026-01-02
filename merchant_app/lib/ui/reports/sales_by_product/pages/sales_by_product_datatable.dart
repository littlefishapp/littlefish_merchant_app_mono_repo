// Flutter imports:
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_text.dart';

// Project imports:
import 'package:littlefish_merchant/ui/reports/sales_by_product/viewmodels/sales_by_product_report_vm.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../models/reports/paged_product_sales_summary_view.dart';

const int _rowsPerPage = 10;

int _offset = 0;

List<ProductSalesSummaryView> _paginatedTransaction = [];

TransactionDataSource _transactionInfoDataSource = TransactionDataSource();

class SalesByProductDatatable extends StatefulWidget {
  final SalesByProductReportVM? vm;

  const SalesByProductDatatable({Key? key, this.vm}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SalesByProductDatatableState();
}

class _SalesByProductDatatableState extends State<SalesByProductDatatable> {
  @override
  Widget build(BuildContext context) {
    _paginatedTransaction = widget.vm!.summaryTableData?.result ?? [];
    _transactionInfoDataSource = TransactionDataSource();
    return LayoutBuilder(
      builder: (context, constraint) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              // height: (MediaQuery.of(context).size.height * (9 / 15)),
              child: _buildDataGrid(constraint),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.vm != null && widget.vm!.tableData != null)
                  Text(
                    '${_offset * 10 + 1}-${_offset * 10 + _rowsPerPage < widget.vm!.tableData!.count! ? _offset * 10 + _rowsPerPage : widget.vm!.tableData!.count} of ${widget.vm!.tableData!.count}',
                  ),
                SizedBox(width: MediaQuery.of(context).size.width * (1 / 15)),
                ButtonText(
                  onTap: (context) => buttonPressPrevious(),
                  expand: true,
                  text: '<',
                ),
                ButtonText(
                  onTap: (context) => buttonPressNext(),
                  expand: true,
                  text: '>',
                ),
                SizedBox(width: MediaQuery.of(context).size.width * (1 / 15)),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildDataGrid(BoxConstraints constraint) {
    const Color columnColor = Colors.black;
    return SfDataGridTheme(
      data: SfDataGridThemeData(
        gridLineColor: const Color.fromRGBO(202, 202, 202, 0.5),
        gridLineStrokeWidth: 1.0,
        frozenPaneLineColor: Colors.grey,
        frozenPaneLineWidth: .5,
      ), //Theme.of(context).colorScheme.secondary
      child: SfDataGrid(
        source: _transactionInfoDataSource,
        frozenColumnsCount: 1,
        columnWidthMode: ColumnWidthMode.auto,
        columns: <GridColumn>[
          GridColumn(
            width: (MediaQuery.of(context).size.width * (1 / 3)),
            label: const Center(
              child: Text('Product', style: TextStyle(color: columnColor)),
            ),
            columnName: 'product',
          ),
          GridColumn(
            width: (MediaQuery.of(context).size.width * (1 / 3)),
            label: const Center(
              child: Text(
                'Total Items',
                style: TextStyle(color: columnColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            columnName: 'total_items',
          ),
          GridColumn(
            width: (MediaQuery.of(context).size.width * (1 / 3)),
            label: const Center(
              child: Text(
                'Gross Sales',
                style: TextStyle(color: columnColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            columnName: 'gross_sales',
          ),
        ],
        stackedHeaderRows: <StackedHeaderRow>[
          StackedHeaderRow(
            cells: [
              StackedHeaderCell(
                columnNames: ['gross_sales', 'total_items', 'product'],
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Products',
                    textScaler: TextScaler.linear(1.5),
                    style: TextStyle(color: columnColor),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  buttonPressNext() async {
    _offset =
        _offset >= (widget.vm!.summaryTableData!.count! / _rowsPerPage).floor()
        ? _offset
        : _offset + 1;
    widget.vm!.onOffsetChange(_offset * 10);
    await widget.vm!.getNextPage(context);
    setState(() {
      _transactionInfoDataSource.makePageChange(
        widget.vm!.summaryTableData!.result!,
      );
    });
  }

  buttonPressPrevious() async {
    _offset = _offset <= 0 ? _offset : _offset - 1;
    widget.vm!.onOffsetChange(_offset * 10);
    await widget.vm!.getNextPage(context);
    setState(() {
      _transactionInfoDataSource.makePageChange(
        widget.vm!.summaryTableData!.result!,
      );
    });
  }
}

class TransactionDataSource extends DataGridSource {
  TransactionDataSource() {
    buildPaginatedDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    const Color valueColor = Colors.black;
    final currencyFormat = NumberFormat.currency(symbol: 'R', locale: 'en_ZA');

    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        var cellValue = dataGridCell.value;
        Alignment alignment = Alignment.center;
        double rightPadding = 0;
        double leftPadding = 0;

        // Format the cell value as currency if it's a double and belongs to 'total_sale' column

        if (dataGridCell.columnName == 'product') {
          alignment = Alignment.centerLeft;
          leftPadding = 20;
        }

        if (dataGridCell.columnName == 'gross_sales') {
          cellValue = currencyFormat.format(cellValue);
          alignment = Alignment.centerRight;
          rightPadding = 30;
        }

        return Container(
          padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
          alignment: alignment,
          child: Text(
            cellValue.toString(),
            style: const TextStyle(color: valueColor),
          ),
        );
      }).toList(),
    );
  }

  makePageChange(List<ProductSalesSummaryView> newdata) async {
    _paginatedTransaction = newdata;
    buildPaginatedDataGridRows();
    notifyListeners();
  }

  void buildPaginatedDataGridRows() {
    dataGridRows = _paginatedTransaction
        .map<DataGridRow>(
          (dataGridRow) => DataGridRow(
            cells: [
              DataGridCell<String>(
                columnName: 'product',
                value: dataGridRow.productName,
              ),
              DataGridCell<double>(
                columnName: 'total_items',
                value: dataGridRow.quantitySold,
              ),
              DataGridCell<double>(
                columnName: 'gross_sales',
                value: dataGridRow.totalSalesValue,
              ),
            ],
          ),
        )
        .toList(growable: false);
  }
}
