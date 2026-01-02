// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/reports/sales_report.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/analysis/reports/sales/view_models.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

const int _rowsPerPage = 10;

const double _dataPagerHeight = 60.0;

List<SalesView> _inventory = [];

List<SalesView> _paginatedInventory = [];

// TODO(lampian): fix 23 and 24 not - remove after testing
//reportMode.ReportMode? _timeMode;
String _timeMode = '';

final TransactionDataSource transactionInfoDataSource = TransactionDataSource();

class SalesDatatable extends StatefulWidget {
  final SalesReportVM? vm;

  const SalesDatatable({Key? key, required this.vm}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SalesDatatableState();
}

class _SalesDatatableState extends State<SalesDatatable> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return Column(
          children: [
            SizedBox(
              height: (MediaQuery.of(context).size.height * (9 / 15)),
              child: _buildDataGrid(constraint),
            ),
            SizedBox(
              height: _dataPagerHeight,
              child: SfDataPagerTheme(
                data: SfDataPagerThemeData(
                  itemColor: Theme.of(context).colorScheme.background,
                  itemTextStyle: const TextStyle(color: Colors.black54),
                  selectedItemColor: Theme.of(context).colorScheme.primary,
                  selectedItemTextStyle: const TextStyle(color: Colors.white),
                  disabledItemColor: Theme.of(context).colorScheme.background,
                  disabledItemTextStyle: const TextStyle(color: Colors.black54),
                ),
                child: SfDataPager(
                  delegate: transactionInfoDataSource,
                  pageCount: (widget.vm!.report!.current!.length / _rowsPerPage)
                      .ceil()
                      .toDouble(),
                  direction: Axis.horizontal,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDataGrid(BoxConstraints constraint) {
    _inventory = widget.vm!.report!.current!;
    _timeMode = 'widget.vm!.mode';
    const Color columnColor = Colors.black;
    return SfDataGridTheme(
      data: SfDataGridThemeData(
        gridLineColor: const Color.fromRGBO(202, 202, 202, 0.5),
        gridLineStrokeWidth: 1.0,
      ), //Theme.of(context).colorScheme.secondary
      child: SfDataGrid(
        source: transactionInfoDataSource,
        frozenColumnsCount: 1,
        columnWidthMode: ColumnWidthMode.auto,
        columns: <GridColumn>[
          GridColumn(
            autoFitPadding: const EdgeInsets.only(left: 12),
            width: (MediaQuery.of(context).size.width * (4 / 15)),
            label: Center(
              child: Text(
                widget.vm!.mode == ReportMode.day
                    ? 'Time'
                    : widget.vm!.mode == ReportMode.year ||
                          widget.vm!.mode == ReportMode.threeMonths
                    ? 'Month'
                    : 'Day of Month',
                style: const TextStyle(color: columnColor),
              ),
            ),
            columnName: 'time_period',
          ),
          GridColumn(
            label: const Center(
              child: Text(
                'Gross Sales',
                style: TextStyle(color: columnColor),
                textAlign: TextAlign.center,
              ),
            ),
            columnName: 'revenue',
          ),
          GridColumn(
            label: const Center(
              child: Text(
                'Gross Profit Margin',
                style: TextStyle(color: columnColor),
                textAlign: TextAlign.center,
              ),
            ),
            columnName: 'margin',
          ),
          GridColumn(
            label: const Center(
              child: Text(
                'Order Count',
                style: TextStyle(color: columnColor),
                textAlign: TextAlign.center,
              ),
            ),
            columnName: 'sale_count',
          ),
          GridColumn(
            label: const Center(
              child: Text(
                'Average Order Value',
                style: TextStyle(color: columnColor),
                textAlign: TextAlign.center,
              ),
            ),
            columnName: 'avg_sale',
          ),
          GridColumn(
            label: const Center(
              child: Text(
                'Discounts',
                style: TextStyle(color: columnColor),
                textAlign: TextAlign.center,
              ),
            ),
            columnName: 'discounts',
          ),
        ],
        stackedHeaderRows: <StackedHeaderRow>[
          StackedHeaderRow(
            cells: [
              StackedHeaderCell(
                columnNames: [
                  'discounts',
                  'avg_sale',
                  'sale_count',
                  'margin',
                  'revenue',
                  'time_period',
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Orders',
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
}

class TransactionDataSource extends DataGridSource {
  TransactionDataSource() {
    _paginatedInventory = _inventory
        .getRange(0, _inventory.length)
        .toList(growable: false);
    buildPaginatedDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    const Color valueColor = Colors.black;
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          padding: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: Text(
            dataGridCell.value.toString(),
            style: const TextStyle(color: valueColor),
          ),
        );
      }).toList(),
    );
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    int startIndex = newPageIndex * _rowsPerPage;
    int endIndex = _inventory.length > startIndex + _rowsPerPage
        ? startIndex + _rowsPerPage
        : _inventory.length;
    if (startIndex < _inventory.length && endIndex <= _inventory.length) {
      _paginatedInventory = _inventory
          .getRange(startIndex, endIndex)
          .toList(growable: false);
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      _paginatedInventory = [];
    }
    return true;
  }

  void buildPaginatedDataGridRows() {
    dataGridRows = _paginatedInventory
        .map<DataGridRow>(
          (dataGridRow) => DataGridRow(
            cells: [
              DataGridCell<String>(
                columnName: 'time_period',
                value: getStringFromGrouping(_timeMode, dataGridRow.key),
              ),
              DataGridCell<String>(
                columnName: 'revenue',
                value: TextFormatter.toStringCurrency(
                  dataGridRow.totalSales,
                  displayCurrency: false,
                  currencyCode: '',
                ),
              ),
              DataGridCell<String>(
                columnName: 'margin',
                value: TextFormatter.toStringCurrency(
                  isGreaterThanZero(dataGridRow.netSales)
                      ? ((dataGridRow.grossProfit ?? 0) /
                                (dataGridRow.netSales!)) *
                            100
                      : 0,
                  displayCurrency: false,
                  currencyCode: '',
                ),
              ),
              DataGridCell<String>(
                columnName: 'sale_count',
                value: dataGridRow.saleCount?.toStringAsFixed(0) ?? 0 as String,
              ),
              DataGridCell<String>(
                columnName: 'avg_sale',
                value: TextFormatter.toStringCurrency(
                  dataGridRow.averageSale,
                  displayCurrency: false,
                  currencyCode: '',
                ),
              ),
              DataGridCell<String>(
                columnName: 'discounts',
                value: TextFormatter.toStringCurrency(
                  dataGridRow.totalDiscounts,
                  displayCurrency: false,
                  currencyCode: '',
                ),
              ),
            ],
          ),
        )
        .toList(growable: false);
  }
}
