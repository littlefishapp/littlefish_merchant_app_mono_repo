// flutter imports
import 'package:flutter/material.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

// project imports
import 'package:littlefish_merchant/app/theme/typography.dart';

class ShowError extends StatelessWidget {
  final String message;
  final IconData? iconData;
  final String details;
  final EdgeInsetsGeometry detailsPadding;
  const ShowError({
    super.key,
    this.message = 'Something went wrong, please try again.',
    this.iconData,
    this.details = '',
    this.detailsPadding = const EdgeInsets.symmetric(vertical: 8.0),
  });

  @override
  Widget build(BuildContext context) {
    final icon = iconData ?? LittleFishIcons.error;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48),
          const SizedBox(height: 16),
          context.labelLarge(message, isSemiBold: true),
          if (details.isNotEmpty)
            Padding(
              padding: detailsPadding,
              child: context.paragraphMedium(details),
            ),
        ],
      ),
    );
  }
}
