// remove ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'package:decimal/decimal.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/footer_buttons_icon_primary.dart';
import 'package:littlefish_merchant/shared/constants/permission_name_constants.dart';
import 'package:littlefish_merchant/shared/constants/semantics_constants.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_quick_sale_page.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/checkout_more_sales_actions.dart';
import 'package:redux/redux.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/shopping_cart_panel.dart';
import 'package:littlefish_merchant/hardware/barcode_scanner/barcode_scanner.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/app_settings/app_settings_actions.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_actions.dart';
import 'package:littlefish_merchant/redux/customer/customer_actions.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_quantity_page.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/checkout_library.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/checkout_shopping_cart.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_charge_page.dart';
import '../../../../app/app.dart';
import '../../../../models/sales/checkout/checkout_discount.dart';
import '../../../../common/presentaion/components/bottomNavBar/bottom_navbar.dart';

class SelectProductsPage extends StatefulWidget {
  final bool hideHomeAppBar;

  static const route = 'checkout/selectProducts';

  const SelectProductsPage({Key? key, this.hideHomeAppBar = false})
    : super(key: key);

  @override
  State<SelectProductsPage> createState() => _SelectProductsPageState();
}

class _SelectProductsPageState extends State<SelectProductsPage>
    with TickerProviderStateMixin {
  LoggerService get logger => LittleFishCore.instance.get<LoggerService>();
  BarcodeScanner? scanner;

  // HardwareProvider hardwareProvider;
  final GlobalKey _favoritesKey = GlobalKey();
  final GlobalKey _categoriesKey = GlobalKey();
  final GlobalKey _moreKey = GlobalKey();

  List<String> scannerLog = <String>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scanner?.dispose();
    scanner = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CheckoutVM>(
      onInit: (store) async {
        store.dispatch(CheckoutSetLoadingAction(false));
        //store.dispatch(initializeCustomers());
        store.dispatch(initializeCustomers());
        store.dispatch(initializeTicketSettings(refresh: true));
        store.dispatch(initialzeSalesTax(refresh: false));
      },
      converter: (Store<AppState> store) {
        return CheckoutVM.fromStore(store);
      },
      builder: (BuildContext context, CheckoutVM vm) {
        if (shouldClearDiscount(vm)) {
          vm.store?.dispatch(CheckoutClearDiscountAction());
        }
        if (shouldClearDiscount(vm)) {
          vm.store?.dispatch(CheckoutClearDiscountAction());
        }
        return EnvironmentProvider.instance.isLargeDisplay!
            ? scaffoldLarge(context, vm)
            : scaffoldMobile(context, vm);
      },
    );
  }

  bool shouldClearDiscount(CheckoutVM vm) {
    if (vm.discount == null) return false;
    if (vm.itemCount == 0) return true;
    if (vm.discount!.type == DiscountType.fixedAmount) {
      if ((vm.discount?.value ?? 0) >
          (vm.totalValue ?? Decimal.zero).toDouble())
        return true;
    }
    return false;
  }

  Widget scaffoldLarge(context, CheckoutVM vm) {
    return AppScaffold(
      navBar: const BottomNavBar(page: PageType.sell),
      title: 'Sell',
      hasDrawer: true,
      displayAppBar: true,
      displayNavDrawer: true,
      enableProfileAction: false,

      // displayNavBar: AppVariables.store!.state.enableBottomNavBar!,
      actions: <Widget>[
        IconButton(
          onPressed: () async {
            await CheckoutMoreSalesActions.showMoreActions(
              context: context,
              vm: vm,
            );
            setState(() {});
          },
          icon: const Icon(Icons.more_vert),
          color: Theme.of(context).extension<AppliedSurface>()?.secondary,
          // color: Theme.of(context).colorScheme.surface,
        ),
      ],
      body: vm.isLoading!
          ? const AppProgressIndicator()
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(flex: 5, child: library(context, vm)),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Visibility(
                        visible:
                            AppVariables.store!.state.enableDiscounts == true &&
                            vm.discountsAllowed,
                        child: Column(
                          children: [
                            if (userHasPermission(allowDiscountOnCart)) ...[
                              ApplyDiscountButton(context: context, vm: vm),
                            ],
                            if (userHasPermission(allowDiscountOnCart) &&
                                vm.itemCount == 0)
                              ...[],
                          ],
                        ),
                      ),
                      const Expanded(
                        child: Material(
                          elevation: 2,
                          child: CheckoutShoppingCart(
                            displaySummary: true,
                            displayButtons: true,
                            displayCurrentSale: true,
                            displayCartItemsHeading: true,
                            viewMode: CartViewMode.checkoutCartView,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget scaffoldMobile(BuildContext context, CheckoutVM vm) {
    return AppScaffold(
      navBar: const BottomNavBar(page: PageType.sell),
      displayNavBar: AppVariables.store!.state.enableBottomNavBar!,
      hasDrawer: AppVariables.store!.state.enableSideNavDrawer!,
      displayNavDrawer: AppVariables.store!.state.enableSideNavDrawer!,
      displayBackNavigation: vm.store!.state.enableSideNavDrawer!,
      persistentFooterButtons: <Widget>[
        FooterButtonsIconPrimary(
          primaryButtonText:
              ((vm.checkoutTotal ?? Decimal.zero) <= Decimal.zero)
              ? 'NO ITEMS'
              : 'CONTINUE TO PAYMENT - ${TextFormatter.toStringCurrency((vm.checkoutTotal ?? Decimal.zero).toDouble())}',
          semanticsIdentifier: SemanticsConstants.kQuickSellbottom,
          semanticsLabel: SemanticsConstants.kQuickSellbottom,
          secondaryButtonIcon: LittleFishIcons.quickSale,
          onPrimaryButtonPressed:
              ((vm.checkoutTotal ?? Decimal.zero) <= Decimal.zero)
              ? null
              : (context) {
                  Navigator.of(context).pushNamed(CheckoutChargePage.route);
                },
          onSecondaryButtonPressed: (_) async {
            vm.onClear();
            Navigator.of(context).pushNamed(CheckoutQuickSale.route);
          },
        ),
      ],
      title: 'Sell',
      actions: <Widget>[
        Semantics(
          identifier: SemanticsConstants.kMoreActionsMenu, // For UI Tests
          label: SemanticsConstants.kMoreActionsMenu, //For screen reader
          child: IconButton(
            onPressed: () async {
              await CheckoutMoreSalesActions.showMoreActions(
                context: context,
                vm: vm,
              );
              setState(() {});
            },
            icon: const Icon(Icons.more_vert),
            color: Theme.of(context).extension<AppliedSurface>()?.secondary,
            // color: Theme.of(context).colorScheme.surface,
          ),
        ),
      ],
      body: vm.isLoading!
          ? const AppProgressIndicator()
          : Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: getCollapsedCartHeight(vm),
                    ),
                    child: library(context, vm),
                  ), // Your main content
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SlidingUpPanel(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppVariables.appDefaultButtonRadius),
                    ),
                    border: Border.all(color: Colors.transparent),
                    minHeight: getCollapsedCartHeight(vm),
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                    backdropEnabled: true,
                    color: Theme.of(context).colorScheme.background,
                    panel: ShoppingCartPanel(vm: vm),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> showQuantity(StockProduct item, CheckoutVM vm) async {
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

  library(BuildContext context, CheckoutVM vm) => CheckoutLibrary(
    vm: vm,
    parentContext: context,
    categoryKey: _categoriesKey,
    favoritesKey: _favoritesKey,
    onChanged: (_) => setState(() {}),
  );

  double getCollapsedCartHeight(CheckoutVM vm) {
    double height = 40;
    return height;
  }
}
