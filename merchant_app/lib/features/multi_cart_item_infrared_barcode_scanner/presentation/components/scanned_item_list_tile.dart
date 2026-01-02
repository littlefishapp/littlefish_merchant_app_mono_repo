import 'package:flutter/material.dart';
import 'package:littlefish_merchant/features/multi_cart_item_infrared_barcode_scanner/data/multi_item_infrared_barcode_scanner.dart';

import '../../../../models/stock/stock_product.dart';

class ScannedItemListTile extends StatelessWidget {
  const ScannedItemListTile({
    super.key,
    required this.vm,
    required this.context,
    required this.item,
  });

  final MultiCartItemInfraBarcodeScanner vm;
  final BuildContext context;
  final StockProduct item;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0),
          child: vm.returnListItemWidget(context: context, item: item),
        ),
      ],
    );
  }
}
