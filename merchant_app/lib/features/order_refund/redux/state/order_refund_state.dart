// package imports
import 'package:built_value/built_value.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/features/order_common/data/model/customer.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_transaction.dart';

// project imports
import 'package:littlefish_merchant/features/order_common/data/model/payment_type.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_refund_line_item.dart';

part 'order_refund_state.g.dart';

@immutable
@JsonSerializable()
abstract class RefundOrderState
    implements Built<RefundOrderState, RefundOrderStateBuilder> {
  factory RefundOrderState() => _$RefundOrderState._(
    hasError: false,
    isLoading: false,
    refundItems: const <OrderRefundLineItem>[],
    availablePaymentTypes: const <PaymentType>[],
    canContinueToPayment: false,
    currentTotalRefundPrice: 0,
    orderLineItemTotalPrice: 0,
    currentTotalDiscountAmount: 0,
    totalAmountOutstanding: 0,
    totalAmountPaid: 0,
    transactions: const <OrderTransaction>[],
  );

  const RefundOrderState._();

  Order? get currentOrder;

  List<OrderTransaction> get transactions;

  OrderTransaction? get currentOrderTransaction;

  List<OrderRefundLineItem> get refundItems;

  bool get hasError;

  bool get isLoading;

  bool get canContinueToPayment;

  PaymentType? get selectedPaymentType;

  List<PaymentType> get availablePaymentTypes;

  double get currentTotalRefundPrice;

  double get orderLineItemTotalPrice;

  double get currentTotalDiscountAmount;

  double get totalAmountOutstanding;

  double get totalAmountPaid;

  Customer? get customer;

  String? get errorMessage;

  String? get transactionFailureReason;

  bool? get orderFailureDialogIsActive;

  bool? get transactionFailureDialogIsActive;

  bool? get pushFailedTrxFailureDialogIsActive;
}
