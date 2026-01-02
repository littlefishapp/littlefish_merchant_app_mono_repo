// flutter imports
import 'package:flutter/material.dart';

// project imports
import '../../../../../tools/textformatter.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

import '../../../../app/theme/applied_system/applied_text_icon.dart';

class TransactionSummaryRow extends StatelessWidget {
  final String title;
  final double amount;
  final String amountPrefix;
  final bool isBold;
  const TransactionSummaryRow({
    super.key,
    required this.title,
    required this.amount,
    this.amountPrefix = '',
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          context.labelXSmall(
            title,
            color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
            isSemiBold: isBold,
          ),
          context.labelXSmall(
            TextFormatter.toStringCurrency(amount),
            color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
          ),
        ],
      ),
    );
  }
}
