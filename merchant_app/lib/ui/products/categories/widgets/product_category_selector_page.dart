import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/ui/products/categories/widgets/product_category_selector_page_list.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';

import '../../../../models/stock/stock_category.dart';
import '../view_models/category_item_vm.dart';

class CategoryProductSelectPage extends StatefulWidget {
  final bool isEmbedded;
  final Function(String)? callback;

  final String? categoryId;

  final CategoryViewModel? vm;

  final StockCategory? category;

  final bool canAddNew;

  const CategoryProductSelectPage({
    Key? key,
    this.callback,
    this.isEmbedded = false,
    this.categoryId,
    this.canAddNew = false,
    this.vm,
    this.category,
  }) : super(key: key);

  @override
  State<CategoryProductSelectPage> createState() =>
      _CategoryProductSelectPage();
}

class _CategoryProductSelectPage extends State<CategoryProductSelectPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return scaffold(context);
  }

  AppSimpleAppScaffold scaffold(context) => AppSimpleAppScaffold(
    // vm: widget.vm,
    // category: widget.category,
    // parentContext: context,
    // parentparentContext: context,
    title: 'Select Product',
    isEmbedded: false,
    body: CategoryProductsList(
      canAddNew: widget.canAddNew,
      categoryId: widget.categoryId,
      onTap: (item) {
        Navigator.of(context).pop(item);
      },
      callback: widget.callback!,
    ),
  );
}
