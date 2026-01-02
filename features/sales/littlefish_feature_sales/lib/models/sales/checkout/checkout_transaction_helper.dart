// package imports
import 'package:collection/collection.dart';

// project imports
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:quiver/strings.dart';

class CheckoutTransactionHelper {
  CheckoutTransaction transaction;

  CheckoutTransactionHelper(this.transaction);

  double getCartItemDiscountedValue(double cartItemValue) {
    if (isZeroOrNull(transaction.totalValue) ||
        isZeroOrNull(transaction.totalDiscount)) {
      return cartItemValue;
    }

    double perUnitDiscount =
        (cartItemValue / transaction.totalValue!) * transaction.totalDiscount!;

    return cartItemValue - perUnitDiscount;
  }

  double getCartItemDiscountedTotalValue(
    String cartItemId, {
    bool removeRefundedItems = true,
  }) {
    if (isNullOrEmpty(transaction.items)) return 0;
    int itemIndex = transaction.items!.indexWhere(
      (item) => item.id == cartItemId,
    );
    if (itemIndex == -1) return 0;
    double cartItemUnitDiscountedValue = getCartItemDiscountedValue(
      transaction.items![itemIndex].itemValue ?? 0,
    );

    return getCartItemQuantity(
          cartItemId,
          removeRefundedItems: removeRefundedItems,
        ) *
        cartItemUnitDiscountedValue;
  }

  double getCartItemQuantity(
    String? cartItemID, {
    bool removeRefundedItems = true,
  }) {
    if (isBlank(cartItemID) || isNullOrEmpty(transaction.items)) return 0;

    CheckoutCartItem? cartItem = transaction.items!.firstWhereOrNull(
      (item) => item.id == cartItemID,
    );
    double quantitySold = cartItem?.quantity ?? 0;

    if (!removeRefundedItems) return quantitySold;

    double totalRefundedQuantity = getQuantityRefundedForItem(
      cartItemID!,
      transaction,
    );
    return quantitySold - totalRefundedQuantity;
  }

  double getQuantityRefundedForItem(
    String cartItemID,
    CheckoutTransaction transaction,
  ) {
    if (isNullOrEmpty(transaction.refunds)) {
      return 0;
    }

    return transaction.refunds!
        .where((refund) => !isNullOrEmpty(refund.items))
        .expand((refund) => refund.items!)
        .where((refundItem) => refundItem.checkoutCartItemId == cartItemID)
        .fold(0.0, (total, refundItem) => total + (refundItem.quantity ?? 0));
  }
}
