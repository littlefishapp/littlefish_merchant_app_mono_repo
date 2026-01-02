// removed ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/ui/products/products/view_models/product_collection_vm.dart';

import '../../../../common/presentaion/components/buttons/button_secondary.dart';

class ProductsListEmptyList extends StatelessWidget {
  const ProductsListEmptyList({
    super.key,
    required this.context,
    required this.vm,
    required this.addProductsOnTap,
  });

  final BuildContext context;
  final ProductsViewModel vm;
  final void Function(void) addProductsOnTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        context.headingXSmall('No products found'),
        const SizedBox(height: 8),
        context.labelXSmall('Add your first product to get started'),
        const SizedBox(height: 8),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: ButtonSecondary(text: 'Add Product', onTap: addProductsOnTap),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
