// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_button.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_discard.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/models/settings/locale/country_stub.dart';
import 'package:quiver/strings.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/models/shared/data/address.dart';
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/business/business_selectors.dart';
import 'package:littlefish_merchant/redux/customer/customer_actions.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/customers/forms/customer_details_form.dart';
import 'package:littlefish_merchant/ui/customers/pages/credit_transactions_page.dart';
import 'package:littlefish_merchant/ui/customers/viewmodels/customer_view_models.dart';
import 'package:littlefish_merchant/ui/sales/pages/transaction_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/expandable_store_address.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';

import '../../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../../../features/ecommerce_shared/models/store/store.dart' as e_store;
import '../../../injector.dart';
import '../../../providers/locale_provider.dart';
import '../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../common/presentaion/components/form_fields/email_form_field.dart';
import '../../../common/presentaion/components/form_fields/mobile_number_form_field.dart';
import '../../../common/presentaion/components/form_fields/string_form_field.dart';
import '../../../common/presentaion/components/common_divider.dart';
import '../../../common/presentaion/components/decorated_text.dart';
import '../../../common/presentaion/components/long_text.dart';
import '../../../common/presentaion/components/app_progress_indicator.dart';
import '../../../tools/network_image/flutter_network_image.dart';

class CustomerPage extends StatefulWidget {
  static const String route = '/customer';

  final Customer? customer;

  final bool isEmbedded;
  final BuildContext? parentContext;

  const CustomerPage({
    Key? key,
    this.parentContext,
    this.customer,
    this.isEmbedded = false,
  }) : super(key: key);

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  PageController? pageController;
  int? _selectedIndex;

