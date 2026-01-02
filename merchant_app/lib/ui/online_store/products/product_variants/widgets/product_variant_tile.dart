import 'package:flutter/material.dart';
import 'package:littlefish_merchant/ui/online_store/common/config.dart';

import '../../../../../common/presentaion/components/icons/delete_icon.dart';
import '../../../../../features/ecommerce_shared/models/store/store_product.dart';

class ProductVariantTile extends StatefulWidget {
  final ProductVariant productVariant;
  final Function onTap;
  final Function onRemove;

  const ProductVariantTile({
    Key? key,
    required this.productVariant,
    required this.onTap,
    required this.onRemove,
  }) : super(key: key);

  @override
  State<ProductVariantTile> createState() => _ProductVariantTileState();
}

class _ProductVariantTileState extends State<ProductVariantTile> {
  @override
  Widget build(BuildContext context) {
    return itemTile();
  }

  ListTile itemTile() => ListTile(
    tileColor: Theme.of(context).colorScheme.background,
    onTap: () {
      widget.onTap();
    },
    trailing: IconButton(
      icon: const DeleteIcon(),
      onPressed: () {
        widget.onRemove();
      },
    ),
    leading: Material(
      elevation: 2.0,
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(kBorderRadius!),
      child: Container(
        alignment: Alignment.center,
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kBorderRadius!),
        ),
        child: Text(
          '${widget.productVariant.products!.length}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    ),
    // title: Text("${widget.product.name}"),
  );
}
