// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:timeago/timeago.dart' as timeago;

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/tools/billing/billing_helpers.dart';
import 'package:littlefish_merchant/ui/online_store/common/constants/order_status_contants.dart';
import 'package:littlefish_merchant/ui/online_store/online_store_router.dart';
import 'package:littlefish_merchant/ui/online_store/orders/orders_home_page.dart';
import 'package:littlefish_merchant/ui/online_store/orders/widgets/single_order_screen.dart';
import 'package:littlefish_merchant/ui/online_store/tools.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';

import '../../../common/presentaion/components/cards/card_neutral.dart';
import '../../../features/ecommerce_shared/models/checkout/checkout_order.dart';
import '../../../tools/textformatter.dart';

class HomeOnlineStoreCard extends StatelessWidget {
  final bool removeElevation;
  List<CheckoutOrder>? get orders =>
      AppVariables.store!.state.storeState.orders?.take(3).toList();

  const HomeOnlineStoreCard({Key? key, this.removeElevation = false})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return item(context);
  }

  Widget item(BuildContext context) {
    return CardNeutral(
      elevation: removeElevation ? 0 : 2,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        height: 284,
        child: AppVariables.store!.state.storeState.store == null
            ? Center(
                child: ButtonPrimary(
                  text: 'Setup your Online Store',
                  onTap: (ctx) {
                    Navigator.of(
                      context,
                    ).pushNamed(OnlineStoreRouterPage.route);
                  },
                ),
              )
            : Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Online Orders'.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            // LongText(
                            //   TextFormatter.toShortDate(
                            //     dateTime: DateTime.now().toUtc(),
                            //     format: 'MMMM yyyy',
                            //   ),
                            // )
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.screen_search_desktop_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    // height: 204,
                    child: (orders?.isEmpty ?? true)
                        ? Center(
                            child: context.paragraphMedium(
                              'No New Orders',
                              isBold: true,
                            ),
                          )
                        : ListView(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            children: orders!
                                .map(
                                  (item) => orderTile(
                                    context,
                                    firstName: item.billing!.firstName,
                                    lastName: item.billing!.lastName,
                                    orderDate: item.orderDate,
                                    color: setColor(item.status),
                                    item: item,
                                    itemCount: item.orderItemCount,
                                    orderValue: item.orderValue,
                                    pending:
                                        item.status ==
                                        OrderStatusConstants.pending.name,
                                    actionable:
                                        item.status !=
                                            OrderStatusConstants
                                                .cancelled
                                                .name &&
                                        item.status !=
                                            OrderStatusConstants.complete.name,
                                  ),
                                )
                                .toList(),
                          ),
                  ),
                  const CommonDivider(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: ButtonPrimary(
                      text: 'View All',
                      onTap: (ctx) {
                        if (isNotPremium('online_store')) {
                          showPopupDialog(
                            defaultPadding: false,
                            context: context,
                            content: billingNavigationHelper(isModal: true),
                          );
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (c) => const OrdersHomePage(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  HexColor? setColor(status) {
    bool hasValuePresent = OrderStatusConstants.orderStatusFlow
        .where((element) => element.id == status)
        .isNotEmpty;

    return hasValuePresent
        ? HexColor(
            OrderStatusConstants.orderStatusFlow
                .firstWhere((element) => element.id == status)
                .color!,
          )
        : null;
  }

  Widget orderTile(
    context, {
    String? firstName,
    String? lastName,
    Function? onTap,
    Color? color,
    DateTime? orderDate,
    double? orderValue,
    double? itemCount,
    required CheckoutOrder item,
    bool pending = false,
    bool actionable = true,
  }) => ListTile(
    tileColor: Theme.of(context).colorScheme.background,
    // dense: true,
    // leading: Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     Icon(
    //       Icons.timer,
    //       color: color,
    //       size: 14,
    //     ),
    //   ],
    // ),
    title: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          item.trackingNumber ?? 'No Data',
          style: const TextStyle(fontSize: 14),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: <Widget>[
              Icon(Icons.timer, color: color, size: 14),
              const SizedBox(width: 4),
              Text('$firstName,', style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 4),
              Text(
                timeago.format(item.orderDate!),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    ),
    trailing: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(height: 6),
        Text(
          TextFormatter.toStringCurrency(
            orderValue,
            displayCurrency: false,
            currencyCode: '',
          ),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          '${item.orderItemCount.toInt()} Items',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    ),
    onTap: () async {
      if (isNotPremium('online_store')) {
        showPopupDialog(
          defaultPadding: false,
          context: context,
          content: billingNavigationHelper(isModal: true),
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => SingleOrderScreen(
              item: item,
              // vm: vm,
              pending: pending,
              actionable: actionable,
            ),
          ),
        );
      }
    },
  );
}
