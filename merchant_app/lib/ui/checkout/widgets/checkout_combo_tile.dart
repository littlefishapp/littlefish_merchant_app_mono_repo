// removed ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:quiver/strings.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/checkout_tile_helper.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_controller.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/business/expenses/widgets/selectable_quantity_tile_new.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/models/products/product_combo.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_actions.dart';

import '../../../injector.dart';
import '../../../tools/network_image/flutter_network_image.dart';

class CheckoutComboTile extends StatefulWidget {
  final ProductCombo combo;
  final bool enableHighlighting;

  const CheckoutComboTile({
    required this.combo,
    this.enableHighlighting = true,
    Key? key,
  }) : super(key: key);

  @override
  State<CheckoutComboTile> createState() => _CheckoutComboTileState();
}

class _CheckoutComboTileState extends State<CheckoutComboTile> {
  late ProductCombo _combo;
  late CheckoutCartItem _cartItem;
  late double _cartItemQuantity;
  late int _cartItemIndex;
  late bool _isProductInCart;

  @override
  void initState() {
    _combo = widget.combo;
    _cartItemQuantity = 0;
    _isProductInCart = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CheckoutVM>(
      converter: (Store<AppState> store) => CheckoutVM.fromStore(store),
      builder: (BuildContext context, CheckoutVM vm) {
        getItemInCart(_combo, vm);
        return layout(_combo, vm, context);
      },
    );
  }

  Widget layout(ProductCombo combo, CheckoutVM vm, BuildContext context) {
    return SelectableQuantityTile(
      initialQuantity: _cartItemQuantity,
      onTap: (newQuantity) {
        if (mounted) {
          setState(() {
            if (newQuantity > 0) {
              // add one to cart
              vm.store!.dispatch(CheckoutAddCombos([combo], []));
            } else {
              vm.onRemove(_cartItem, context); // remove from cart
            }
          });
        }
      },
      leading: isNotBlank(combo.imageUri)
          ? getIt<FlutterNetworkImage>().asWidget(
              id: combo.id!,
              category: 'combos',
              legacyUrl: combo.imageUri!,
              height: AppVariables.listImageHeight,
              width: AppVariables.listImageWidth,
            )
          : const Icon(Icons.inventory_2_outlined),
      trailing: CheckoutTileHelper.buildTrailText(
        context: context,
        trailText: TextFormatter.toStringCurrency(
          combo.comboSellingPrice,
          currencyCode: '',
        ),
      ),
      title: CheckoutTileHelper.buildTitle(
        context: context,
        title: combo.displayName ?? '',
      ),
      onFieldSubmitted: (double newQuantity) {
        if (mounted) {
          setState(() {
            double? difference = newQuantity - _cartItemQuantity;
            _cartItem.quantity += difference;
            vm.store!.dispatch(CheckoutAddCombos([], [_cartItem]));
          });
        }
      },
      minValue: 0,
      enableHighlighting: widget.enableHighlighting,
    );
  }

  getItemInCart(ProductCombo combo, CheckoutVM vm) {
    _cartItem =
        CheckoutCartController.getCartItemFromList(combo, vm.items ?? []) ??
        CheckoutCartItem.fromCombo(combo, 1);
    _cartItemIndex = CheckoutCartController.getItemIndexInCart(
      _cartItem,
      vm.items ?? [],
    );
    _isProductInCart = (_cartItemIndex != -1) && isNotNullOrEmpty(vm.items);
    _cartItemQuantity = _isProductInCart
        ? vm.items![_cartItemIndex].quantity
        : 0;
  }
}
