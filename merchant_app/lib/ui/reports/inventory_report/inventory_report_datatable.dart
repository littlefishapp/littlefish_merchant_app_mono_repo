// Flutter imports:
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// Project imports:
import 'package:littlefish_merchant/models/reports/inventory_overview.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/reports/inventory_report/inventory_report_vm.dart';

const int _rowsPerPage = 10;

const double _dataPagerHeight = 60.0;

List<InventoryOverview> _inventory = [];

List<InventoryOverview> _paginatedInventory = [];

final InventoryInfoDataSource _inventoryInfoDataSource =
    InventoryInfoDataSource();

class InventoryDataTable extends StatefulWidget {
  final InventoryReportVM? vm;

  const InventoryDataTable({Key? key, this.vm}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _InventoryDataTableState();
}

class _InventoryDataTableState extends State<InventoryDataTable> {
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
                  delegate: _inventoryInfoDataSource,
                  pageCount:
                      ((widget.vm!.reportData?.length ?? 1) / _rowsPerPage)
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
    _inventory = widget.vm!.reportData ?? [];
    const Color columnColor = Colors.black;
    return SfDataGridTheme(
      data: SfDataGridThemeData(
        gridLineColor: const Color.fromRGBO(202, 202, 202, 0.5),
        gridLineStrokeWidth: 1.0,
      ), //Theme.of(context).colorScheme.secondary
      child: SfDataGrid(
        source: _inventoryInfoDataSource,
        frozenColumnsCount: 1,
        columnWidthMode: ColumnWidthMode.auto,
        columns: <GridColumn>[
          GridColumn(
            autoFitPadding: const EdgeInsets.only(left: 12),
            width: (MediaQuery.of(context).size.width * (4 / 15)),
            label: const Center(
              child: Text('Product', style: TextStyle(color: columnColor)),
            ),
            columnName: 'product',
          ),
          GridColumn(
            label: const Center(
              child: Text(
                'Closing Inventory',
                style: TextStyle(color: columnColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            columnName: 'closing_inventory',
          ),
          GridColumn(
            label: const Center(
              child: Text(
                'Items Sold',
                style: TextStyle(color: columnColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            columnName: 'item_sold',
          ),
          GridColumn(
            label: const Center(
              child: Text(
                'Items Sold per Day',
                style: TextStyle(color: columnColor),
              ),
            ),
            columnName: 'item_sold_per_day',
          ),
          GridColumn(
            label: const Center(
              child: Text('Days Covered', style: TextStyle(color: columnColor)),
            ),
            columnName: 'days_covered',
          ),
          GridColumn(
            label: const Center(
              child: Text('Gross sales', style: TextStyle(color: columnColor)),
            ),
            columnName: 'gross_sales',
          ),
          GridColumn(
            label: const Center(
              child: Text('Gross Profit', style: TextStyle(color: columnColor)),
            ),
            columnName: 'gross_profit',
          ),
          GridColumn(
            label: const Center(
              child: Text(
                'Inventory Cost',
                style: TextStyle(color: columnColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            columnName: 'inventory_cost',
          ),
          GridColumn(
            label: const Center(
              child: Text(
                'Retail Value',
                style: TextStyle(color: columnColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            columnName: 'retail_value',
          ),
        ],
        stackedHeaderRows: <StackedHeaderRow>[
          StackedHeaderRow(
            cells: [
              StackedHeaderCell(
                columnNames: [
                  'retail_value',
                  'inventory_cost',
                  'gross_profit',
                  'gross_sales',
                  'days_covered',
                  'item_sold_per_day',
                  'item_sold',
                  'closing_inventory',
                  'product',
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Inventory',
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

class InventoryInfoDataSource extends DataGridSource {
  InventoryInfoDataSource() {
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
                columnName: 'product',
                value: dataGridRow.productName,
              ),
              DataGridCell<String>(
                columnName: 'closing_inventory',
                value: dataGridRow.closingInventory!.toStringAsFixed(2),
              ),
              DataGridCell<String>(
                columnName: 'item_sold',
                value: dataGridRow.quantitySold!.toStringAsFixed(2),
              ),
              DataGridCell<String>(
                columnName: 'item_sold_per_day',
                value: dataGridRow.quantitySoldPerDay!.toStringAsFixed(1),
              ),
              DataGridCell<String>(
                columnName: 'days_covered',
                value: dataGridRow.daysCovered!.toStringAsFixed(0),
              ),
              DataGridCell<String>(
                columnName: 'gross_sales',
                value: TextFormatter.toStringCurrency(
                  dataGridRow.grossSales,
                  displayCurrency: false,
                  currencyCode: '',
                ),
              ),
              DataGridCell<String>(
                columnName: 'gross_profit',
                value: dataGridRow.grossProfit!.toStringAsFixed(2),
              ),
              DataGridCell<String>(
                columnName: 'inventory_cost',
                value: TextFormatter.toStringCurrency(
                  dataGridRow.inventoryCostPrice,
                  displayCurrency: false,
                  currencyCode: '',
                ),
              ),
              DataGridCell<String>(
                columnName: 'retail_value',
                value: TextFormatter.toStringCurrency(
                  dataGridRow.inventorySalePrice,
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
