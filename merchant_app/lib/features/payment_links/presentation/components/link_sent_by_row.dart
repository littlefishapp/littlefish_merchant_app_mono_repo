import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

class LinkSentByRow extends StatelessWidget {
  final bool sentBySms;
  final bool sentByEmail;

  const LinkSentByRow({
    super.key,
    this.sentBySms = true,
    this.sentByEmail = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        context.labelSmall('Link Sent By:', isBold: true),
        Row(
          children: [
            if (sentBySms) _sentBox(label: 'SMS', context: context),
            const SizedBox(width: 8),
            if (sentByEmail) _sentBox(label: 'Email', context: context),
          ],
        ),
      ],
    );
  }

  Widget _sentBox({required String label, required BuildContext context}) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(Icons.check, size: 14, color: Colors.white),
        ),
        const SizedBox(width: 6),
        context.labelSmall(
          label,
          isBold: false,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ],
    );
  }
}
