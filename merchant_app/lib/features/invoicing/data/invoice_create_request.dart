import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../order_common/data/model/order.dart';
import '../../order_common/data/model/order_line_item.dart';

part 'invoice_create_request.g.dart';

@JsonSerializable()
class InvoiceCreateRequest extends Equatable {
  final String? note;
  final CapturedChannel? capturedChannel;
  final List<OrderLineItem>? orderLineItems;

  const InvoiceCreateRequest({
    this.note,
    required this.capturedChannel,
    required this.orderLineItems,
  });

  factory InvoiceCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$InvoiceCreateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceCreateRequestToJson(this);

  @override
  List<Object?> get props => [note, capturedChannel, orderLineItems];
}
