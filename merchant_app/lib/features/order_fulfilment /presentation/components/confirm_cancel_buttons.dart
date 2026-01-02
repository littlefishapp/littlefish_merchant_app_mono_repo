// flutter imports
import 'package:flutter/material.dart';

// project imports
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';

class ConfirmCancelButtons extends StatelessWidget {
  final String cancelText;
  final String confirmText;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final bool disabled;
  final bool showCancelButton;
  final bool showConfirmButton;
  final bool isNegative;

  const ConfirmCancelButtons({
    Key? key,
    this.cancelText = 'Cancel',
    this.confirmText = 'Confirm Order',
    required this.onCancel,
    required this.onConfirm,
    this.disabled = false,
    this.showCancelButton = true,
    this.showConfirmButton = true,
    this.isNegative = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showCancelButton)
          Expanded(
            flex: 1,
            child: ButtonSecondary(
              isNegative: isNegative,
              text: cancelText,
              disabled: disabled,
              onTap: (_) async {
                if (!disabled) onCancel();
              },
            ),
          ),
        const SizedBox(width: 16),
        if (showConfirmButton)
          Expanded(
            flex: 1,
            child: ButtonPrimary(
              disabled: disabled,
              upperCase: false,
              text: confirmText,
              onTap: (_) async {
                if (!disabled) onConfirm();
              },
            ),
          ),
      ],
    );
  }
}
