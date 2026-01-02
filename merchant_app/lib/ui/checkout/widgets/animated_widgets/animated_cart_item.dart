// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// Project imports:
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_actions.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_quantity_page.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';

class AnimatedCartItem extends StatelessWidget {
  final Animation<Color?> forgroundColor;
  final Animation<Color?> backgroundColor;
  final Animation<double> controller;
  final Animation<double> fontSize;
  final Animation<FontWeight> fontWeight;
  final BuildContext parentContext;
  final CheckoutCartItem item;
  final CheckoutVM vm;

  AnimatedCartItem({
    Key? key,
    required this.vm,
    required this.parentContext,
    required this.item,
    required this.controller,
  }) : forgroundColor =
           ColorTween(
             begin: Colors.black,
             end: Theme.of(parentContext).colorScheme.primary,
           ).animate(
             CurvedAnimation(
               parent: controller,
               curve: const Interval(0, 0.9, curve: Curves.fastOutSlowIn),
             ),
           ),
       backgroundColor =
           ColorTween(
             begin: Colors.grey.shade600,
             end: Theme.of(parentContext).colorScheme.secondary,
           ).animate(
             CurvedAnimation(
               parent: controller,
               curve: const Interval(0, 0.9, curve: Curves.fastOutSlowIn),
             ),
           ),
       fontSize = Tween<double>(begin: 16, end: 20).animate(
         CurvedAnimation(
           parent: controller,
           curve: const Interval(0, 0.9, curve: Curves.easeIn),
         ),
       ),
       fontWeight =
           Tween<FontWeight>(
             begin: FontWeight.normal,
             end: FontWeight.bold,
           ).animate(
             CurvedAnimation(
               parent: controller,
               curve: const Interval(0, 0.9, curve: Curves.easeIn),
             ),
           ),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (ctx, widget) => cartItem(parentContext, item, vm),
    );
  }

  Slidable cartItem(
    BuildContext context,
    CheckoutCartItem item,
    CheckoutVM vm,
  ) => Slidable(
    endActionPane: ActionPane(
      extentRatio: .25,
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (ctx) async {
            var result = await confirmDismissal(context, item);

            if (result == true) {
              // removed ignore: use_build_context_synchronously
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
    key: Key(item.id!),
    // actionPane: SlidableDrawerActionPane(),
    // actionExtentRatio: 0.25,
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
    child: ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      dense: EnvironmentProvider.instance.isLargeDisplay! ? false : true,
      subtitle: item.productId != null && item.productId!.isNotEmpty
          ? (item.isService ?? false)
                ? LongText('Service', textColor: backgroundColor.value)
                : LongText(
                    '${vm.productState!.getProductQty(productId: item.productId)} currently in stock',
                    textColor: backgroundColor.value,
                  )
          : item.isCombo ?? false
          ? LongText(
              'Combo Item, saving of '
              '${TextFormatter.toStringCurrency(item.totalSaving, currencyCode: '')}',
              textColor: backgroundColor.value,
            )
          : LongText('Custom item sale', textColor: backgroundColor.value),
      title: Text(
        '${item.quantity.round()} x ${item.description}',
        style: TextStyle(color: forgroundColor.value, fontSize: fontSize.value),
      ),
      trailing: Text(
        TextFormatter.toStringCurrency(item.value, currencyCode: ''),
      ),
      onTap: () async {
        if (!item.isCustomSale!) {
          var qty = await showPopupDialog(
            context: parentContext,
            content: CheckoutItemQuantityCapturePage(
              item: item,
              initialValue: item.quantity,
            ),
          );

          if (qty == null || qty <= 0) {
            return;
          } else {
            item.quantity = qty;
            // if (mounted) setState(() {});

            // removed ignore: use_build_context_synchronously
            StoreProvider.of<AppState>(
              parentContext,
            ).dispatch(createCartCombos());
          }
        }
      },
    ),
  );
}
