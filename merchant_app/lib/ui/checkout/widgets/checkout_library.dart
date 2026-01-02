import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/products/product_combo.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_actions.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_merchant/redux/product/product_selectors.dart';
import 'package:littlefish_merchant/tools/billing/billing_helpers.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_quantity_page.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_merchant/ui/products/categories/widgets/category_list_card.dart';
import 'package:littlefish_merchant/ui/products/combos/widgets/product_combo_list.dart';
import 'package:littlefish_merchant/ui/products/products/pages/product_select_page.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/products_list.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_tabbed_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/new_list_tile.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_tabbar.dart';

import 'library_item_tile_tablet.dart';
import 'library_tile_item.dart';
import 'new_sale_top_bar.dart';

class CheckoutLibrary extends StatefulWidget {
  const CheckoutLibrary({
    Key? key,
    this.parentContext,
    this.categoryKey,
    this.favoritesKey,
    required this.vm,
    this.getOfflineProducts = false,
    required this.onChanged,
  }) : super(key: key);

  final BuildContext? parentContext;
  final CheckoutVM vm;

  final Key? categoryKey, favoritesKey;
  final bool getOfflineProducts;
  final void Function(String) onChanged;

  @override
  State<CheckoutLibrary> createState() => _CheckoutLibraryState();
}

class _CheckoutLibraryState extends State<CheckoutLibrary> {
  Key? categoryKey, favoritesKey, newFavKey, prodKey, combosKey;

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    categoryKey = widget.categoryKey;
    favoritesKey = widget.favoritesKey;

