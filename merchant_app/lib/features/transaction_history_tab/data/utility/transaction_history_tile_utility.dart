import 'package:flutter/material.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_transaction.dart';

class TransactionHistoryTileUtility {
  static IconData getTileIcon(AcceptanceChannel paymentType) {
    switch (paymentType) {
      case AcceptanceChannel.card:
        return Icons.payment_outlined;
      case AcceptanceChannel.cash:
        return Icons.payments_outlined;
      default:
        return Icons.payments_outlined;
    }
  }

  static String getTileTitle(OrderTransactionType paymentType) {
    switch (paymentType) {
      case OrderTransactionType.purchase:
        return 'Purchase';
      case OrderTransactionType.refund:
        return 'Refund';
      case OrderTransactionType.$void:
        return 'Void';
      case OrderTransactionType.withdrawal:
        return 'Cash Withdrawal';
      case OrderTransactionType.cashback:
      case OrderTransactionType.purchaseCashback:
        return 'Purchase + Cashback';
      case OrderTransactionType.undefined:
        return 'Error';
      default:
        return 'Error';
    }
  }
}
