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
import 'package:littlefish_merchant/ui/reports/store_credit_report/store_credit_report_datatable.dart';
import 'package:littlefish_merchant/ui/reports/store_credit_report/store_credit_report_vm.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';

import '../../../common/presentaion/components/cards/card_neutral.dart';

class StoreCreditReportPage extends StatefulWidget {
  static const route = 'report/storecredit-report';

  const StoreCreditReportPage({Key? key}) : super(key: key);

  @override
  State<StoreCreditReportPage> createState() => _StoreCreditReportPageState();
}

class _StoreCreditReportPageState extends State<StoreCreditReportPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, StoreCreditReportVM>(
      converter: (Store<AppState> store) =>
          StoreCreditReportVM.fromStore(store),
      builder: (BuildContext ctx, StoreCreditReportVM vm) {
        if (vm.reportData == null) vm.runReport(context);
        return AppScaffold(
          title: 'Store Credit Report',
          body: Center(
            child: FutureBuilder(
              future: vm.getCustomerReport(context),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const LinearProgressIndicator();
                }

                return ListView(
                  shrinkWrap: true,
                  children: [
                    CardNeutral(
                      child: SalesBoard(
                        title: 'Current Store Credit',
                        type: BoardType.column,
                        data:
                            vm.reportData!.creditCustomers
                                ?.map(
                                  (e) => AnalysisPair(
                                    id: e.displayName,
                                    value: e.creditBalance,
                                  ),
                                )
                                .toList() ??
                            [],
                      ),
                    ),
                    StoreCreditDataTable(vm: vm),
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
