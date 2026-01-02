import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/footer_buttons_icon_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/list_detail_view.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/invoice/invoice_actions.dart';
import 'package:littlefish_merchant/redux/suppliers/supplier_actions.dart';
import 'package:littlefish_merchant/ui/invoicing/invoice_page.dart';
import 'package:littlefish_merchant/ui/invoicing/view_models.dart';
import 'package:littlefish_merchant/ui/invoicing/widgets/invoice_list.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class InvoicesPage extends StatelessWidget {
  static const String route = 'business/supplier-invoices';

  const InvoicesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, InvoicesVM>(
      onInit: (store) {
        store.dispatch(getInvoices(refresh: false));
        store.dispatch(getSuppliers(refresh: false));
      },
      converter: (store) => InvoicesVM.fromStore(store),
      builder: (BuildContext context, InvoicesVM vm) =>
          EnvironmentProvider.instance.isLargeDisplay!
          ? scaffoldLargeDisplay(context, vm)
          : scaffold(context, vm),
    );
  }

  Widget scaffoldLargeDisplay(context, InvoicesVM vm) {
    return ListDetailView(
      listWidget: AppScaffold(
        enableProfileAction: false,
        title: 'Supplier Invoices',
        hasDrawer: true,
        displayNavDrawer: true,
        persistentFooterButtons: [addAndRefresh(context, vm)],
        body: !vm.isLoading! ? list(context, vm) : const AppProgressIndicator(),
      ),
      detailWidget: vm.selectedItem != null && !vm.selectedItem!.isNew!
          ? const InvoicePage(embedded: true)
          : const AppScaffold(
              enableProfileAction: false,
              displayBackNavigation: false,
              body: Center(
                child: DecoratedText(
                  'Select Invoice',
                  alignment: Alignment.center,
                  fontSize: 24,
                ),
              ),
            ),
    );
  }

  Widget scaffold(BuildContext context, InvoicesVM vm) {
    var hasDrawer = false;
    var displayDrawer = false;
    if (vm.store != null) {
      hasDrawer = vm.store!.state.enableSideNavDrawer ?? false;
      displayDrawer = vm.store!.state.enableSideNavDrawer ?? false;
    }
    return AppScaffold(
      title: 'Supplier Invoices',
      hasDrawer: hasDrawer,
      displayNavDrawer: displayDrawer,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            vm.onRefresh();
          },
        ),
      ],
      body: !(vm.isLoading ?? false)
          ? list(context, vm)
          : const AppProgressIndicator(),
    );
  }

  InvoiceList list(context, vm) => InvoiceList(
    items: vm.items,
    selectedItem: vm.selectedItem,
    onTap: (invoice) {
      StoreProvider.of<AppState>(
        context,
      ).dispatch(editInvoice(context, invoice));
    },
  );

  Widget addAndRefresh(BuildContext context, InvoicesVM vm) {
    return FooterButtonsIconPrimary(
      primaryButtonText: 'Add Invoice',
      onPrimaryButtonPressed: (_) async {
        StoreProvider.of<AppState>(context).dispatch(createInvoice(context));
      },
      secondaryButtonIcon: Icons.refresh,
      onSecondaryButtonPressed: (context) async {
        vm.onRefresh();
      },
    );
  }
}
