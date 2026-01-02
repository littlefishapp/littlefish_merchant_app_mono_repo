// Package imports:
import 'package:built_value/built_value.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/models/customers/customer.dart';

// Project imports:
import 'package:littlefish_merchant/models/expenses/business_expense.dart';

part 'expenses_state.g.dart';

abstract class ExpensesState
    implements Built<ExpensesState, ExpensesStateBuilder> {
  ExpensesState._();

  factory ExpensesState() => _$ExpensesState._(
    hasError: false,
    isLoading: false,
    errorMessage: null,
    expenses: <BusinessExpense>[],
  );

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isLoading;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get hasError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get errorMessage;

  List<BusinessExpense>? get expenses;
}

abstract class BusinessExpensesUIState
    implements Built<BusinessExpensesUIState, BusinessExpensesUIStateBuilder> {
  factory BusinessExpensesUIState() {
    return _$BusinessExpensesUIState._(item: BusinessExpense.create());
  }

  BusinessExpensesUIState._();

  BusinessExpense? get item;

  Customer? get customer;

  bool get isNew => item?.isNew ?? false;
}
