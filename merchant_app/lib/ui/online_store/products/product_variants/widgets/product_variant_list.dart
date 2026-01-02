import 'package:flutter/material.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import '../../../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../../common/presentaion/components/common_divider.dart';
import 'product_variant_tile.dart';

class ProductVariantLists extends StatefulWidget {
  final List<ProductVariant> productVariantList;
  final ManageStoreVM vm;

  const ProductVariantLists({
    Key? key,
    required this.productVariantList,
    required this.vm,
  }) : super(key: key);

  @override
  State<ProductVariantLists> createState() => _ProductVariantListsState();
}

class _ProductVariantListsState extends State<ProductVariantLists> {
  late bool _isLoading;

  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.productVariantList.isEmpty) {
      return const Center(child: Text('No Data'));
    }

    return body(widget.vm);
  }

  Column body(ManageStoreVM vm) => Column(
    children: [
      if (_isLoading) const LinearProgressIndicator(),
      Expanded(
        child: ListView.separated(
          itemCount: widget.productVariantList.length,
          itemBuilder: (context, index) {
            var item = widget.productVariantList[index];

            return ProductVariantTile(
              productVariant: item,
              onTap: () async {
                // await Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (ctx) => ProductVariantPage(
                //       storeProduct: item,
                //     ),
                //   ),
                // );

                setState(() {});
              },
              onRemove: () async {
                try {
                  _isLoading = true;
                  setState(() {});
                  // await vm.deleteProductVariant(item);
                } catch (e) {
                  showMessageDialog(context, 'Error', LittleFishIcons.error);
                }
                _isLoading = false;
                setState(() {});
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const CommonDivider(),
        ),
      ),
    ],
  );
}
