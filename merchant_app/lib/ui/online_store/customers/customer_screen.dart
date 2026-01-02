import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:littlefish_merchant/ui/online_store/common/config.dart';
import 'package:littlefish_merchant/ui/online_store/customers/manage_customer_vm.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';

import '../../../common/presentaion/components/icons/delete_icon.dart';
import '../../../features/ecommerce_shared/models/store/store_customer.dart';
import '../../../models/settings/locale/country_stub.dart';
import '../../../tools/textformatter.dart';
import '../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../common/presentaion/components/form_fields/email_form_field.dart';
import '../../../common/presentaion/components/form_fields/mobile_number_form_field.dart';
import '../../../common/presentaion/components/form_fields/string_form_field.dart';
import '../../../common/presentaion/components/text_tag.dart';

class CustomerScreen extends StatefulWidget {
  final StoreCustomer? customer;

  const CustomerScreen({Key? key, this.customer}) : super(key: key);

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  late StoreCustomer _customer;

  final List<FocusNode> _nodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  @override
  void initState() {
    _customer = widget.customer ?? StoreCustomer.defaults();
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageCustomerVM>(
      converter: (store) => ManageCustomerVM.fromStore(store),
      builder: (context, ManageCustomerVM vm) {
        return AppSimpleAppScaffold(
          title: widget.customer == null
              ? 'New Customer'
              : '${widget.customer!.firstName} ${widget.customer!.lastName}',
          actions: <Widget>[
            if (widget.customer != null && vm.isLoading == false)
              IconButton(
                icon: const DeleteIcon(),
                onPressed: () async {
                  vm.store!.dispatch(SetStoreLoadingAction(true));
                  await vm
                      .deleteCustomer(_customer)
                      .then((_) {
                        vm.store!.dispatch(SetStoreLoadingAction(false));
                        showMessageDialog(
                          context,
                          'Customer Deleted Successfully',
                          Icons.thumb_up,
                        ).then((_) => Navigator.of(context).pop(true));
                      })
                      .catchError((error) {
                        vm.store!.dispatch(SetStoreLoadingAction(false));
                        reportCheckedError(error);

                        showMessageDialog(
                          context,
                          'Something Went Wrong',
                          Icons.thumbs_up_down,
                        );
                      });
                },
              ),
          ],
          footerActions: <Widget>[
            Builder(
              builder: (context) => ButtonBar(
                buttonHeight: 48,
                buttonMinWidth: MediaQuery.of(context).size.width,
                children: <Widget>[
                  if (vm.isLoading == false)
                    ElevatedButton(
                      // TODO(lampian): fix colors
                      // color: Theme.of(context).colorScheme.primary,
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          vm.store!.dispatch(SetStoreLoadingAction(true));
                          await vm
                              .saveCustomer(_customer)
                              .then((_) {
                                vm.store!.dispatch(
                                  SetStoreLoadingAction(false),
                                );
                                showSuccess(
                                  context,
                                  'Changes Saved',
                                  Icons.thumb_up,
                                ).then((_) => Navigator.of(context).pop(true));
                              })
                              .catchError((error) {
                                vm.store!.dispatch(
                                  SetStoreLoadingAction(false),
                                );
                                reportCheckedError(error);

                                showMessageDialog(
                                  context,
                                  'Something Went Wrong',
                                  Icons.thumbs_up_down,
                                );
                              });
                        }
                      },
                    ),
                ],
              ),
            ),
          ],
          body: DefaultTabController(
            length: widget.customer == null ? 1 : 2,
            initialIndex: 0,
            child: Column(
              children: <Widget>[
                if (vm.isLoading!) const LinearProgressIndicator(),
                Material(
                  child: SizedBox(
                    height: 128,
                    child: Container(
                      constraints: const BoxConstraints.expand(),
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 64,
                            width: 64,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                kBorderRadius!,
                              ),
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            child: const Icon(Icons.person, size: 48),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(_customer.firstName ?? 'First Name'),
                              Text(_customer.lastName ?? 'Last Name'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                TabBar(
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  tabs: <Widget>[
                    const Tab(text: 'Details'),
                    if (widget.customer != null) const Tab(text: 'Sales'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      _detailsTab(context, _customer),
                      if (widget.customer !=
                          null) //existing customer could have purchases
                        _salesTab(context, _customer),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Container _salesTab(context, StoreCustomer customer) => Container(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: ListView(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Total Purchases'),
              const SizedBox(height: 4),
              TextTag(
                displayText: TextFormatter.toStringCurrency(
                  customer.totalPurchases ?? 0,
                  currencyCode: '',
                ),
                // style: TextStyle(
                // fontWeight: FontWeight.bold,
                // fontSize: 20,
                // ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Average Purchases'),
              const SizedBox(height: 4),
              TextTag(
                displayText: TextFormatter.toStringCurrency(
                  customer.averagePurchaseValue ?? 0,
                  currencyCode: '',
                ),
                // style: TextStyle(
                // fontWeight: FontWeight.bold,
                // fontSize: 20,
                // ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Total Visits'),
              const SizedBox(height: 4),
              TextTag(
                displayText: customer.totalPurchaseCount == null
                    ? '0'
                    : customer.totalPurchaseCount!.toInt().toString(),
                // style: TextStyle(
                // fontWeight: FontWeight.bold,
                // fontSize: 20,
                // ),
              ),
            ],
          ),
        ),
        ListTile(
          tileColor: Theme.of(context).colorScheme.background,
          title: const Text('Last Visit'),
          trailing: TextTag(
            displayText: customer.lastPurchaseDate == null
                ? 'Never'
                : TextFormatter.toShortDate(
                    dateTime: customer.lastPurchaseDate,
                    format: 'dd MMM yyyy',
                  ),
            // style: TextStyle(
            // fontWeight: FontWeight.bold,
            // fontSize: 20,
            // ),
          ),
        ),
      ],
    ),
  );

  Form _detailsTab(context, StoreCustomer customer) => Form(
    key: _formKey,
    child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const BouncingScrollPhysics(),
      children: <Widget>[
        StringFormField(
          enforceMaxLength: false,
          maxLength: 255,
          hintText: 'John',
          key: const Key('firstName'),
          labelText: 'First Name',
          initialValue: customer.firstName,
          inputAction: TextInputAction.next,
          focusNode: _nodes[0],
          nextFocusNode: _nodes[1],
          onSaveValue: (String? value) {
            customer.firstName = value;
          },
          onFieldSubmitted: (value) {
            customer.firstName = value;
          },
        ),
        StringFormField(
          enforceMaxLength: false,
          maxLength: 255,
          hintText: 'John',
          key: const Key('lastName'),
          labelText: 'Last Name',
          initialValue: customer.lastName,
          inputAction: TextInputAction.next,
          focusNode: _nodes[1],
          nextFocusNode: _nodes[2],
          onSaveValue: (String? value) {
            customer.lastName = value;
          },
          onFieldSubmitted: (value) {
            customer.lastName = value;
          },
        ),
        EmailFormField(
          textColor: Theme.of(context).colorScheme.onBackground,
          iconColor: Theme.of(context).colorScheme.onBackground,
          hintColor: Theme.of(context).colorScheme.onBackground,
          enforceMaxLength: false,
          maxLength: 255,
          hintText: 'email',
          key: const Key('email'),
          initialValue: customer.email,
          labelText: 'Email',
          inputAction: TextInputAction.next,
          focusNode: _nodes[2],
          nextFocusNode: _nodes[3],
          onSaveValue: (String? value) {
            customer.email = value;
          },
          onFieldSubmitted: (value) {
            customer.email = value;
          },
        ),
        MobileNumberFormField(
          hintText: 'mobile',
          key: const Key('mobile'),
          country: CountryStub(
            countryCode: kCountryCode,
            diallingCode: kCountryDiallingCode,
          ),
          labelText: 'Mobile Number',
          initialValue: customer.mobileNumber,
          inputAction: TextInputAction.done,
          focusNode: _nodes[3],
          onSaveValue: (value) {
            customer.mobileNumber = value;
          },
          onFieldSubmitted: (value) {
            customer.mobileNumber = value;
          },
        ),
      ],
    ),
  );
}
