import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/presentation/components/transaction_history_item.dart';

class OrderInfoTile extends StatelessWidget {
  final String totalItems,
      totalOrderValue,
      orderStatus,
      paymentStatus,
      orderNumber;
  final OrderSource orderType;

  final Function() onTap;

  const OrderInfoTile({
    super.key,
    required this.orderType,
    required this.totalItems,
    required this.totalOrderValue,
    required this.orderStatus,
    required this.paymentStatus,
    required this.onTap,
    required this.orderNumber,
  });

  @override
  Widget build(BuildContext context) {
    return content(context);
  }

  Padding content(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: TransactionHistoryItem(
      leadingIcon: Icons.shopping_bag_outlined,
      leadingText: '${getAcceptanceType(orderType)} Order',
      leadingBottomTextOne: '#ORD$orderNumber',
      leadingBottomTextTwo: '$totalItems Items',
      trailText: totalOrderValue,
      trailBottomTextOne: paymentStatus,
      trailBottomTextTwo: orderStatus,
      trailBottomTextOneColour: Colors.green,
      leadingAndTrailColour: Theme.of(
        context,
      ).extension<AppliedTextIcon>()?.brand,
      useTrailingBottomTags: true,
      onTap: onTap,
      leadingBottomTextGap: 8,
    ),
  );

  String getAcceptanceType(OrderSource type) {
    switch (type) {
      case OrderSource.instore:
        return 'In-Store';
      case OrderSource.online:
        return 'Online';
      default:
        return 'N/A';
    }
  }
}
