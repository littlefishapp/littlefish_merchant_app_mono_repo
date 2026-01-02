// removed ignore: depend_on_referenced_packages
import 'package:littlefish_merchant/features/errors/presentation/redux/error_reducer.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/redux/auth/auth_reducer.dart';
import 'package:littlefish_merchant/redux/business/business_reducer.dart';
import 'package:littlefish_merchant/redux/customer/customer_reducer.dart';
import 'package:littlefish_merchant/redux/discounts/discounts_reducer.dart';
import 'package:littlefish_merchant/redux/expenses/expenses_reducer.dart';
import 'package:littlefish_merchant/redux/inventory/inventory_reducer.dart';
import 'package:littlefish_merchant/redux/invoice/invoice_reducer.dart';
import 'package:littlefish_merchant/redux/product/product_reducer.dart';
import 'package:littlefish_merchant/redux/store/store_reducer.dart';
import 'package:littlefish_merchant/redux/suppliers/supplier_reducer.dart';
import 'package:littlefish_merchant/redux/tickets/ticket_reducer.dart';
import 'package:littlefish_merchant/redux/ui/ui_state.dart';
import 'package:littlefish_merchant/redux/ui/ui_state_actions.dart';

UIState uiStateReducer(UIState state, action) => state.rebuild((b) {
  b.employeeUIState.replace(employeeUIReducer(state.employeeUIState, action));

  b.businessUsersUIState.replace(
    businessUserUIStateReducer(state.businessUsersUIState, action),
  );

  b.customerUIState.replace(customerUIReducer(state.customerUIState, action));

  b.stockTakeUI.replace(stockTakeUIReducer(state.stockTakeUI, action));

  b.stockRecievableUI.replace(grvUIReducers(state.stockRecievableUI, action));

  b.supplierUIState.replace(suppliersUIReducer(state.supplierUIState, action));

  b.authUIState.replace(authUIReducer(state.authUIState, action));

  b.invoiceUIState.replace(invoiceUIReducer(state.invoiceUIState, action));

  b.productsUIState.replace(productsUIReducer(state.productsUIState, action));

  b.storeUIState.replace(storeUIReducer(state.storeUIState, action));

  b.modifierUIState.replace(modifiersUIReducer(state.modifierUIState, action));

  b.categoriesUIState.replace(
    categoryUIReducer(state.categoriesUIState, action),
  );

  b.combosUIState.replace(comboUIReducer(state.combosUIState, action));

  b.homeUIState.replace(homeUIReducer(state.homeUIState, action));

  b.expensesUIState.replace(expenseUIReducer(state.expensesUIState, action));

  b.ticketUIState.replace(ticketUIReducer(state.ticketUIState, action));

  b.discountUIState.replace(discountsUIReducer(state.discountUIState, action));

  // b.hardwareUIState
  //     .replace(hardwareUIReducer(state.hardwareUIState, action));
  b.settingUpText = settingUpTextReducer(b.settingUpText, action);
  b.previousRoute = b.previousRoute;
  b.currentRoute = currentRouteReducer(b.currentRoute, action);
  b.errorState.replace(errorStateReducer(state.errorState, action));
});

Reducer<String?> settingUpTextReducer = combineReducers([
  TypedReducer<String?, SetSettingUpTextAction>(
    updateSettingUpTextReducer,
  ).call,
]);

String? updateSettingUpTextReducer(
  String? settingUpText,
  SetSettingUpTextAction action,
) {
  return action.value;
}

Reducer<String?> currentRouteReducer = combineReducers([
  TypedReducer<String?, SetRouteAction>(updateCurrentRouteReducer).call,
]);
String? updateCurrentRouteReducer(String? currentRoute, SetRouteAction action) {
  return action.value;
}

Reducer<HomeUIState> homeUIReducer = combineReducers([
  TypedReducer<HomeUIState, SetHomeOverview>(onSetHomeView).call,
  TypedReducer<HomeUIState, SetHomeLoadingAction>(onHomeLoading).call,
  TypedReducer<HomeUIState, SetHomeFailureAction>(onHomeFailure).call,
  TypedReducer<HomeUIState, SetHomeMode>(onSetMode).call,
  TypedReducer<HomeUIState, SetHomeUIIndexAction>(onSetIndex).call,
]);

HomeUIState onSetHomeView(HomeUIState state, SetHomeOverview action) {
  return state.rebuild((b) => b.overview = action.value);
}

HomeUIState onHomeLoading(HomeUIState state, SetHomeLoadingAction action) =>
    state.rebuild((b) => b.isLoading = action.value);

HomeUIState onHomeFailure(HomeUIState state, SetHomeFailureAction action) =>
    state.rebuild((b) => b.hasError = true);

HomeUIState onSetMode(HomeUIState state, SetHomeMode action) =>
    state.rebuild((b) => b.mode = action.value);

HomeUIState onSetIndex(HomeUIState state, SetHomeUIIndexAction action) =>
    state.rebuild((b) => b.homeUIIndex = action.value);
