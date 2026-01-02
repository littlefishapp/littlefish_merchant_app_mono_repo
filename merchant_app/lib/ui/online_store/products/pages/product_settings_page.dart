import 'package:flutter/material.dart';

import '../../../../features/ecommerce_shared/models/store/store_product.dart';

class ProductSettingsPage extends StatefulWidget {
  final StoreProduct? item;

  const ProductSettingsPage({Key? key, required this.item}) : super(key: key);

  @override
  State<ProductSettingsPage> createState() => _ProductSettingsPageState();
}

class _ProductSettingsPageState extends State<ProductSettingsPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.item!.productSettings == null) {
      widget.item!.productSettings = StoreProductSettings.defaults();
    }

    return ListView(
      children: <Widget>[
        CheckboxListTile(
          title: const Text('Allow Reviews'),
          subtitle: const Text('Allow Reviews'),
          value: widget.item!.productSettings!.allowReview,
          onChanged: (value) {
            widget.item!.productSettings!.allowReview = value;
            _rebuild(context);
          },
        ),
        CheckboxListTile(
          title: const Text('Allow Comments'),
          subtitle: const Text('Allow Comments'),
          value: widget.item!.productSettings!.allowComments,
          onChanged: (value) {
            widget.item!.productSettings!.allowComments = value;
            _rebuild(context);
          },
        ),
        CheckboxListTile(
          title: const Text('Allow Wishlist'),
          subtitle: const Text('Allow Wishlist'),
          value: widget.item!.productSettings!.allowWishList,
          onChanged: (value) {
            widget.item!.productSettings!.allowWishList = value;
            _rebuild(context);
          },
        ),
        CheckboxListTile(
          title: const Text('Track Views'),
          subtitle: const Text('Track Views'),
          value: widget.item!.productSettings!.trackViews,
          onChanged: (value) {
            widget.item!.productSettings!.trackViews = value;
            _rebuild(context);
          },
        ),
        CheckboxListTile(
          title: const Text('Track Stock'),
          subtitle: const Text('Track Stock'),
          value: widget.item!.productSettings!.showInStock,
          onChanged: (value) {
            widget.item!.productSettings!.showInStock = value;
            _rebuild(context);
          },
        ),
        if ((widget.item!.productSettings!.showInStock ?? false))
          CheckboxListTile(
            title: const Text('Show In Stock'),
            subtitle: const Text('Show In Stock'),
            value: widget.item!.inStock,
            onChanged: (value) {
              widget.item!.inStock = value;
              _rebuild(context);
            },
          ),
      ],
    );
  }

  _rebuild(context) {
    if (mounted) setState(() {});
  }
}
