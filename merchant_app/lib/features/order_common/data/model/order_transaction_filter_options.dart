import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_transaction.dart';

part 'order_transaction_filter_options.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderTransactionFilterOptions {
  final String? searchText;
  final List<TransactionStatus>? transactionStatus;
  final List<OrderTransactionType>? transactionType;
  final List<AcceptanceType>? acceptanceType;
  final List<AcceptanceChannel>? acceptanceChannel;
  final DateTime? startDate;
  final DateTime? endDate;

  OrderTransactionFilterOptions({
    this.searchText,
    this.transactionStatus,
    this.transactionType,
    this.acceptanceType,
    this.acceptanceChannel,
    this.startDate,
    this.endDate,
  });

  factory OrderTransactionFilterOptions.fromJson(Map<String, dynamic> json) =>
      _$OrderTransactionFilterOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$OrderTransactionFilterOptionsToJson(this);
}
