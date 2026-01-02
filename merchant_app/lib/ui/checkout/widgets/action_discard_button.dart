import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_actions.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_merchant/models/enums.dart';

import '../../../common/presentaion/components/icons/delete_icon.dart';

class ActionDiscardButton extends StatefulWidget {
  final CheckoutActionType actionType;
  final CheckoutVM vm;

  const ActionDiscardButton({
    required this.actionType,
    required this.vm,
    Key? key,
  }) : super(key: key);

  @override
  State<ActionDiscardButton> createState() => _ActionDiscardButtonState();
}

class _ActionDiscardButtonState extends State<ActionDiscardButton> {
  @override
  Widget build(BuildContext context) {
    switch (widget.actionType) {
      case CheckoutActionType.cashback:
        return discardActionButton(
          context: context,
          vm: widget.vm,
          onTap: () {
            if (mounted) {
              setState(() {
                widget.vm.store?.dispatch(
                  CheckoutSetCurrentActionAmount(Decimal.zero),
                );
                widget.vm.store?.dispatch(
                  CheckoutSetCashbackAmountAction(Decimal.zero),
                );
              });
            }
          },
          dialogTitle: 'Discard Cashback',
          dialogContent: 'Are you sure you want to remove the cashback?',
        );
      case CheckoutActionType.withdrawal:
        return discardActionButton(
          context: context,
          vm: widget.vm,
          onTap: () {
            if (mounted) {
              setState(() {
                widget.vm.store?.dispatch(
                  CheckoutSetCurrentActionAmount(Decimal.zero),
                );
                widget.vm.store?.dispatch(
                  CheckoutSetWithdrawalAmountAction(Decimal.zero),
                );
              });
            }
          },
          dialogTitle: 'Discard Cash Withdrawal',
          dialogContent: 'Are you sure you want to remove the cash withdrawal?',
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget discardActionButton({
    required BuildContext context,
    required CheckoutVM vm,
    required VoidCallback onTap,
    required String dialogContent,
    required String dialogTitle,
  }) {
    return Container(
      width: 32,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: IconButton(
        icon: const DeleteIcon(),
        color: Theme.of(context).colorScheme.primary,
        onPressed: () async {
          final ModalService modalService = getIt<ModalService>();

          bool? discardSelectedDiscount = await modalService.showActionModal(
            context: context,
            title: dialogTitle,
            description: dialogContent,
          );

          if (discardSelectedDiscount == false) return;

          if (mounted) {
            setState(() {
              onTap();
            });
          }
        },
      ),
    );
  }
}
