// flutter imports
// removed ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/checkout_product_tile.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_controller.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';

class CheckoutCartProductTile extends StatefulWidget {
  final StockProduct product;
  final bool enableHighlighting;

  const CheckoutCartProductTile({
    required this.product,
    this.enableHighlighting = true,
    Key? key,
  }) : super(key: key);

  @override
  State<CheckoutCartProductTile> createState() =>
      _CheckoutCartProductTileState();
}

class _CheckoutCartProductTileState extends State<CheckoutCartProductTile> {
  late StockProduct _product;
  late CheckoutCartItem _cartItem;
  late double _cartItemQuantity;
  late int _cartItemIndex;
  late bool _isProductInCart;

  @override
  void initState() {
    _product = widget.product;
    _cartItemQuantity = 0;
    _isProductInCart = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CheckoutVM>(
      converter: (Store<AppState> store) => CheckoutVM.fromStore(store),
      builder: (BuildContext context, CheckoutVM vm) {
        getItemInCart(_product, vm);
        return layout(_product, vm, context);
      },
    );
  }

  Widget layout(StockProduct product, CheckoutVM vm, BuildContext context) {
    return CheckoutProductTile(product: product);
  }

  getItemInCart(StockProduct product, CheckoutVM vm) {
    _cartItem =
        CheckoutCartController.getCartItemFromList(product, vm.items ?? []) ??
        CheckoutCartItem.fromProduct(product, product.regularVariance!);
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
