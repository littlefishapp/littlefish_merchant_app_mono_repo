// Package imports:
import 'package:built_value/built_value.dart';
import 'package:json_annotation/json_annotation.dart';

part 'finance_state.g.dart';

abstract class FinanceState
    implements Built<FinanceState, FinanceStateBuilder> {
  FinanceState._();

  factory FinanceState() =>
      _$FinanceState._(hasError: false, isLoading: false, errorMessage: null);

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isLoading;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get hasError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get errorMessage;

  int? get monthsTrading;

  int? get daysTrading;

  double? get totalRevenue;

  double? get totalExpenses;

  double? get totalCostOfSale;

  double? get totalDebtors;

  double? get totalCreditors;

  double? get totalInventoryValue;

  double? get financeablePortion;
}
