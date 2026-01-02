// package imports
import 'package:built_value/built_value.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

// project imports
import 'package:littlefish_merchant/shared/exceptions/general_error.dart';

import '../../../order_common/data/model/customer.dart';
import '../../../order_common/data/model/order.dart';
import '../../../order_common/data/model/order_transaction.dart';

part 'order_receipt_state.g.dart';

@immutable
@JsonSerializable()
abstract class OrderReceiptState
    implements Built<OrderReceiptState, OrderReceiptStateBuilder> {
  factory OrderReceiptState() =>
      _$OrderReceiptState._(isLoading: false, hasSent: false);
  const OrderReceiptState._();

  bool get isLoading;

  bool get hasSent;

  GeneralError? get error;

  Customer? get customer;

  Order? get currentOrder;

  OrderTransaction? get currentTransaction;
}
