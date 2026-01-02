class CalculateFinanceEligabilityAction {}

class SetFinanceLoadingAction {
  bool value;

  SetFinanceLoadingAction(this.value);
}

class SetErrorMessageAction {
  String value;

  SetErrorMessageAction(this.value);
}

class SetFinancialParametersAction {
  int? monthsTrading;

  int? daysTrading;

  double? totalRevenue;

  double? totalExpenses;

  double? totalCostOfSale;

  double? totalDebtors;

  double? totalCreditors;

  double? totalInventoryValue;

  SetFinancialParametersAction({
    this.daysTrading,
    this.monthsTrading,
    this.totalCostOfSale,
    this.totalCreditors,
    this.totalDebtors,
    this.totalExpenses,
    this.totalInventoryValue,
    this.totalRevenue,
  });
}
