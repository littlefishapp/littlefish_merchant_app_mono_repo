// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/expenses/business_expense.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/expenses/expenses_actions.dart';
import 'package:littlefish_merchant/redux/expenses/expenses_selectors.dart';
import 'package:littlefish_merchant/redux/expenses/expenses_state.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

class ExpensesVM
    extends StoreCollectionViewModel<BusinessExpense?, ExpensesState> {
  ExpensesVM.fromStore(Store<AppState> store) : super.fromStore(store);

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.expensesState;

    items = activeExpenses(store.state)?.toList();

    selectedItem = store.state.expensesUIState!.item;
    // isNew = selectedItem?.isNew ?? false;

    // this.onRefresh = () => store.dispatch(getExpenses(refresh: true));

    onSetSelected = (item) => store.dispatch(ExpenseSelectAction(item));

    onRemove = (item, ctx) => store.dispatch(removeExpense(item));

    onResetErorr = () => store.dispatch(SetExpensesStateFailureAction(null));

    isLoading = state!.isLoading ?? false;
    hasError = state!.hasError ?? false;
    errorMessage = state!.errorMessage;
  }
}

class ExpenseVM extends StoreItemViewModel<BusinessExpense?, ExpensesState> {
  ExpenseVM.fromStore(Store<AppState> store) : super.fromStore(store);

  late Customer? customer;
  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.expensesState;

    isLoading = state!.isLoading ?? false;
    hasError = state!.hasError ?? false;
    errorMessage = state!.errorMessage;

    item = store.state.expensesUIState!.item;
    isNew = item?.isNew ?? false;

    customer = store.state.expensesUIState!.customer;

    onAdd = (item, ctx) async {
      if (key == null || key!.currentState == null) return;

      if (key!.currentState!.validate()) {
        key!.currentState!.save();
        if (ctx != null) saveAndUpdateState(ctx);
      }
    };

    onRemove = (item, ctx) => store.dispatch(
      removeExpense(
        item,
        completer: snackBarCompleter(ctx, '${item!.displayName} removed'),
      ),
    );

    onResetErorr = () => store.dispatch(SetExpensesStateFailureAction(null));
  }

  saveAndUpdateState(BuildContext ctx) {
    store?.dispatch(
      updateOrSaveExpense(
        item,
        completer: snackBarCompleter(
          ctx,
          '${item!.beneficiary} payment saved successfully!',
          shouldPop: true,
        ),
      ),
    );
  }
}
