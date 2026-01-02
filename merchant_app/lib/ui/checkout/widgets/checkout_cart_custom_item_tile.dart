// flutter imports
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/tools/helpers.dart';

// package imports
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// project imports
import 'package:littlefish_merchant/ui/checkout/widgets/checkout_tile_helper.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_controller.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/business/expenses/widgets/selectable_quantity_tile_new.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';

class CheckoutCartCustomItemTile extends StatefulWidget {
  final CheckoutCartItem customItem;
  final bool enableHighlighting;

  const CheckoutCartCustomItemTile({
    required this.customItem,
    this.enableHighlighting = true,
    Key? key,
  }) : super(key: key);

  @override
  State<CheckoutCartCustomItemTile> createState() =>
      _CheckoutCartCustomItemTileState();
}

class _CheckoutCartCustomItemTileState
    extends State<CheckoutCartCustomItemTile> {
  late CheckoutCartItem _customItem;
  late CheckoutCartItem _cartItem;
  late double _cartItemQuantity;
  late int _cartItemIndex;
  late bool _isProductInCart;

  @override
  void initState() {
    _customItem = widget.customItem;
    _cartItemQuantity = 0;
    _isProductInCart = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CheckoutVM>(
      converter: (Store<AppState> store) => CheckoutVM.fromStore(store),
      builder: (BuildContext context, CheckoutVM vm) {
        getItemInCart(_customItem, vm);
        return layout(_customItem, vm, context);
      },
    );
  }

  Widget layout(
    CheckoutCartItem customItem,
    CheckoutVM vm,
    BuildContext context,
  ) {
    return SelectableQuantityTile(
      initialQuantity: _cartItemQuantity,
      leading: const Icon(Icons.sell_outlined),
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
        if (mounted) {
          setState(() {
            vm.addCustomSaleToCart(
              Decimal.parse(customItem.itemValue!.toString()),
              customItem.description!,
            );
          });
        }
      },
      onFieldSubmitted: (double newQuantity) {
        if (mounted) {
          setState(() {
            double? difference = newQuantity - _cartItemQuantity;
            if (difference > 0) {
              vm.addCustomSaleToCart(
                Decimal.parse(customItem.itemValue!.toString()),
                customItem.description!,
              );
            } else if (difference < 0) {
              vm.reduceCustomSaleQuantityInCart(
                Decimal.parse(customItem.itemValue!.toString()),
                customItem.description!,
              );
            }
            if (_cartItemQuantity + difference <= 0) {
              vm.onRemove(_customItem, context);
            }
          });
        }
      },
      minValue: 0,
      enableHighlighting: widget.enableHighlighting,
    );
  }

  getItemInCart(CheckoutCartItem customItem, CheckoutVM vm) {
    _cartItem =
        CheckoutCartController.getCartItemFromList(
          customItem,
          vm.items ?? [],
        ) ??
        CheckoutCartItem.fromCustomSale(
          customItem.itemValue ?? 0,
          customItem.description ?? 'Custom Sale',
        );
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
