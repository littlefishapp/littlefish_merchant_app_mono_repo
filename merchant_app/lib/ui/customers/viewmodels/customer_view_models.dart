// Flutter imports:
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/models/reports/customer_overview.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/customer/customer_actions.dart';
import 'package:littlefish_merchant/redux/customer/customer_state.dart';
import 'package:littlefish_merchant/services/analysis_service.dart';
import 'package:littlefish_merchant/services/checkout_service.dart';
import 'package:littlefish_merchant/ui/customers/pages/customer_import_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';
import '../../../features/ecommerce_shared/models/store/store.dart' as e_store;
import 'package:littlefish_icons/littlefish_icons.dart';

class CustomersViewModel
    extends StoreCollectionViewModel<Customer, CustomerState> {
  CustomersViewModel.fromStore(Store<AppState> store) : super.fromStore(store);

  List<Customer> get creditCustomers => state!.customers!
      .where((element) => element.creditBalance != null)
      .toList();

  double get totalCredit =>
      creditCustomers.fold(
        0,
        ((previousValue, element) =>
            previousValue! + (element.creditBalance ?? 0)),
      ) ??
      0;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.customerstate;

    onRefresh = () => store.dispatch(initializeCustomers(refresh: true));
    onRemove = (item, ctx) => store.dispatch(removeCustomer(item: item));
    onAdd = (item, ctx) => store.dispatch(addOrUpdateCustomer(item: item));

    onSetSelected = (item) => store.dispatch(setUICustomer(item));

    selectedItem = store.state.customerUIState!.item?.item;
    isNew = store.state.customerUIState!.item?.isNew;

    items = store.state.customerstate.customers;
    isLoading = state!.isLoading ?? false;
    hasError = state!.hasError ?? false;
  }
}

class ContactsViewModel
    extends StoreCollectionViewModel<Contact, CustomerState> {
  ContactsViewModel.fromStore(
    Store<AppState> store, {
    List<SelectableItem<Contact>>? selectableItems,
  }) : super.fromStore(store) {
    if (selectableItems != null) {
      //set the private variable to not invoke the getter
      _selectableItems = selectableItems;
    }
  }

  late Function saveContactList;

  List<SelectableItem<Contact>>? _selectableItems;
  List<SelectableItem<Contact>>? get selectableItems {
    if (_selectableItems == null && items != null) {
      _selectableItems = List.from(
        items!
            .map((c) => SelectableItem<Contact>(item: c, initialValue: false))
            .toList(),
      );
    }

    return _selectableItems;
  }

  set selectableItems(value) {
    _selectableItems = value;
  }

  List<SelectableItem<Contact>> get selectedItems {
    return selectableItems?.where((c) => c.selected!).toList() ??
        <SelectableItem<Contact>>[];
  }

  List<Contact> getSelectedItems() {
    return selectableItems
            ?.where((c) => c.selected!)
            .map((cs) => cs.item)
            .toList() ??
        <Contact>[];
  }

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    saveContactList = () =>
        store.dispatch(addContactList(contacts: getSelectedItems()));
    state = store.state.customerstate;
    onRefresh = () => store.dispatch(getContacts(refresh: true));
    onAdd = (item, ctx) =>
        store.dispatch(addCustomerFromContact(contact: item));
    items = store.state.customerstate.contacts;
    isLoading = state!.isLoading ?? false;
    hasError = state!.hasError ?? false;
  }
}

class CustomerViewModel extends StoreItemViewModel<Customer?, CustomerState> {
  CustomerViewModel.fromStore(Store<AppState> store, {this.form})
    : super.fromStore(store) {
    if (item != null) item = item;
  }

  FormManager? form;
  CustomerOverview? reportData;
  ReportService? reportService;
  e_store.StoreAddress? primaryAddress = e_store.StoreAddress();

  late Function? rebuild;

  Function? saveAddress;

  Future<List<CheckoutTransaction>> getTransactions(String? customerId) async {
    var service = CheckoutService.fromStore(store!);

    return await service.getTransactionsByCustomerId(customerId);
  }

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    reportService = ReportService.fromStore(store);
    state = store.state.customerstate;
    this.store = store;

    onRemove = (item, ctx) => store.dispatch(
      removeCustomer(
        item: item,
        completer: snackBarCompleter(ctx, '${item!.firstName} was removed'),
      ),
    );

    onAdd = (customer, ctx) {
      if (key != null) {
        if (key!.currentState!.validate()) {
          key!.currentState!.save();

          Customer? trimmedCust = customer;
          trimmedCust?.firstName = customer?.firstName?.trim();
          trimmedCust?.lastName = customer?.lastName?.trim();
          trimmedCust?.email = customer?.email?.trim();
          trimmedCust?.mobileNumber = customer?.mobileNumber?.trim();
          store.dispatch(
            addOrUpdateCustomer(
              item: trimmedCust,
              clearCustomerInUiState: false,
              completer: actionCompleter(ctx!, () async {
                // Navigator.of(ctx!).popUntil(
                //     (route) => (route.settings.name == CustomersPage.route));
                // Navigator.of(ctx!)
                //     .popAndPushNamed<HomePage, CustomerDetailsForm>('/home');
                Navigator.of(ctx).pop();

                await showMessageDialog(
                  ctx,
                  '${customer!.firstName} saved successfully!',
                  LittleFishIcons.info,
                );

                //if (rebuild != null) rebuild!(item);

                return customer;
              }),
            ),
          );
        }
      } else {
        // store.dispatch(
        //   addOrUpdateCustomer(
        //     item: item,
        //     completer: snackBarCompleter(
        //       ctx,
        //       "${item.firstName} saved successfully!",
        //       shouldPop: !store.state.isLargeDisplay,
        //     ),
        //   ),
        // );
      }
    };

    saveAddress =
        (e_store.StoreAddress addr, formKey, context, String addressId) {
          if (addressId == 'cust') {
            item!.address = addr;
          } else {
            item!.companyAddress = addr;
          }
        };

    isLoading = state!.isLoading ?? false;
    hasError = state!.hasError ?? false;

    item = store.state.customerUIState!.item?.item;
    isNew = store.state.customerUIState!.item?.isNew;
  }
}
