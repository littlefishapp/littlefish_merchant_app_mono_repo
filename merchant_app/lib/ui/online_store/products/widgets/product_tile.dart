import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:littlefish_merchant/ui/online_store/common/config.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/online_store/common/constants/image_constants.dart';
import 'package:littlefish_merchant/ui/online_store/products/store_product_page.dart';
import 'package:littlefish_merchant/ui/online_store/products/viewmodels/product_vm.dart';
import 'package:littlefish_merchant/ui/online_store/products/widgets/product_quantity_widget.dart';
import 'package:littlefish_merchant/ui/online_store/shared/firebase_image.dart';
import 'package:quiver/strings.dart';
import '../../../../common/presentaion/components/cards/card_neutral.dart';
import '../../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../../models/enums.dart';
import '../../../../tools/textformatter.dart';
import '../../../../common/presentaion/components/common_divider.dart';

class ProductTile extends StatefulWidget {
  final StoreProduct? product;

  final Function? onTap;

  final Function? onLongPress;

  final Function(StoreProduct item)? onRemove;

  final Widget? trailing;

  final ItemDisplayMode displayMode;

  final bool captureQtyEnabled;

  final bool displaySubtitle;

  final bool displayPrice;

  final bool manageLayout;

  const ProductTile({
    Key? key,
    required this.product,
    this.onTap,
    this.onLongPress,
    this.displayMode = ItemDisplayMode.list,
    this.captureQtyEnabled = false,
    this.displayPrice = true,
    this.displaySubtitle = true,
    this.manageLayout = true,
    this.trailing,
    this.onRemove,
  }) : super(key: key);

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  GlobalKey<ProductQuantityWidgetState> qtyKey = GlobalKey();

  late bool isProductOption;
  late bool customProductOptions;

  double? lowestPrice;
  double? highestPrice;

