// removed ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/add_product_variant_to_cart.dart';
import 'package:quiver/strings.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_controller.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/business/expenses/widgets/selectable_quantity_tile_new.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_actions.dart'
    as checkout;

class CheckoutProductTile extends StatefulWidget {
  final StockProduct product;
  final bool enableHighlighting;
  final bool enableVariantSelection;

  const CheckoutProductTile({
    required this.product,
    this.enableHighlighting = true,
    this.enableVariantSelection = false,
    Key? key,
  }) : super(key: key);

  @override
  State<CheckoutProductTile> createState() => _CheckoutProductTileState();
}

class _CheckoutProductTileState extends State<CheckoutProductTile> {
  late StockProduct _product;
  late CheckoutCartItem _cartItem;
  late double _cartItemQuantity;
  late int _cartItemIndex;
  late bool _isProductInCart;
  late bool _hasOptions;
  final Map<String, double> _productCustomPrices = {};

  @override
  void initState() {
    _product = widget.product;
    _cartItemQuantity = 0;
    _isProductInCart = false;
    _hasOptions =
        _product.productOptionAttributes != null &&
        _product.productOptionAttributes!.isNotEmpty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CheckoutVM>(
      converter: (Store<AppState> store) => CheckoutVM.fromStore(store),
      builder: (BuildContext context, CheckoutVM vm) {
        double cumulativeQuantity = 0;
        bool showCumulativeTotal = false;

        if (widget.enableVariantSelection && _hasOptions) {
          cumulativeQuantity = getCumulativeVariantQuantity(
            widget.product.id!,
            vm,
          );
          if (cumulativeQuantity > 0) {
            showCumulativeTotal = true;
          }
        }

        _product = widget.product;
        getItemInCart(_product, vm);
        return layout(
          _product,
          vm,
          context,
          showCumulativeTotal,
          cumulativeQuantity,
        );
      },
    );
  }

  Widget layout(
    StockProduct product,
    CheckoutVM vm,
    BuildContext context,
    bool showCumulativeTotal,
    double cumulativeQuantity,
  ) {
    return SelectableQuantityTile(
      initialQuantity: _cartItemQuantity,
      enableQuantityField: !showCumulativeTotal,
      cumulativeVariantQuantity: showCumulativeTotal
          ? cumulativeQuantity
          : null,
      enableAutoIncrementOnTap: (widget.enableVariantSelection && _hasOptions)
          ? false
          : true,
      onTap: (newQuantity) async {
        if (widget.enableVariantSelection && _hasOptions) {
          await showModalBottomSheet(
            useSafeArea: true,
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppVariables.appDefaultRadius),
              ),
            ),
            builder: (ctx) => SafeArea(
              top: false,
              bottom: true,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(ctx).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppVariables.appDefaultRadius),
                  ),
                ),
                child: AddProductVariantToCart(parentProduct: product),
              ),
            ),
          );
        } else {
          final assignedPrice = await vm.addToCart(
            product,
            product.regularVariance,
            1,
            context,
            true,
          );

          if (assignedPrice != null && assignedPrice > 0) {
            setState(() {
              _productCustomPrices[product.id!] = assignedPrice;
            });
          }
        }
      },
      leading: isNotBlank(product.imageUri)
          ? ListLeadingImageTile(url: product.imageUri)
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
                  product.displayName?.substring(0, 2).toUpperCase() ?? '',
                  isSemiBold: true,
                ),
              ),
            ),
      trailing: context.labelSmall(
        TextFormatter.toStringCurrency(
          product.regularSellingPrice ?? 0,
          currencyCode: '',
        ),
        alignRight: true,
        alignLeft: false,
        overflow: TextOverflow.ellipsis,
      ),
      title: context.labelSmall(
        product.displayName ?? '',
        alignLeft: true,
        isBold: true,
        overflow: TextOverflow.ellipsis,
      ),
      onFieldSubmitted: (double newQuantity) async {
        if (!mounted) return;

        final difference = newQuantity - _cartItemQuantity;
        final productId = product.id!;
        if (difference == 0) return;

        final assignedPrice = _productCustomPrices[productId];

        if (difference < 0) {
          setState(() {
            if (product.isVariable) {
              if (assignedPrice != null && assignedPrice > 0) {
                vm.store!.dispatch(
                  checkout.addProductToCart(
                    product: product,
                    variance: product.regularVariance,
                    quantity: difference,
                    variableAmount: assignedPrice,
                    onlyAddOneIfNotInCart: true,
                  ),
                );
              } else {
                vm.addToCart(
                  product,
                  product.regularVariance,
                  difference,
                  context,
                  true,
                );
              }
            } else {
              vm.addToCart(
                product,
                product.regularVariance,
                difference,
                context,
                true,
              );
            }
          });
        } else {
          double? price = assignedPrice;

          if (price == null || price <= 0) {
            price = await vm.addToCart(
              product,
              product.regularVariance,
              difference,
              context,
              true,
            );

            if (price != null && price > 0) {
              _productCustomPrices[productId] = price;
            } else {
              return;
            }
          }

          setState(() {
            vm.store!.dispatch(
              checkout.addProductToCart(
                product: product,
                variance: product.regularVariance,
                quantity: difference,
                variableAmount: price!,
                onlyAddOneIfNotInCart: true,
              ),
            );
          });
        }
      },
      minValue: 0,
      enableHighlighting: widget.enableHighlighting,
    );
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

  List<CheckoutCartItem> getProductVariantsInCart(
    String parentProductId,
    CheckoutVM vm,
  ) {
    List<StockProduct> variants = vm.productVariants[parentProductId] ?? [];
    List<String> variantIds = variants
        .map((e) => e.id)
        .whereType<String>()
        .toList();
    return vm.items
            ?.where((item) => variantIds.contains(item.productId))
            .toList() ??
        [];
  }

  double getCumulativeVariantQuantity(String parentProductId, CheckoutVM vm) {
    List<CheckoutCartItem> variantsInCart = getProductVariantsInCart(
      parentProductId,
      vm,
    );
    if (variantsInCart.isEmpty) return 0;

    return variantsInCart.map((item) => item.quantity).reduce((a, b) => a + b);
  }
}
