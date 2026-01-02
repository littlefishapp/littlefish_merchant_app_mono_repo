import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_scan_viewmodel.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/checkout_tile_helper.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_controller.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/business/expenses/widgets/selectable_quantity_tile_new.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:quiver/strings.dart';

class CheckoutScanItemTile extends StatefulWidget {
  final CheckoutCartItem scannedItem;
  final bool enableHighlighting;
  final CheckoutScanViewModel vm;

  const CheckoutScanItemTile({
    required this.scannedItem,
    required this.vm,
    this.enableHighlighting = true,
    Key? key,
  }) : super(key: key);

  @override
  State<CheckoutScanItemTile> createState() => _CheckoutScanItemTileState();
}

class _CheckoutScanItemTileState extends State<CheckoutScanItemTile> {
  late CheckoutCartItem _customItem;
  late CheckoutCartItem _cartItem;
  late double _cartItemQuantity;
  late int _cartItemIndex;
  late bool _isProductInCart;
  String? _productImageUrl;

  @override
  void initState() {
    _customItem = widget.scannedItem;
    _cartItemQuantity = 0;
    _isProductInCart = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getItemInCart(_customItem, widget.vm);
    return layout(_customItem, widget.vm, context);
  }

  Widget layout(
    CheckoutCartItem customItem,
    CheckoutScanViewModel vm,
    BuildContext context,
  ) {
    return SelectableQuantityTile(
      initialQuantity: _cartItemQuantity,
      leading: isNotBlank(_productImageUrl)
          ? _ProductImage(
              productImageUrl: _productImageUrl!,
              displayName: customItem.description ?? '',
            )
          : const Icon(Icons.sell_outlined),
      trailing: CheckoutTileHelper.buildTrailText(
        context: context,
        trailText: TextFormatter.toStringCurrency(
          customItem.itemValue ?? 0,
          currencyCode: '',
        ),
      ),
      title: CheckoutTileHelper.buildTitle(
        context: context,
        title: customItem.description ?? '',
      ),
      onTap: (quantity) {
        vm.updateItemQuantity(widget.scannedItem, quantity);
      },
      onFieldSubmitted: (double newQuantity) {
        vm.updateItemQuantity(widget.scannedItem, newQuantity);
      },
      minValue: 0,
      enableHighlighting: widget.enableHighlighting,
    );
  }

  void getItemInCart(CheckoutCartItem customItem, CheckoutScanViewModel vm) {
    _cartItem =
        CheckoutCartController.getCartItemFromList(
          customItem,
          vm.scannedItems,
        ) ??
        CheckoutCartItem.fromCustomSale(
          customItem.itemValue ?? 0,
          customItem.description ?? 'Custom Sale',
        );
    _cartItemIndex = CheckoutCartController.getItemIndexInCart(
      _cartItem,
      vm.scannedItems,
    );
    _isProductInCart =
        (_cartItemIndex != -1) && isNotNullOrEmpty(vm.scannedItems);
    _cartItemQuantity = _isProductInCart
        ? vm.scannedItems[_cartItemIndex].quantity
        : 0;
    _productImageUrl ??= AppVariables.store?.state.productState
        .getProductById(_cartItem.productId)
        ?.imageUri;
  }
}

class _ProductImage extends StatelessWidget {
  final String productImageUrl;
  final String displayName;
  const _ProductImage({
    super.key,
    required this.productImageUrl,
    required this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    return isNotBlank(productImageUrl)
        ? ListLeadingImageTile(url: productImageUrl)
        : Container(
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).extension<AppliedSurface>()?.brandSubTitle,
              border: Border.all(color: Colors.transparent, width: 1),
              borderRadius: BorderRadius.circular(
                AppVariables.appDefaultButtonRadius,
              ),
            ),
            child: Center(
              child: context.labelLarge(
                _getSafeDisplayName(),
                isSemiBold: true,
              ),
            ),
          );
  }

  String _getSafeDisplayName() {
    if (displayName.isEmpty) return 'Unknown item';

    if (displayName.length < 2) return displayName;
    return displayName.substring(0, 2).toUpperCase();
  }
}
