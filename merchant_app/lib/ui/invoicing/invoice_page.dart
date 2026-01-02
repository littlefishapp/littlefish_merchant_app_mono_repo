// removed ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/models/suppliers/supplier_invoice.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/suppliers/supplier_actions.dart';
import 'package:littlefish_merchant/ui/invoicing/forms/invoice_details_form.dart';
import 'package:littlefish_merchant/ui/invoicing/view_models.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_tabbed_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_tabbar.dart';

import '../../common/presentaion/components/buttons/button_primary.dart';
import '../../common/presentaion/pages/scaffolds/app_scaffold.dart';

class InvoicePage extends StatefulWidget {
  static const String route = '/invoice-details';

  final bool embedded;

  final SupplierInvoice? invoice;

  const InvoicePage({Key? key, this.embedded = false, this.invoice})
    : super(key: key);

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, InvoiceVM>(
      onInit: (store) {
        store.dispatch(getSuppliers(refresh: false));
      },
      converter: (Store store) {
        return InvoiceVM.fromStore(store as Store<AppState>)..key = key;
      },
      builder: (BuildContext context, InvoiceVM vm) => scaffold(context, vm),
    );
  }

  AppScaffold scaffold(context, InvoiceVM vm) {
    final isLargeDisplay = EnvironmentProvider.instance.isLargeDisplay ?? false;
    return AppScaffold(
      title: vm.item?.displayName == null || vm.item!.displayName!.isEmpty
          ? 'New Invoice'
          : vm.item!.displayName ?? 'Invoice',
      enableProfileAction: !isLargeDisplay,
      displayBackNavigation: !isLargeDisplay,
      persistentFooterButtons: vm.item!.isNew!
          ? <Widget>[
              ButtonPrimary(
                upperCase: false,
                text: 'Save',
                onTap: (context) {
                  vm.onAdd(vm.item, context);
                },
              ),
            ]
          : null,
      body: vm.isLoading!
          ? const AppProgressIndicator()
          : AppTabBar(
              reverse: true,
              tabs: [
                TabBarItem(
                  text: 'Details',
                  content: detailsLayout(context, vm),
                ),
              ],
            ),
    );
  }

  Column detailsLayout(context, InvoiceVM vm) =>
      Column(children: <Widget>[Expanded(child: form(context, vm))]);

  Container form(BuildContext context, InvoiceVM vm) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InvoiceDetailsForm(formKey: vm.key, invoice: vm.item),
    ),
  );
}
