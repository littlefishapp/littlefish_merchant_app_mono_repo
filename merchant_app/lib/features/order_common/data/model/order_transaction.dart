import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/features/order_common/data/model/payment_type.dart';

import '../../../order_common/data/model/customer.dart';
import 'order.dart';

part 'order_transaction.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderTransaction extends Equatable {
  final String id;
  final int transactionNumber;
  final String businessId;
  final String deviceId;
  final String traceId;
  final Customer customer;
  final String orderId;
  final double amount;
  final double changeGiven;
  final double amountTendered;
  final double tipAmount;
  final TransactionStatus transactionStatus;
  final String failureReason;
  final OrderTransactionType transactionType;
  final EffectOnCartTotal effectOnCartTotal;
  final String additionalData;
  final CapturedChannel capturedChannel;
  final String receiptData;
  final PaymentType paymentType;
  final DateTime? dateCreated;
  final DateTime? dateUpdated;
  final String createdBy;
  final String updatedBy;
  final String terminalId;
  final int? batchNo;

  const OrderTransaction({
    this.amount = 0.0,
    this.deviceId = '',
    this.businessId = '',
    this.capturedChannel = CapturedChannel.undefined,
    this.orderId = '',
    this.paymentType = const PaymentType(),
    this.transactionStatus = TransactionStatus.undefined,
    this.transactionType = OrderTransactionType.undefined,
    this.createdBy = '',
    this.effectOnCartTotal = EffectOnCartTotal.none,
    this.additionalData = '',
    this.amountTendered = 0.0,
    this.changeGiven = 0.0,
    this.customer = const Customer(),
    this.failureReason = '',
    this.id = '',
    this.receiptData = '',
    this.tipAmount = 0.0,
    this.traceId = '',
    this.transactionNumber = 0,
    this.dateCreated,
    this.dateUpdated,
    this.updatedBy = '',
    this.terminalId = '',
    this.batchNo,
  });

  factory OrderTransaction.fromJson(Map<String, dynamic> json) =>
      _$OrderTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$OrderTransactionToJson(this);

  static int transactionStatusToJson(TransactionStatus transactionStatus) =>
      _$TransactionStatusEnumMap[transactionStatus]!;

  static int orderTransactionTypeToJson(
    OrderTransactionType orderTransactionType,
  ) => _$OrderTransactionTypeEnumMap[orderTransactionType]!;

  @override
  List<Object?> get props => [
    id,
    transactionNumber,
    businessId,
    deviceId,
    traceId,
    customer,
    orderId,
    amount,
    changeGiven,
    amountTendered,
    tipAmount,
    transactionStatus,
    failureReason,
    transactionType,
    effectOnCartTotal,
    additionalData,
    capturedChannel,
    receiptData,
    paymentType,
    dateCreated,
    dateUpdated,
    createdBy,
    updatedBy,
    terminalId,
    batchNo,
  ];

  OrderTransaction copyWith({
    String? id,
    int? transactionNumber,
    String? businessId,
    String? deviceId,
    String? traceId,
    Customer? customer,
    String? orderId,
    double? amount,
    double? changeGiven,
    double? amountTendered,
    double? tipAmount,
    TransactionStatus? transactionStatus,
    String? failureReason,
    OrderTransactionType? transactionType,
    EffectOnCartTotal? effectOnCartTotal,
    String? additionalData,
    CapturedChannel? capturedChannel,
    String? receiptData,
    PaymentType? paymentType,
    DateTime? dateCreated,
    DateTime? dateUpdated,
    String? createdBy,
    String? updatedBy,
    String? terminalId,
    int? batchNo,
  }) {
    return OrderTransaction(
      id: id ?? this.id,
      transactionNumber: transactionNumber ?? this.transactionNumber,
      businessId: businessId ?? this.businessId,
      deviceId: deviceId ?? this.deviceId,
      traceId: traceId ?? this.traceId,
      customer: customer ?? this.customer,
      orderId: orderId ?? this.orderId,
      amount: amount ?? this.amount,
      changeGiven: changeGiven ?? this.changeGiven,
      amountTendered: amountTendered ?? this.amountTendered,
      tipAmount: tipAmount ?? this.tipAmount,
      transactionStatus: transactionStatus ?? this.transactionStatus,
      failureReason: failureReason ?? this.failureReason,
      transactionType: transactionType ?? this.transactionType,
      effectOnCartTotal: effectOnCartTotal ?? this.effectOnCartTotal,
      additionalData: additionalData ?? this.additionalData,
      capturedChannel: capturedChannel ?? this.capturedChannel,
      receiptData: receiptData ?? this.receiptData,
      paymentType: paymentType ?? this.paymentType,
      dateCreated: dateCreated ?? this.dateCreated,
      dateUpdated: dateUpdated ?? this.dateUpdated,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      terminalId: terminalId ?? this.terminalId,
      batchNo: batchNo ?? this.batchNo,
    );
  }
}

@JsonEnum()
enum AcceptanceChannel {
  @JsonValue(-1)
  undefined,
  @JsonValue(0)
  qrCode,
  @JsonValue(1)
  tapOnGlass,
  @JsonValue(2)
  cash,
  @JsonValue(3)
  pos,
  @JsonValue(4)
  payByLink,
  @JsonValue(5)
  mobileWallet,
  @JsonValue(6)
  card,
  @JsonValue(7)
  other,
}

@JsonEnum()
enum AcceptanceType {
  @JsonValue(-1)
  undefined,
  @JsonValue(0)
  online,
  @JsonValue(1)
  inPerson,
}

@JsonEnum()
enum TransactionStatus {
  @JsonValue(-1)
  undefined,
  @JsonValue(0)
  pending,
  @JsonValue(1)
  failure,
  @JsonValue(2)
  success,
  @JsonValue(3)
  error,
}

@JsonEnum()
enum OrderTransactionType {
  @JsonValue(-1)
  undefined,
  @JsonValue(0)
  refund,
  @JsonValue(1)
  $void,
  @JsonValue(2)
  withdrawal,
  @JsonValue(3)
  purchase,
  @JsonValue(4)
  cashback,
  @JsonValue(5)
  purchaseCashback,
}

@JsonEnum()
enum EffectOnCartTotal {
  @JsonValue(-1)
  undefined,
  @JsonValue(0)
  increase,
  @JsonValue(1)
  decrease,
  @JsonValue(2)
  none,
}
