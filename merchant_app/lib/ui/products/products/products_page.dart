// flutter imports
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

// project imports
import 'package:littlefish_merchant/common/presentaion/components/bottomNavBar/bottom_navbar.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/footer_buttons_icon_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/list_detail_view.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';

import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/inventory/inventory_actions.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_merchant/ui/products/products/pages/product_page.dart';
import 'package:littlefish_merchant/ui/products/products/view_models/product_collection_vm.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/products_list.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

import '../../../models/stock/stock_product.dart';

class ProductsPage extends StatefulWidget {
  static const route = 'item/products';

  final bool showBackButton;
  final bool isStockProducts;

  const ProductsPage({
    Key? key,
    this.showBackButton = false,
    this.isStockProducts = false,
  }) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final GlobalKey _refreshKey = GlobalKey();
  final GlobalKey _newItemKey = GlobalKey();
  final GlobalKey _newItemStockKey = GlobalKey();
  late dynamic args;
  late bool _isStockProducts = widget.isStockProducts;
  bool isTablet = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('#### ProductsPage build called');
    isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    return StoreConnector<AppState, ProductsViewModel>(
      onInit: (store) => store.dispatch(getAllOptionAttributesAction()),
      converter: (store) => ProductsViewModel.fromStore(store),
      builder: (ctx, vm) {
        try {
          args = ModalRoute.of(context)?.settings.arguments;
          if (args != null && args is Map<String, dynamic>) {
            _isStockProducts = args!['isStockProducts'];
          }
        } catch (e) {
          log('error occurred when getting product page arguments', error: e);
        }

        return isTablet
            ? scaffoldLandscape(context, vm)
            : scaffoldMobile(context, vm);
      },
    );
  }

  scaffoldLandscape(context, ProductsViewModel vm) {
    return ListDetailView(
      listWidget: AppScaffold(
        enableProfileAction: false,
        title: 'Products',
        hasDrawer: true,
        displayNavBar: false,
        displayNavDrawer: true,
        body: vm.isLoading!
            ? const AppProgressIndicator()
            : products(context, vm),
        persistentFooterButtons: <Widget>[
          FooterButtonsIconPrimary(
            primaryButtonText: 'Add Product',
            secondaryButtonIcon: Icons.refresh,
            onPrimaryButtonPressed: (BuildContext ctx) {
              vm.store!.dispatch(createProduct(ctx));
            },
            onSecondaryButtonPressed: (context) {
              vm.store!.dispatch(getProducts(refresh: true));
              vm.store!.dispatch(initializeCategories(refresh: true));
              vm.store!.dispatch(getStockRuns(refresh: true));
            },
          ),
          IconButton(
            key: _newItemKey,
            icon: const Icon(Icons.add),
            onPressed: () => viewProductDetails(context, vm),
          ),
        ],
      ),
      detailWidget:
          vm.selectedItem != null && (vm.selectedItem!.isNew ?? false) == false
          ? ProductPage(
              isEmbedded: true,
              parentContext: context,
              useTabletConfig: true,
            )
          : const AppScaffold(
              enableProfileAction: false,
              displayBackNavigation: false,
              body: Center(
                child: DecoratedText(
                  'Select Product',
                  alignment: Alignment.center,
                  fontSize: 24,
                ),
              ),
            ),
    );
  }

  scaffoldMobile(context, ProductsViewModel vm) => AppScaffold(
    navBar: const BottomNavBar(page: PageType.products),
    title: 'Products',
    body: vm.isLoading!
        ? const AppProgressIndicator()
        : _isStockProducts
        ? products(context, vm, mode: ProductViewMode.stockView)
        : products(context, vm),
    displayNavBar: false,
    hasDrawer: vm.store!.state.enableSideNavDrawer!,
    displayNavDrawer: vm.store!.state.enableSideNavDrawer!,
    persistentFooterButtons: <Widget>[
      FooterButtonsIconPrimary(
        primaryButtonText: 'Add Product',
        secondaryButtonIcon: Icons.refresh,
        onPrimaryButtonPressed: (BuildContext ctx) {
          vm.store!.dispatch(createProduct(context));
        },
        onSecondaryButtonPressed: (context) {
          vm.store!.dispatch(getProducts(refresh: true));
          vm.store!.dispatch(initializeCategories(refresh: true));
          vm.store!.dispatch(getStockRuns(refresh: true));
        },
      ),
    ],
  );

  products(
    BuildContext context,
    ProductsViewModel vm, {
    ProductViewMode mode = ProductViewMode.productsView,
  }) => ProductsList(
    newItemKey: mode == ProductViewMode.productsView
        ? _newItemKey
        : _newItemStockKey,
    isOnlyTrackableStock: mode == ProductViewMode.stockView,
    viewMode: mode,
    parentContext: context,
    sortBy: vm.sortBy,
    sortOrder: vm.sortOrder,
    onUpdateSort: (order, type) async {
      await vm.updateSortOptions(order, type);
      if (mounted) setState(() {});
    },
    onTap: (item) => viewProductDetails(context, vm, product: item),
  );

  Future<void> viewProductDetails(
    BuildContext context,
    ProductsViewModel vm, {
    StockProduct? product,
  }) async {
    //this is an existing product that should be edited
    if (product != null) {
      vm.store!.dispatch(ProductSelectAction(product));
      vm.store!.dispatch(editProduct(context, product));
      debugPrint(
        '### ProductsPage - dispatch ProductSelectAction & editProduct of ${product.name}',
      );
    } else {
      vm.store!.dispatch(createProduct(context));
    }
  }
}
