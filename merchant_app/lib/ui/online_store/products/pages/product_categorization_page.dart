import 'package:flutter/material.dart';
import 'package:littlefish_merchant/ui/online_store/products/pages/product_categories/product_category_list.dart';
import 'package:quiver/strings.dart';

import '../../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';

class ProductCategorizationPage extends StatefulWidget {
  final StoreProduct? item;
  final StoreProductCategory? baseCategory;
  const ProductCategorizationPage({
    Key? key,
    required this.item,
    this.baseCategory,
  }) : super(key: key);

  @override
  State<ProductCategorizationPage> createState() =>
      _ProductCategorizationPageState();
}

class _ProductCategorizationPageState extends State<ProductCategorizationPage> {
  StoreProductCategory? _baseCategory;
  StoreProduct? _item;

  @override
  void initState() {
    _item = widget.item;
    _baseCategory = widget.baseCategory;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }

  ListView body() => ListView(
    children: <Widget>[
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: const Text(
          'Categorize your product, make it easier to find',
          style: TextStyle(fontSize: 16),
        ),
      ),
      const SizedBox(height: 16),
      Material(
        child: ListTile(
          tileColor: Theme.of(context).colorScheme.background,
          title: Text(_item!.baseCategory ?? 'Choose Category'),
          subtitle: const Text('Base Category'),
          trailing: isNotBlank(_item!.baseCategory)
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    if (mounted) {
                      setState(() {
                        _item!.subCategories = [];
                        _item!.baseCategory = null;
                        _item!.baseCategoryId = null;
                        _baseCategory = null;
                      });
                    }
                  },
                )
              : null,
          onTap: () {
            showPopupDialog(
              context: context,
              content: ProductCategoryList(
                canAddNew: false,
                onTap: (res) {
                  if (mounted) {
                    setState(() {
                      _item!.subCategories = [];
                      _item!.baseCategory = res.displayName;
                      _item!.baseCategoryId = res.id;
                      _baseCategory = res;
                    });
                    Navigator.of(context).pop();
                  }
                },
              ),
            );
          },
        ),
      ),
      if (_baseCategory != null && (_baseCategory?.productTypeCount ?? 0) > 0)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: const Text('Select any related sub categories'),
        ),
      if (_baseCategory != null)
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children:
              _baseCategory!.subCategories
                  ?.map(
                    (e) => CheckboxListTile(
                      title: Text(e.displayName!),
                      subtitle: isBlank(e.description)
                          ? null
                          : Text(e.description!),
                      onChanged: (bool? value) {
                        if (value!) {
                          _item!.subCategories!.add(e.categoryId!);
                        } else {
                          _item!.subCategories!.removeWhere(
                            (element) => element == e.categoryId,
                          );
                        }

                        if (mounted) setState(() {});
                      },
                      value: _item!.subCategories!.contains(e.categoryId),
                    ),
                  )
                  .toList() ??
              [],
        ),
    ],
  );
}
