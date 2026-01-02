// removed ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quiver/strings.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({
    super.key,
    required this.category,
    required this.selected,
    required this.onTap,
    required this.onLongPress,
    required this.context,
    required this.item,
  });

  final StockCategory? category;
  final bool selected;
  final Function(StockProduct item)? onTap;
  final Function(StockProduct item)? onLongPress;
  final BuildContext context;
  final StockProduct item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      isThreeLine:
          (item.isOnline == true ||
              ((item.regularVariance?.lowQuantityValue ?? 10) >
                  item.regularItemQuantity)) &&
          category != null,
      dense: !EnvironmentProvider.instance.isLargeDisplay!,
      selected: selected,
      title: context.paragraphMedium('${item.displayName}'),
      leading: isNotBlank(item.imageUri)
          ? ListLeadingImageTile(url: item.imageUri)
          : ListLeadingIconTile(
              icon: item.productType == ProductType.physical
                  ? MdiIcons.tag
                  : MdiIcons.account,
            ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (category != null) LongText('${category!.displayName}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((item.regularVariance?.lowQuantityValue ?? 10) >
                  item.regularItemQuantity)
                Text('LOW STOCK', style: TextStyle(color: Colors.red.shade300)),
              if (AppVariables.store!.state.permissions!.manageOnline == true)
                if (item.isOnline == true &&
                    AppVariables.store!.state.storeState.storeIsLive)
                  Container(
                    margin: const EdgeInsets.only(left: 2),
                    child: LongText(
                      'ONLINE',
                      textColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
            ],
          ),
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          context.labelXSmall(
            'Stock: ${(item.quantity.toStringAsFixed(0))}',
            color: Theme.of(context).colorScheme.secondary,
            isBold: true,
          ),
        ],
      ),
      onTap: onTap == null
          ? null
          : () {
              if (onTap != null) onTap!(item);
            },
      onLongPress: () {
        if (onLongPress != null) onLongPress!(item);
      },
    );
  }
}
