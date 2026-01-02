import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/cards/card_square_flat.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/presentation/components/transaction_info_item.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';

class TransactionSummaryCard extends StatelessWidget {
  final DateTime? dateUpdated;
  final DateTime? dateCreated;
  final String status;
  final String transactionNumber;
  final String providerReferenceNumber;

  final String sellerName;
  final String paymentType;
  final double checkoutTotal;
  final bool isWithdrawal;
  final double withdrawalAmount;
  final double cashbackAmount;
  final double amountTendered;
  final double totalRefund;

  const TransactionSummaryCard({
    super.key,
    required this.dateUpdated,
    required this.dateCreated,
    required this.status,
    required this.transactionNumber,
    this.providerReferenceNumber = '',
    required this.sellerName,
    required this.paymentType,
    required this.checkoutTotal,
    required this.isWithdrawal,
    required this.withdrawalAmount,
    required this.cashbackAmount,
    required this.amountTendered,
    required this.totalRefund,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: CardSquareFlat(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 24),
                alignment: Alignment.centerLeft,
                child: context.labelLarge(
                  'Transaction Summary',
                  isBold: true,
                  alignLeft: true,
                ),
              ),
              TransactionInfoItem(
                title: 'Date:',
                value: TextFormatter.toShortDate(
                  dateTime: dateUpdated ?? dateCreated,
                  format: AppVariables.appFullDateTimeFormat,
                ),
              ),
              TransactionInfoItem(
                title: 'Status:',
                value: TextFormatter.toCapitalize(value: status),
              ),
              if (providerReferenceNumber.isNotEmpty)
                TransactionInfoItem(
                  title: 'Payment Reference #:',
                  value: providerReferenceNumber,
                ),
              TransactionInfoItem(
                title: 'Transaction #:',
                value: transactionNumber,
              ),
              TransactionInfoItem(title: 'Cashier:', value: sellerName),
              TransactionInfoItem(title: 'Payment Type:', value: paymentType),
              if (checkoutTotal > 0 && !isWithdrawal)
                TransactionInfoItem(
                  title: 'Total Value:',
                  value: TextFormatter.toStringCurrency(checkoutTotal),
                ),
              if (withdrawalAmount > 0)
                TransactionInfoItem(
                  title: 'Cash Withdrawal:',
                  value: TextFormatter.toStringCurrency(withdrawalAmount),
                ),
              if (cashbackAmount > 0)
                TransactionInfoItem(
                  title: 'CashBack:',
                  value: TextFormatter.toStringCurrency(cashbackAmount),
                ),
              if (paymentType.toLowerCase() == 'cash' && amountTendered > 0)
                TransactionInfoItem(
                  title: 'Amount Paid:',
                  value: TextFormatter.toStringCurrency(amountTendered),
                ),
              if (totalRefund > 0)
                TransactionInfoItem(
                  title: 'Total Refunded:',
                  value: TextFormatter.toStringCurrency(totalRefund),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
