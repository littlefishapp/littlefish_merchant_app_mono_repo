import 'package:flutter/material.dart';
import 'package:littlefish_merchant/ui/online_store/common/constants/image_constants.dart';
import 'package:littlefish_merchant/ui/online_store/products/viewmodels/product_vm.dart';
import 'package:littlefish_merchant/ui/online_store/shared/firebase_image.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:quiver/strings.dart';

import '../../../../common/presentaion/components/icons/delete_icon.dart';
import '../../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../../tools/textformatter.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../common/presentaion/components/common_divider.dart';
import '../../../../common/presentaion/components/text_tag.dart';

class RelatedProductsPage extends StatefulWidget {
  final StoreProduct? item;

  final ProductVM vm;

  const RelatedProductsPage({Key? key, required this.item, required this.vm})
    : super(key: key);

  @override
  State<RelatedProductsPage> createState() => _RelatedProductsPageState();
}

class _RelatedProductsPageState extends State<RelatedProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var relItems = widget.vm.products
              ?.where(
                (x) => !widget.item!.relatedProducts!
                    .map((f) => f.productId)
                    .contains(x.productId),
              )
              .where((x) => x.id != widget.item!.id)
              .toList();
          if (relItems?.length as bool? ?? 0 > 0) {
            await showPopupDialog(
              context: context,
              content: _relatedLayout(context, relItems),
            ).then((res) {
              if (res != null) {
                if (mounted) {
                  setState(() {
                    var relProd = StoreRelatedProduct(
                      featureImageUrl: res.featureImageUrl,
                      productName: res.displayName,
                      productId: res.id,
                    );
                    widget.item!.relatedProducts!.add(relProd);
                  });
                }
              }
            });
          } else {
            showMessageDialog(
              context,
              'No Related Products Available',
              LittleFishIcons.info,
            );
          }
        },
        child: const Icon(Icons.add),
      ),
      body: relatedProductsGrid(context, widget.vm, widget.item!),
    );
  }

  Container relatedProductsGrid(context, vm, StoreProduct product) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: GridView.builder(
      itemCount: product.relatedProducts?.length ?? 0,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      itemBuilder: (context, index) => Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: FirebaseImage(
                  imageAddress: product.relatedProducts![index].featureImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  tileColor: Theme.of(context).colorScheme.background,
                  title: Text(
                    product.relatedProducts![index].productName!,
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const DeleteIcon(),
              onPressed: () {
                if (mounted) {
                  setState(() {
                    widget.item!.relatedProducts!.removeAt(index);
                  });
                } else {
                  widget.item!.relatedProducts!.removeAt(index);
                }
              },
            ),
          ),
        ],
      ),
    ),
  );

  Column _relatedLayout(BuildContext context, items) => Column(
    children: <Widget>[
      Expanded(
        flex: 20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: const Text(
                'Related Products',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const CommonDivider(),
            Expanded(child: productList(context, items)),
          ],
        ),
      ),
    ],
  );

  ListView productList(BuildContext context, items) => ListView.separated(
    physics: const BouncingScrollPhysics(),
    itemCount: items.length,
    itemBuilder: (BuildContext context, int index) {
      var i = items[index];
      return ListTile(
        tileColor: Theme.of(context).colorScheme.background,
        leading: Container(
          margin: const EdgeInsets.all(12.0),
          child: isNotBlank(i.featureImageUrl)
              ? FirebaseImage(imageAddress: i.featureImageUrl)
              : Image.asset(ImageConstants.productDefault),
        ),
        title: Text(i.displayName),
        trailing: TextTag(
          displayText: TextFormatter.toStringCurrency(
            i.sellingPrice,
            displayCurrency: false,
            currencyCode: '',
          ),
        ),
        onTap: () async {
          Navigator.of(context).pop(i);
        },
      );
    },
    separatorBuilder: (BuildContext context, int index) =>
        const CommonDivider(),
  );
}