  @override
  void initState() {
    isProductOption =
        widget.product!.storeProductVariantType ==
        StoreProductVariantType.variant;

    customProductOptions = false;
    if (isProductOption) {
      customProductOptions =
          widget.product!.productVariant!.variantCombinations?.isNotEmpty ??
          false;

      widget.product!.productVariant!.products!.sort(
        (x, y) => x.sellingPrice!.compareTo(y.sellingPrice!),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProductVM>(
      converter: (store) => ProductVM.fromStore(
        store,
        widget.product!.productId,
        product: widget.product,
      ),
      builder: (ctx, vm) {
        // bool showImage = kAdvanceConfig['ShowDefaultProductImage'] ?? false;

        bool? isFeatured = widget.product!.isFeatured;

        bool? isOnSale = widget.product!.onSale;

        return widget.displayMode == ItemDisplayMode.grid
            ? _productCard(context, isFeatured, isOnSale, 0, false, vm)
            : Slidable(
                child: _productTile(context, isFeatured, isOnSale, vm),
                // actionPane: SlidableDrawerActionPane(),
                // secondaryActions: [],
              );
      },
    );
  }

  Widget _productCard(
    context,
    isFeatured,
    isOnSale,
    double cartQty,
    bool showImage,
    ProductVM vm,
  ) => CardNeutral(
    child: Stack(
      children: <Widget>[
        InkWell(
          onTap: () async {
            if (widget.onTap != null) {
              widget.onTap!();
              // vm.updateCartInformation();

              if (mounted) {
                setState(() {
                  // vm.updateCartInformation();
                });
              }

              qtyKey.currentState?.changeValue(vm.quantity);
            } else {}
          },
          child: Container(
            constraints: const BoxConstraints.expand(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Material(child: SizedBox(height: 28)),
                Expanded(
                  child: Material(
                    child: Container(
                      constraints: const BoxConstraints.expand(),
                      child: FirebaseImage(
                        imageAddress: widget.product!.featureImageUrl,
                        defaultNetworkImage: ImageConstants.productDefault,
                        fit: BoxFit.cover,
                        isAsset: true,
                      ),
                    ),
                  ),
                ),
                const CommonDivider(),
                SizedBox(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.product!.displayName?.toString() ?? '',
                          textAlign: TextAlign.start,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 2),
                        if (widget.displaySubtitle &&
                            widget.displayPrice &&
                            !customProductOptions)
                          Row(
                            children: <Widget>[
                              Text(
                                TextFormatter.toStringCurrency(
                                  widget.product!.sellingPrice,
                                  currencyCode:
                                      vm.shortCurrencyCode ??
                                      vm.currencyCode ??
                                      '',
                                ),
                              ),
                              if (widget.product!.compareAtPrice != null &&
                                  widget.product!.compareAtPrice! >
                                      widget.product!.sellingPrice!)
                                const SizedBox(width: 4),
                              if (widget.product!.compareAtPrice != null &&
                                  widget.product!.compareAtPrice! >
                                      widget.product!.sellingPrice!)
                                Text(
                                  TextFormatter.toStringCurrency(
                                    widget.product!.compareAtPrice,
                                    currencyCode:
                                        vm.shortCurrencyCode ??
                                        vm.currencyCode ??
                                        '',
                                  ),
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                            ],
                          ),
                        if (widget.displaySubtitle &&
                            widget.displayPrice &&
                            customProductOptions)
                          Row(
                            children: <Widget>[
                              Text(
                                TextFormatter.toStringCurrency(
                                  widget
                                      .product!
                                      .productVariant!
                                      .products!
                                      .first
                                      .sellingPrice,
                                  currencyCode:
                                      vm.shortCurrencyCode ??
                                      vm.currencyCode ??
                                      '',
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text('- '),
                              Text(
                                TextFormatter.toStringCurrency(
                                  widget
                                      .product!
                                      .productVariant!
                                      .products!
                                      .last
                                      .sellingPrice,
                                  currencyCode:
                                      vm.shortCurrencyCode ??
                                      vm.currencyCode ??
                                      '',
                                ),
                              ),
                            ],
                          ),
                        if (widget.displaySubtitle && !widget.displayPrice)
                          Text(widget.product!.description!),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  ListTile _productTile(
    context,
    isFeatured,
    isOnSale,
    ProductVM vm,
  ) => ListTile(
    tileColor: Theme.of(context).colorScheme.background,
    leading: Material(
      borderRadius: BorderRadius.circular(kBorderRadius!),
      elevation: 2,
      child: Container(
        width: 64,
        height: 84,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kBorderRadius!),
        ),
        child: isNotBlank(widget.product!.featureImageUrl)
            ? FirebaseImage(imageAddress: widget.product!.featureImageUrl)
            : Image.asset(ImageConstants.productDefault, fit: BoxFit.cover),
      ),
    ),
    title: Text(widget.product!.displayName!),
    trailing: widget.trailing,
    subtitle: Row(
      children: customProductOptions
          ? [
              Text(
                TextFormatter.toStringCurrency(
                  widget.product!.productVariant!.products!.first.sellingPrice,
                  currencyCode: vm.shortCurrencyCode ?? vm.currencyCode ?? '',
                ),
              ),
              const SizedBox(width: 4),
              const Text('- '),
              Text(
                TextFormatter.toStringCurrency(
                  widget.product!.productVariant!.products!.last.sellingPrice,
                  currencyCode: vm.shortCurrencyCode ?? vm.currencyCode ?? '',
                ),
              ),
            ]
          : [
              Text(
                TextFormatter.toStringCurrency(
                  widget.product!.sellingPrice,
                  currencyCode: vm.shortCurrencyCode ?? vm.currencyCode ?? '',
                ),
              ),
              if (widget.product!.compareAtPrice != null &&
                  widget.product!.compareAtPrice! >
                      widget.product!.sellingPrice!)
                const SizedBox(width: 4),
              if (widget.product!.compareAtPrice != null &&
                  widget.product!.compareAtPrice! >
                      widget.product!.sellingPrice!)
                Text(
                  TextFormatter.toStringCurrency(
                    widget.product!.compareAtPrice,
                    currencyCode: vm.shortCurrencyCode ?? vm.currencyCode ?? '',
                  ),
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
            ],
    ),
    onTap: () async {
      if (widget.manageLayout == false) {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (ctx) => isProductOption && customProductOptions
        //         ? ProductOptionsScreen(widget.product)
        //         : ProductScreen(product: widget.product),
        //   ),
        // );
      } else if (widget.onTap != null) {
        widget.onTap!();
      } else {
        vm.product!.isNew = false;
        _editOrCaptureProduct(context, product: vm.product).then((value) {
          if (mounted) setState(() {});
        });
      }
    },
    onLongPress: () async {
      if (widget.onLongPress != null) widget.onLongPress!(widget.product);
    },
  );

  Future<void> _editOrCaptureProduct(
    BuildContext context, {
    StoreProduct? product,
  }) async {
    if (product != null) {
      //push this route to get object data
      Navigator.of(
        context,
      ).pushNamed(StoreProductPage.route, arguments: product);

      // vm.setSelectedItem(product);
      // return Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      //   return StoreProductScreen(item: product);
      // }));
    } else {
      //push this route to get object data
      var result = await Navigator.of(
        context,
      ).pushNamed(StoreProductPage.route);

      if (result is StoreProduct) {}
    }
  }
}
