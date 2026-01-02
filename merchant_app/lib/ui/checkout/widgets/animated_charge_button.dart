// Flutter imports:
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

// Project imports:
import 'package:littlefish_merchant/ui/checkout/pages/checkout_charge_page.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/app/theme/ui_state_data.dart';

class ChargeButtonAnimation extends StatelessWidget {
  final BuildContext parentContext;
  final Key? chargeKey;
  final CheckoutVM checkoutVM;
  final bool withTicket;
  final Animation<double> controller;
  // final Animation<double> width;
  final Animation<double> height;
  final Animation<EdgeInsets> padding;
  final Animation<EdgeInsets> margin;
  final Animation<EdgeInsets> ticketMargin;
  final Animation<Color?> color;

  ChargeButtonAnimation({
    Key? key,
    this.chargeKey,
    this.withTicket = false,
    required this.controller,
    required this.parentContext,
    required this.checkoutVM,
  }) : height = Tween<double>(begin: 62, end: 76).animate(
         CurvedAnimation(
           parent: controller,
           curve: const Interval(0, 0.9, curve: Curves.ease),
         ),
       ),
       padding =
           Tween<EdgeInsets>(
             begin: const EdgeInsets.only(top: 0),
             end: const EdgeInsets.only(top: 8),
           ).animate(
             CurvedAnimation(
               parent: controller,
               curve: const Interval(0, 0.9, curve: Curves.ease),
             ),
           ),
       margin =
           Tween<EdgeInsets>(
             begin: const EdgeInsets.only(top: 2, bottom: 8, left: 8, right: 8),
             end: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
           ).animate(
             CurvedAnimation(
               parent: controller,
               curve: const Interval(0, 0.9, curve: Curves.ease),
             ),
           ),
       ticketMargin =
           Tween<EdgeInsets>(
             begin: const EdgeInsets.only(top: 2, bottom: 8, left: 4, right: 8),
             end: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
           ).animate(
             CurvedAnimation(
               parent: controller,
               curve: const Interval(0, 0.9, curve: Curves.ease),
             ),
           ),
       color =
           ColorTween(
             begin: Theme.of(parentContext).colorScheme.primary,
             end: Theme.of(parentContext).colorScheme.secondary,
           ).animate(
             CurvedAnimation(
               parent: controller,
               curve: const Interval(0, 0.9, curve: Curves.ease),
             ),
           ),
       super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (ctx, widget) => chargeButton(parentContext, checkoutVM),
    );
  }

  Row chargeButton(BuildContext context, CheckoutVM vm) {
    var chargeButton = Expanded(
      child: Container(
        margin: withTicket ? ticketMargin.value : margin.value,
        child: ElevatedButton(
          key: chargeKey,
          style: ElevatedButton.styleFrom(
            elevation: UIStateData.buttonElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: vm.totalValue! > Decimal.zero
              ? Container(
                  padding: padding.value,
                  height: height.value,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      LongText(
                        'Continue to Payment',
                        // "Charge",
                        alignment: TextAlign.center,
                        textColor: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      // SizedBox(height: 4),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: <Widget>[
                      //     LongText(
                      //       "${TextFormatter.toStringCurrency(vm.totalValue)}",
                      //       alignment: TextAlign.center,
                      //       textColor: Colors.white,
                      //       fontSize: 14.0,
                      //       fontWeight: FontWeight.normal,
                      //     ),
                      //     SizedBox(width: 4),
                      //     withTicket
                      //         ? SizedBox.shrink()
                      //         : LongText(
                      //             "(${vm.itemCount} item${vm.itemCount == 1 ? "" : "s"})",
                      //             alignment: TextAlign.center,
                      //             textColor: Colors.white,
                      //             fontSize: 12.0,
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //   ],
                      // ),
                    ],
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(12),
                  height: height.value,
                  child: DefaultTextStyle(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: withTicket ? TextAlign.center : TextAlign.end,
                    style: const TextStyle(
                      color: Colors.white,
                      // fontWeight: FontWeight.bold,
                      //fontFamily: UIStateData.primaryFontFamily,
                      fontStyle: FontStyle.normal,
                      fontSize: 20,
                    ),
                    child: const Text(
                      'Continue to Payment',
                      // 'Empty Cart',
                    ),
                  ),
                ),
          // : LongText(
          //     "Empty Cart",
          //     alignment: TextAlign.center,
          //     textColor: Colors.white,
          //     fontSize: 24.0,
          //     fontWeight: FontWeight.bold,
          //   ),
          // color: color.value, // TODO(lampian): fix color
          onPressed: () {
            if (vm.itemCount! > 0) {
              Navigator.of(context).pushNamed(CheckoutChargePage.route);
            } else {
              showMessageDialog(
                context,
                'Your shopping cart is empty, please add items before charging',
                LittleFishIcons.info,
              );
            }
          },
        ),
      ),
    );

    return Row(children: <Widget>[chargeButton]);
  }
}
