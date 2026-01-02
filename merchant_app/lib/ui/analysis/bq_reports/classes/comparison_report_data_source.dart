// Flutter imports:
import 'package:flutter/material.dart';

class ComparisonReportDataSource extends DataTableSource {
  List<dynamic>? table;
  String? reportType;

  ComparisonReportDataSource(this.table, this.reportType) : super();

  @override
  DataRow getRow(int index) {
    final row = table![index];

    switch (reportType) {
      case 'Rev':
        return DataRow.byIndex(
          index: index,
          cells: <DataCell>[
            DataCell(Text(row.dateTimeIndex.toString())),
            DataCell(Text(row.revenue.toString())),
            DataCell(Text(row.sales.toString())),
            DataCell(Text(row.ats.toString())),
          ],
        );

      case 'Tax':
        return DataRow.byIndex(
          index: index,
          cells: <DataCell>[
            DataCell(Text(row.dateTimeIndex.toString())),
            DataCell(Text(row.revenue.toString())),
            DataCell(Text(row.sales.toString())),
            DataCell(Text(row.amtToTax.toString())),
            DataCell(Text(row.ats.toString())),
          ],
        );

      case 'Profits':
        return DataRow.byIndex(
          index: index,
          cells: <DataCell>[
            DataCell(Text(row.dateTimeIndex.toString())),
            DataCell(Text(row.revenue.toString())),
            DataCell(Text(row.profits.toString())),
          ],
        );

      case 'Payments':
        return DataRow.byIndex(
          index: index,
          cells: <DataCell>[
            DataCell(Text(row.paymentType.toString())),
            DataCell(Text(row.qty.toString())),
            DataCell(Text(row.percentage.toString())),
            DataCell(Text(row.amount.toString())),
          ],
        );

      case 'Products':
        return DataRow.byIndex(
          index: index,
          cells: <DataCell>[
            DataCell(Text(row.productName.toString())),
            DataCell(Text(row.amount.toString())),
            DataCell(Text(row.qty.toString())),
          ],
        );

      case 'Customer Purchases':
        return DataRow.byIndex(
          index: index,
          cells: <DataCell>[
            DataCell(Text(row.firstName ?? '')),
            DataCell(Text(row.amount.toString())),
            DataCell(Text(row.qty.toString())),
          ],
        );

      case 'Staff Sales':
        return DataRow.byIndex(
          index: index,
          cells: <DataCell>[
            DataCell(Text(row.firstName ?? '')),
            DataCell(Text(row.amount.toString())),
            DataCell(Text(row.qty.toString())),
          ],
        );

      default:
        return DataRow.byIndex(
          index: index,
          cells: <DataCell>[
            DataCell(Text(row.dateTimeIndex!.toString())),
            DataCell(Text(row.revenue.toString())),
            DataCell(Text(row.sales.toString())),
            DataCell(Text(row.ats.toString())),
          ],
        );
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => table?.length ?? 0;

  @override
  int get selectedRowCount => 0;
}
