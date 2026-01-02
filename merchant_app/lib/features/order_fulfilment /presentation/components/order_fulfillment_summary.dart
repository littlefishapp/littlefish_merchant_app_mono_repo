// flutter imports
import 'package:flutter/material.dart';
// package imports
import 'package:intl/intl.dart';
// project imports
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/cards/card_square_flat.dart';
import 'package:littlefish_merchant/common/presentaion/components/labels/info_summary_row.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/order_transaction_history/presentation/redux/order_transaction_utilities.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/features/order_fulfilment%20/presentation/components/order_items_tile.dart';

import '../../../../app/theme/applied_system/applied_text_icon.dart';

class OrderFulfillmentSummary extends StatelessWidget {
  final Order order;
  final EdgeInsetsGeometry infoRowMargin;
  const OrderFulfillmentSummary({
    super.key,
    required this.order,
    this.infoRowMargin = const EdgeInsets.symmetric(vertical: 4),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: Column(
        children: [
          CardSquareFlat(
            margin: const EdgeInsets.all(0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  InfoSummaryRow(
                    leadingTextStyle: context.styleParagraphMediumBold,
                    leading: 'Dispatch type',
                    trailing: OrderTransactionUtilities.getOrderTypeText(
                      order.fulfilmentMethod,
                      toUpperCase: false,
                    ),
                    margin: infoRowMargin,
                    trailingColor: Theme.of(
                      context,
                    ).extension<AppliedTextIcon>()?.brand,
                  ),
                  const SizedBox(height: 10),
                  InfoSummaryRow(
                    leadingTextStyle: context.styleParagraphMediumSemiBold,
                    leading: 'Order status',
                    trailing:
                        OrderTransactionUtilities.getFulfillmentStatusText(
                          order.fulfillmentStatus,
                          toUpperCase: false,
                        ),
                    margin: infoRowMargin,
                    trailingColor: Theme.of(
                      context,
                    ).extension<AppliedTextIcon>()?.brand,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: context.labelSmall('Order Overview', isBold: true),
                  ),
                  InfoSummaryRow(
                    leading: 'Transaction Total',
                    trailing: TextFormatter.toTwoDecimalPlace(
                      order.totalPrice,
                      displayCurrency: true,
                    ),
                    trailingTextStyle: context.styleParagraphMediumSemiBold,
                    margin: infoRowMargin,
                  ),
                  InfoSummaryRow(
                    leading: 'Vat',
                    trailing: TextFormatter.toTwoDecimalPlace(
                      order.totalTax,
                      displayCurrency: true,
                    ),
                    trailingTextStyle: context.styleParagraphMediumSemiBold,
                    margin: infoRowMargin,
                  ),
                  InfoSummaryRow(
                    leading: 'Delivery Fee',
                    trailing: TextFormatter.toTwoDecimalPlace(
                      order.totalShipping,
                      displayCurrency: true,
                    ),
                    trailingTextStyle: context.styleParagraphMediumSemiBold,
                    margin: infoRowMargin,
                  ),
                  InfoSummaryRow(
                    leading: 'Discounts',
                    trailing: TextFormatter.toTwoDecimalPlace(
                      order.totalDiscount,
                      displayCurrency: true,
                    ),
                    trailingTextStyle: context.styleParagraphMediumSemiBold,
                  ),
                  InfoSummaryRow(
                    leading: 'Items Purchased',
                    trailing: order.orderLineItems.length.toString(),
                    margin: infoRowMargin,
                  ),
                  InfoSummaryRow(
                    leading: 'Date',
                    trailing: DateFormat(
                      'dd MMMM yyyy',
                    ).format(order.dateCreated!),
                    margin: infoRowMargin,
                  ),
                  InfoSummaryRow(
                    leading: 'Time',
                    trailing: DateFormat('HH:mm:ss').format(order.dateCreated!),
                    margin: infoRowMargin,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: context.labelSmall('Payment Method', isBold: true),
                  ),
                  // TODO(Roy): When payment method is now added pull the right one(Temporary fix is to hard code card as per Salvo's request)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: context.paragraphMedium(
                      'Card',
                      color: Theme.of(
                        context,
                      ).extension<AppliedTextIcon>()?.primary,
                      isSemiBold: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: context.labelSmall('Order Items', isBold: true),
          ),
          // if(order.orderLineItems.isNotEmpty)
          Expanded(
            child: ListView.builder(
              itemCount: order.orderLineItems.length,
              itemBuilder: (context, index) {
                final orderLineItems = order.orderLineItems[index];
                return OrderItemsTile(
                  leadingTopText: orderLineItems.displayName,
                  trailTopText: TextFormatter.toStringRemoveZeroDecimals(
                    orderLineItems.totalPrice,
                    displayCurrency: true,
                  ),
                  trailTopTextColour: Theme.of(
                    context,
                  ).extension<AppliedTextIcon>()?.primary,
                  leadingBottomTextOne:
                      TextFormatter.toStringRemoveZeroDecimals(
                        orderLineItems.quantity,
                        displayCurrency: false,
                      ),
                  isManyItems: orderLineItems.quantity > 1 ? true : false,
                  trailBottomTextOne: '',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
