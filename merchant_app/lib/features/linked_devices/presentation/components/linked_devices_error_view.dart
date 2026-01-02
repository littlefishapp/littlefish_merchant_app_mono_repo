import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/icons/error_icon.dart';

class LinkedDevicesErrorView extends StatelessWidget {
  const LinkedDevicesErrorView({
    super.key,
    required this.context,
    this.message,
  });

  final String? message;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const ErrorIcon(),
          const SizedBox(height: 16),
          context.labelSmall(
            message ?? 'An error occurred while fetching terminals',
            isBold: true,
          ),
        ],
      ),
    );
  }
}
