// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

// Project imports:
import 'package:littlefish_merchant/models/reports/paged_products.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/reports/products/filter/product_list_vm.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

const int _rowsPerPage = 10;

const double _dataPagerHeight = 60.0;

List<ProductSingleVariance> _transaction = [];

List<ProductSingleVariance> _paginatedTransaction = [];
List _mylist = [];

TransactionDataSource _transactionInfoDataSource = TransactionDataSource(
  _mylist,
);

class ProductListDataTable extends StatefulWidget {
  final ProductListVM? vm;

  const ProductListDataTable({Key? key, this.vm}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProductListDataTableState();
}

class _ProductListDataTableState extends State<ProductListDataTable> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return Column(
          children: [
            SizedBox(
              height: (MediaQuery.of(context).size.height * (10.1 / 15)),
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
                  delegate: _transactionInfoDataSource,
                  pageCount:
                      ((widget.vm!.tableData!.result!.length / _rowsPerPage))
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
    _transaction = widget.vm!.tableData!.result!;
    _transactionInfoDataSource = TransactionDataSource(_transaction);
    const Color columnColor = Colors.black;
    return SfDataGridTheme(
      data: SfDataGridThemeData(
        gridLineColor: const Color.fromRGBO(202, 202, 202, 0.5),
        gridLineStrokeWidth: 1.0,
      ), //Theme.of(context).colorScheme.secondary
      child: SfDataGrid(
        source: _transactionInfoDataSource,
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
          // GridColumn(
          //   label: const Center(child: Text('image',
          //     style: const TextStyle(color: column_color),
          //     overflow: TextOverflow.ellipsis,)),
          //   columnName: 'image',
          // ),
          GridColumn(
            label: const Center(
              child: Text(
                'Margin (%)',
                style: TextStyle(color: columnColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            columnName: 'margin',
          ),
          GridColumn(
            label: const Center(
              child: Text(
                'Selling Price',
                style: TextStyle(color: columnColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            columnName: 'selling_price',
          ),
          GridColumn(
            label: const Center(
              child: Text('Cost Price', style: TextStyle(color: columnColor)),
            ),
            columnName: 'cost_price',
          ),
          GridColumn(
            label: const Center(
              child: Text(
                'Items in Stock',
                style: TextStyle(color: columnColor),
              ),
            ),
            columnName: 'item_in_stock',
          ),
          GridColumn(
            label: const Center(
              child: Text('Date Added', style: TextStyle(color: columnColor)),
            ),
            columnName: 'date_added',
          ),
          GridColumn(
            label: const Center(
              child: Text('Type', style: TextStyle(color: columnColor)),
            ),
            columnName: 'type',
          ),
        ],
        stackedHeaderRows: <StackedHeaderRow>[
          StackedHeaderRow(
            cells: [
              StackedHeaderCell(
                columnNames: [
                  'type',
                  'date_added',
                  'item_in_stock',
                  'cost_price',
                  'selling_price',
                  'margin',
                  'product',
                  // 'image',
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Product',
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
  TransactionDataSource(List mylist) {
    _paginatedTransaction = _transaction
        .getRange(0, _transaction.length)
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
    int endIndex = _transaction.length > startIndex + _rowsPerPage
        ? startIndex + _rowsPerPage
        : _transaction.length;
    if (startIndex < _transaction.length && endIndex <= _transaction.length) {
      _paginatedTransaction = _transaction
          .getRange(startIndex, endIndex)
          .toList(growable: false);
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      _paginatedTransaction = [];
    }
    return true;
  }

  void buildPaginatedDataGridRows() {
    dataGridRows = _paginatedTransaction
        .map<DataGridRow>(
          (dataGridRow) => DataGridRow(
            cells: [
              DataGridCell<String>(
                columnName: 'product',
                value: dataGridRow.displayName!,
              ),
              // DataGridCell<Widget>(columnName: 'image', value: ClipRRect(
              //   borderRadius: BorderRadius.circular(4),
              //   child: dataGridRow.imageUri != null?
              //   FadeInImage(
              //     image: getIt<FlutterNetworkImage>().asImageProvider(dataGridRow.imageUri!),
              //     placeholder: AssetImage(UIStateData().appLogo),
              //   ):
              //   dataGridRow.productType == ProductType.physical
              //       ? Container(child: Icon(MdiIcons.tag))
              //       : Container(child: Icon(MdiIcons.account)),
              // )
              // ),
              DataGridCell<String>(
                columnName: 'margin',
                value: TextFormatter.toOneDecimalPlace(
                  dataGridRow.variances!.markup,
                ),
              ),
              DataGridCell<String>(
                columnName: 'selling_price',
                value: TextFormatter.toStringCurrency(
                  dataGridRow.variances!.sellingPrice,
                  displayCurrency: false,
                  currencyCode: '',
                ),
              ),
              DataGridCell<String>(
                columnName: 'cost_price',
                value: TextFormatter.toStringCurrency(
                  dataGridRow.variances!.costPrice,
                  displayCurrency: false,
                  currencyCode: '',
                ),
              ),
              DataGridCell<String>(
                columnName: 'item_in_stock',
                value: dataGridRow.variances!.quantityAsNonNegative.toString(),
              ),
              DataGridCell<String>(
                columnName: 'date_added',
                value: TextFormatter.toShortDate(
                  dateTime: dataGridRow.dateCreated,
                ).toString(),
              ),
              DataGridCell<String>(
                columnName: 'type',
                value: dataGridRow.productType == ProductType.physical
                    ? 'Physical'
                    : 'Service',
              ),
            ],
          ),
        )
        .toList(growable: false);
  }
}
