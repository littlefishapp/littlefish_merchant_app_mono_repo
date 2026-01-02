// Package imports:
import 'package:built_value/built_value.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/models/customers/customer.dart';

// Project imports:
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund.dart';

import '../../features/ecommerce_shared/models/checkout/checkout_order.dart';

part 'sales_state.g.dart';

@JsonSerializable()
abstract class SalesState implements Built<SalesState, SalesStateBuilder> {
  SalesState._();

  factory SalesState() => _$SalesState._(
    hasError: false,
    isLoading: false,
    errorMessage: null,
    enableTerminalReportFiltering: false,
    agglomerationTransactions: <CheckoutTransaction>[],
    sequentialTransactions: <CheckoutTransaction>[],
    transactionsFiltered: <CheckoutTransaction>[],
    originalTransactionUnmodified: null,
    modifiedTransactionCopy: null,
    currentRefund: null,
    customer: null,
  );

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isLoading;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get hasError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get enableTerminalReportFiltering;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get errorMessage;

  List<CheckoutTransaction> get sequentialTransactions;

  List<CheckoutTransaction> get agglomerationTransactions;

  List<CheckoutTransaction> get transactionsFiltered;

  List<CheckoutOrder?>? get onlineTransactions;

  CheckoutTransaction? get originalTransactionUnmodified;

  CheckoutTransaction? get modifiedTransactionCopy;

  Customer? get customer;

  Refund? get currentRefund;
}
