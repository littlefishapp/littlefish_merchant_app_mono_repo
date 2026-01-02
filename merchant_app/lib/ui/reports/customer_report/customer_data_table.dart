// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/models/reports/paged_checkout_transaction.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/reports/customer_report/customer_statement_vm.dart';

class CustomerDataTable extends StatefulWidget {
  final CustomerStatementVM? vm;

  const CustomerDataTable({Key? key, this.vm}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomerDataTableState();
}

class _CustomerDataTableState extends State<CustomerDataTable> {
  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      header: const Text('Purchases'),
      availableRowsPerPage: const [10],
      onPageChanged: (offset) {
        widget.vm!.onOffsetChange(offset);
        widget.vm!.getNextPage(context);
      },
      columns: const <DataColumn>[
        DataColumn(label: Text('Transaction Date')),
        DataColumn(label: Text('Total Spent')),
        DataColumn(label: Text('Total Cost')),
        DataColumn(label: Text('Total Profit')),
        DataColumn(label: Text('Total Tax')),
        DataColumn(label: Text('Total Quantity')),
        DataColumn(label: Text('Total Discount')),
        DataColumn(label: Text('Payment Type')),
        DataColumn(label: Text('Sold By')),
      ],
      source: TransactionDataSource(widget.vm!.reportData!.sales),
    );
  }
}

class TransactionDataSource extends DataTableSource {
  PagedCheckoutTransaction? table;

  TransactionDataSource(this.table);

  @override
  DataRow? getRow(int index) {
    if (index >= rowCount || rowCount == -1) return null;

    var offset = (index ~/ 10);

    if (offset > 0) {
      index -= (offset * 10);
    }

    final sale = table!.result![index];

    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(
          Text(TextFormatter.toShortDate(dateTime: sale.transactionDate)),
        ),
        DataCell(
          Text(
            TextFormatter.toStringCurrency(
              sale.totalValue,
              displayCurrency: false,
              currencyCode: '',
            ),
          ),
        ),
        DataCell(
          Text(
            TextFormatter.toStringCurrency(
              sale.totalCost,
              displayCurrency: false,
              currencyCode: '',
            ),
          ),
        ),
        DataCell(
          Text(
            TextFormatter.toStringCurrency(
              (sale.totalValue! - sale.totalCost!),
              displayCurrency: false,
              currencyCode: '',
            ),
          ),
        ),
        DataCell(
          Text(
            TextFormatter.toStringCurrency(
              sale.totalTax,
              displayCurrency: false,
              currencyCode: '',
            ),
          ),
        ),
        DataCell(Text('${sale.totalQty}')),
        DataCell(
          Text(
            TextFormatter.toStringCurrency(
              sale.totalDiscount,
              displayCurrency: false,
              currencyCode: '',
            ),
          ),
        ),
        DataCell(Text('${sale.paymentType!.name}')),
        DataCell(Text('${sale.sellerName}')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => table?.count ?? 0;

  @override
  int get selectedRowCount => 0;
}
