// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';

part 'business_summary.g.dart';

@JsonSerializable(explicitToJson: true)
class BusinessSummary {
  List<AnalysisPair>? salesByPaymentType;
  List<AnalysisPair>? expensesByType;
  List<CheckoutTransaction>? recentTransactions;

  double? profit, revenue, expenses;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<AnalysisPair> get profitability {
    return [
      AnalysisPair(id: 'Expenses', value: expenses),
      AnalysisPair(id: 'Revenue', value: revenue),
    ];
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  double? get transactionTotal {
    return recentTransactions!
        .map((x) => x.totalValue)
        .reduce((value, element) => value! + element!);
  }

  BusinessSummary({
    this.expenses,
    this.expensesByType,
    this.profit,
    this.revenue,
    this.salesByPaymentType,
    this.recentTransactions,
  });

  factory BusinessSummary.fromJson(Map<String, dynamic> json) =>
      _$BusinessSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessSummaryToJson(this);
}
