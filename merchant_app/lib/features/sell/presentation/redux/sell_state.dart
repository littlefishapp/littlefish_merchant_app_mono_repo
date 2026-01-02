// package imports
import 'package:built_value/built_value.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

// project imports
import 'package:littlefish_merchant/features/order_common/data/model/payment_type.dart';

import '../../../../models/sales/checkout/checkout_tip.dart';
import '../../../order_common/data/model/customer.dart';
import '../../../order_common/data/model/order.dart';
import '../../../order_common/data/model/order_discount.dart';
import '../../../../models/enums.dart';
import '../../../order_common/data/model/order_line_item.dart';
import '../../../order_common/data/model/order_transaction.dart';

part 'sell_state.g.dart';

@immutable
@JsonSerializable()
abstract class SellState implements Built<SellState, SellStateBuilder> {
  factory SellState() => _$SellState._(
    hasError: false,
    isLoading: false,
    items: const <OrderLineItem>[],
    orderTotalTipAmount: 0,
    transactionTipAmount: 0,
    availablePaymentTypes: const <PaymentType>[],
    tipTabIndex: 0,
    orderTotalWithdrawalAmount: 0,
    transactionWithdrawalAmount: 0,
    discountTabIndex: 0,
    totalDiscount: 0,
    totalTax: 0,
    canContinueToPayment: false,
    currentTotalPrice: 0,
    subtotalPrice: 0,
    totalAmountOutstanding: 0,
    totalAmountPaid: 0,
    checkoutTabIndex: 0,
    financialStatus: FinancialStatus.pending,
    orderStatus: OrderStatus.open,
    tags: const <String>[],
    transactions: const <OrderTransaction>[],
    drafts: const <Order>[],
    uiState: PurchasePaymentMethodPageState.initial,
    orderTransactionType: OrderTransactionType.purchase,
  );

  const SellState._();

  Order? get currentOrder;

  OrderTransaction? get currentOrderTransaction;

  bool get hasError;

  bool get canContinueToPayment;

  String? get orderId;

  List<OrderLineItem> get items;

  FinancialStatus get financialStatus;

  OrderStatus get orderStatus;

  List<String> get tags;

  bool get isLoading;

  String? get searchText;

  double get orderTotalTipAmount;

  double get transactionTipAmount;

  PaymentType? get selectedPaymentType;

  List<PaymentType> get availablePaymentTypes;

  int get tipTabIndex;

  double get orderTotalWithdrawalAmount;

  double get transactionWithdrawalAmount;

  double get currentTotalPrice;

  double get subtotalPrice;

  double get totalAmountOutstanding;

  double get totalAmountPaid;

  int get discountTabIndex;

  double get totalDiscount;

  OrderDiscount? get cartDiscount;

  int get checkoutTabIndex;

  double get totalTax;

  List<OrderTransaction> get transactions;

  SortBy? get sortBy;

  SortOrder? get sortOrder;

  List<Order> get drafts;

  Customer? get customer;

  CheckoutTip? get checkoutTip;

  double? get cashbackAmount;

  String? get errorMessage;

  String? get transactionFailureReason;

  PurchasePaymentMethodPageState get uiState;

  bool? get orderFailureDialogIsActive;

  bool? get transactionFailureDialogIsActive;

  bool? get pushFailedTrxFailureDialogIsActive;

  OrderTransactionType get orderTransactionType;
}

@JsonEnum()
enum PurchasePaymentMethodPageState {
  @JsonValue(0)
  initial,
  @JsonValue(1)
  orderCreated,
  @JsonValue(2)
  orderFailure,
  @JsonValue(3)
  transactionCompleted,
  @JsonValue(4)
  transactionFailure,
  @JsonValue(5)
  pushFailedTransactionFailure,
  @JsonValue(6)
  orderDiscarded,
}
