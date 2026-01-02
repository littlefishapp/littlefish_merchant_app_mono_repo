// flutter imports
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/products/product_combo.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/checkout_cart_combo_tile.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/checkout_cart_custom_item_tile.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/checkout_cart_product_tile.dart';
import 'package:littlefish_merchant/ui/business/expenses/widgets/selectable_quantity_tile_new.dart';

// package imports
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// project imports
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';

import '../../../common/presentaion/components/icons/error_icon.dart';

class CheckoutCartItemTile extends StatefulWidget {
  final CheckoutCartItem cartItem;
  const CheckoutCartItemTile({required this.cartItem, Key? key})
    : super(key: key);

  @override
  State<CheckoutCartItemTile> createState() => _CheckoutCartItemTileState();
}

class _CheckoutCartItemTileState extends State<CheckoutCartItemTile> {
  late bool _isError;
  StockProduct? _product;
  ProductCombo? _combo;
  CheckoutCartItem? _customItem;

  @override
  void initState() {
    _isError = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CheckoutVM>(
      converter: (Store<AppState> store) => CheckoutVM.fromStore(store),
      onInit: (store) {
        _setItemFromCartItem(widget.cartItem, store);
      },
      builder: (BuildContext context, CheckoutVM vm) =>
          layout(context, widget.cartItem, vm),
    );
  }

  layout(BuildContext context, CheckoutCartItem cartItem, CheckoutVM vm) {
    if (_isError) return errorTile();

    switch (cartItem.itemType) {
      case CheckoutCartItemType.stockProduct:
        return CheckoutCartProductTile(
          product: _product!,
          enableHighlighting: false,
          key: ValueKey(_product!.id),
        );
      case CheckoutCartItemType.productCombo:
        return CheckoutCartComboTile(
          combo: _combo!,
          enableHighlighting: false,
          key: ValueKey(_combo!.id),
        );
      case CheckoutCartItemType.customItem:
        return CheckoutCartCustomItemTile(
          customItem: _customItem!,
          enableHighlighting: false,
          key: ValueKey(_customItem!.id),
        );
      default:
        return CheckoutCartCustomItemTile(
          customItem: _customItem!,
          enableHighlighting: false,
          key: ValueKey(_customItem!.id),
        );
    }
  }

  _setItemFromCartItem(CheckoutCartItem cartItem, Store<AppState> store) {
    var productState = store.state.productState;
    switch (cartItem.itemType) {
      case CheckoutCartItemType.stockProduct:
        _product = productState.getProductById(cartItem.productId);
        if (AppVariables.enableProductVariance) {
          _product ??= productState.getProductVariantById(cartItem.productId);
        }
        if (_product == null) _isError = true;
        break;
      case CheckoutCartItemType.productCombo:
        _combo = productState.getComboById(cartItem.comboId);
        if (_combo == null) _isError = true;
        break;
      case CheckoutCartItemType.customItem:
        _customItem = cartItem;
        break;
      default:
        _customItem = cartItem;
        break;
    }
  }

  Widget errorTile() {
    return SelectableQuantityTile(
      tileHeight: 80,
      leading: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Center(child: ErrorIcon()),
      ),
      title: Expanded(
        child: Text(
          'Something went wrong, please empty the cart and try again.',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
      enableHighlighting: false,
    );
  }
}
