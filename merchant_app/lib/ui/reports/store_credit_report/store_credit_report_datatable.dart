// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/models/reports/store_credit_overview.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/reports/store_credit_report/store_credit_report_vm.dart';

class StoreCreditDataTable extends StatefulWidget {
  final StoreCreditReportVM? vm;

  const StoreCreditDataTable({Key? key, this.vm}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StoreCreditDataTableState();
}

class _StoreCreditDataTableState extends State<StoreCreditDataTable> {
  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      header: const Text('StoreCredit'),
      availableRowsPerPage: const [10],
      // onPageChanged: (offset) {
      //   widget.vm.onOffsetChange(offset);
      //   widget.vm.getNextPage(context);
      // },
      columns: const <DataColumn>[
        DataColumn(label: Text('Customer')),
        DataColumn(label: Text('Amount Owed')),
      ],
      source: TransactionDataSource(widget.vm!.reportData),
    );
  }
}

class TransactionDataSource extends DataTableSource {
  StoreCreditOverview? table;

  TransactionDataSource(this.table);

  @override
  DataRow getRow(int index) {
    final customer = table!.creditCustomers![index];

    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text(customer.displayName!)),
        DataCell(
          Text(
            TextFormatter.toStringCurrency(
              customer.creditBalance,
              displayCurrency: false,
              currencyCode: '',
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => table?.creditCustomers?.length ?? 0;

  @override
  int get selectedRowCount => 0;
}
