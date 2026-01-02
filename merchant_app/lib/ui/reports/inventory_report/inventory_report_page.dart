// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/analysis/reports/sales/widgets/sales_boards.dart';
import 'package:littlefish_merchant/ui/reports/inventory_report/inventory_report_datatable.dart';
import 'package:littlefish_merchant/ui/reports/inventory_report/inventory_report_vm.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';

import '../../../common/presentaion/components/cards/card_neutral.dart';

class InventoryReportPage extends StatefulWidget {
  static const route = 'report/inventory-report';

  const InventoryReportPage({Key? key}) : super(key: key);

  @override
  State<InventoryReportPage> createState() => _InventoryReportPageState();
}

class _InventoryReportPageState extends State<InventoryReportPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, InventoryReportVM>(
      converter: (Store<AppState> store) => InventoryReportVM.fromStore(store),
      builder: (BuildContext ctx, InventoryReportVM vm) {
        if (vm.reportData == null) vm.runReport(context);
        return AppScaffold(
          title: 'Stock Report',
          body: Center(
            child: FutureBuilder(
              future: vm.getInvReport(context),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const LinearProgressIndicator();
                }

                return ListView(
                  shrinkWrap: true,
                  children: [
                    CardNeutral(
                      child: SalesBoard(
                        title: '',
                        type: BoardType.column,
                        data:
                            vm.reportData
                                ?.map(
                                  (e) => AnalysisPair(
                                    id: e.productName,
                                    value: e.closingInventory,
                                  ),
                                )
                                .toList() ??
                            [],
                      ),
                    ),
                    CardNeutral(
                      child: SalesBoard(
                        title: 'Stock Sold per Day (3 months)',
                        type: BoardType.bar,
                        data:
                            vm.reportData
                                ?.map(
                                  (e) => AnalysisPair(
                                    id: e.productName,
                                    value: e.quantitySoldPerDay,
                                    // useLessThan: true,
                                    // lessThanValue: 1,
                                  ),
                                )
                                .toList() ??
                            [],
                      ),
                    ),
                    Visibility(
                      visible: vm.reportData?.isNotEmpty == true,
                      child: InventoryDataTable(vm: vm),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
