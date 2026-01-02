// remove ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quiver/strings.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/business/business_selectors.dart';
import 'package:littlefish_merchant/redux/customer/customer_actions.dart';
import 'package:littlefish_merchant/ui/customers/pages/credit_transactions_page.dart';
import 'package:littlefish_merchant/ui/customers/pages/customer_import_page.dart';
import 'package:littlefish_merchant/ui/customers/pages/customer_select_page.dart';
import 'package:littlefish_merchant/ui/customers/viewmodels/customer_view_models.dart';
import 'package:littlefish_merchant/ui/settings/pages/credit/store_credit_settings_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_tabbed_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/pages/popup_forms/customer_credit_amount_popup_form.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_tabbar.dart';
import '../../injector.dart';
import '../../tools/network_image/flutter_network_image.dart';
import '../../tools/textformatter.dart';
import '../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../common/presentaion/components/form_fields/auto_complete_text_field.dart';
import '../../common/presentaion/components/common_divider.dart';
import '../../common/presentaion/components/decorated_text.dart';
import '../../common/presentaion/components/long_text.dart';
import '../../common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

class StoreCreditPage extends StatefulWidget {
  static const String route = 'business/manage-credit';

  const StoreCreditPage({Key? key}) : super(key: key);

  @override
  State<StoreCreditPage> createState() => _CreditPageState();
}

class _CreditPageState extends State<StoreCreditPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CustomersViewModel>(
      onInit: (store) {
        if (store.state.customerstate.customers == null ||
            store.state.customerstate.customers?.isEmpty == true) {
          store.dispatch(initializeCustomers(refresh: true));
        }
      },
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
        title: 'Store Credit',
        hasDrawer: AppVariables.store!.state.enableSideNavDrawer!,
        displayNavDrawer: AppVariables.store!.state.enableSideNavDrawer!,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed(StoreCreditSettingsPage.route);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              vm.onRefresh();
            },
          ),
        ],
        body: storeCreditSettings(vm.store!.state)?.enabled == true
            ? vm.isLoading!
                  ? const AppProgressIndicator()
                  : AppTabBar(
                      reverse: true,
                      tabs: [
                        TabBarItem(
                          content: creditList(context, vm),
                          text: 'Customers',
                          // icon: Icons.people,
                        ),
                        // TabBarItem(
                        //   content: CustomerTopTenView(),
                        //   text: "Top 5",
                        //   icon: Icons.star,
                        // )
                      ],
                    )
            : const Center(child: Text('Credit is currently disabled')),
      );

  AppScaffold scaffoldTablet(BuildContext context, CustomersViewModel vm) =>
      AppScaffold(
        enableProfileAction: false,
        title: 'Store Credit',
        actions: <Widget>[
          IconButton(
            icon: Icon(MdiIcons.badgeAccount),
            onPressed: () {
              showPopupDialog(
                context: context,
                content: const CustomerImportPage(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              vm.onRefresh();
            },
          ),
        ],
        body: vm.isLoading!
            ? const AppProgressIndicator()
            : Row(
                children: <Widget>[
                  // Expanded(child: creditBalance(context, vm)),
                  Expanded(child: creditList(context, vm)),
                  const VerticalDivider(width: 0.5),
                  // Expanded(
                  //   child: vm.selectedItem != null && !vm.isNew
                  //       ? CustomerPage(
                  //           isEmbedded: true,
                  //           parentContext: context,
                  //         )
                  //       : Container(
                  //           child: Center(
                  //             child: DecoratedText(
                  //               "Select Customer",
                  //               alignment: Alignment.center,
                  //               fontSize: 24,
                  //             ),
                  //           ),
                  //         ),
                  // )
                ],
              ),
      );

  CreditList creditList(context, CustomersViewModel vm) => CreditList(
    onTap: (customer) {
      vm.store!.dispatch(editCustomer(customer, context: context));
      if (mounted) setState(() {});
    },
    vm: vm,
  );
}

class CreditList extends StatefulWidget {
  final Function(Customer customer) onTap;

  final CustomersViewModel vm;

  final bool canAddNew;

  const CreditList({
    Key? key,
    required this.onTap,
    required this.vm,
    this.canAddNew = true,
  }) : super(key: key);

  @override
  State<CreditList> createState() => _CreditListState();
}

class _CreditListState extends State<CreditList> {
  GlobalKey<AutoCompleteTextFieldState<Customer>> filterKey =
      GlobalKey<AutoCompleteTextFieldState<Customer>>();

  CustomersViewModel? vm;

  @override
  Widget build(BuildContext context) {
    vm = widget.vm;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [sliverBalance(context, vm!), creditList(context)],
      ),
    );
  }

  Container creditBalance(BuildContext context, CustomersViewModel vm) =>
      Container(
        width: MediaQuery.of(context).size.width - 8,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Store Balance:', style: TextStyle(fontSize: 16)),
            Text(
              TextFormatter.toStringCurrency(
                (vm.totalCredit),
                currencyCode: '',
              ),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      );

  Material sliverBalance(BuildContext context, CustomersViewModel vm) =>
      Material(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [creditBalance(context, vm), creditButtons(context)],
          ),
        ),
      );

  ListView creditList(BuildContext context) => ListView.builder(
    shrinkWrap: true,
    itemCount: vm!.creditCustomers.length,
    physics: const BouncingScrollPhysics(),
    itemBuilder: (ctx, index) => Column(
      children: [
        // if (index == 0) CommonDivider(),
        CustomerTile(
          item: vm!.creditCustomers[index],
          onTap: (item) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) =>
                    CreditTransactionsPage(customer: item, vm: vm),
              ),
            );
          },
          selected: vm!.selectedItem == vm!.creditCustomers[index],
          dismissAllowed: widget.canAddNew,
          onRemove: (item) {
            vm!.onRemove(item, context);
          },
        ),
        const CommonDivider(),
      ],
    ),
  );

  Material creditButtons(BuildContext context) => Material(
    child: ButtonBar(
      buttonHeight: 36,
      buttonMinWidth: (MediaQuery.of(context).size.width / 2) - 20,
      alignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          child: const Text(
            'Give',
            style: TextStyle(
              // fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          onPressed: () async {
            var customer = await showPopupDialog(
              context: context,
              content: CustomerSelectPage(
                canAddNew: false,
                onSelected: (con, cust) async {
                  // Navigator.of(context).pop();
                },
              ),
            );

            if (customer != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => CustomerCreditAmountPopupForm(
                    shouldPop: false,
                    creditBalance: customer.creditBalance ?? 0.00,
                    initialValue: 0.0,
                    title: 'Credit Amount',
                    hintText: 'Enter amount here',
                    onSubmit: (context, value) async {
                      var currentCredit = double.parse(
                        (customer?.creditBalance ?? 0).toStringAsFixed(2),
                      );

                      var credIncrease = value + (currentCredit * (-1));
                      var credLimit =
                          storeCreditSettings(vm!.store!.state)?.creditLimit ??
                          0;

                      if (credIncrease > credLimit) {
                        // Navigator.of(context).pop();
                        await showMessageDialog(
                          context,
                          'Customer credit cannot exceed credit limit',
                          LittleFishIcons.info,
                        );
                      } else {
                        vm!.store!.dispatch(
                          giveCustomerStoreCreditAmount(
                            item: customer,
                            value: value,
                            completer: actionCompleter(context, () {
                              Navigator.of(context).pop();
                              showMessageDialog(
                                context,
                                'Success',
                                LittleFishIcons.info,
                              );
                            }),
                          ),
                        );
                      }
                    },
                  ),
                ),
              );
            }
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          child: const Text(
            'Pay',
            style: TextStyle(
              color: Colors.white,
              // fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          onPressed: () async {
            var customer = await showPopupDialog(
              context: context,
              content: CustomerSelectPage(
                canAddNew: false,
                onSelected: (con, cust) async {
                  // Navigator.of(context).pop();
                },
              ),
            );

            if (customer != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => CustomerCreditAmountPopupForm(
                    shouldPop: false,
                    creditBalance: customer.creditBalance ?? 0.00,
                    initialValue: 0.0,
                    title: 'Pay Amount',
                    hintText: 'Enter amount here',
                    onSubmit: (context, value) async {
                      var currentCredit = double.parse(
                        (customer?.creditBalance ?? 0).toStringAsFixed(2),
                      );
                      if (value + currentCredit > 0) {
                        // Navigator.of(context).pop();
                        await showMessageDialog(
                          context,
                          'Customer cannot have a positive credit balance \n Please input the exact amount instead ',
                          LittleFishIcons.info,
                        );
                      } else {
                        vm!.store!.dispatch(
                          payCustomerStoreCreditAmount(
                            item: customer,
                            value: value,
                            completer: actionCompleter(context, () {
                              Navigator.of(context).pop();
                              showMessageDialog(
                                context,
                                'Success',
                                LittleFishIcons.info,
                              );
                            }),
                          ),
                        );
                      }
                    },
                  ),
                ),
              );
            }
          },
        ),
      ],
    ),
  );
}

