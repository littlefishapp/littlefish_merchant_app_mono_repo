// Flutter imports:

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/models/security/access_management/module.dart';

class HomeBoardOverviewAction extends StatelessWidget {
  const HomeBoardOverviewAction({
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
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Icon(
                action.icon,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          action.name!,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