  double? totalSaleValue;
  double? avgSalesValue;
  int? totalSales;
  int? totalTransactions;
  @override
  void initState() {
    _selectedIndex = 0;
    pageController = PageController(viewportFraction: 0.5, initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CustomerViewModel>(
      converter: (Store store) {
        return CustomerViewModel.fromStore(store as Store<AppState>)
          ..key = key
          ..form = FormManager(key);
      },
      builder: (BuildContext ctx, CustomerViewModel vm) {
        if (ModalRoute.of(context)!.settings.arguments != null) {
          vm.item ??= (ModalRoute.of(context)!.settings.arguments as List)[0];
          vm.rebuild = (Customer item) {
            vm.item = item;
            setState(() {});
          };
        }

        // if (widget.customer != null) vm.item = widget.customer;
        return scaffold(context, vm);
      },
    );
  }

  Widget scaffold(context, CustomerViewModel vm) {
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;

    return AppScaffold(
      enableProfileAction: false,
      displayBackNavigation: isTablet ? false : true,
      actions: [
        ButtonDiscard(
          isIconButton: true,
          enablePopPage: true,
          backgroundColor: Colors.transparent,
          borderColor: Colors.transparent,
          modalTitle: 'Delete Customer',
          modalDescription:
              'Are you sure you would like to delete this customer? This cannot be undone.',
          modalAcceptText: 'Yes. Delete Customer',
          modalCancelText: 'No, Cancel',
          onDiscard: (ctx) async {
            vm.onRemove(vm.item, context);
            Navigator.of(context).pop();
          },
        ),
      ],
      persistentFooterButtons: _selectedIndex == 0
          ? [
              if (!isTablet)
                ButtonPrimary(
                  onTap: (onTapContext) {
                    AppVariables.store!.dispatch(
                      editCustomer(
                        vm.item,
                        context: onTapContext,
                        clearCustomerOnPagePop: false,
                      ),
                    );
                  },
                  text: 'Edit Details',
                )
              else
                ButtonSecondary(
                  onTap: (onTapContext) {
                    AppVariables.store!.dispatch(
                      editCustomer(
                        vm.item,
                        context: onTapContext,
                        clearCustomerOnPagePop: false,
                      ),
                    );
                  },
                  text: 'Edit Details',
                ),
            ]
          : null,
      title: vm.item!.displayName ?? '',
      body: vm.isLoading! ? const AppProgressIndicator() : layout(context, vm),
    );
  }

  Column layout(context, CustomerViewModel vm) => Column(
    children: <Widget>[
      customerHeader(context, vm.item!, vm),
      Expanded(child: body(context, vm)),
    ],
  );

  DefaultTabController body(BuildContext context, CustomerViewModel vm) =>
      DefaultTabController(
        length: storeCreditSettings(vm.store!.state)?.enabled == true
            ? vm.store!.state.enableStoreCredit!
                  ? 3
                  : 2
            : 2,
        initialIndex: 0,
        child: Column(
          children: <Widget>[
            TabBar(
              tabAlignment: TabAlignment.fill,
              indicatorSize: TabBarIndicatorSize.tab,
              onTap: (val) {
                _selectedIndex = val;
                if (mounted) setState(() {});
              },
              tabs: <Widget>[
                const Tab(text: 'INFO'),
                const Tab(text: 'SALES'),
                if (storeCreditSettings(vm.store!.state)?.enabled == true &&
                    vm.store!.state.enableStoreCredit!)
                  const Tab(text: 'CREDIT'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  basicInfo(context, vm.item!),
                  salesFuture(context, vm),
                  if (storeCreditSettings(vm.store!.state)?.enabled == true &&
                      vm.store!.state.enableStoreCredit!)
                    CreditTransactionsPage(
                      customer: vm.item,
                      showAppBar: false,
                      bottonsAsFooter: true,
                    ),
                ],
              ),
            ),
          ],
        ),
      );

  Container form(BuildContext context, CustomerViewModel vm) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: CustomerDetailsForm(vm: vm),
    ),
  );

  Material customerHeader(
    context,
    Customer customer,
    CustomerViewModel vm,
  ) => Material(
    child: InkWell(
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        backgroundImage: isNotBlank(customer.profileImageUri)
                            ? getIt<FlutterNetworkImage>().asImageProviderById(
                                id: customer.id!,
                                category: 'customers',
                                legacyUrl: customer.profileImageUri!,
                                height: AppVariables.listImageHeight,
                                width: AppVariables.listImageWidth,
                              )
                            : null,
                        child: isNotBlank(customer.profileImageUri)
                            ? null
                            : Icon(
                                Icons.person,
                                size: 48,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(customer.displayName ?? ''),
                  ],
                ),
              ),
            ),
            const VerticalDivider(width: 0.5, indent: 24, endIndent: 24),
            const SizedBox(width: 12),
            Expanded(
              child: _selectedIndex == 0
                  ? infoHeader(customer)
                  : _selectedIndex == 1
                  ? salesSummary(context, vm)
                  : creditHeader(customer),
            ),
          ],
        ),
      ),
    ),
  );

  Column salesHeader(
    double? totalSaleValue,
    double? avgSaleValue,
    int? totalVisits,
  ) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text('Total Purchases', style: TextStyle(fontSize: 14)),
      DecoratedText(
        TextFormatter.toStringCurrency(
          totalSaleValue ?? 0,
          displayCurrency: false,
          currencyCode: '',
        ),
        fontSize: 12,
        alignment: Alignment.centerLeft,
        fontWeight: FontWeight.bold,
        textColor: Theme.of(context).colorScheme.primary,
      ),
      const SizedBox(height: 4),
      const Text('Average Purchase', style: TextStyle(fontSize: 14)),
      DecoratedText(
        TextFormatter.toStringCurrency(
          avgSaleValue ?? 0,
          displayCurrency: false,
          currencyCode: '',
        ),
        fontSize: 12,
        alignment: Alignment.centerLeft,
        fontWeight: FontWeight.bold,
        textColor: Theme.of(context).colorScheme.primary,
      ),
      const SizedBox(height: 4),
      const Text('Total Visits', style: TextStyle(fontSize: 14)),
      DecoratedText(
        (totalVisits ?? 0).toString(),
        fontSize: 12,
        alignment: Alignment.centerLeft,
        fontWeight: FontWeight.bold,
        textColor: Theme.of(context).colorScheme.primary,
      ),
    ],
  );

  Column creditHeader(Customer customer) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text('Total Credit', style: TextStyle(fontSize: 14)),
      DecoratedText(
        TextFormatter.toStringCurrency(
          customer.creditBalance ?? 0,
          displayCurrency: false,
          currencyCode: '',
        ),
        fontSize: 12,
        alignment: Alignment.centerLeft,
        fontWeight: FontWeight.bold,
        textColor: Theme.of(context).colorScheme.primary,
      ),
      const SizedBox(height: 4),
      const Text('Credit Transactions', style: TextStyle(fontSize: 14)),
      DecoratedText(
        customer.customerLedgerEntries?.length.toString() ?? '',
        fontSize: 12,
        alignment: Alignment.centerLeft,
        fontWeight: FontWeight.bold,
        textColor: Theme.of(context).colorScheme.primary,
      ),
    ],
  );

  Column infoHeader(Customer customer) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text('Date Registered', style: TextStyle(fontSize: 14)),
      DecoratedText(
        TextFormatter.toShortDate(dateTime: customer.dateCreated),
        fontSize: 12,
        alignment: Alignment.centerLeft,
        fontWeight: FontWeight.bold,
        textColor: Theme.of(context).colorScheme.primary,
      ),
      const SizedBox(height: 4),
      const Text('Status', style: TextStyle(fontSize: 14)),
      DecoratedText(
        customer.userVerified ? 'Verified' : 'Not',
        fontSize: 12,
        alignment: Alignment.centerLeft,
        fontWeight: FontWeight.bold,
        textColor: Theme.of(context).colorScheme.primary,
      ),
      const SizedBox(height: 4),
      const Text('Total Visits', style: TextStyle(fontSize: 14)),
      DecoratedText(
        (customer.totalSaleCount ?? 0).toString(),
        fontSize: 12,
        alignment: Alignment.centerLeft,
        fontWeight: FontWeight.bold,
        textColor: Theme.of(context).colorScheme.primary,
      ),
    ],
  );

  Container basicInfo(BuildContext context, Customer item) {
    var formFields = <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: MobileNumberFormField(
          enabled: false,
          hintText: 'Mobile Number',
          useOutlineStyling: true,
          country: CountryStub(
            countryCode: LocaleProvider.instance.currentLocale!.countryCode,
            diallingCode: LocaleProvider.instance.currentLocale!.diallingCode,
          ),
          key: const Key('mobilenumber'),
          labelText: 'Mobile Number',
          initialValue: item.mobileNumber,
          onFieldSubmitted: (value) {},
          inputAction: TextInputAction.next,
          isRequired: true,
          onSaveValue: (value) {},
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: EmailFormField(
          textColor: Theme.of(context).colorScheme.onBackground,
          iconColor: Theme.of(context).colorScheme.onBackground,
          hintColor: Theme.of(context).colorScheme.onBackground,
          enabled: false,
          enforceMaxLength: true,
          maxLength: 50,
          hintText: 'Email address',
          key: const Key('email'),
          labelText: 'Email Address',
          onFieldSubmitted: (value) {},
          inputAction: TextInputAction.next,
          initialValue: item.email,
          isRequired: false,
          onSaveValue: (value) {
            // vm.item.email = value;
          },
        ),
      ),

      Column(
        children: [
          Row(
            children: [
              Text(
                'Customer Address',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                textAlign: TextAlign.start,
              ),
            ],
          ),
          ExpandableStoreAddress(
            fieldsEnabled: false,
            details: item.address ?? e_store.StoreAddress(),
          ),
        ],
      ),

      //CommonDivider(),
      // Column(
      //   children: [
      //     Row(children: [
      //       Text(
      //         "Company Details",
      //         textAlign: TextAlign.start,
      //       ),
      //     ]),
      //     expandableDetailsPanel(
      //         context, item, "Company Details", Icons.business)
      //   ],
      // ),
      // expandableDetailsPanel(context, item, "Company Details", Icons.business),
      // Container(
      //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      //   child: CapsuleOutlineButton(
      //     onTap: (c) => showPopupDialog(
      //         content: companyDetailsModal(item, false),
      //         context: context,
      //         height: 600),
      //     text: "Company Details",
      //     textColor: Theme.of(context).colorScheme.primary,
      //   ),
      // ),
      const SizedBox(height: 16),
      const CommonDivider(),
      companyDetailsExpanded(item, false),
      const SizedBox(height: 16),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Align(
        alignment: Alignment.topLeft,
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: formFields,
        ),
      ),
    );
  }

  FutureBuilder<List<CheckoutTransaction>> salesFuture(
    context,
    CustomerViewModel vm,
  ) => FutureBuilder(
    future: vm.getTransactions(vm.item!.id),
    builder: (ctx, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const AppProgressIndicator();
      }

      if (snapshot.data == null || (snapshot.data as List).isEmpty) {
        return const Center(child: Text('No Results'));
      }

      return sales(context, snapshot.data as List<CheckoutTransaction>);
    },
  );

  /// Todo(Brandon): Below is hotfix for transaction sales header summary, customers does need to be relooked at
  FutureBuilder<List<CheckoutTransaction>> salesSummary(
    context,
    CustomerViewModel vm,
  ) => FutureBuilder(
    future: vm.getTransactions(vm.item!.id),
    builder: (ctx, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const AppProgressIndicator();
      }
      totalSaleValue = 0;
      avgSalesValue = 0;
      totalTransactions = 0;
      totalSales = 0;

      if (snapshot.data != null || (snapshot.data as List).isNotEmpty) {
        List<CheckoutTransaction> transactions =
            snapshot.data as List<CheckoutTransaction>;
        totalSaleValue = transactions.fold(
          0,
          (previousValue, element) =>
              (previousValue ?? 0) + element.checkoutTotal,
        );
        totalSales = transactions.length;
        avgSalesValue = (totalSaleValue ?? 0) / totalSales!;
        for (CheckoutTransaction transaction in transactions) {
          totalTransactions = (totalTransactions ?? 0) + 1;
          totalTransactions =
              (totalTransactions ?? 0) + (transaction.refunds ?? []).length;
        }
      }

      return salesHeader(totalSaleValue, avgSalesValue, totalTransactions);
    },
  );

  Column sales(context, List<CheckoutTransaction> items) => Column(
    children: <Widget>[
      Expanded(
        child: GroupedListView(
          sort: true,
          separator: const CommonDivider(height: 0.5),
          physics: const BouncingScrollPhysics(),
          elements: items,
          groupBy: (dynamic item) {
            var tx = (item as CheckoutTransaction);
            return DateTime(
              tx.transactionDate!.year,
              tx.transactionDate!.month,
              tx.transactionDate!.day,
            );
          },
          groupSeparatorBuilder: (dynamic date) {
            var sales = items.where(
              (sale) =>
                  sale.transactionDate != null &&
                  sale.transactionDate!.day == date.day &&
                  sale.transactionDate!.month == date.month,
            );

            var totalSales = sales
                .map((a) => a.totalValue)
                .reduce((a, b) => a! + b!);

            var saleCount = sales.length;

            return ListTile(
              tileColor: Theme.of(context).colorScheme.background,
              leading: LongText(
                TextFormatter.toShortDate(dateTime: date, format: 'dd MMM'),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              title: LongText(
                '${TextFormatter.toStringCurrency(totalSales, displayCurrency: false, currencyCode: '')} '
                'sold over ${(saleCount).floor()} sales',
                fontSize: 16,
                textColor: Colors.grey.shade700,
              ),
            );
          },
          itemBuilder: (ctx, CheckoutTransaction item) => ListTile(
            tileColor: Theme.of(context).colorScheme.background,
            dense: !EnvironmentProvider.instance.isLargeDisplay!,
            onTap: () {
              if (EnvironmentProvider.instance.isLargeDisplay!) {
                showPopupDialog(
                  context: ctx,
                  content: TransactionPage(transaction: item),
                );
              } else {
                showDialog(
                  context: ctx,
                  barrierDismissible: true,
                  builder: (cx) => TransactionPage(transaction: item),
                );
              }
            },
            leading: const ListLeadingIconTile(icon: Icons.payment),
            title: LongText(
              TextFormatter.toStringCurrency(item.totalValue, currencyCode: ''),
              fontSize: null,
              fontWeight: FontWeight.bold,
              textColor: Colors.grey.shade700,
            ),
            subtitle: LongText(
              "${item.itemCount} ${item.itemCount == 1 ? "item" : "items"}",
            ),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                LongText(
                  TextFormatter.toShortDate(
                    dateTime: item.dateCreated,
                    format: 'hh:mm',
                  ),
                  fontWeight: FontWeight.bold,
                ),
                Visibility(
                  visible:
                      (item.pendingSync ?? false) == false &&
                      (item.isCancelled) == false,
                  child: LongText('#${(item.transactionNumber ?? 0).floor()}'),
                ),
                Visibility(
                  visible: (item.pendingSync ?? false) == true,
                  child: const LongText(
                    'pending',
                    fontSize: 10,
                    textColor: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Visibility(
                  visible: (item.isCancelled) == true,
                  child: const LongText(
                    'cancelled',
                    fontSize: 10,
                    textColor: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );

  Address toBasicAddress(e_store.StoreAddress addr) {
    return Address(
      address1: addr.addressLine1,
      address2: addr.addressLine2,
      city: addr.city,
      country: addr.country,
      postalCode: addr.postalCode,
      state: addr.state,
    );
  }

  ExpansionTile companyDetailsExpanded(Customer item, bool enabled) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: const Text('Company Details'),
      subtitle: const LongText("Customer's Company Details"),
      children: <Widget>[
        StringFormField(
          enabled: enabled,
          maxLength: 40,
          useOutlineStyling: true,
          // suffixIcon: Icons.person,
          hintText: 'Company Name',
          key: const Key('compName'),
          labelText: 'Company Name',

          inputAction: TextInputAction.next,
          initialValue: item.companyName,
          isRequired: false,
          onSaveValue: (value) {
            item.companyName = value;
          },
        ),
        StringFormField(
          enabled: enabled,
          maxLength: 40,
          // suffixIcon: Icons.person,
          useOutlineStyling: true,
          hintText: 'Company VAT/Registration No.',
          key: const Key('compRegNo'),
          labelText: 'Company VAT/Registration No.',
          onFieldSubmitted: (value) {},
          inputAction: TextInputAction.next,
          initialValue: item.companyRegVatNumber,
          isRequired: false,
          onSaveValue: (value) {
            item.companyRegVatNumber = value;
          },
        ),
        MobileNumberFormField(
          enabled: enabled,
          useOutlineStyling: true,
          hintText: 'Company Contact Number',
          country: CountryStub(
            countryCode: LocaleProvider.instance.currentLocale!.countryCode,
            diallingCode: LocaleProvider.instance.currentLocale!.diallingCode,
          ),
          key: const Key('compContactNum'),
          labelText: 'Company Contact Number',
          initialValue: item.companyContactNumber,
          inputAction: TextInputAction.next,
          isRequired: false,
          onSaveValue: (value) {
            if (isNotBlank(value)) item.companyContactNumber = value;
          },
        ),
        Column(
          children: [
            Row(
              children: [
                Text(
                  'Company Address',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            ExpandableStoreAddress(
              details: item.companyAddress ?? e_store.StoreAddress(),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  AppSimpleAppScaffold companyDetailsModal(Customer item, bool enabled) {
    var itemPadding = const EdgeInsets.symmetric(vertical: 10, horizontal: 20);

    var modalDetails = ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            top: 30,
            left: 20,
            right: 20,
            bottom: 10,
          ),
          child: StringFormField(
            enabled: enabled,
            maxLength: 40,
            // suffixIcon: Icons.person,
            hintText: 'Company Name',
            key: const Key('compName'),
            labelText: 'Company Name',

            inputAction: TextInputAction.next,
            initialValue: item.companyName,
            isRequired: false,
            onSaveValue: (value) {
              item.companyName = value;
            },
          ),
        ),
        Padding(
          padding: itemPadding,
          child: StringFormField(
            enabled: enabled,
            maxLength: 40,
            // suffixIcon: Icons.person,
            hintText: 'Company VAT/Registration No.',
            key: const Key('compRegNo'),
            labelText: 'Company VAT/Registration No.',
            onFieldSubmitted: (value) {},
            inputAction: TextInputAction.next,
            initialValue: item.companyRegVatNumber,
            isRequired: false,
            onSaveValue: (value) {
              item.companyRegVatNumber = value;
            },
          ),
        ),
        Padding(
          padding: itemPadding,
          child: MobileNumberFormField(
            enabled: enabled,
            hintText: 'Company Contact Number',
            country: CountryStub(
              countryCode: LocaleProvider.instance.currentLocale!.countryCode,
              diallingCode: LocaleProvider.instance.currentLocale!.diallingCode,
            ),
            key: const Key('compContactNum'),
            labelText: 'Company Contact Number',
            initialValue: item.companyContactNumber,
            inputAction: TextInputAction.next,
            isRequired: false,
            onSaveValue: (value) {
              if (isNotBlank(value)) item.companyContactNumber = value;
            },
          ),
        ),
        Padding(
          padding: itemPadding,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Company Address',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              ExpandableStoreAddress(
                details: item.companyAddress ?? e_store.StoreAddress(),
              ),
            ],
          ),
        ),
      ],
    );

    return AppSimpleAppScaffold(title: 'Company Details', body: modalDetails);
  }
}
