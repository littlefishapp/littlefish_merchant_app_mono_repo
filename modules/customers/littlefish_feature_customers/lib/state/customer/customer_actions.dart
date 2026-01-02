// removed ignore: depend_on_referenced_packages
import 'dart:async';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/customer_service.dart';
import 'package:littlefish_merchant/ui/customers/pages/customer_edit_page.dart';
import 'package:littlefish_merchant/ui/customers/pages/customer_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';

late CustomerService customerService;

ThunkAction<AppState> initializeCustomers({
  bool refresh = false,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);
      var customerState = store.state.customerstate;

      if (!refresh && (customerState.customers?.length ?? 0) > 0) {
        return;
      }

      store.dispatch(ClearCustomerStateFailure());

      store.dispatch(SetCustomerLoadingAction(true));

      await customerService
          .getCustomers()
          .catchError((e) {
            store.dispatch(CustomerLoadFailure(e.toString()));
            store.dispatch(SetCustomerLoadingAction(false));
            completer?.completeError(e);
            return <Customer>[];
          })
          .then((result) {
            store.dispatch(CustomersLoadedAction(result));
            store.dispatch(SetCustomerLoadingAction(false));
            completer?.complete();
          });
    });
  };
}

ThunkAction<AppState> getContacts({bool refresh = false}) {
  return (Store<AppState> store) async {
    Future(() async {
      //logger.debug(this,'get contacts called');

      _initializeService(store);
      var customerState = store.state.customerstate;

      store.dispatch(SetCustomerLoadingAction(true));

      if (!refresh && (customerState.contacts?.length ?? 0) > 0) {
        //logger.debug(this,'returning from cache');
        store.dispatch(SetCustomerLoadingAction(false));
        return;
      }

      await customerService
          .getContacts()
          .catchError((e) {
            //logger.debug(this,e.toString());
            store.dispatch(CustomerLoadFailure(e.toString()));
            return <Contact>[];
          })
          .then((result) {
            store.dispatch(ContactsLoadedAction(result));
            store.dispatch(SetCustomerLoadingAction(false));
          });
    });
  };
}

ThunkAction<AppState> addContactList({required List<Contact> contacts}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      if (contacts.isEmpty) return;

      var customers = store.state.customerstate.customers;

      store.dispatch(SetCustomerLoadingAction(true));

      for (final c in contacts) {
        var item = Customer.fromContact(c);

        if (customers != null && customers.any((m) => m.id == item.id)) {
          await customerService
              .updateCustomer(customer: item)
              .catchError((e) {
                store.dispatch(CustomerLoadFailure(e.toString()));
                return Customer();
              })
              .then((result) {
                store.dispatch(CustomerChangedAction(item, ChangeType.updated));
              });
          return;
        }

        await customerService
            .addCustomer(customer: item)
            .catchError((e) {
              store.dispatch(CustomerLoadFailure(e.toString()));
              return Customer();
            })
            .then((result) {
              store.dispatch(CustomerChangedAction(item, ChangeType.added));
            });
      }

      store.dispatch(SetCustomerLoadingAction(false));
    });
  };
}

ThunkAction<AppState> addCustomerFromContact({required Contact contact}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      var customers = store.state.customerstate.customers;

      var item = Customer.fromContact(contact);

      store.dispatch(SetCustomerLoadingAction(true));

      if (customers != null && customers.any((m) => m.id == item.id)) {
        await customerService
            .updateCustomer(customer: item)
            .catchError((e) {
              store.dispatch(CustomerLoadFailure(e.toString()));
              return Customer();
            })
            .then((result) {
              store.dispatch(CustomerChangedAction(item, ChangeType.updated));
              store.dispatch(SetCustomerLoadingAction(false));
            });
        return;
      }

      await customerService
          .addCustomer(customer: item)
          .catchError((e) {
            store.dispatch(CustomerLoadFailure(e.toString()));
            return Customer();
          })
          .then((result) {
            store.dispatch(CustomerChangedAction(item, ChangeType.added));
            store.dispatch(SetCustomerLoadingAction(false));
          });
    });
  };
}

