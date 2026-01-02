// flutter imports
import 'package:flutter/material.dart';

// project imports
import 'package:littlefish_merchant/app/theme/typography.dart';

import '../../../../app/theme/applied_system/applied_surface.dart';
import '../../../../app/theme/applied_system/applied_text_icon.dart';

class TransactionStatusIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String message;

  const TransactionStatusIcon({
    Key? key,
    required this.icon,
    required this.color,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Theme.of(
            context,
          ).extension<AppliedSurface>()?.successSubTitle.withAlpha(67),
          radius: 62.0,
          child: CircleAvatar(
            backgroundColor: Theme.of(
              context,
            ).extension<AppliedTextIcon>()?.successAlt,
            radius: 48.0,
            child: Icon(icon, size: 64.0, color: color),
          ),
        ),
        const SizedBox(height: 16.0),
        context.headingXSmall(
          message,
          color: Theme.of(context).extension<AppliedTextIcon>()?.success,
          isBold: true,
        ),
      ],
    );
  }
}
