// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';

class ProductExpansionTile extends StatelessWidget {
  final StockProduct? item;

  const ProductExpansionTile({Key? key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return productDetails(context);
  }

  ExpansionTile productDetails(context) => ExpansionTile(
    title: Text(
      "${item!.displayName} - ${TextFormatter.toStringCurrency(item!.regularCostPrice, currencyCode: '')}",
    ),
    children: <Widget>[
      productDetailTile(
        context,
        item!.displayName!,
        'Product Name',
        Icons.pregnant_woman,
      ),
      const CommonDivider(),
      productDetailTile(
        context,
        item!.regularVariance!.name!,
        'Variant',
        Icons.pregnant_woman,
      ),
      const CommonDivider(),
      productDetailTile(
        context,
        TextFormatter.toStringCurrency(
          item!.regularCostPrice,
          currencyCode: '',
        ),
        'Current Unit Cost',
        Icons.pregnant_woman,
      ),
      const CommonDivider(),
      productDetailTile(
        context,
        (item!.quantity).floor().toString(),
        'Cost Unit Count',
        Icons.pregnant_woman,
      ),
      const CommonDivider(),
    ],
  );

  ListTile productDetailTile(
    context,
    String title,
    String description,
    IconData icon,
  ) => ListTile(
    tileColor: Theme.of(context).colorScheme.background,
    dense: true,
    title: DecoratedText(
      description,
      fontSize: null,
      textColor: Theme.of(context).colorScheme.secondary,
    ),
    trailing: Text(
      title,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        // fontWeight: FontWeight.bold,
      ),
    ),
  );
}
