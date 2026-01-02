import 'package:littlefish_merchant/models/expenses/business_expense.dart';
import 'package:littlefish_merchant/models/expenses/expenses_payment_types/expenses_payment_type_data_source.dart';

class _GetEnabledSourceOfFunds {
  final ExpensesPaymentTypeDataSource dataSource =
      ExpensesPaymentTypeDataSource();

  List<SourceOfFunds> build() {
    final entities = dataSource.getEnabledExpensePaymentTypesConfiguration();
    final sourceOfFunds = entities.map((e) => e.sourceOfFunds).toList();
    return sourceOfFunds;
  }
}

List<SourceOfFunds> getEnabledExpensePaymentTypes() =>
    _GetEnabledSourceOfFunds().build();
