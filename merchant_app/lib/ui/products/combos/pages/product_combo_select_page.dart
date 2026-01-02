// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/ui/products/combos/widgets/product_combo_list.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';

class ProductComboSelectPage extends StatelessWidget {
  const ProductComboSelectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return scaffold(context);
  }

  AppSimpleAppScaffold scaffold(context) => AppSimpleAppScaffold(
    title: 'Select Combo',
    body: ProductComboList(
      onTap: (item) {
        Navigator.of(context).pop(item);
      },
    ),
  );
}
