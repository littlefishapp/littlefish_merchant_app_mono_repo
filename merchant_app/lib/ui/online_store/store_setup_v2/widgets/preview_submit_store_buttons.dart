// flutter imports
import 'package:flutter/material.dart';

// project imports
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';

class PreviewSubmitStoreButtons extends StatelessWidget {
  final String previewStore;
  final String submit;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final bool disabled;
  final bool showPreviewStoreButton;
  final bool showSubmitButton;

  const PreviewSubmitStoreButtons({
    Key? key,
    this.previewStore = 'Preview Store',
    this.submit = 'Submit',
    required this.onCancel,
    required this.onConfirm,
    this.disabled = false,
    this.showPreviewStoreButton = true,
    this.showSubmitButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showPreviewStoreButton)
          Expanded(
            flex: 1,
            child: ButtonSecondary(
              isNegative: true,
              text: previewStore,
              disabled: disabled,
              onTap: (_) async {
                if (!disabled) onCancel();
              },
            ),
          ),
        const SizedBox(width: 16),
        if (showSubmitButton)
          Expanded(
            flex: 1,
            child: ButtonPrimary(
              disabled: disabled,
              upperCase: false,
              text: submit,
              onTap: (_) async {
                if (!disabled) onConfirm();
              },
            ),
          ),
      ],
    );
  }
}
