import 'package:collection/collection.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/models/tax/sales_tax.dart';
import 'package:littlefish_merchant/tools/extensions/extensions.dart';

class TaxCalculationService {
  /// Calculates the tax for a single [CheckoutCartItem] by finding its specific tax rate.
  /// Returns the calculated tax amount for the single item.
  static double calculateTaxForItem({
    required CheckoutCartItem item,
    required List<CheckoutCartItem> allCartItems,
    required double totalCartDiscount,
    required List<StockProduct> productsInCart,
    required List<SalesTax> allAvailableTaxes,
  }) {
    SalesTax? salesTaxForItem;

    // --- Find the correct SalesTax object for THIS item ---
    if (item.isCustomSale == true) {
      // assuming we should use the store's default sales tax for custom items
      salesTaxForItem = AppVariables.store?.state.appSettingsState.salesTax;
    } else if (item.productId != null) {
      // For products, find the corresponding StockProduct to get its taxId and tax object.
      final product = productsInCart.firstWhereOrNull(
        (p) => p.id == item.productId,
      );
      if (product?.taxId != null) {
        salesTaxForItem = allAvailableTaxes.firstWhereOrNull(
          (tax) => tax.id == product?.taxId,
        );
      }
    }

    // --- Validate the found tax rate ---
    // The item is not taxable if:
    // - No corresponding tax rate was found.
    // - The found tax rate is explicitly disabled.
    // - The tax rate percentage is zero.
    if (salesTaxForItem == null ||
        salesTaxForItem.enabled != true ||
        salesTaxForItem.percentage == 0) {
      return 0.0;
    }

    // --- Calculate proportional discount ---
    final double preDiscountSubtotal = allCartItems.fold(
      0.0,
      (sum, cartItem) => sum + (cartItem.value ?? 0.0),
    );

    if (preDiscountSubtotal <= 0) {
      return 0.0;
    }

    final double itemOriginalValue = item.value ?? 0.0;
    final double proportionalDiscount =
        (itemOriginalValue / preDiscountSubtotal) * totalCartDiscount;
    final double itemFinalPrice = itemOriginalValue - proportionalDiscount;

    // --- Calculate tax using the item-specific tax rate ---
    final double taxRate = salesTaxForItem.percentage! / 100.0;
    double itemTax = 0.0;

    if (salesTaxForItem.taxPricingMode == TaxPricingMode.alreadyIncluded) {
      itemTax = itemFinalPrice - (itemFinalPrice / (1 + taxRate));
    } else {
      itemTax = itemFinalPrice * taxRate;
    }

    return itemTax > 0 ? itemTax.truncateToDecimalPlaces(2) : 0.0;
  }

  /// Calculates the total tax for an entire cart with potentially mixed tax rates.
  /// This method iterates through each item, finds its specific tax, and sums the results.
  /// Returns the total calculated tax for the cart.
  static double calculateTotalCartTax({
    required List<CheckoutCartItem> items,
    required double totalDiscount,
    required List<StockProduct> productsInCart,
    required List<SalesTax> allAvailableTaxes,
  }) {
    if (allAvailableTaxes.isEmpty) {
      return 0.0;
    }

    // Sum the tax for each item in the cart.
    final double totalTax = items.fold(0.0, (sum, item) {
      return sum +
          calculateTaxForItem(
            item: item,
            allCartItems: items,
            totalCartDiscount: totalDiscount,
            productsInCart: productsInCart,
            allAvailableTaxes: allAvailableTaxes,
          );
    });

    return totalTax.truncateToDecimalPlaces(2);
  }
}
