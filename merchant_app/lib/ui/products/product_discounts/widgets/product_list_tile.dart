import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:quiver/strings.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/ui/products/product_discounts/view_models/product_discount_vm.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../common/presentaion/components/icons/delete_icon.dart';
import '../../../../common/presentaion/components/icons/warning_icon.dart';

class ProductListTile extends StatelessWidget {
  final bool isDismissable;

  final StockProduct? item;
  final ProductDiscountVM? vm;

  final bool selected;

  final Function(StockProduct item, StockCategory category)? onTap;

  final Function(StockProduct item)? onRemove;

  final int productCount;

  const ProductListTile({
    Key? key,
    required this.item,
    this.vm,
    this.onTap,
    this.isDismissable = false,
    this.onRemove,
    this.selected = false,
    this.productCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isDismissable
        ? dismissibleProductTile(context, item!, vm!)
        : productTile(context, item!, true, vm!);
  }

  //Not in use anymore
  dismissibleProductTile(
    BuildContext context,
    StockProduct item,
    ProductDiscountVM vm,
  ) => Slidable(
    child: productTile(context, item, true, vm),
    key: Key(item.id!),
    endActionPane: ActionPane(
      extentRatio: .25,
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (ctx) async {
            var result = await confirmDismissal(context, null);

            if (result == true) {
              onRemove!(item);
            }
          },
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
      ],
    ),
  );

  productTile(
    BuildContext context,
    StockProduct item,
    bool isTap,
    ProductDiscountVM vm,
  ) => Container(
    padding: const EdgeInsets.only(left: 16),
    height: 88,
    child: ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      contentPadding: EdgeInsets.zero,
      dense: true,
      selected: selected,
      title: Text(
        '${item.displayName}',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      leading: isNotBlank(item.imageUri)
          ? ListLeadingImageTile(width: 56, height: 56, url: item.imageUri)
          : ListLeadingIconTile(
              width: 56,
              height: 72,
              icon: item.productType == ProductType.physical
                  ? MdiIcons.tag
                  : MdiIcons.account,
            ),
      subtitle: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            NumberFormat.currency(
              locale: 'en_ZA', // Use the appropriate locale for your currency
              symbol: 'R',
              decimalDigits: 2,
            ).format(item.regularPrice!),
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          if ((item.regularVariance?.lowQuantityValue ?? 10) >
              item.regularItemQuantity)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(' • ', style: TextStyle(color: Colors.grey.shade800)),
                const WarningIcon(size: 12),
                Text(
                  ' LOW STOCK',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error.withOpacity(.5),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
        ],
      ),
      trailing: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LongText(
              'Stock: ${(item.quantity.toStringAsFixed(0))}',
              fontSize: 12,
            ),
          ],
        ),
      ),
      onTap: () {
        if (isTap) {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            builder: (ctx) => SafeArea(
              top: false,
              bottom: true,
              child: SizedBox(
                height: 164,
                child: productEdit(context, item, vm),
              ),
            ),
          );
        }
      },
    ),
  );

  productEdit(BuildContext context, StockProduct item, ProductDiscountVM vm) =>
      Column(
        children: [
          const SizedBox(height: 20),
          productTile(context, item, false, vm),
          ListTile(
            tileColor: Theme.of(context).colorScheme.background,
            trailing: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: DeleteIcon(),
            ),
            title: const Text('Remove from Discount'),
            onTap: () {
              Navigator.of(context).pop(item);
              onRemove!(item);
            },
          ),
        ],
      );
}
