import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/toggle_switch.dart';

class TextAndToggleRow extends StatelessWidget {
  const TextAndToggleRow({
    super.key,
    required this.leading,
    required this.initialValue,
    required this.onChanged,
    this.forceRefresh = true,
  });

  final String leading;
  final bool initialValue, forceRefresh;
  final Function(bool value) onChanged;

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
          ToggleSwitch(
            initiallyEnabled: initialValue,
            enabledColor: Theme.of(context).extension<AppliedTextIcon>()?.brand,
            onChanged: onChanged,
            forceRefresh: forceRefresh,
          ),
        ],
      ),
    );
  }
}
