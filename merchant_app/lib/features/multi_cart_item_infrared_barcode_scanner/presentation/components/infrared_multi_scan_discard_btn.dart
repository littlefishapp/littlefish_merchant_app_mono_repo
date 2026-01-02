import 'package:flutter/material.dart';

import '../../../../common/presentaion/components/icons/delete_icon.dart';
import '../../data/multi_item_infrared_barcode_scanner.dart';

class InfraredMultiScanDiscardBtn extends StatelessWidget {
  final MultiCartItemInfraBarcodeScanner vm;

  const InfraredMultiScanDiscardBtn(this.vm, {super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        vm.dismissScanner!();
      },
      icon: const DeleteIcon(),
    );
  }
}
