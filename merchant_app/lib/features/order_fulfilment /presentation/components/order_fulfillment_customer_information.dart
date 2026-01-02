// flutter imports
import 'package:flutter/material.dart';
// project imports
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/cards/card_square_flat.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';

class OrderFulfillmentCustomerInformation extends StatelessWidget {
  final Order order;
  final EdgeInsetsGeometry infoRowMargin;
  const OrderFulfillmentCustomerInformation({
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: context.labelSmall('Customer Details', isBold: true),
                  ),
                  const SizedBox(height: 10),
                  if (order.customer != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: context.paragraphMedium(
                        '${order.customer?.firstName}'
                        '${order.customer?.lastName}\n'
                        '${order.customer?.mobileNumber}\n'
                        '${order.customer?.email}\n',
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withOpacity(0.6),
                        alignLeft: true,
                        isSemiBold: true,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