ThunkAction<AppState> addOrUpdateCustomer({
  required Customer? item,
  bool clearCustomerInUiState = true,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        _initializeService(store);

        if (item == null) {
          return Customer();
        }

        if (isBlank(item.mobileNumber)) {
          item.mobileNumber = null;
        }

        var customers = store.state.customerstate.customers;
        if (customers != null && customers.any((m) => m.id == item.id)) {
          store.dispatch(SetCustomerLoadingAction(true));
          Customer updatedCustomer = await customerService.updateCustomer(
            customer: item,
          );
          store.dispatch(
            CustomerChangedAction(
              updatedCustomer,
              ChangeType.updated,
              clearCustomerInUiState: clearCustomerInUiState,
            ),
          );
          store.dispatch(SetCustomerLoadingAction(false));
          completer?.complete();
          return Customer();
        } else {
          store.dispatch(SetCustomerLoadingAction(true));
          var result = await customerService.addCustomer(customer: item);
          store.dispatch(
            CustomerChangedAction(
              result,
              ChangeType.added,
              clearCustomerInUiState: clearCustomerInUiState,
            ),
          );

          store.dispatch(SetCustomerLoadingAction(false));
          completer?.complete();
        }
      } catch (e) {
        store.dispatch(CustomerLoadFailure(e.toString()));
        store.dispatch(SetCustomerLoadingAction(false));
        completer?.completeError(e);
      }
    });
  };
}

ThunkAction<AppState> cancelPayCustomerStoreCreditAmount({
  required Customer? item,
  required CustomerLedgerEntry? entry,
  Completer? completer,
  bool sendToServer = true,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        _initializeService(store);

        if (item == null) return;
        if (sendToServer) {
          store.dispatch(SetCustomerLoadingAction(true));
          await customerService.cancelPayCustomerCredit(
            customer: item,
            entryId: entry!.id,
          );
        }

        if (entry!.entryType!.toLowerCase() == 'debit') {
          item.creditBalance = (item.creditBalance ?? 0) - entry.amount!;
        }
        if (entry.entryType!.toLowerCase() == 'credit') {
          item.creditBalance = (item.creditBalance ?? 0) + entry.amount!;
        }

        item.customerLedgerEntries!
                .firstWhereOrNull((element) => element.id == entry.id)
                ?.status =
            'cancelled';

        store.dispatch(CustomerChangedAction(item, ChangeType.updated));
        store.dispatch(SetCustomerLoadingAction(false));
        completer?.complete();
      } catch (e) {
        store.dispatch(CustomerLoadFailure(e.toString()));
        store.dispatch(SetCustomerLoadingAction(false));
        completer?.completeError(e);
      }
    });
  };
}

ThunkAction<AppState> payCustomerStoreCreditAmount({
  required Customer? item,
  required double value,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        _initializeService(store);

        if (item == null) return;
        var result = await customerService.payCustomerCredit(
          customer: item,
          amount: value,
        );

        item.creditBalance = (item.creditBalance ?? 0) + value;

        if (result != null) {
          store.dispatch(CustomerChangedAction(item, ChangeType.updated));
          store.dispatch(SetCustomerLoadingAction(false));
          completer?.complete();
        }
      } catch (e) {
        store.dispatch(CustomerLoadFailure(e.toString()));
        store.dispatch(SetCustomerLoadingAction(false));
        completer?.completeError(e);
      }
    });
  };
}

ThunkAction<AppState> giveCustomerStoreCreditAmount({
  required Customer? item,
  required double value,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        _initializeService(store);

        if (item == null) return;
        store.dispatch(SetCustomerLoadingAction(true));
        var result = await customerService.giveCustomerCredit(
          customer: item,
          amount: value,
        );

        item.creditBalance = (item.creditBalance ?? 0) - value;

        if (result != null) {
          store.dispatch(CustomerChangedAction(item, ChangeType.updated));
          store.dispatch(SetCustomerLoadingAction(false));
          completer?.complete();
        }
      } catch (e) {
        store.dispatch(CustomerLoadFailure(e.toString()));
        store.dispatch(SetCustomerLoadingAction(false));
        completer?.completeError(e);
      }
    });
  };
}

