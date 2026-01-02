import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/cards/card_square_flat.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/presentation/components/transaction_info_item.dart';

class CustomerSummaryCard extends StatelessWidget {
  final String customerName;
  final String customerEmail;
  final String customerMobile;

  const CustomerSummaryCard({
    super.key,
    required this.customerName,
    required this.customerEmail,
    required this.customerMobile,
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
            'Customer Details',
            isBold: true,
            alignLeft: true,
          ),
          children: [
            TransactionInfoItem(
              title: 'Name:',
              value: customerName.isNotEmpty ? customerName : 'N/A',
            ),
            TransactionInfoItem(
              title: 'Email:',
              value: customerEmail.isNotEmpty ? customerEmail : 'N/A',
            ),
            TransactionInfoItem(
              title: 'Mobile:',
              value: customerMobile.isNotEmpty ? customerMobile : 'N/A',
            ),
          ],
        ),
      ),
    );
  }
}
