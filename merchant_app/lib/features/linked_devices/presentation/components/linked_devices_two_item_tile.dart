import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

class LinkedDevicesTwoItemTile extends StatelessWidget {
  const LinkedDevicesTwoItemTile({
    super.key,
    required this.context,
    required this.leading,
    required this.trailing,
  });

  final BuildContext context;
  final String leading;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          context.labelSmall(
            leading,
            alignLeft: true,
            color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: context.labelSmall(
              trailing,
              alignRight: true,
              alignLeft: false,
              // isSemiBold: true,
              overflow: TextOverflow.ellipsis,
              color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
            ),
          ),
        ],
      ),
    );
  }
}
