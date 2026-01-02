import 'package:flutter/cupertino.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_tabbar.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_tabbed_scaffold.dart';
import 'package:littlefish_merchant/features/order_cart_discount/presentation/components/order_discount_amount_tab.dart';
import 'package:littlefish_merchant/features/order_cart_discount/presentation/components/order_discount_percentage_tab.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_discount.dart';

class OrderDiscountTabs extends StatelessWidget {
  final int index;
  final double orderTotal;
  final Function(int) onTabChange;
  final Function(double?, DiscountValueType) onDiscountAdded;
  final OrderDiscount discount;
  final GlobalKey _percentageTabKey = GlobalKey();
  final GlobalKey _amountTabKey = GlobalKey();

  OrderDiscountTabs({
    super.key,
    required this.orderTotal,
    required this.index,
    required this.onTabChange,
    required this.discount,
    required this.onDiscountAdded,
  });

  @override
  Widget build(BuildContext context) {
    return tabs();
  }

  //Todo:refactor AppTabBar to not  have nest scaffold
  tabs() => AppTabBar(
    physics: const BouncingScrollPhysics(),
    intialIndex: index,
    scrollable: false,
    resizeToAvoidBottomInset: false,
    onTabChanged: (int index) => () async {
      await onTabChange(index);
    },
    tabs: [
      TabBarItem(
        key: _percentageTabKey,
        content: OrderDiscountPercentageTab(
          discount: discount,
          onChanged: (double? percent) {
            onDiscountAdded(percent, DiscountValueType.percentage);
          },
        ),
        text: 'Percentage',
      ),
      TabBarItem(
        key: _amountTabKey,
        content: OrderDiscountAmountTab(
          orderTotal: orderTotal,
          discount: discount,
          onChanged: (double? amount) {
            onDiscountAdded(amount, DiscountValueType.fixedAmount);
          },
        ),
        text: 'Amount',
      ),
    ],
  );
}
