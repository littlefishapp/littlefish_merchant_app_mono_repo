import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/models/assets/app_assets.dart';

class LinkedDevicesTransactionFailedView extends StatelessWidget {
  const LinkedDevicesTransactionFailedView({
    super.key,
    required this.context,
    this.message,
  });

  final String? message;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final messageUsed = (message ?? '').isEmpty
        ? 'Transaction failed completion on the POS device.'
        : message!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            AppAssets.creditCardPng,
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: context.labelSmall(
              'Transaction failed completion on the POS device.',
              isBold: true,
              alignLeft: false,
            ),
          ),
        ],
      ),
    );
  }
}
