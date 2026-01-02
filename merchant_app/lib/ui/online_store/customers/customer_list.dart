import 'package:flutter/material.dart';
import 'package:littlefish_merchant/ui/online_store/customers/customer_tile.dart';

import '../../../features/ecommerce_shared/models/store/store_customer.dart';
import '../../../common/presentaion/components/common_divider.dart';

class CustomersList extends StatelessWidget {
  final List<StoreCustomer>? customers;
  final bool onTap;
  final ScrollController? scrollController;
  const CustomersList({
    Key? key,
    required this.customers,
    this.onTap = false,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (customers!.isEmpty) {
      return const Center(child: Text('No Customers'));
    }

    return ListView.separated(
      controller: scrollController,
      itemCount: customers?.length ?? 0,
      itemBuilder: (context, index) {
        var customer = customers![index];

        return CustomerTile(customer: customer, onTap: onTap);
      },
      separatorBuilder: (BuildContext context, int index) =>
          const CommonDivider(),
    );
  }
}
