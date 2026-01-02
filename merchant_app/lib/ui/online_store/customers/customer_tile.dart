import 'package:flutter/material.dart';
import 'package:littlefish_merchant/ui/online_store/common/config.dart';
import 'package:littlefish_merchant/ui/online_store/customers/customer_screen.dart';

import '../../../features/ecommerce_shared/models/store/store_customer.dart';
import '../../../tools/textformatter.dart';

class CustomerTile extends StatelessWidget {
  final StoreCustomer customer;
  final bool onTap;
  const CustomerTile({Key? key, required this.customer, this.onTap = false})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      onTap: () {
        if (onTap == false) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CustomerScreen(customer: customer),
            ),
          );
        } else {
          Navigator.of(context).pop(customer);
        }
      },
      leading: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kBorderRadius!),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: const Icon(Icons.person, size: 34),
      ),
      title: Text('${customer.firstName} ${customer.lastName}'),
      subtitle: customer.lastPurchaseDate == null
          ? const Text('No Purchase History')
          : Text(
              "${TextFormatter.toStringCurrency(customer.totalPurchases, currencyCode: '')} Purchases",
            ),
      // trailing: PopupMenuButton(
      //   onSelected: (dynamic res) {
      //     // if (res == 0)
      //     //   Navigator.of(context).push(
      //     //     MaterialPageRoute(
      //     //       builder: (ctx) => NotificationPopup(
      //     //         parentContext: context,
      //     //         userId: customer.customerId,
      //     //       ),
      //     //     ),
      //     //   );
      //   },
      //   itemBuilder: (ctx) => [
      //     PopupMenuItem(
      //       value: 0,
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: <Widget>[Text("Send Notification"), Icon(Icons.mail)],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

class NotificationPopup {}