    return layout(widget.parentContext ?? context, widget.vm);
  }

  Widget layout(BuildContext context, CheckoutVM vm) => Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: NewSaleTopBar(
          context: context,
          searchController: searchController,
          vm: vm,
          onChanged: widget.onChanged,
        ),
      ),
      Expanded(
        child: AppTabBar(
          tabAlignment: TabAlignment.start,
          physics: const BouncingScrollPhysics(),
          intialIndex: 0,
          scrollable: true,
          resizeToAvoidBottomInset: false,
          tabs: [
            if (AppVariables.store!.state.enableCheckoutFavourites == true)
              TabBarItem(
                key: favoritesKey,
                content: Container(
                  child: favouritesList(
                    context,
                    vm,
                    favoriteProductsSelector(vm.store!.state),
                  ),
                ),
                icon: MdiIcons.star,
              ),
            TabBarItem(
              key: prodKey,
              content: productsList(context, vm),
              // icon: MdiIcons.tagMultiple,
              text: 'All',
            ),
            if (combosWithItemsSelector(vm.store!.state).isNotEmpty &&
                AppVariables.store!.state.enableCombos == true)
              TabBarItem(
                key: combosKey,
                content: comboList(context, vm),
                text: 'Combos',
              ),
            ...categoriesWithItemsSelector(vm.store!.state).map((e) {
              return TabBarItem(
                text: e.displayName,
                content: productsList(context, vm, categoryId: e.id),
              );
            }),
          ],
        ),
      ),
    ],
  );

  MediaQuery favouritesList(
    BuildContext context,
    CheckoutVM vm,
    Iterable<StockProduct>? items,
  ) => MediaQuery.removeViewPadding(
    context: context,
    removeLeft: true,
    removeTop: true,
    child: Container(
      child: EnvironmentProvider.instance.isLargeDisplay!
          ? favoritesTablet(context, vm, items)
          : favoritesMobile(context, vm, items),
    ),
  );

  Container favoritesTablet(
    BuildContext context,
    CheckoutVM vm,
    Iterable<StockProduct>? items,
  ) => Container(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: GridView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: (items?.length ?? 0) + 1,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        // childAspectRatio: 1.5,
        mainAxisSpacing: 8,
        // crossAxisSpacing: 8,
      ),
      itemBuilder: (ctx, index) => index == 0
          ? NewItemTileTablet(
              padding: const EdgeInsets.all(4),
              onTap: () =>
                  showPopupDialog<StockProduct>(
                    content: const ProductSelectPage(isEmbedded: true),
                    context: context,
                    defaultPadding: false,
                  ).then((product) {
                    if (product != null) {
                      vm.store!.dispatch(
                        setProductFavouriteStatus(item: product, value: true),
                      );

                      if (mounted) setState(() {});
                    }
                  }),
              title: 'New Favourite',
            )
          : LibraryItemTileTablet(
              item: items!.elementAt(index - 1),
              onLongPress: () async {
                await showQuantity(items.elementAt(index - 1), vm);
              },
              onTap: (item) {
                if (item.unitType == StockUnitType.byFraction) {
                  showQuantity(items.elementAt(index - 1), vm);
                } else {
                  try {
                    vm.addToCart(
                      item,
                      item.regularVariance,
                      1.0,
                      context,
                      true,
                    );
                  } catch (e) {
                    log(
                      'an error occurred adding an item to the shopping cart',
                      error: e,
                      stackTrace: StackTrace.current,
                    );
                    debugPrint(
                      '### checkout library favoritesTablet error [$e]',
                    );
                  }
                }
              },
            ),
    ),
  );

  Future<void> showQuantity(StockProduct item, CheckoutVM vm) async {
    // var item = items.elementAt(index - 1);

    //ToDo: allow for long press on variable charge items
    if (item.isVariable) return;

    var cartItem = CheckoutCartItem.fromProduct(item, item.regularVariance!);

    var qty = await showPopupDialog<double>(
      context: context,
      defaultPadding: false,
      content: CheckoutItemQuantityCapturePage(
        item: cartItem,
        initialValue: cartItem.quantity,
        asInt: item.unitType == StockUnitType.byUnit,
        isFraction: item.unitType == StockUnitType.byFraction,
      ),
    );

    if (qty == null || qty <= 0) {
      return;
    } else {
      cartItem.quantity = qty;

      vm.addItemsToCart([cartItem]);

      if (mounted) setState(() {});
    }
  }

  Future<void> showQuantityCombo(ProductCombo item, CheckoutVM vm) async {
    // var item = items.elementAt(index - 1);

    var cartItem = CheckoutCartItem.fromCombo(item, 1);

    var qty = await showPopupDialog<double>(
      context: context,
      defaultPadding: false,
      content: CheckoutItemQuantityCapturePage(
        item: cartItem,
        initialValue: cartItem.quantity,
        asInt: true,
      ),
    );

    if (qty == null || qty <= 0) {
      return;
    } else {
      cartItem.quantity = qty;

      vm.addItemsToCart([cartItem]);

      if (mounted) setState(() {});
    }
  }

  ListView favoritesMobile(
    BuildContext context,
    CheckoutVM vm,
    Iterable<StockProduct>? items,
  ) => ListView.separated(
    physics: const BouncingScrollPhysics(),
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) => index == 0
        ? NewItemTile(
            key: newFavKey,
            padding: const EdgeInsets.all(4),
            onTap: () {
              if (isNotPremium(cleanString('favorites'))) {
                showPopupDialog(
                  defaultPadding: false,
                  context: context,
                  content: billingNavigationHelper(isModal: true),
                );
              } else {
                showPopupDialog<StockProduct>(
                  content: const ProductSelectPage(
                    isEmbedded: true,
                    canAddNew: true,
                  ),
                  context: context,
                  defaultPadding: false,
                ).then((product) {
                  if (product != null) {
                    vm.store!.dispatch(
                      setProductFavouriteStatus(item: product, value: true),
                    );

                    if (mounted) setState(() {});
                  }
                });
              }
            },
            title: 'New Favourite',
          )
        : LibraryItemTile(
            item: items!.elementAt(index - 1),
            onLongPress: () {
              showQuantity(items.elementAt(index - 1), vm);
            },
            onRemove: (product) {
              vm.store!.dispatch(
                setProductFavouriteStatus(item: product, value: false),
              );

              if (mounted) setState(() {});
            },
            onTap: (item) async {
              if (item.unitType == StockUnitType.byFraction) {
                showQuantity(items.elementAt(index - 1), vm);
              } else {
                try {
                  vm.addToCart(item, item.regularVariance, 1.0, context, true);
                } catch (e) {
                  log(
                    'an error occurred adding an item to the shopping cart',
                    error: e,
                    stackTrace: StackTrace.current,
                  );

                  debugPrint('### checkout library favoritesMobile error [$e]');
                }
              }
            },
          ),
    itemCount: (items?.length ?? 0) + 1,
    separatorBuilder: (BuildContext context, int index) =>
        const CommonDivider(height: 0.5),
  );

  Container categoriesGrid(
    BuildContext context,
    CheckoutVM vm,
    Iterable<StockCategory> items,
  ) => Container(
    child: EnvironmentProvider.instance.isLargeDisplay!
        ? categoriesTablet(context, vm, items)
        : categoriesMobile(context, vm, items),
  );
  GridView categoriesTablet(
    BuildContext context,
    CheckoutVM vm,
    Iterable<StockCategory> items,
  ) => GridView.builder(
    physics: const BouncingScrollPhysics(),
    shrinkWrap: true,
    itemCount: (items.length),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 5,
      // childAspectRatio: 1.5,
      mainAxisSpacing: 8,
      // crossAxisSpacing: 8,
    ),
    itemBuilder: (BuildContext ctx, int index) => CategoryItemCardTablet(
      item: items.elementAt(index),
      onTap: (category) {
        showPopupDialog<StockProduct>(
          context: ctx,
          defaultPadding: false,
          content: ProductSelectPage(isEmbedded: true, categoryId: category.id),
        ).then((product) {
          if (product != null) {
            vm.addToCart(product, product.regularVariance, null, context, true);
          }
        });
      },
    ),
  );

  ListView categoriesMobile(
    BuildContext context,
    CheckoutVM vm,
    Iterable<StockCategory> items,
  ) => ListView.separated(
    physics: const BouncingScrollPhysics(),
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) => CategoryListCard(
      item: items.elementAt(index),
      onTap: (category) {
        showPopupDialog<StockProduct>(
          context: context,
          defaultPadding: false,
          content: ProductSelectPage(isEmbedded: true, categoryId: category.id),
        ).then((product) {
          if (product != null) {
            vm.addToCart(product, product.regularVariance, null, context, true);
          }
        });
      },
    ),
    itemCount: (items.length),
    separatorBuilder: (BuildContext context, int index) =>
        const CommonDivider(height: 0.5),
  );

  ProductsList productsList(
    BuildContext context,
    CheckoutVM vm, {
    String? categoryId,
  }) => ProductsList(
    canAddNew: false,
    categoryId: categoryId,
    showTopBar: false,
    showCurrentQuantity: false,
    sortBy: vm.sortBy,
    sortOrder: vm.sortOrder,
    onLongPress: (item) {
      showQuantity(item, vm);
    },
    onTap: (product) {
      vm.addToCart(product, product.regularVariance, null, context, true);
    },
    searchController: searchController,
    showQuickPaymentButton: true,
    checkoutVM: vm,
    viewMode: ProductViewMode.checkoutView,
  );

  ProductComboList comboList(BuildContext context, CheckoutVM vm) =>
      ProductComboList(
        canAddNew: false,
        canRemove: false,
        showTopBar: false,
        sortOrder: vm.sortOrder,
        sortBy: vm.sortBy,
        onLongPress: (item) {
          showQuantityCombo(item, vm);
        },
        onTap: (item) {
          vm.store!.dispatch(CheckoutAddCombos([item], []));
        },
        searchController: searchController,
        showQuickPaymentButton: false,
        checkoutVM: vm,
        viewMode: ComboViewMode.checkoutView,
      );
}
