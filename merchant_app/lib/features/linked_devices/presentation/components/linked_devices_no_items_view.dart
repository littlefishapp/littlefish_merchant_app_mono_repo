import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/icons/warning_icon.dart';

class LinkedDevicesNoItemsView extends StatelessWidget {
  const LinkedDevicesNoItemsView({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const WarningIcon(),
          const SizedBox(height: 16),
          context.labelSmall('No terminals found', isBold: true),
        ],
      ),
    );
  }
}
