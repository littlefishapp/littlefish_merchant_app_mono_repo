// Flutter imports:
// remove ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_actions.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_charge_page.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_quantity_page.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'checkout_cart_item_tile.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

class CheckoutShoppingCart extends StatefulWidget {
  final bool displayButtons;

  final bool displaySummary;
  final bool displayCurrentQuantity;
  final bool displayCartItemsHeading;

  final bool displayCurrentSale;
  final AnimationController? controller;
  final CartViewMode? viewMode;
  const CheckoutShoppingCart({
    Key? key,
    this.displayButtons = true,
    this.displaySummary = true,
    this.displayCurrentSale = true,
    this.displayCurrentQuantity = true,
    this.displayCartItemsHeading = true,
    this.controller,
    this.viewMode,
  }) : super(key: key);

  @override
  State<CheckoutShoppingCart> createState() => _CheckoutShoppingCartState();
}

class _CheckoutShoppingCartState extends State<CheckoutShoppingCart> {
  AnimationController? _controller;
  bool? _isLargeDisplay;
  late double _horizontalPadding;

  @override
  void initState() {
    super.initState();
    _horizontalPadding = 16;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller != null) _controller = widget.controller;
    return StoreConnector<AppState, CheckoutVM>(
      onInit: (store) {
        final vm = CheckoutVM.fromStore(store);
        _isLargeDisplay ??= vm.store!.state.isLargeDisplay;
        _horizontalPadding = (_isLargeDisplay ?? false) ? 16.0 : 0;
      },
      converter: (Store<AppState> store) => CheckoutVM.fromStore(store),
      builder: (BuildContext context, CheckoutVM vm) {
        _isLargeDisplay ??= vm.store!.state.isLargeDisplay;

        return layout(context, vm);
      },
    );
  }

  RenderObjectWidget layout(BuildContext context, CheckoutVM vm) {
    return vm.itemCount == 0 && !(_isLargeDisplay ?? false)
        ? const Center(
            child: Column(
              children: [
                Expanded(child: SizedBox()),
                Icon(Icons.shopping_cart_outlined, size: 50.0),
                SizedBox(height: 8.0),
                Text(
                  'Cart is empty.',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF636164),
                  ),
                ),
                SizedBox(height: 16),
                Text('Add items to continue to payment.'),
                Expanded(child: SizedBox()),
              ],
            ),
          )
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
            child: Column(
              children: <Widget>[
                const CommonDivider(),
                if (widget.displayCartItemsHeading)
                  ListTile(
                    tileColor: Theme.of(context).colorScheme.background,
                    title: context.labelMedium(
                      'Cart Items',
                      isBold: true,
                      alignLeft: true,
                    ),
                  ),
                Expanded(
                  flex: 4,
                  child: Container(
                    child: widget.viewMode == null
                        ? itemList(context, vm)
                        : checkoutProductsPageItemList(context, vm),
                  ),
                ),
                Visibility(
                  visible: widget.displaySummary,
                  child: SizedBox(child: cartSummary(context, vm)),
                ),
                Visibility(
                  visible: widget.displayButtons,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Container(child: buttonRow(context, vm)),
                  ),
                ),
                // if (!EnvironmentProvider.instance.isLargeDisplay!)
                const SizedBox(height: 32),
              ],
            ),
          );
  }

  Container itemList(BuildContext context, CheckoutVM vm) => Container(
    padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
    child: ListView.separated(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: vm.items!.length,
      itemBuilder: (BuildContext ctx, int index) {
        // var item = vm.items[index];

        return cartItem(context, vm.items![index], vm);
      },
      separatorBuilder: (BuildContext context, int index) =>
          const CommonDivider(height: 0.5),
    ),
  );

  Container checkoutProductsPageItemList(BuildContext context, CheckoutVM vm) =>
      Container(
        padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: vm.items!.length,
          itemBuilder: (BuildContext ctx, int index) {
            CheckoutCartItem cartItem = vm.items![index];
            return CheckoutCartItemTile(
              cartItem: cartItem,
              key: ValueKey(cartItem.id),
            );
          },
        ),
      );

  cartItem(
    BuildContext context,
    CheckoutCartItem item,
    CheckoutVM vm,
  ) => Slidable(
    key: Key(item.id!),
    endActionPane: ActionPane(
      extentRatio: .25,
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (ctx) async {
            var result = await confirmDismissal(context, item);

            if (result == true) {
              vm.onRemove(item, context);
            }
          },
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
      ],
    ),
    child: ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      dense: EnvironmentProvider.instance.isLargeDisplay! ? false : true,
      subtitle: item.productId != null && item.productId!.isNotEmpty
          ? (item.isService ?? false)
                ? const LongText('Service')
                : LongText(
                    '${vm.productState!.getProductQty(productId: item.productId)} currently in stock',
                  )
          : item.isCombo ?? false
          ? LongText(
              "Combo Item, saving of ${TextFormatter.toStringCurrency(item.totalSaving, currencyCode: '')}",
            )
          : const LongText('Custom item sale'),
      title: Text('${item.quantity.round()} x ${item.description}'),
      trailing: Text(
        TextFormatter.toStringCurrency(item.value, currencyCode: ''),
      ),
      onTap: () async {
        if (!item.isCustomSale!) {
          var qty = await showPopupDialog(
            context: context,
            defaultPadding: false,
            content: CheckoutItemQuantityCapturePage(
              item: item,
              initialValue: item.quantity,
            ),
          );

          if (qty == null || qty <= 0) {
            return;
          } else {
            item.quantity = qty;
            if (mounted) setState(() {});

            StoreProvider.of<AppState>(context).dispatch(createCartCombos());
          }
        }
      },
    ),
    // secondaryActions: [
    //   IconSlideAction(
    //     color: Colors.red,
    //     icon: Icons.delete,
    //     onTap: () async {
    //       var result = await confirmDismissal(context, item);

    //       if (result == true) {
    //         vm.onRemove(item, context);
    //       }
    //     },
    //   ),
    // ],
  );

  Container cartSummary(context, CheckoutVM vm) => Container(
    color: Colors.grey.shade50,
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(right: 8, top: 8),
    child: Column(
      children: <Widget>[
        DecoratedText(
          "Discount: ${TextFormatter.toStringCurrency(0, currencyCode: '')}",
          alignment: Alignment.topRight,
          fontSize: 12,
          textColor: Theme.of(context).colorScheme.secondary,
        ),
        const SizedBox(height: 8.0),
        DecoratedText(
          "Sales Tax: ${TextFormatter.toStringCurrency((vm.totalSalesTax ?? Decimal.zero).toDouble(), currencyCode: '')}",
          alignment: Alignment.topRight,
          fontSize: 12,
          textColor: Theme.of(context).colorScheme.secondary,
        ),
        // const SizedBox(height: 8.0),
        // vm.store!.state.isLargeDisplay! &&
        //         vm.store!.state.appSettingsState.allowTickets!
        //     ? Container(
        //         padding: const EdgeInsets.only(
        //           // horizontal: 4.0,
        //           bottom: 12.0,
        //         ),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceAround,
        //           children: <Widget>[
        //             const SizedBox(width: 4),
        //             moreButton(vm),
        //             const SizedBox(width: 36),
        //             DecoratedText(
        //               "TOTAL: ${TextFormatter.toStringCurrency(vm.totalValue, currencyCode: '')}",
        //               alignment: Alignment.topRight,
        //               fontSize: 14,
        //               fontWeight: FontWeight.bold,
        //               textColor: Theme.of(context).colorScheme.secondary,
        //             ),
        //             // SizedBox(width: 4),
        //           ],
        //         ),
        //       )
        //     : DecoratedText(
        //         "TOTAL: ${TextFormatter.toStringCurrency(vm.totalValue, currencyCode: '')}",
        //         alignment: Alignment.topRight,
        //         fontSize: 14,
        //         fontWeight: FontWeight.bold,
        //         textColor: Theme.of(context).colorScheme.secondary,
        //       ),
      ],
    ),
  );

  Visibility buttonRow(BuildContext context, CheckoutVM vm) {
    var addToCartButton = EnvironmentProvider.instance.isLargeDisplay!
        ? Expanded(
            child: (vm.itemCount ?? 0) > 0
                ? ButtonPrimary(
                    buttonColor: Theme.of(context).colorScheme.primary,
                    text:
                        'PAY ${TextFormatter.toStringCurrency((vm.checkoutTotal ?? Decimal.zero).toDouble(), displayCurrency: true)}',
                    onTap: (context) {
                      if (EnvironmentProvider.instance.isLargeDisplay!) {
                        showPopupDialog(
                          context: context,
                          defaultPadding: false,
                          content: const CheckoutChargePage(isEmbedded: true),
                        );
                      } else {
                        Navigator.of(
                          context,
                        ).pushNamed(CheckoutChargePage.route);
                      }
                    },
                  )
                : ButtonSecondary(
                    onTap: (BuildContext context) => showMessageDialog(
                      context,
                      'Your shopping cart is empty, please add items before charging',
                      LittleFishIcons.info,
                    ),
                    text: 'NO ITEMS',
                  ),
          )
        : Expanded(
            child: (vm.itemCount ?? 0) > 0
                ? ButtonPrimary(
                    buttonColor: Theme.of(context).colorScheme.primary,
                    text:
                        'Total ${TextFormatter.toStringCurrency((vm.checkoutTotal ?? Decimal.zero).toDouble(), displayCurrency: true)}',
                    onTap: (context) {
                      if (EnvironmentProvider.instance.isLargeDisplay!) {
                        showPopupDialog(
                          context: context,
                          defaultPadding: false,
                          content: const CheckoutChargePage(isEmbedded: true),
                        );
                      } else {
                        Navigator.of(
                          context,
                        ).pushNamed(CheckoutChargePage.route);
                      }
                    },
                  )
                : ButtonSecondary(
                    onTap: (BuildContext context) => showMessageDialog(
                      context,
                      'Your shopping cart is empty, please add items before charging',
                      LittleFishIcons.info,
                    ),
                    text: 'NO ITEMS',
                  ),
          );

    return Visibility(
      visible: vm.itemCount! > 0,
      child: Container(
        color: Colors.grey.shade50,
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        child: Row(
          children: <Widget>[
            if (!(vm.store!.state.isLargeDisplay ?? false)) clearButton(vm),
            const SizedBox(width: 8.0),
            if (vm.store!.state.isLargeDisplay ?? false) addToCartButton,
          ],
        ),
      ),
    );
  }

  Expanded clearButton(CheckoutVM vm) => Expanded(
    child: ButtonSecondary(onTap: (c) => vm.onClear(), text: 'CLEAR'),
  );
}

enum CartViewMode { checkoutCartView, receiptCartView }
