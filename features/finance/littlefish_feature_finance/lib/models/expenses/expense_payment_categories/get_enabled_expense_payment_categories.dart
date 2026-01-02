import 'package:littlefish_merchant/models/expenses/business_expense.dart';
import 'package:littlefish_merchant/models/expenses/expense_payment_categories/expenses_payment_categories_data_source.dart';

class _GetEnabledExpenseCategories {
  final ExpensesCategoryDataSource dataSource = ExpensesCategoryDataSource();
  List<ExpenseType> build() {
    final entities = dataSource.getEnabledExpenseCategoriesConfiguration();
    final expenseTypes = entities.map((e) => e.expenseType).toList();
    return expenseTypes;
  }
}

List<ExpenseType> getEnabledExpenseCategories() =>
    _GetEnabledExpenseCategories().build();
