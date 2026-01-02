// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/models/shared/simple_data_item.dart';

part 'ticket.g.dart';

@JsonSerializable(explicitToJson: true)
class Ticket extends BusinessDataItem {
  String? customerId;
  String? customerName;
  String? customerEmail;
  String? customerMobile;
  String? transactionId;
  String? reference;
  String? notes;
  List<CheckoutCartItem>? items;
  double? ticketNumber;
  double? totalValue;
  double? totalCost;
  DateTime? transactionDate;

  @JsonKey(defaultValue: false)
  bool? completed;

  @JsonKey(defaultValue: false)
  bool? pendingSync;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? isNew;

  @JsonKey(includeFromJson: false, includeToJson: false)
  double? get itemCount {
    if (items != null && items!.isNotEmpty) {
      return items?.fold(0, ((a, b) => (a ?? 0) + b.quantity));
    }

    return 0;
  }

  Ticket({
    this.completed,
    this.customerEmail,
    this.customerId,
    this.customerMobile,
    this.customerName,
    this.items,
    this.ticketNumber,
    this.notes,
    this.totalCost,
    this.reference,
    this.totalValue,
    this.transactionDate,
    this.transactionId,
  });

  Ticket.create() {
    items = [];
    completed = false;
    isNew = true;
    pendingSync = true;
  }

  factory Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);

  Map<String, dynamic> toJson() => _$TicketToJson(this);
}