class CustomerTile extends StatelessWidget {
  final Customer item;
  final bool dismissAllowed;
  final Function(Customer item)? onRemove;

  final Function(Customer item)? onTap;

  final bool selected;

  const CustomerTile({
    Key? key,
    required this.item,
    this.onTap,
    this.selected = false,
    this.dismissAllowed = false,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return customerTile(context);
  }

  ListTile customerTile(context) => ListTile(
    tileColor: Theme.of(context).colorScheme.background,
    // dense: !EnvironmentProvider.instance.isLargeDisplay,
    onTap: onTap != null ? () => onTap!(item) : null,
    selected: selected,
    title: Text(item.displayName!, style: const TextStyle(fontSize: 14)),
    subtitle: item.lastPurchaseDate == null
        ? LongText(item.mobileNumber ?? 'no mobile number')
        : LongText(
            "last visit ${TextFormatter.toShortDate(dateTime: item.lastPurchaseDate, format: "dd MMM yyyy")}",
          ),
    leading: Material(
      color: Theme.of(context).colorScheme.secondary,
      elevation: 1,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          image: isNotBlank(item.profileImageUri)
              ? DecorationImage(
                  image: getIt<FlutterNetworkImage>().asImageProviderById(
                    id: item.profileImageUri!,
                    category: 'customers',
                    legacyUrl: item.profileImageUri!,
                    height: AppVariables.listImageHeight,
                    width: AppVariables.listImageWidth,
                  ),
                )
              : null,
        ),
        height: 44,
        width: 56,
        child: isNotBlank(item.profileImageUri)
            ? Container()
            : ListLeadingIconTile(icon: MdiIcons.account),
      ),
    ),
    trailing: storeCreditSettings(AppVariables.store!.state)?.enabled == true
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text('Balance', style: TextStyle(fontSize: 14)),
              Text(
                TextFormatter.toStringCurrency(
                  item.creditBalance,
                  displayCurrency: false,
                  currencyCode: '',
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        : CircleAvatar(
            child: DecoratedText(
              item.displayName!.substring(0, 1).toUpperCase(),
              textColor: Colors.white,
              alignment: Alignment.center,
            ),
          ),
    // trailing: TextTag(
    //   displayText: item.totalSaleCount == null
    //       ? "0"
    //       : item.totalSaleCount.toString(),
    //   color: Theme.of(context).colorScheme.secondary,
    //   fontSize: 16,
    // ),
  );
}
