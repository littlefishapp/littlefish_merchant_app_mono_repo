import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/ui/online_store/common/config.dart';
import 'package:littlefish_merchant/ui/online_store/common/constants/image_constants.dart';
import 'package:littlefish_merchant/ui/online_store/products/product_options_list_page.dart';
import 'package:littlefish_merchant/ui/online_store/products/viewmodels/product_vm.dart';
import 'package:littlefish_merchant/ui/online_store/products/widgets/product_list.dart';
import 'package:littlefish_merchant/ui/online_store/shared/firebase_image.dart';
import 'package:quiver/strings.dart';
import '../../../../common/presentaion/components/custom_app_bar.dart';
import '../../../../common/presentaion/components/icons/delete_icon.dart';
import '../../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../../models/enums.dart';

class ProductOptionsProductSelect extends StatefulWidget {
  final ProductVM? vm;

  final StoreProduct? item;

  const ProductOptionsProductSelect({Key? key, this.item, this.vm})
    : super(key: key);

  @override
  State<ProductOptionsProductSelect> createState() =>
      _ProductOptionsProductSelectState();
}

class _ProductOptionsProductSelectState
    extends State<ProductOptionsProductSelect> {
  // GlobalKey<FormState>? _formKey;

  @override
  Widget build(BuildContext context) {
    return _productsTab(widget.vm);
  }

  ListView _productsTab(ProductVM? vm) {
    return ListView(
      shrinkWrap: true,
      children:
          (widget.item!.productVariant!.totalCombinations)?.map((e) {
            var currentProduct = widget
                .item!
                .productVariant
                ?.variantCombinations
                ?.firstWhereOrNull((element) => element.variant == e);

            return ListTile(
              tileColor: Theme.of(context).colorScheme.background,
              isThreeLine: true,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(kBorderRadius!),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: isNotBlank(currentProduct?.imageUrl)
                      ? FirebaseImage(imageAddress: currentProduct!.imageUrl)
                      : Image.asset(
                          ImageConstants.productDefault,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              title: Text(e),
              trailing: IconButton(
                icon: const DeleteIcon(),
                onPressed: () {
                  // currentProduct = null;
                  widget.item!.productVariant!.variantCombinations!.removeWhere(
                    (element) => element.variant == e,
                  );

                  if (mounted) setState(() {});
                },
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(currentProduct?.sku ?? 'None Selected'),
                  Text(
                    currentProduct?.price?.toString() ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              onTap: () async {
                StoreProduct? product = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) =>
                        ProductOptionsListPage(vm: vm, item: widget.item),
                  ),
                );

                if (product != null) {
                  // var itemAlreadySelected = _productVariant
                  //     .variantCombinations
                  //     .map((f) => f.productId)
                  //     .contains(product.id);
                  // if (!itemAlreadySelected) {
                  // if (isNotBlank(product.variantId)) {
                  // var replaceVariant = await showAcceptDialog(
                  // context: context,
                  // toUppercase: false,
                  // title: S.of(context).proceedButtonText,
                  // content: Text(S.of(context).productInAVariantTitle),
                  // );
                  // if (replaceVariant == true) {
                  addVariant(product, e);
                  // }
                } else {
                  // addVariant(product, e);
                }

                // _productVariant.variantCombinations.removeWhere(
                //   (el) => el?.productId == currentProduct?.productId,
                // );
                // } else {
                // showMessageDialog(
                // context,
                // S.of(context).productInAVariantTitle,
                // LittleFishIcons.error,
                // );
                // }
                // }
              },
            );
          }).toList() ??
          [],
    );
  }

  addVariant(product, e) {
    var variant = ProductVariantLink(
      price: product.sellingPrice,
      productId: product.id ?? product.productId,
      variant: e,
      sku: product.displayName,
      imageUrl: product.featureImageUrl,
    );

    if (widget.item!.productVariant!.variantCombinations == null) {
      widget.item!.productVariant!.variantCombinations = [variant];
    } else {
      widget.item!.productVariant!.variantCombinations!.add(variant);
    }

    if (mounted) setState(() {});
  }

  Scaffold productPage() => const Scaffold(
    appBar: CustomAppBar(title: Text('Product')),
    body: SafeArea(child: ProductsList(listViewMode: ListViewMode.select)),
  );
}
