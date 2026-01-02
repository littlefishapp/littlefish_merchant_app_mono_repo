// Project imports:
import 'package:littlefish_merchant/models/expenses/business_expense.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';

List<BusinessExpense>? productsSelector(AppState state) =>
    state.expensesState.expenses;

Iterable<BusinessExpense>? activeExpenses(AppState state) =>
    state.expensesState.expenses?.where((p) => p.enabled!);
