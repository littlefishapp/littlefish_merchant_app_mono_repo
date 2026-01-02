import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/circle_gradient_avatar.dart';
import 'package:littlefish_merchant/features/receipt_common/presentation/viewmodels/order_receipt_vm.dart';

class ReceiptSent extends StatelessWidget {
  final OrderReceiptVM vm;
  final String receiptType;
  const ReceiptSent({Key? key, required this.vm, required this.receiptType})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        vm.setHasReceiptSent!(false);
        Navigator.of(context).pop();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AnimatedContainer(
            alignment: Alignment.center,
            duration: const Duration(milliseconds: 300),
            child: OutlineGradientAvatar(
              radius: 80,
              child: Icon(
                Icons.check,
                color: Theme.of(context).extension<AppliedTextIcon>()?.brand,
                size: 80,
              ),
            ),
          ),
          const SizedBox(height: 16),
          context.paragraphMedium(
            '$receiptType Sent!',
            color: Theme.of(context).extension<AppliedTextIcon>()?.brand,
          ),
          const SizedBox(height: 4),
          context.paragraphMedium(
            'tap to close',
            color: Theme.of(context).extension<AppliedTextIcon>()?.brand,
          ),
        ],
      ),
    );
  }
}
