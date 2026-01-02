// flutter imports
import 'package:flutter/material.dart';

// project imports
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/enums.dart';

import '../../../../common/presentaion/components/icons/delete_icon.dart';

class DiscardDialogActionButton extends StatelessWidget {
  final void Function(bool shouldDiscard) onTap;
  final String dialogContent, dialogTitle;

  const DiscardDialogActionButton({
    super.key,
    required this.onTap,
    required this.dialogContent,
    required this.dialogTitle,
  });

  @override
  Widget build(BuildContext context) {
    return _discardButton(context);
  }

  Widget _discardButton(BuildContext context) {
    return Container(
      width: 32,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: IconButton(
        icon: const DeleteIcon(),
        onPressed: () async {
          final ModalService modalService = getIt<ModalService>();

          bool? discardSelectedDiscount = await modalService.showActionModal(
            context: context,
            title: dialogTitle,
            description: dialogContent,
            acceptText: 'Discard',
            cancelText: 'Cancel',
            status: StatusType.destructive,
          );

          onTap(discardSelectedDiscount ?? false);
        },
      ),
    );
  }
}
