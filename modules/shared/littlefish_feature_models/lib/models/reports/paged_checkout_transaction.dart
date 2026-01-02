// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';

part 'paged_checkout_transaction.g.dart';

@JsonSerializable()
class PagedCheckoutTransaction {
  int? count;
  List<CheckoutTransaction>? result;

  PagedCheckoutTransaction({this.result, this.count});

  factory PagedCheckoutTransaction.fromJson(Map<String, dynamic> json) =>
      _$PagedCheckoutTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$PagedCheckoutTransactionToJson(this);
}
