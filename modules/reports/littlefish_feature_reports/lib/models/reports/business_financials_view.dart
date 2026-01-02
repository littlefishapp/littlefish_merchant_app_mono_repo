// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart';

part 'business_financials_view.g.dart';

@JsonSerializable()
class BusinessFinancialsView {
  double? totalProfit;
  double? totalDiscount;
  double? totalTax;
  double? totalSalesCost;
  double? totalSalesProfit;
  double? totalRevenue;
  double? totalRefundedSales;
  double? totalRefundedSalesCost;
  List<AnalysisPair>? paymentType;
  double? totalExpenses;
  List<AnalysisPair>? expenseType;
  List<AnalysisPair>? refundPaymentType;

  BusinessFinancialsView({
    this.expenseType,
    this.paymentType,
    this.totalDiscount,
    this.totalExpenses,
    this.totalProfit,
    this.totalRevenue,
    this.totalSalesCost,
    this.totalSalesProfit,
    this.totalRefundedSales,
    this.totalRefundedSalesCost,
    this.refundPaymentType,
    this.totalTax,
  });

  factory BusinessFinancialsView.fromJson(Map<String, dynamic> json) =>
      _$BusinessFinancialsViewFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessFinancialsViewToJson(this);
}
