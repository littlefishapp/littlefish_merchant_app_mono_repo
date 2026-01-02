// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/models/customers/customer.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/expenses/business_expense.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/business_service.dart';
import 'package:littlefish_merchant/ui/business/expenses/pages/expense_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/app/custom_route.dart';

ThunkAction<AppState> createExpense(
  BuildContext context, {
  BusinessExpense? defaultExpense,
  bool refund = false,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(ExpenseCreateAction());

      Navigator.of(context).push(
        CustomRoute(
          builder: (BuildContext ctx) =>
              ExpensePage(defaultExpense: defaultExpense),
        ),
      );
      // }
    });
  };
}

ThunkAction<AppState> editExpense(BuildContext context, BusinessExpense item) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(ExpenseSelectAction(item));

      if (store.state.isLargeDisplay ?? false) {
        showPopupDialog(context: context, content: const ExpensePage());
      } else {
        Navigator.of(context).pushNamed(ExpensePage.route);
      }
    });
  };
}

//Business Users
ThunkAction<AppState> getExpenses({bool refresh = false}) {
  return (Store<AppState> store) async {
    Future(() async {
      var state = store.state.expensesState;

      //pull from cache
      if (!refresh && (state.expenses?.length ?? 0) > 0) {
        // store.dispatch(SetExpensesStateLoadingAction(false));
        return;
      }

      var service = ExpensesService.fromStore(store);

      store.dispatch(SetExpensesStateLoadingAction(true));

      await service
          .getExpenses()
          .catchError((e) {
            reportCheckedError(e, trace: StackTrace.current);
            store.dispatch(SetExpensesStateFailureAction(e.toString()));
            store.dispatch(SetExpensesStateLoadingAction(false));
            return <BusinessExpense>[];
          })
          .then((result) {
            store.dispatch(SetExpensesLoadedAction(result));
            store.dispatch(SetExpensesStateLoadingAction(false));
          })
          .catchError((error) {
            reportCheckedError(error);
          });
    });
  };
}

ThunkAction<AppState> updateOrSaveExpense(
  BusinessExpense? expense, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      var service = ExpensesService.fromStore(store);

      store.dispatch(SetExpensesStateLoadingAction(true));

      try {
        var result = await service.addOrUpdateExpense(item: expense!);
        store.dispatch(ExpenseChangedAction(result, ChangeType.updated));
        store.dispatch(SetExpensesStateLoadingAction(false));
        if (completer != null && !completer.isCompleted) completer.complete();
      } catch (e) {
        store.dispatch(SetExpensesStateFailureAction(e.toString()));
        store.dispatch(SetExpensesStateLoadingAction(false));
        reportCheckedError(e, trace: StackTrace.current);
        //notify the error if there is a completer present
        completer?.completeError(e, StackTrace.current);
      }
    });
  };
}

ThunkAction<AppState> removeExpense(
  BusinessExpense? expense, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      var service = ExpensesService.fromStore(store);

      store.dispatch(SetExpensesStateLoadingAction(true));

      await service
          .removeExpense(expense!)
          .catchError((e) {
            store.dispatch(SetExpensesStateFailureAction(e.toString()));
            store.dispatch(SetExpensesStateLoadingAction(false));
            reportCheckedError(e, trace: StackTrace.current);

            //notify the error if there is a completer present
            completer?.completeError(e, StackTrace.current);
            return false;
          })
          .then((result) {
            if (result) {
              store.dispatch(ExpenseChangedAction(expense, ChangeType.removed));
              if (completer != null && !completer.isCompleted)
                completer.complete();
            }
          })
          .whenComplete(
            () => store.dispatch(SetExpensesStateLoadingAction(false)),
          );
    });
  };
}

//EXPENSES
class ExpenseChangedAction {
  BusinessExpense? value;

  ChangeType type;

  Completer? completer;

  ExpenseChangedAction(this.value, this.type, {this.completer});
}

class SetExpensesLoadedAction {
  List<BusinessExpense>? value;

  SetExpensesLoadedAction(this.value);
}

class SetExpensesStateFailureAction {
  String? value;

  SetExpensesStateFailureAction(this.value);
}

class SetExpensesStateLoadingAction {
  bool value;

  SetExpensesStateLoadingAction(this.value);
}

class SetQuickRefundAction {
  BusinessExpense value;

  SetQuickRefundAction(this.value);
}

class ClearExpenseAction {
  ClearExpenseAction();
}

class SetCustomerAction {
  Customer customer;

  SetCustomerAction(this.customer);
}

class ClearCustomerAction {
  ClearCustomerAction();
}

//UI ACTIONS

class ExpenseSelectAction {
  BusinessExpense? value;

  ExpenseSelectAction(this.value);
}

class ExpenseCreateAction {}
