import 'package:flutter/widgets.dart';

import '../../../../common/presentaion/components/buttons/button_secondary.dart';
import '../../data/multi_item_infrared_barcode_scanner.dart';

class InfraredMultiScanCancelBtn extends StatelessWidget {
  final MultiCartItemInfraBarcodeScanner vm;

  const InfraredMultiScanCancelBtn(this.vm, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ButtonSecondary(
        text: 'Cancel',
        onTap: (context) async {
          debugPrint('### Scanner InfraredMultiScanCancelBtn cancel');
          await vm.cancelScan(context: context);
        },
      ),
    );
  }
}
