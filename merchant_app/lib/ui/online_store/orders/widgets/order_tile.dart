// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:timeago/timeago.dart' as timeago;

// Project imports:
import 'package:littlefish_merchant/ui/online_store/common/constants/icon_constants.dart';
import 'package:littlefish_merchant/ui/online_store/orders/widgets/single_order_screen.dart';

import '../../../../features/ecommerce_shared/models/checkout/checkout_order.dart';
import '../../../../tools/textformatter.dart';

class OrderTile extends StatelessWidget {
  final String? firstName;
  final String? lastName;
  final Function? onTap;
  final Color? color;
  final DateTime? orderDate;
  final double? orderValue;
  final double? itemCount;
  final CheckoutOrder? item;
  final bool pending = false;
  final bool actionable = true;

  const OrderTile({
    Key? key,
    this.orderDate,
    this.orderValue,
    this.color,
    this.firstName,
    this.item,
    this.itemCount,
    this.lastName,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      subtitle: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: <Widget>[
            Image.asset(
              IconConstants.userIcon,
              height: 14,
              width: 14,
              color: color,
            ),
            const SizedBox(width: 4),
            Text('$firstName,', style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            Icon(Icons.timer, color: color, size: 14),
            const SizedBox(width: 4),
            Text('${item!.status},', style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            Text(
              '${item!.orderItemCount.toInt()} Items',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            timeago.format(item!.orderDate!),
            style: const TextStyle(fontSize: 12),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(item!.trackingNumber ?? 'No Data'),
          ),
        ],
      ),
      trailing: Text(
        TextFormatter.toStringCurrency(
          orderValue,
          displayCurrency: false,
          currencyCode: '',
        ),
        style: const TextStyle(fontSize: 20),
      ),
      onTap: () async {
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
      },
    );
  }
}
