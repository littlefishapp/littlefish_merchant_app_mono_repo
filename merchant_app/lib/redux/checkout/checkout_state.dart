import 'package:built_value/built_value.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_discount.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_tip.dart';
import 'package:littlefish_merchant/models/sales/tickets/ticket.dart';
import 'package:littlefish_merchant/models/settings/payments/payment_type.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/models/tax/sales_tax.dart';
import '../../models/enums.dart' as enums;

part 'checkout_state.g.dart';

@immutable
@JsonSerializable()
abstract class CheckoutState
    implements Built<CheckoutState, CheckoutStateBuilder> {
  // static Serializer<CheckoutState> get serializer => _$checkoutStateSerializer;

  factory CheckoutState({double? transactionNumber}) => _$CheckoutState._(
    hasError: false,
    isLoading: false,
    errorMessage: null,
    items: const [],
    refunds: const [],
    voidedItems: const [],
    keypadIndex: 0,
    lastTransactionNumber: transactionNumber,
    productVariantIsLoading: false,
  );

  const CheckoutState._();

  Decimal get amountChange {
    return ((amountTendered ?? Decimal.zero) - checkoutTotal).truncate(
      scale: 2,
    );
  }

  Decimal get amountShort {
    if (checkoutTotal <= Decimal.zero) return Decimal.zero;
    var result = checkoutTotal - (amountTendered ?? Decimal.zero);

    if (result <= Decimal.zero) return Decimal.zero;

    return result.truncate(scale: 2);
  }

  Decimal? get amountTendered;

  Decimal get averageItemValue {
    if (totalValue <= Decimal.zero) return Decimal.zero;

    return (totalValue / itemCount)
        .toDecimal(scaleOnInfinitePrecision: 10)
        .truncate(scale: 2);
  }

  Decimal get checkoutTotal {
    var total =
        totalValue -
        (discountAmount ?? Decimal.zero) +
        (cashbackAmount ?? Decimal.zero) +
        (withdrawalAmount ?? Decimal.zero) +
        (tipAmount ?? Decimal.zero);

    if (total <= Decimal.zero) {
      return Decimal.zero;
    } else {
      return total.truncate(scale: 2);
    }
  }

  Decimal get totalBeforeTip {
    var total =
        totalValue -
        (discountAmount ?? Decimal.zero) +
        (cashbackAmount ?? Decimal.zero) +
        (withdrawalAmount ?? Decimal.zero);

    if (total <= Decimal.zero) {
      return Decimal.zero;
    } else {
      return total.truncate(scale: 2);
    }
  }

  Decimal? get customAmount;

  String? get customDescription;

  Customer? get customer;

  CheckoutDiscount? get discount;

  int? get discountTabIndex;

  int? get tipTabIndex;

  Decimal? get discountAmount {
    if (discount == null) return Decimal.zero;

    if (totalValue <= Decimal.zero) return Decimal.zero;

    if (discount!.value! <= 0) return Decimal.zero;
    if (discount!.type == DiscountType.fixedAmount) {
      return (Decimal.tryParse(discount!.value.toString()) ?? Decimal.zero)
          .truncate(scale: 2);
    } else {
      return (totalValue *
              (Decimal.tryParse(discount!.value.toString()) ?? Decimal.zero) /
              Decimal.fromInt(100))
          .toDecimal(scaleOnInfinitePrecision: 10)
          .truncate(scale: 2);
    }
  }

  Decimal? get tipAmount {
    if (tip == null || tip?.value == null) return Decimal.zero;

    if (tip!.value! <= 0) return Decimal.zero;

    Decimal tipValue = Decimal.tryParse(tip!.value.toString()) ?? Decimal.zero;

    if (tip!.type == TipType.fixedAmount) {
      return tipValue.truncate(scale: 2);
    } else {
      return (totalValue * tipValue / Decimal.fromInt(100))
          .toDecimal(scaleOnInfinitePrecision: 10)
          .truncate(scale: 2);
    }
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get errorMessage;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get hasError;

  bool get isCashPayment {
    return paymentType?.name?.toLowerCase() == 'cash';
  }

  Decimal? get currentCheckoutActionAmount;

  Decimal? get withdrawalAmount;

  Decimal? get cashbackAmount;
  Decimal? get totalSaving;

  CheckoutTip? get tip;

  Ticket? get ticket;

  enums.SortBy? get sortBy;

  enums.SortOrder? get sortOrder;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isLoading;

  bool get isShort {
    return checkoutTotal > (amountTendered ?? Decimal.zero);
  }

  Decimal get itemCount {
    if (items!.isEmpty) return Decimal.zero;

    return items
            ?.map((i) => Decimal.parse(i.quantity.toString()))
            .reduce((a, b) => a + b) ??
        Decimal.zero;
  }

  List<CheckoutCartItem>? get items;

  int? get keypadIndex;

  Decimal get markup {
    if (checkoutTotal <= Decimal.zero) return Decimal.zero;

    if (totalCost <= Decimal.zero) return Decimal.zero;

    if (!items!.any((i) => !i.isCustomSale!)) return Decimal.zero;

    var totalCalculatedValue = items!
        .where((i) => !(i.isCustomSale ?? false))
        .map((s) => Decimal.parse((s.value ?? 0).toString()))
        .reduce((a, b) => a + b);

    var totalCalculatedCost = items!
        .where((i) => !(i.isCustomSale ?? false))
        .map((s) => Decimal.parse((s.valueCost ?? 0).toString()))
        .reduce((a, b) => a + b);

    if (totalCalculatedValue <= Decimal.zero) return Decimal.zero;

    if (totalCalculatedCost <= Decimal.zero) return Decimal.zero;

    //mark-up only applies to items that can be measured, should there be no measurable items no markup should be tracked / recorded

    // Calculate the cost ratio safely, avoiding division by zero.
    Decimal costRatio = (totalCalculatedCost / totalCalculatedValue).toDecimal(
      scaleOnInfinitePrecision: 10,
    );

    return (Decimal.fromInt(100) - (costRatio * Decimal.fromInt(100))).truncate(
      scale: 2,
    );
  }

  PaymentType? get paymentType;

  List<Refund>? get refunds;

  Decimal? get totalRefund;

  Decimal? get totalRefundCost;

  SalesTax? get salesTax => AppVariables.salesTax;

  Decimal get totalCost {
    if (items!.isEmpty) return Decimal.zero;
    Decimal value =
        items?.fold(
          Decimal.zero,
          (dynamic previousValue, element) =>
              (Decimal.tryParse(previousValue.toString()) ?? Decimal.zero) +
              (Decimal.tryParse((element.valueCost ?? 0).toString()) ??
                  Decimal.zero),
        ) ??
        Decimal.zero;
    return value.truncate(scale: 2);
  }

  Decimal? get totalDiscount => discountAmount;

  Decimal get totalSalesTax {
    if (salesTax == null || salesTax!.enabled == false) return Decimal.zero;

    if (itemCount <= Decimal.zero) return Decimal.zero;

    Decimal customItemsTaxInclusiveTaxAmount = Decimal.zero;

    Decimal productItemsTaxInclusiveTaxAmount = Decimal.zero;
    Decimal cartDiscount = totalDiscount ?? Decimal.zero;

    if (salesTax!.applyToCustomAmount! && items!.any((i) => i.isCustomSale!)) {
      Decimal customItemsTotalValue = items!
          .where((i) => i.isCustomSale ?? false)
          .map((s) => Decimal.parse((s.valueCost ?? 0).toString()))
          .reduce((a, b) => a + b);
      Decimal taxableValue = (customItemsTotalValue - cartDiscount);

      Decimal taxMultiplier =
          (Decimal.parse((salesTax!.percentage!).toString()) /
                  Decimal.fromInt(100))
              .toDecimal(scaleOnInfinitePrecision: 10);

      customItemsTaxInclusiveTaxAmount =
          taxableValue -
          (taxableValue / (Decimal.fromInt(1) + taxMultiplier)).toDecimal(
            scaleOnInfinitePrecision: 10,
          );
    }

    if (items!.any((i) => !i.isCustomSale!)) {
      Decimal productItemsTotalValue = items!
          .where((i) => !(i.isCustomSale ?? false))
          .map((s) => Decimal.parse((s.valueCost ?? 0).toString()))
          .reduce((a, b) => a + b);
      Decimal taxableValue = (productItemsTotalValue - cartDiscount);

      Decimal taxMultiplier =
          (Decimal.parse((salesTax!.percentage!).toString()) /
                  Decimal.fromInt(100))
              .toDecimal(scaleOnInfinitePrecision: 10);
      productItemsTaxInclusiveTaxAmount ==
          taxableValue -
              (taxableValue / (Decimal.fromInt(1) + taxMultiplier)).toDecimal(
                scaleOnInfinitePrecision: 10,
              );
    }

    return (productItemsTaxInclusiveTaxAmount +
            customItemsTaxInclusiveTaxAmount)
        .truncate(scale: 2);
  }

  // TODO: This implementation of totalSalesTax could be used when we introduce item-level taxes
  // double get totalSalesTax {
  //   if (items == null || items!.isEmpty) return 0.0;
  //   List<StockProduct> productsInCart = getStockProductsInCart(items!);

  //   List<SalesTax> allTaxes =
  //       AppVariables.store?.state.appSettingsState.salesTaxesList ?? [];

  //   return TaxCalculationService.calculateTotalCartTax(
  //     items: items!,
  //     totalDiscount: totalDiscount ?? 0,
  //     productsInCart: productsInCart,
  //     allAvailableTaxes: allTaxes,
  //   );
  // }

  // List<StockProduct> getStockProductsInCart(List<CheckoutCartItem> items) {
  //   final List<StockProduct> allProducts =
  //       AppVariables.store?.state.productState.products ?? [];
  //   final Map<String, List<StockProduct>> allProductVariantsMap =
  //       AppVariables.store?.state.productState.productVariants ?? {};
  //   return items
  //       .where((item) => item.productId != null && item.productId!.isNotEmpty)
  //       .map((item) {
  //         // Try to find in allProducts first
  //         final product =
  //             allProducts.firstWhereOrNull((p) => p.id == item.productId);
  //         if (product != null) return product;
  //         // If not found, search in allProductVariantsMap values
  //         for (final variants in allProductVariantsMap.values) {
  //           final variant =
  //               variants.firstWhereOrNull((v) => v.id == item.productId);
  //           if (variant != null) return variant;
  //         }
  //         return null;
  //       })
  //       .whereNotNull()
  //       .toList();
  // }

  List<StockProduct> getStockProductsInCart(List<CheckoutCartItem> items) {
    final List<StockProduct> allProducts =
        AppVariables.store?.state.productState.products ?? [];
    final Map<String, List<StockProduct>> allProductVariantsMap =
        AppVariables.store?.state.productState.productVariants ?? {};

    final Map<String, StockProduct> productLookupMap = getProductLookupMap(
      allProducts,
      allProductVariantsMap,
    );
    return items
        .map((item) => productLookupMap[item.productId])
        .nonNulls
        .toList();
  }

  Map<String, StockProduct> getProductLookupMap(
    List<StockProduct> allProducts,
    Map<String, List<StockProduct>> allProductVariantsMap,
  ) {
    // Merge all products and variants into a single lookup map for efficiency.
    final Map<String, StockProduct> productLookupMap = {};

    // Add all base products to the map.
    for (final product in allProducts) {
      if (product.id != null && product.id!.isNotEmpty) {
        productLookupMap[product.id!] = product;
      }
    }

    // Add all variant products to the map.
    for (final variantList in allProductVariantsMap.values) {
      for (final variant in variantList) {
        if (variant.id != null && variant.id!.isNotEmpty) {
          productLookupMap[variant.id!] = variant;
        }
      }
    }
    return productLookupMap;
  }

  Decimal get totalValue {
    if (items!.isEmpty) return Decimal.zero;
    Decimal value =
        items?.fold(
          Decimal.zero,
          (dynamic previousValue, element) =>
              (Decimal.tryParse(previousValue.toString()) ?? Decimal.zero) +
              (Decimal.tryParse((element.value ?? 0).toString()) ??
                  Decimal.zero),
        ) ??
        Decimal.zero;

    return value.truncate(scale: 2);
  }

  List<CheckoutCartItem>? get voidedItems;

  Refund? get quickRefund;

  double? get lastTransactionNumber;

  bool get productVariantIsLoading;

  StockProduct? get productVariant;
}
