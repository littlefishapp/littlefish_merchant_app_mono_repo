import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/cards/card_square_flat.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/presentation/components/transaction_info_item.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:quiver/strings.dart';

class PaymentSummaryCard extends StatelessWidget {
  final String paymentType;
  final String? cardType;
  final String? paymentStatus;
  final int? batchNo;
  final String? authResponse;
  final String? authResponseCode;
  final String? entry;
  final String? traceID;
  final String? terminalIdPOS;

  const PaymentSummaryCard({
    super.key,
    required this.paymentType,
    this.cardType,
    this.paymentStatus,
    this.batchNo,
    this.authResponse,
    this.authResponseCode,
    this.entry,
    this.traceID,
    this.terminalIdPOS,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: CardSquareFlat(
        child: ExpansionTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppVariables.appDefaultButtonRadius,
            ),
            side: BorderSide.none,
          ),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          title: context.labelLarge(
            'Payment Details',
            isBold: true,
            alignLeft: true,
          ),
          children: [
            TransactionInfoItem(title: 'Payment Type:', value: paymentType),
            if (isNotBlank(cardType) && paymentType.toLowerCase() == 'card')
              TransactionInfoItem(title: 'Card Type:', value: cardType!),
            if (paymentStatus != null)
              TransactionInfoItem(
                title: 'Payment Status:',
                value: TextFormatter.toCapitalize(
                  value: paymentStatus ?? 'N/A',
                ),
              ),
            if ((batchNo ?? 0) > 0)
              TransactionInfoItem(
                title: 'Batch Number:',
                value: (batchNo ?? 'N/A').toString(),
              ),
            if (isNotBlank(authResponse))
              TransactionInfoItem(
                title: 'Auth Response:',
                value: authResponse!,
              ),
            if (isNotBlank(authResponseCode))
              TransactionInfoItem(
                title: 'Auth Code:',
                value: authResponseCode!,
              ),
            if (isNotBlank(entry))
              TransactionInfoItem(title: 'Entry:', value: entry!),
            if (isNotBlank(traceID))
              TransactionInfoItem(title: 'Trace ID:', value: traceID!),
            if (isNotBlank(terminalIdPOS))
              TransactionInfoItem(title: 'Terminal ID:', value: terminalIdPOS!),
          ],
        ),
      ),
    );
  }
}
