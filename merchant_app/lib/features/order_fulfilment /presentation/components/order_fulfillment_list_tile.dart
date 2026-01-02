import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';

class OrderFulfillmentListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailingText;
  final VoidCallback onTap;

  const OrderFulfillmentListTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.trailingText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).extension<AppliedSurface>()?.brand,
        ),
        child: Center(
          child: Text(
            trailingText,
            style: TextStyle(
              color: Theme.of(
                context,
              ).extension<AppliedTextIcon>()?.inversePrimary,
            ),
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
