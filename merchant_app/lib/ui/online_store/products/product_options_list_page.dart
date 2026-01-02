import 'package:flutter/material.dart';
import 'package:littlefish_merchant/ui/online_store/products/pages/product_option_create_page.dart';
import 'package:littlefish_merchant/ui/online_store/products/viewmodels/product_vm.dart';
import 'package:littlefish_merchant/ui/online_store/products/widgets/product_tile.dart';

import '../../../common/presentaion/components/custom_app_bar.dart';
import '../../../features/ecommerce_shared/models/store/store_product.dart';

class ProductOptionsListPage extends StatefulWidget {
  final ProductVM? vm;

  final StoreProduct? item;

  const ProductOptionsListPage({Key? key, this.vm, this.item})
    : super(key: key);

  @override
  State<ProductOptionsListPage> createState() => _ProductOptionsListPageState();
}

class _ProductOptionsListPageState extends State<ProductOptionsListPage> {
  List<StoreProduct>? products;

  @override
  void initState() {
    products = widget.item!.productVariant!.products ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: Text('Product Options')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          var prod = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => ProductOptionCreatePage(vm: widget.vm),
            ),
          );

          if (prod != null) {
            var index = products!.indexWhere(
              (element) =>
                  (element.productId ?? element.id) ==
                  (prod.productId ?? prod.id),
            );

            if (index != -1) {
              products![index] = prod;
            } else {
              products!.add(prod);
            }

            widget.item!.productVariant!.products = products;

            if (mounted) setState(() {});
          }
        },

        // productListKeyState.currentState.refresh();
      ),
      body: SafeArea(child: items()),
    );
  }

  ListView items() => ListView.builder(
    itemCount: products!.length,
    itemBuilder: (ctx, index) => ProductTile(
      product: products![index],
      onLongPress: (val) async {
        var prod = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => ProductOptionCreatePage(item: val, vm: widget.vm),
          ),
        );

        if (prod != null) {
          products![index] = prod;
        }

        if (mounted) setState(() {});
      },
      onRemove: (val) {
        products!.removeAt(index);
        widget.item!.productVariant!.variantCombinations!.removeWhere(
          (element) => element.productId == (val.productId ?? val.id),
        );
        if (mounted) setState(() {});
      },
      onTap: (val) {
        Navigator.of(context).pop(val);
      },
    ),
  );
}
