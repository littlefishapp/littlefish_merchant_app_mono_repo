import 'package:littlefish_merchant/app/theme/typography.dart';

import '../../../../app/app.dart';
import '../../../../common/presentaion/components/buttons/button_primary.dart';
import '../../../../common/presentaion/components/cards/card_square_flat.dart';
import 'package:flutter/material.dart';

import '../../../../tools/textformatter.dart';
import '../../../order_common/data/model/order.dart';

class PaymentLinkPreviewTab extends StatelessWidget {
  final Order link;

  const PaymentLinkPreviewTab({super.key, required this.link});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          context.headingLarge(
            'Hi ${link.customer?.firstName}! ${AppVariables.store?.state.businessState.profile?.name} sent you a payment link.',
            isBold: false,
          ),
          const SizedBox(height: 24),
          CardSquareFlat(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                children: [
                  context.headingMedium(
                    TextFormatter.toStringCurrency(link.totalPrice),
                    isBold: true,
                  ),
                  const SizedBox(height: 32),
                  context.labelSmall(link.note, isBold: false),
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