ThunkAction<AppState> removeCustomer({
  required Customer? item,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      if (item == null) return;

      store.dispatch(SetCustomerLoadingAction(true));

      await customerService
          .removeCustomer(item)
          .catchError((e) {
            store.dispatch(CustomerLoadFailure(e.toString()));
            return false;
          })
          .then((result) {
            store.dispatch(CustomerChangedAction(item, ChangeType.removed));
            store.dispatch(SetCustomerLoadingAction(false));
          });
    });
  };
}

ThunkAction<AppState> setUICustomer(Customer customer, {bool isNew = false}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(SetCustomerLoadingAction(true));
      if (isNew) {
        store.dispatch(CustomerCreateAction());
      } else {
        store.dispatch(CustomerSelectAction(customer));
      }
      store.dispatch(SetCustomerLoadingAction(false));
    });
  };
}

ThunkAction<AppState> createCustomer({required BuildContext context}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(SetCustomerLoadingAction(true));

      store.dispatch(CustomerCreateAction());

      if (store.state.isLargeDisplay ?? false) {
        showPopupDialog(
          content: const CustomerEditPage(isEmbedded: true),
          context: context,
        );
      } else {
        Navigator.pushNamed(
          globalNavigatorKey.currentContext!,
          CustomerEditPage.route,
          arguments: null,
        );
      }

      store.dispatch(SetCustomerLoadingAction(false));
    });
  };
}

ThunkAction<AppState> editCustomer(
  Customer? customer, {
  required BuildContext context,
  bool clearCustomerOnPagePop = true,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(CustomerSelectAction(customer));

      if (!(store.state.isLargeDisplay ?? false)) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => CustomerEditPage(
              customer: customer,
              parentContext: context,
              clearCustomerOnPop: clearCustomerOnPagePop,
            ),
          ),
        );
      } else {
        showPopupDialog(
          content: CustomerEditPage(
            customer: customer,
            parentContext: context,
            clearCustomerOnPop: clearCustomerOnPagePop,
          ),
          context: context,
        );
      }
    });
  };
}

ThunkAction<AppState> viewCustomer(
  Customer customer, {
  required BuildContext context,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(CustomerSelectAction(customer));

      if (!(store.state.isLargeDisplay ?? false)) {
        Navigator.pushNamed(
          globalNavigatorKey.currentContext!,
          CustomerPage.route,
          arguments: [customer, context],
        );
      }
    });
  };
}

_initializeService(Store<AppState> store) {
  customerService = CustomerService(
    store: store,
    baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
    token: store.state.authState.token,
    businessId: store.state.currentBusinessId,
  );
}

class SetCustomerLoadingAction {
  bool value;

  SetCustomerLoadingAction(this.value);
}

class ClearCustomerItemAction {
  ClearCustomerItemAction();
}

class CustomersLoadedAction {
  List<Customer>? value;

  CustomersLoadedAction(this.value);
}

class CustomerLoadFailure {
  String value;

  CustomerLoadFailure(this.value);
}

class ClearCustomerStateFailure {}

class CustomerChangedAction {
  Customer value;

  ChangeType type;

  Completer? completer;
  bool clearCustomerInUiState;

  CustomerChangedAction(
    this.value,
    this.type, {
    this.completer,
    this.clearCustomerInUiState = true,
  });
}

class SetLastPurchaseAction {
  String customerId;

  CheckoutTransaction purchase;

  SetLastPurchaseAction(this.customerId, this.purchase);
}

class ContactsLoadedAction {
  List<Contact> value;

  ContactsLoadedAction(this.value);
}

//UI ACTIONS
class CustomerSelectAction {
  Customer? value;

  CustomerSelectAction(this.value);
}

class CustomerCreateAction {}
