import 'package:flutter/material.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/square_icon_button_secondary.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/shared/constants/semantics_constants.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';

import '../icon_text_tile.dart';

class DiscardSaleButton extends StatefulWidget {
  final CheckoutVM? checkoutVM;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool? isIconButton, enablePopPage;
  final IconData? iconData;
  final Color? borderColor;
  final bool enabled;

  const DiscardSaleButton({
    Key? key,
    required this.checkoutVM,
    required this.isIconButton,
    this.backgroundColor,
    this.iconColor,
    this.iconData,
    this.enablePopPage = false,
    this.borderColor,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<DiscardSaleButton> createState() => _DiscardSaleButtonState();
}

class _DiscardSaleButtonState extends State<DiscardSaleButton> {
  @override
  Widget build(BuildContext context) {
    return widget.isIconButton == true
        ? Semantics(
            identifier: SemanticsConstants.kEmptyCart,
            label: SemanticsConstants.kEmptyCart,
            child: SquareIconButtonSecondary(
              icon: Icons.delete_outline,
              isNegative: widget.enabled ? true : false,
              isNeutral: widget.enabled ? false : true,
              onPressed: (ctx) async {
                if ((widget.checkoutVM?.itemCount ?? 0) <= 0) {
                  showMessageDialog(
                    ctx,
                    'The cart is empty, please add items to your cart',
                    LittleFishIcons.info,
                  );
                  return;
                }

                await discardFunction();
              },
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
      text: context.paragraphMedium('Discard Sale'),
      onTap: () async {
        discardFunction();
      },
    );
  }

  Future<void> discardFunction() async {
    final modalService = getIt<ModalService>();

    bool? isAccepted = await modalService.showActionModal(
      context: context,
      title: 'Delete Sale?',
      description:
          'Are you sure you want to discard your current sale? This cannot be undone.',
      acceptText: 'Yes, Delete Sale',
      cancelText: 'No, Cancel',
      status: StatusType.destructive,
    );

    if (isAccepted == true) {
      widget.checkoutVM?.onClear();
    }
    if (widget.enablePopPage == true && context.mounted) {
      // removed ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
  }
}
