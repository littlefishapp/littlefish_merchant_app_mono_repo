import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/inventory/inventory_actions.dart';
import 'package:littlefish_merchant/redux/suppliers/supplier_actions.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/inventory/stock_take/pages/stock_take_list_page.dart';
import 'package:littlefish_merchant/ui/invoicing/invoices_page.dart';
import 'package:littlefish_merchant/ui/products/categories/widgets/product_categories_new.dart';
import 'package:littlefish_merchant/ui/products/products/products_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/bottomNavBar/bottom_navbar.dart';
import 'package:littlefish_merchant/ui/suppliers/suppliers_page.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/products/products/view_models/product_collection_vm.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/products_list.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../common/presentaion/components/buttons/button_quick_action.dart';
import '../../../../models/stock/stock_take_item.dart';
import '../../../../shared/constants/permission_name_constants.dart';
import '../../../manage_users/widgets/item_list_tile.dart';

class StockPageAction {
  late String route;
  late String title;
  late IconData icon;
  late String? description;
  final Function({required BuildContext context})? onTap;

  StockPageAction({
    required this.title,
    required this.icon,
    required this.route,
    this.description,
    this.onTap,
  });
}

class StockManagementPage extends StatefulWidget {
  static const route = 'item/stock-manage';
  final bool showBackButton;
  const StockManagementPage({Key? key, this.showBackButton = false})
    : super(key: key);

  @override
  State<StockManagementPage> createState() => _StockManagementPageState();
}

class _StockManagementPageState extends State<StockManagementPage> {
  // List<TargetFocus> targets = [];
  final GlobalKey _newItemKey = GlobalKey();
  final GlobalKey _newItemStockKey = GlobalKey();
  List<StockPageAction> _actions = List.empty();
  List<StockPageAction> _manageActions = List.empty();

  void buildActions() {
    List<StockPageAction> actions = List.empty(growable: true);
    if (userHasPermission(allowInventoryStock)) {
      actions.add(
        StockPageAction(
          title: 'Record Stock',
          icon: Icons.add,
          route: '',
          onTap: ({required context}) {
            StoreProvider.of<AppState>(context).dispatch(
              newStockTake(type: StockRunType.reCount, context: context),
            );
          },
        ),
      );
      if (AppVariables.store!.state.enableReceivedStock ?? true) {
        actions.add(
          StockPageAction(
            title: 'Received Stock',
            icon: Icons.receipt_long_sharp,
            route: '',
            onTap: ({required context}) {
              StoreProvider.of<AppState>(
                context,
              ).dispatch(newGoodsRecievable(context));
            },
          ),
        );
      }
    }

    if (userHasPermission(allowSupplier)) {
      actions.add(
        StockPageAction(
          title: 'Add Supplier',
          icon: Icons.local_shipping_outlined,
          route: '',
          onTap: ({required context}) {
            StoreProvider.of<AppState>(
              context,
            ).dispatch(createSupplier(context));
          },
        ),
      );
    }

    setState(() {
      _actions = actions;
    });
  }

  void buildManageActions() {
    List<StockPageAction> actions = List.empty(growable: true);

    if (userHasPermission(allowInventoryStock)) {
      actions.add(
        StockPageAction(
          title: 'Manage Stock',
          icon: Icons.inventory_2_outlined,
          route: ProductsPage.route,
          description: 'Add, edit & organise stock',
        ),
      );

      actions.add(
        StockPageAction(
          title: 'Past Stock Takes',
          icon: Icons.category_outlined,
          route: StockTakeListPage.route,
          description: 'Add & edit past stock takes',
        ),
      );
    }

    if (userHasPermission(allowSupplier)) {
      actions.add(
        StockPageAction(
          title: 'Manage Suppliers',
          icon: Icons.local_shipping_outlined,
          route: SuppliersPage.route,
          description: 'Add & edit your suppliers',
        ),
      );

      actions.add(
        StockPageAction(
          title: 'Manage Suppliers Invoices',
          icon: Icons.checklist_rtl_outlined,
          route: InvoicesPage.route,
          description: 'View & manage suppliers invoices',
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
        return scaffold(context, vm);
      },
    );
  }

  Widget scaffold(BuildContext context, ProductsViewModel vm) {
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    final showSideNav =
        isTablet || (vm.store?.state.enableSideNavDrawer ?? false);
    return AppScaffold(
      enableProfileAction: !showSideNav,
      hasDrawer: showSideNav,
      displayNavDrawer: showSideNav,
      navBar: const BottomNavBar(page: PageType.stock),
      displayNavBar: AppVariables.store!.state.enableBottomNavBar!,
      displayBackNavigation: !showSideNav,
      displayAppBar: true,
      title: 'Stock',
      actions: const <Widget>[],
      body: Container(
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  onTap: () => Navigator.of(context).pushNamed(
                    action.route,
                    arguments: routeArgumentChecker(action.title),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  routeArgumentChecker(String route) {
    if (route == 'Manage Stock') {
      return {'isStockProducts': true};
    } else {
      return null;
    }
  }

  categoriesContext(context) => Column(
    children: [
      Expanded(
        child: SingleChildScrollView(
          child: ProductCategoriesNew(parentContext: context),
        ),
      ),
    ],
  );

  products(
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
