// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/expenses/business_expense.dart';
import 'package:littlefish_merchant/redux/expenses/expenses_actions.dart';
import 'package:littlefish_merchant/redux/expenses/expenses_state.dart';

// import '../auth/auth_actions.dart';

final expensesReducer = combineReducers<ExpensesState>([
  TypedReducer<ExpensesState, ExpenseChangedAction>(onExpensesChanged).call,
  TypedReducer<ExpensesState, SetExpensesLoadedAction>(onSetExpenses).call,
  TypedReducer<ExpensesState, SetExpensesStateFailureAction>(
    onStateFailure,
  ).call,
  // TypedReducer<ExpensesState, SignoutAction>(onClearState).call,
  TypedReducer<ExpensesState, SetExpensesStateLoadingAction>(
    onSetExpensesLoading,
  ).call,
]);

// ExpensesState onClearState(ExpensesState state, SignoutAction action) =>
//     state.rebuild((b) {
//       b.isLoading = false;
//       b.hasError = false;
//       b.errorMessage = null;
//       b.expenses = [];
//     });

ExpensesState onExpensesChanged(
  ExpensesState state,
  ExpenseChangedAction action,
) => state.rebuild((b) {
  if (action.type == ChangeType.removed) {
    b.expenses = _removeExpense(
      b.expenses,
      action.value,
    ).cast<BusinessExpense>();
  } else {
    b.expenses = _addOrUpdateExpense(b.expenses, action.value);
  }
});

List<BusinessExpense> _addOrUpdateExpense(
  List<BusinessExpense>? state,
  BusinessExpense? item,
) {
  if (state == null || state.isEmpty) {
    state = [item!];
    return state;
  }

  var index = state.indexWhere((i) => i.id == item!.id);
  if (index >= 0) {
    return state..[index] = item!;
  } else {
    return state..add(item!);
  }
}

List _removeExpense(List<BusinessExpense>? state, BusinessExpense? item) {
  if (state == null || state.isEmpty) return [];
  state.removeWhere((i) => i.newID == item!.newID);

  return state;
}

ExpensesState onSetExpenses(
  ExpensesState state,
  SetExpensesLoadedAction action,
) {
  //logger.debug(this,'loading expenses');
  return state.rebuild((b) => b.expenses = action.value);
}

ExpensesState onStateFailure(
  ExpensesState state,
  SetExpensesStateFailureAction action,
) => state.rebuild((b) {
  b.errorMessage = action.value;
  b.hasError = action.value != null && action.value!.isNotEmpty;
});

ExpensesState onSetExpensesLoading(
  ExpensesState state,
  SetExpensesStateLoadingAction action,
) => state.rebuild((b) => b.isLoading = action.value);

final expenseUIReducer = combineReducers<BusinessExpensesUIState>([
  TypedReducer<BusinessExpensesUIState, ExpenseChangedAction>(
    onExpenseChanged,
  ).call,
  TypedReducer<BusinessExpensesUIState, ExpenseCreateAction>(
    onCreateExpense,
  ).call,
  TypedReducer<BusinessExpensesUIState, ExpenseSelectAction>(
    onSelectExpense,
  ).call,
  TypedReducer<BusinessExpensesUIState, SetExpensesLoadedAction>(
    onExpensesLoaded,
  ).call,
  TypedReducer<BusinessExpensesUIState, SetQuickRefundAction>(
    onSetQuickRefundAction,
  ).call,
  TypedReducer<BusinessExpensesUIState, ClearExpenseAction>(
    onClearExpenseAction,
  ).call,
  TypedReducer<BusinessExpensesUIState, SetCustomerAction>(
    onSetCustomerAction,
  ).call,
  TypedReducer<BusinessExpensesUIState, ClearCustomerAction>(
    onClearCustomerAction,
  ).call,
]);

BusinessExpensesUIState onSetQuickRefundAction(
  BusinessExpensesUIState state,
  SetQuickRefundAction action,
) => state.rebuild((b) => b.item = action.value);

BusinessExpensesUIState onClearExpenseAction(
  BusinessExpensesUIState state,
  ClearExpenseAction action,
) => state.rebuild((b) {
  b.item = null; //BusinessExpense();
});

BusinessExpensesUIState onSetCustomerAction(
  BusinessExpensesUIState state,
  SetCustomerAction action,
) => state.rebuild((b) => b.customer = action.customer);

BusinessExpensesUIState onClearCustomerAction(
  BusinessExpensesUIState state,
  ClearCustomerAction action,
) => state.rebuild((b) => b.customer = null);

BusinessExpensesUIState onExpenseChanged(
  BusinessExpensesUIState state,
  ExpenseChangedAction action,
) => state.rebuild((b) => b.item = BusinessExpense.create());

BusinessExpensesUIState onCreateExpense(
  BusinessExpensesUIState state,
  ExpenseCreateAction action,
) => state.rebuild((b) => b.item = BusinessExpense.create());

BusinessExpensesUIState onSelectExpense(
  BusinessExpensesUIState state,
  ExpenseSelectAction action,
) => state.rebuild((b) => b.item = action.value ?? BusinessExpense.create());

BusinessExpensesUIState onExpensesLoaded(
  BusinessExpensesUIState state,
  SetExpensesLoadedAction action,
) => state.rebuild((b) => b.item = BusinessExpense.create());
