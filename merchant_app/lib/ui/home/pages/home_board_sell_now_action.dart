// Flutter imports:

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/models/security/access_management/module.dart';

import '../../../app/theme/applied_system/applied_text_icon.dart';

class HomeBoardSellNowAction extends StatelessWidget {
  const HomeBoardSellNowAction({
    super.key,
    required this.context,
    required this.action,
  });

  final BuildContext context;
  final ModuleAction action;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: (action.route != null)
              ? () => Navigator.of(context).pushNamed(action.route!)
              : () {
                  if (action.action != null) {
                    action.action!(context);
                  }
                },
          child: Material(
            borderRadius: BorderRadius.circular(4),
            elevation: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Theme.of(context).extension<AppliedTextIcon>()?.brand,
              ),
              child: Icon(
                action.icon,
                color: Theme.of(context).extension<AppliedSurface>()?.brand,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          action.name!,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
          ),
        ),
      ],
    );
  }
}
