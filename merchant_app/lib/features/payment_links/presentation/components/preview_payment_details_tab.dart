// Flutter imports
import 'package:flutter/material.dart';

// Project imports
import 'package:littlefish_merchant/app/theme/typography.dart';

import '../../../../app/app.dart';
import '../../../../common/presentaion/components/buttons/button_primary.dart';
import '../../../../common/presentaion/components/cards/card_square_flat.dart';

class PreviewPaymentDetailsTab extends StatelessWidget {
  final TextEditingController linkNameController;
  final TextEditingController descriptionController;
  final TextEditingController amountDueController;
  final TextEditingController customerNameController;

  const PreviewPaymentDetailsTab({
    super.key,
    required this.linkNameController,
    required this.descriptionController,
    required this.amountDueController,
    required this.customerNameController,
  });

  @override
  Widget build(BuildContext context) {
    final amount = amountDueController.text;
    final description = linkNameController.text;
    final note = descriptionController.text;
    final customerName = customerNameController.text;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          context.headingLarge(
            'Hi $customerName! ${AppVariables.store?.state.businessState.profile?.name} sent you a payment link.',
            isBold: false,
          ),
          const SizedBox(height: 24),
          CardSquareFlat(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                children: [
                  context.headingMedium(
                    'R${amount.isEmpty ? '0.00' : amount}',
                    isBold: true,
                  ),
                  const SizedBox(height: 32),
                  context.labelSmall(
                    description.isEmpty ? 'Payment Description' : description,
                    isBold: true,
                  ),
                  const SizedBox(height: 6),
                  context.labelSmall(
                    note.isEmpty ? 'No additional notes provided.' : note,
                    isBold: false,
                  ),
                  const SizedBox(height: 8),
                  ButtonPrimary(text: 'PAY NOW', onTap: (context) async {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
