import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core/auth/services/auth_service.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/list_detail_view.dart';
import 'package:littlefish_merchant/ui/customers/pages/customer_import_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/customer/customer_actions.dart';
import 'package:littlefish_merchant/ui/customers/pages/customer_page.dart';
import 'package:littlefish_merchant/ui/customers/viewmodels/customer_view_models.dart';
import 'package:littlefish_merchant/ui/customers/widgets/customer_list.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_tabbed_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_tabbar.dart';
import '../../common/presentaion/components/buttons/footer_buttons_icon_primary.dart';
import '../../injector.dart';
import '../../models/customers/customer.dart';
import '../../models/enums.dart';

class CustomersPage extends StatefulWidget {
  static const String route = 'business/customers';

  const CustomersPage({Key? key}) : super(key: key);

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CustomersViewModel>(
      onInit: (store) => store.dispatch(initializeCustomers()),
      converter: (Store store) {
        return CustomersViewModel.fromStore(store as Store<AppState>);
      },
      builder: (BuildContext ctx, CustomersViewModel vm) =>
          EnvironmentProvider.instance.isLargeDisplay!
          ? scaffoldTablet(context, vm)
          : scaffoldMobile(context, vm),
    );
  }

  AppScaffold scaffoldMobile(BuildContext context, CustomersViewModel vm) =>
      AppScaffold(
        title: 'Customers',
        hasDrawer: vm.store!.state.enableSideNavDrawer!,
        displayNavDrawer: vm.store!.state.enableSideNavDrawer!,
        body: vm.isLoading!
            ? const AppProgressIndicator()
            : AppTabBar(
                reverse: true,
                tabs: [
                  TabBarItem(
                    content: customerList(context, vm),
                    text: 'Customers',
                    // icon: Icons.people,
                  ),
                ],
              ),
        actions: [
          if (platformType != PlatformType.pos) ...[
            IconButton(
              icon: Icon(MdiIcons.badgeAccount),
              color: Theme.of(context).colorScheme.surface,
              onPressed: () async {
                Navigator.of(context).pushNamed(CustomerImportPage.route);
              },
            ),
          ],
        ],
        persistentFooterButtons: [addCustomerRefresh(context, vm)],
      );

  Widget addCustomerRefresh(BuildContext context, CustomersViewModel vm) {
    return FooterButtonsIconPrimary(
      primaryButtonText: 'Add Customer',
      onPrimaryButtonPressed: (_) async {
        StoreProvider.of<AppState>(
          context,
        ).dispatch(createCustomer(context: context));
      },
      secondaryButtonIcon: Icons.refresh,
      onSecondaryButtonPressed: (context) async {
        vm.onRefresh();
      },
    );
  }

  Widget scaffoldTablet(BuildContext context, CustomersViewModel vm) {
    return ListDetailView(
      listWidget: AppScaffold(
        title: 'Customers',
        enableProfileAction: false,
        hasDrawer: true,
        displayNavDrawer: true,
        actions: <Widget>[
          if (platformType != PlatformType.pos) ...[
            IconButton(
              icon: Icon(MdiIcons.badgeAccount),
              color: Theme.of(context).colorScheme.surface,
              onPressed: () async {
                Navigator.of(context).pushNamed(CustomerImportPage.route);
              },
            ),
          ],
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              vm.onRefresh();
            },
          ),
        ],
        body: vm.isLoading!
            ? const AppProgressIndicator()
            : customerList(context, vm),
        persistentFooterButtons: [addCustomerRefresh(context, vm)],
      ),
      detailWidget: vm.selectedItem != null && !vm.isNew!
          ? CustomerPage(isEmbedded: true, parentContext: context)
          : const AppScaffold(
              enableProfileAction: false,
              displayBackNavigation: false,
              body: Center(
                child: DecoratedText(
                  'Select Customer',
                  alignment: Alignment.center,
                  fontSize: 24,
                ),
              ),
            ),
    );
  }

  CustomerList customerList(context, CustomersViewModel vm) {
    return CustomerList(
      onTap: (Customer customer) {
        vm.store!.dispatch(viewCustomer(customer, context: context));
        if (mounted) setState(() {});
      },
      vm: vm,
    );
  }
}
