// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/redux/customer/customer_actions.dart';
import 'package:littlefish_merchant/redux/customer/customer_state.dart';
import 'package:littlefish_merchant/redux/ui/ui_entity_state.dart';

final customerReducer = combineReducers<CustomerState>([
  TypedReducer<CustomerState, SetCustomerLoadingAction>(onSetLoading).call,
  TypedReducer<CustomerState, CustomersLoadedAction>(onCustomersLoaded).call,
  TypedReducer<CustomerState, CustomerLoadFailure>(onCustomerFailure).call,
  TypedReducer<CustomerState, CustomerChangedAction>(onCustomerChanged).call,
  TypedReducer<CustomerState, SetLastPurchaseAction>(onSetLastPurchase).call,
  TypedReducer<CustomerState, ContactsLoadedAction>(onContactsLoaded).call,
  TypedReducer<CustomerState, SignoutAction>(onClearState).call,
  TypedReducer<CustomerState, ClearCustomerStateFailure>(
    onClearStateError,
  ).call,
]);

CustomerState onClearStateError(
  CustomerState state,
  ClearCustomerStateFailure action,
) => state.rebuild((b) {
  b.errorMessage = null;
  b.hasError = false;
});

CustomerState onClearState(CustomerState state, SignoutAction action) =>
    state.rebuild((b) {
      b.isLoading = false;
      b.hasError = false;
      b.errorMessage = null;

      b.customers = [];
    });

CustomerState onSetLoading(
  CustomerState state,
  SetCustomerLoadingAction action,
) => state.rebuild((b) => b.isLoading = action.value);

CustomerState onCustomersLoaded(
  CustomerState state,
  CustomersLoadedAction action,
) {
  //logger.debug(this,'recieved load customers');
  return state.rebuild((b) => b.customers = action.value);
}

CustomerState onCustomerFailure(
  CustomerState state,
  CustomerLoadFailure action,
) => state.rebuild((b) {
  b.hasError = true;
  b.errorMessage = action.value;
});

CustomerState onCustomerChanged(
  CustomerState state,
  CustomerChangedAction action,
) => state.rebuild(
  (b) => b.customers = action.type == ChangeType.removed
      ? _removeCustomer(action.value, b.customers)
      : _addOrUpdateCustomer(action.value, b.customers),
);

CustomerState onSetLastPurchase(
  CustomerState state,
  SetLastPurchaseAction action,
) => state.rebuild(
  (b) => b.customers = _setLastPurchase(
    customerId: action.customerId,
    state: b.customers,
    purchase: action.purchase,
  ),
);

CustomerState onContactsLoaded(
  CustomerState state,
  ContactsLoadedAction action,
) => state.rebuild((b) => b.contacts = action.value);

List<Customer>? _setLastPurchase({
  String? customerId,
  CheckoutTransaction? purchase,
  List<Customer>? state,
}) {
  state?.where((c) => c.id == customerId).forEach((cc) {
    cc.lastPurchaseDate = DateTime.now().toUtc();
    cc.totalSaleCount = (cc.totalSaleCount ?? 0) + 1;
    cc.totalSaleValue = (cc.totalSaleValue ?? 0) + purchase!.totalValue!;
    cc.lastSaleValue = purchase.totalValue;
    cc.averageSaleValue = cc.totalSaleValue! / cc.totalSaleCount!;
  });

  return state;
}

List<Customer> _addOrUpdateCustomer(Customer value, List<Customer>? state) {
  var index = state!.indexWhere((p) => p.id == value.id);
  if (index >= 0) {
    state[index] = value;
  } else {
    state.add(value);
  }

  return state;
}

List<Customer> _removeCustomer(Customer value, List<Customer>? state) {
  state!.removeWhere((p) => p.id == value.id);

  return state;
}

//UI
final customerUIReducer = combineReducers<CustomerUIState>([
  TypedReducer<CustomerUIState, CustomerSelectAction>(onCustomerSelected).call,
  TypedReducer<CustomerUIState, CustomerCreateAction>(onCreateCustomer).call,
  TypedReducer<CustomerUIState, CustomerChangedAction>(
    onSetCustomerChanged,
  ).call,
  TypedReducer<CustomerUIState, ClearCustomerItemAction>(onClearCustomer).call,
]);

CustomerUIState onClearCustomer(
  CustomerUIState state,
  ClearCustomerItemAction action,
) {
  return state.rebuild(
    (b) => b.item = UIEntityState<Customer>(Customer.create(), isNew: true),
  );
}

CustomerUIState onCustomerSelected(
  CustomerUIState state,
  CustomerSelectAction action,
) => state.rebuild((b) => b.item = UIEntityState(action.value, isNew: false));

CustomerUIState onCreateCustomer(
  CustomerUIState state,
  CustomerCreateAction action,
) => state.rebuild(
  (b) => b.item = UIEntityState(Customer.create(), isNew: true),
);

CustomerUIState onSetCustomerChanged(
  CustomerUIState state,
  CustomerChangedAction action,
) {
  return state.rebuild((b) {
    if (action.clearCustomerInUiState) {
      b.item = UIEntityState<Customer>(Customer.create(), isNew: true);
    }
  });
}
