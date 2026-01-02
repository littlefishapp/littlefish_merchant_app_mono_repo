// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/components/cards/card_square_flat.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/product_stock_tile.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/products_list.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/products_low_stock_list.dart';

class HomeLowStockCard extends StatelessWidget {
  List<StockProduct>? get products =>
      AppVariables.store!.state.productState.lowStockProducts?.take(3).toList();

  const HomeLowStockCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return item(context);
  }

  Widget item(BuildContext context) {
    int lowCount =
        AppVariables.store!.state.productState.lowStockProducts?.length ?? 0;

    return CardSquareFlat(
      margin: EdgeInsets.zero,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        // height: 284,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: context.labelXSmall('Stock & Inventory', alignLeft: true),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: context.headingXSmall(
                '$lowCount Products Low',
                isBold: true,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: context.labelXSmall('Items Running Low', isBold: true),
            ),
            products == null || (products?.isEmpty ?? true)
                ? const Center(child: Text('No Low Stock Items'))
                : ListView(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: products!
                        .map(
                          (item) =>
                              ProductStockTile(item: item, onTap: (item) {}),
                        )
                        .toList(),
                  ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: ButtonSecondary(
                buttonTextSize: PrimaryButtonTextSize.small,
                text: 'View Items',
                onTap: (_) => showDialog(
                  context: context,
                  barrierDismissible: true,
                  useSafeArea: true,
                  builder: (cx) => Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    child: ProductsLowStockList(
                      viewMode: ProductViewMode.stockView,
                      parentContext: context,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
