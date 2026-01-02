// flutter imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:littlefish_merchant/app/app.dart';

// project imports
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/features/order_fulfilment%20/presentation/pages/order_fulfillment_details_page.dart';

class FulfillmentOrderTile extends StatelessWidget {
  final Order order;
  const FulfillmentOrderTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      onTap: () {
        Navigator.of(context).push(
          CustomRoute(
            builder: (BuildContext context) =>
                OrderFulfillmentDetailsPage(order: order),
          ),
        );
      },
      leading: Container(
        width: AppVariables.appDefaultlistItemSize,
        height: AppVariables.appDefaultlistItemSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).extension<AppliedSurface>()?.brandSubTitle,
          border: Border.all(color: Colors.transparent, width: 1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          order.capturedChannel == CapturedChannel.web
              ? Icons.language
              : Icons.shopping_cart_outlined,
        ),
      ),
      title: context.labelSmall(
        'Order #${order.orderNumber}',
        isBold: true,
        alignLeft: true,
      ),
      subtitle: context.labelXSmall(
        '${order.customer?.firstName ?? 'Unknown'} ${order.customer?.lastName ?? 'Unknown'}',
        alignLeft: true,
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          context.labelSmall(
            TextFormatter.toStringRemoveZeroDecimals(
              order.currentTotalPrice,
              displayCurrency: true,
            ),
            isBold: true,
          ),
          const SizedBox(height: 2),
          context.labelXSmall(
            '${order.orderLineItems.isNotEmpty ? '${TextFormatter.toStringRemoveZeroDecimals(order.orderLineItems[0].quantity)} Item' : '0 Item'} ${DateFormat('dd/MM').format(order.dateCreated!)}',
          ),
        ],
      ),
    );
  }
}
