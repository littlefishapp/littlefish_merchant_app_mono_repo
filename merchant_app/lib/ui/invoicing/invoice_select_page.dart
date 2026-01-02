// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/invoice/invoice_actions.dart';
import 'package:littlefish_merchant/ui/invoicing/view_models.dart';
import 'package:littlefish_merchant/ui/invoicing/widgets/invoice_list.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class InvoiceSelectPage extends StatelessWidget {
  static const String route = '/invoices/select';

  const InvoiceSelectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, InvoicesVM>(
      onInit: (store) {
        store.dispatch(getInvoices(refresh: false));
      },
      converter: (store) => InvoicesVM.fromStore(store),
      builder: (BuildContext context, InvoicesVM vm) => scaffold(context, vm),
    );
  }

  AppSimpleAppScaffold scaffold(BuildContext context, InvoicesVM vm) =>
      AppSimpleAppScaffold(
        title: 'Select Invoice',
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              vm.onRefresh();
            },
          ),
        ],
        body: !vm.isLoading! ? list(context, vm) : const AppProgressIndicator(),
      );

  InvoiceList list(context, vm) => InvoiceList(
    items: vm.items,
    selectedItem: vm.selectedItem,
    onTap: (invoice) {
      Navigator.of(context).pop(invoice);
    },
  );
}
