// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/ui/products/products/widgets/products_list.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';

class ProductSelectPage extends StatefulWidget {
  final bool isEmbedded;

  final bool isOnlyTrackableStock;

  final String? categoryId;

  final bool canAddNew;

  const ProductSelectPage({
    Key? key,
    this.isEmbedded = false,
    this.isOnlyTrackableStock = false,
    this.categoryId,
    this.canAddNew = false,
  }) : super(key: key);

  @override
  State<ProductSelectPage> createState() => _ProductSelectPageState();
}

class _ProductSelectPageState extends State<ProductSelectPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return scaffold(context);
  }

  AppSimpleAppScaffold scaffold(context) => AppSimpleAppScaffold(
    title: 'Select Product',
    isEmbedded: widget.isEmbedded,
    body: ProductsList(
      isOnlyTrackableStock: widget.isOnlyTrackableStock,
      isStockListing: true,
      canAddNew: widget.canAddNew,
      categoryId: widget.categoryId,
      onTap: (item) {
        Navigator.of(context).pop(item);
      },
    ),
  );
}
