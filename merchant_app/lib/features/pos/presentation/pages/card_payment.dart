import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/features/pos/presentation/pages/pos_payment_page.dart';
import 'package:littlefish_payments/models/shared/payment_result.dart';
import '../../../../models/enums.dart';
import '../../../../models/sales/checkout/checkout_refund.dart';
import '../../../../models/sales/checkout/checkout_transaction.dart';

class CardPayment extends StatelessWidget {
  final CheckoutTransaction? transaction;
  final Decimal amount;
  final BuildContext? parentContext;
  final int backButtonTimeout;
  final bool transactionIsSaving;
  final Function(dynamic result) saveSale;
  final Function(PaymentResult? result)? onError;
  final Decimal cashBackAmount;
  final CardTransactionType paymentType;
  final Refund? refund;
  final void Function(BuildContext context)? onNavigate;
  final bool isV2;
  final bool canPrint;
  final String? refundReference;

  const CardPayment({
    super.key,
    required this.amount,
    this.transaction,
    this.parentContext,
    required this.backButtonTimeout,
    required this.transactionIsSaving,
    required this.saveSale,
    required this.cashBackAmount,
    this.paymentType = CardTransactionType.purchase,
    this.refund,
    this.onNavigate,
    this.isV2 = false,
    this.canPrint = true,
    this.onError,
    this.refundReference,
  });

  @override
  Widget build(BuildContext context) {
    return PosPaymentPage(
      transaction: transaction,
      amount: amount,
      saveSale: saveSale,
      backButtonTimeout: backButtonTimeout,
      cashBackAmount: cashBackAmount,
      parentContext: context,
      transactionIsSaving: transactionIsSaving,
      paymentType: paymentType,
      refund: refund,
      onNavigate: onNavigate,
      isV2: isV2,
      canPrint: canPrint,
      onError: onError,
      refundReference: refundReference,
    );
  }
}
