// flutter imports
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';

// project imports
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_quick_action.dart';
import 'package:littlefish_merchant/ui/manage_users/widgets/item_list_tile.dart';
import 'package:littlefish_merchant/ui/products/categories/widgets/product_categories_new.dart';
import 'package:littlefish_merchant/ui/products/categories/widgets/product_categories_page.dart';
import 'package:littlefish_merchant/ui/products/combos/product_combos_page.dart';
import 'package:littlefish_merchant/ui/products/discounts/pages/discount_page.dart';
import 'package:littlefish_merchant/ui/products/product_discounts/pages/manage_product_discounts_page.dart';
import 'package:littlefish_merchant/ui/products/products/products_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/bottomNavBar/bottom_navbar.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/products/products/view_models/product_collection_vm.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/products_list.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';

import '../../../../redux/product/product_actions.dart';

class ProductPageAction {
  late String route;
  late String title;
  late IconData icon;
  late String? description;
  final Function({required BuildContext context})? onTap;

  ProductPageAction({
    required this.title,
    required this.icon,
    required this.route,
    this.description,
    this.onTap,
  });
}

class ProductsManagementPage extends StatefulWidget {
  static const route = 'item/products-manage';
  final bool showBackButton;
  const ProductsManagementPage({Key? key, this.showBackButton = false})
    : super(key: key);

  @override
  State<ProductsManagementPage> createState() => _ProductsManagementPageState();
}

class _ProductsManagementPageState extends State<ProductsManagementPage> {
  final GlobalKey _newItemKey = GlobalKey();
  final GlobalKey _newItemStockKey = GlobalKey();
  List<ProductPageAction> _actions = List.empty();
  List<ProductPageAction> _manageActions = List.empty();

  void buildActions() {
    List<ProductPageAction> actions = List.empty(growable: true);
    actions.add(
      ProductPageAction(
        title: 'Add \n Product',
        icon: Icons.add,
        route: '',
        onTap: ({required context}) {
          StoreProvider.of<AppState>(context).dispatch(createProduct(context));
        },
      ),
    );
    actions.add(
      ProductPageAction(
        title: 'Add \n Category',
        icon: Icons.category_outlined,
        onTap: ({required context}) {
          StoreProvider.of<AppState>(context).dispatch(createCategory(context));
        },
        route: '',
      ),
    );
    if (AppVariables.store!.state.enableCombos == true) {
      actions.add(
        ProductPageAction(
          title: 'Add \n Combo',
          icon: Icons.card_giftcard,
          onTap: ({required context}) {
            StoreProvider.of<AppState>(context).dispatch(createCombo(context));
          },
          route: '',
        ),
      );
    }
    if (AppVariables.store!.state.enableProductDiscounts == true) {
      actions.add(
        ProductPageAction(
          title: 'Discount \n Products',
          icon: Icons.percent,
          route: DiscountPage.route,
        ),
      );
    }
    setState(() {
      _actions = actions;
    });
  }

  void buildManageActions() {
    List<ProductPageAction> actions = List.empty(growable: true);
    actions.add(
      ProductPageAction(
        title: 'Products',
        icon: Icons.library_books,
        route: ProductsPage.route,
        description: 'Add, edit & organise products',
      ),
    );

    actions.add(
      ProductPageAction(
        title: 'Categories',
        icon: Icons.category_outlined,
        route: ProductCategoriesPage.route,
        description: 'Add & edit product categories',
      ),
    );
    if (AppVariables.store!.state.enableCombos == true) {
      actions.add(
        ProductPageAction(
          title: 'Product Combos',
          icon: Icons.card_giftcard,
          route: ProductCombosPage.route,
          description: 'Add & edit your combos',
        ),
      );
    }

    if (AppVariables.store!.state.enableProductDiscounts == true) {
      actions.add(
        ProductPageAction(
          title: 'Promotions & Discounts',
          icon: Icons.checklist_rtl_outlined,
          route: ManageProductDiscountsPage.route,
          description: 'View & manage promotions & discounts',
        ),
      );
    }
    setState(() {
      _manageActions = actions;
    });
  }

  @override
  void initState() {
    super.initState();
    buildActions();
    buildManageActions();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProductsViewModel>(
      converter: (store) => ProductsViewModel.fromStore(store),
      builder: (ctx, vm) {
        return scaffoldMobile(context, vm);
      },
    );
  }

  AppScaffold scaffoldMobile(BuildContext context, ProductsViewModel vm) =>
      AppScaffold(
        navBar: const BottomNavBar(page: PageType.products),
        displayNavBar: vm.store!.state.enableBottomNavBar!,
        displayBackNavigation: vm.store!.state.enableSideNavDrawer!,
        title: 'Products',
        actions: const <Widget>[],
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(width: 4),
                      context.headingXSmall(
                        'Actions',
                        color: Theme.of(
                          context,
                        ).extension<AppliedTextIcon>()?.emphasized,
                        isBold: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: _actions.map((action) {
                        return ButtonQuickAction(
                          icon: action.icon,
                          title: action.title,
                          onTap: () {
                            if (action.onTap != null) {
                              action.onTap!(context: context);
                            } else {
                              Navigator.of(context).pushNamed(action.route);
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(width: 4),
                      context.headingXSmall(
                        'Manage',
                        color: Theme.of(
                          context,
                        ).extension<AppliedTextIcon>()?.emphasized,
                        isBold: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: _manageActions.map((action) {
                    return ItemListTile(
                      title: action.title,
                      subtitle: action.description,
                      leading: Icon(action.icon),
                      onTap: () =>
                          Navigator.of(context).pushNamed(action.route),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      );

  Column categoriesContext(context) => Column(
    children: [
      Expanded(
        child: SingleChildScrollView(
          child: ProductCategoriesNew(parentContext: context),
        ),
      ),
    ],
  );

  ProductsList products(
    BuildContext context, {
    ProductViewMode mode = ProductViewMode.productsView,
  }) => ProductsList(
    newItemKey: mode == ProductViewMode.productsView
        ? _newItemKey
        : _newItemStockKey,
    viewMode: mode,
    parentContext: context,
    onTap: (item) {},
  );
}
