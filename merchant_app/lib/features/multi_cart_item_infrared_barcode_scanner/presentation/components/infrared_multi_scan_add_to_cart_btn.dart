import 'package:flutter/material.dart';

import '../../../../common/presentaion/components/buttons/button_primary.dart';
import '../../data/multi_item_infrared_barcode_scanner.dart';

class InfraredMultiScanAddToCartBtn extends StatelessWidget {
  final MultiCartItemInfraBarcodeScanner vm;

  const InfraredMultiScanAddToCartBtn(this.vm, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ButtonPrimary(
        upperCase: false,
        text: 'Add to Cart',
        onTap: (ctx) {
          debugPrint('### Scanner InfraredMultiScanAddToCartBtn add to cart');
          vm.addToCart(context: ctx);
        },
      ),
    );
  }
}
