// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';

part 'store_credit_overview.g.dart';

@JsonSerializable()
class StoreCreditOverview {
  List<Customer>? creditCustomers;
  List<CheckoutTransaction>? creditTrend;

  StoreCreditOverview({this.creditTrend, this.creditCustomers});

  factory StoreCreditOverview.fromJson(Map<String, dynamic> json) =>
      _$StoreCreditOverviewFromJson(json);

  Map<String, dynamic> toJson() => _$StoreCreditOverviewToJson(this);
}
