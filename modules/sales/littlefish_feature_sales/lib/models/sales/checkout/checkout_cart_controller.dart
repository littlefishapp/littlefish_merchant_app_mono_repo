import 'package:littlefish_merchant/models/products/product_combo.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';

class CheckoutCartController {
  static CheckoutCartItem? getCartItemFromList<T>(
    T item,
    List<CheckoutCartItem> cartItems, {
    bool Function(CheckoutCartItem)? searchCondition,
  }) {
    if (cartItems.isEmpty) return null;

    int existingItemIndex = getItemIndexInCart(
      item,
      cartItems,
      searchCondition: searchCondition,
    );

    bool hasItem = existingItemIndex != -1;
    if (hasItem) {
      return cartItems[existingItemIndex];
    }

    return null;
  }

  static double getItemQuanityInList<T>(
    T item,
    List<CheckoutCartItem> cartItems, {
    bool Function(CheckoutCartItem)? searchCondition,
  }) {
    CheckoutCartItem? cartItem = getCartItemFromList(
      item,
      cartItems,
      searchCondition: searchCondition,
    );
    if (cartItem == null) return 0;

    return cartItem.quantity;
  }

  static int getItemIndexInCart<T>(
    T item,
    List<CheckoutCartItem> cartItems, {
    bool Function(CheckoutCartItem)? searchCondition,
  }) {
    // returns -1 if item not found in list

    bool Function(CheckoutCartItem)? usedSearchCondition =
        searchCondition ?? getCartItemSearchCondition(item);

    if (usedSearchCondition == null || cartItems.isEmpty) return -1;

    return cartItems.indexWhere(usedSearchCondition);
  }

  static bool Function(CheckoutCartItem)? getCartItemSearchCondition<T>(
    T item,
  ) {
    if (item is StockProduct) {
      return (cartItem) => cartItem.productId == item.id;
    } else if (item is ProductCombo) {
      return (cartItem) => cartItem.comboId == item.id;
    } else if (item is CheckoutCartItem) {
      return (cartItems) => cartItems.id == item.id;
    } else {
      return null;
    }
  }

  // Additional methods for cart operations can be added here.
}
