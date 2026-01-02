import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/enums.dart';

import '../../../../common/presentaion/components/icons/delete_icon.dart';

class OrderDiscountDiscardButton extends StatelessWidget {
  final Function() onDiscard;
  const OrderDiscountDiscardButton({super.key, required this.onDiscard});

  @override
  Widget build(BuildContext context) {
    return discardDiscountButton(context);
  }

  Widget discardDiscountButton(BuildContext context) {
    return Container(
      width: 32,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: IconButton(
        icon: const DeleteIcon(),
        color: Theme.of(context).colorScheme.error,
        onPressed: () async {
          final ModalService modalService = getIt<ModalService>();

          bool? discardSelectedDiscount = await modalService.showActionModal(
            context: context,
            title: 'Discard Discount',
            description:
                'Are you sure you want to remove the discount applied to your cart?',
            acceptText: 'Yes, Discard',
            cancelText: 'No, Cancel',
            status: StatusType.destructive,
          );
          if (discardSelectedDiscount == false) return;
          onDiscard();
        },
      ),
    );
  }
}
