// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/models/products/product_combo.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';

class ProductComboSummary extends StatelessWidget {
  final ProductCombo? item;

  const ProductComboSummary({Key? key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var markup = item!.totalItems > 0
        ? 100 - ((item!.comboCostPrice / item!.comboSellingPrice) * 100).round()
        : 0;

    return comboSummary(context, markup);
  }

  Widget comboSummary(context, int markup) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        summaryItem('Total Combo Cost', item!.comboCostPrice),
        summaryItem('Total Combo Discount', item!.comboSaving),
        summaryItem('Combo Price', item!.comboSellingPrice),
      ],
    );
  }

  Column summaryItem(String title, double value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DecoratedText(
          title,
          alignment: Alignment.center,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 4),
        DecoratedText(
          TextFormatter.toStringCurrency(value, currencyCode: ''),
          alignment: Alignment.center,
        ),
      ],
    );
  }
}
