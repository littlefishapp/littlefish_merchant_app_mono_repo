// remove ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/shared/constants/semantics_constants.dart';

import '../icon_text_tile.dart';
import '../icons/delete_icon.dart';

class ButtonDiscard extends StatefulWidget {
  final Color? backgroundColor;
  final Color? iconColor;
  final bool? isIconButton, enablePopPage;
  final IconData? iconData;
  final Color? borderColor;
  final Function(BuildContext context)? onDiscard;
  final String modalTitle;
  final String modalDescription;
  final String modalAcceptText;
  final String modalCancelText;
  final String discardTileText;

  const ButtonDiscard({
    Key? key,
    required this.isIconButton,
    this.backgroundColor,
    this.iconColor,
    this.iconData,
    this.enablePopPage = false,
    this.borderColor,
    this.onDiscard,
    this.modalTitle = 'Discard Sale',
    this.modalDescription =
        'Would you like to discard your current sale?'
        '\n\nThis will clear your cart and you will lose your progress.',
    this.modalAcceptText = 'Yes, Discard',
    this.modalCancelText = 'No, Cancel',
    this.discardTileText = 'Discard Sale',
  }) : super(key: key);

  @override
  State<ButtonDiscard> createState() => _ButtonDiscardState();
}

class _ButtonDiscardState extends State<ButtonDiscard> {
  @override
  Widget build(BuildContext context) {
    return widget.isIconButton == true
        ? Semantics(
            identifier: SemanticsConstants.kDiscard,
            label: SemanticsConstants.kDiscard,
            child: IconButton(
              onPressed: widget.onDiscard == null
                  ? null
                  : () async {
                      discardFunction();
                    },
              icon: const DeleteIcon(),
            ),
          )
        : discardTileButton();
  }

  Widget discardTileButton() {
    return IconTextTile(
      icon: Icon(
        widget.iconData ?? Icons.cancel_outlined,
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
      ),
      text: context.paragraphMedium(widget.discardTileText),
      onTap: widget.onDiscard == null
          ? null
          : () async {
              discardFunction();
            },
    );
  }

  discardFunction() async {
    final modalService = getIt<ModalService>();

    bool? isAccepted = await modalService.showActionModal(
      status: StatusType.destructive,
      title: widget.modalTitle,
      context: context,
      description: widget.modalDescription,
      acceptText: widget.modalAcceptText,
      cancelText: widget.modalCancelText,
    );

    if (isAccepted == true) {
      if (widget.enablePopPage == true) {
        if (widget.onDiscard != null) {
          widget.onDiscard!(context);
          return;
        }
        Navigator.of(context).pop();
      }
    }
  }
}
