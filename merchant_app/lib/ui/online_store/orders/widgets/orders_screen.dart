// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:timeago/timeago.dart' as timeago;

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/hex_color.dart';
import 'package:littlefish_merchant/ui/online_store/common/constants/order_status_contants.dart';
import 'package:littlefish_merchant/ui/online_store/orders/widgets/filtered_orders_screen.dart';
import 'package:littlefish_merchant/ui/online_store/orders/widgets/single_order_screen.dart';
import 'package:littlefish_merchant/ui/online_store/services/service_factory.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';

import '../../../../common/presentaion/components/cards/card_neutral.dart';
import '../../../../features/ecommerce_shared/models/checkout/checkout_order.dart';
import '../../../../tools/textformatter.dart';
import '../../../../common/presentaion/components/common_divider.dart';
import '../../../../common/presentaion/components/long_text.dart';
import '../../../../common/presentaion/components/app_progress_indicator.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  OrdersScreenState createState() => OrdersScreenState();
}

class OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late ManageStoreVM vm;
  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVM>(
      converter: (store) => ManageStoreVM.fromStore(store),
      builder: (context, vm) {
        vm = vm;
        return _renderShopTabbedUI(context, vm);
      },
    );
  }

  AppSimpleAppScaffold _renderShopTabbedUI(context, ManageStoreVM vm) {
    // setColor(status) {
    //   if (status == OrderStatusConstants.pending.name)
    //     return HexColor(OrderStatusConstants.pending.color);
    //   if (status == OrderStatusConstants.confirmed.name)
    //     return HexColor(OrderStatusConstants.confirmed.color);
    //   if (status == OrderStatusConstants.cancelled.name)
    //     return HexColor(OrderStatusConstants.cancelled.color);
    //   if (status == OrderStatusConstants.complete.name)
    //     return HexColor(OrderStatusConstants.complete.color);

    //   return vm.orderStatuses
    //       .firstWhere((x) => x.name == status,
    //           orElse: () => OrderStatusConstants.cancelled)
    //       .color;
    // }

    return AppSimpleAppScaffold(
      title: 'Orders',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Container(
          //   margin: const EdgeInsets.only(
          //     left: 16,
          //     right: 16,
          //     top: 4,
          //     bottom: 8,
          //   ),
          //   child: Text(
          //     "Manage Orders",
          //     style: TextStyle(fontSize: 14),
          //   ),
          // ),
          SizedBox(height: 100, child: Material(child: summ(context))),
          const CommonDivider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Object?>>(
              stream: ServiceFactory().getOrdersStream(
                vm.store!.state.storeState.store!,
              ),
              builder: (ctx, snapshot) {
                if (snapshot.hasData != true) {
                  return const AppProgressIndicator();
                }

                var orders = snapshot.data?.docs
                    .map(
                      (e) => CheckoutOrder.fromJson(
                        e.data() as Map<String, dynamic>,
                      ),
                    )
                    .sortedByCompare<DateTime>(
                      (element) => element.orderDate!,
                      (a, b) => b.compareTo(a),
                    )
                    .toList();

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: orders?.length ?? 0,
                  itemBuilder: (ctx, index) {
                    var item = orders![index];
                    return orderTile(
                      context,
                      firstName: item.billing!.firstName,
                      lastName: item.billing!.lastName,
                      orderDate: item.orderDate,
                      color: setColor(item.status),
                      item: item,
                      itemCount: item.orderItemCount,
                      orderValue: item.orderValue,
                      pending: item.status == OrderStatusConstants.pending.name,
                      actionable:
                          item.status != OrderStatusConstants.cancelled.name &&
                          item.status != OrderStatusConstants.complete.name,
                    );
                  },
                  separatorBuilder: (ctx, index) => const CommonDivider(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> summ(
    context,
  ) => StreamBuilder<QuerySnapshot<Object?>>(
    stream: ServiceFactory().getOrdersStatusesStream(
      vm.store!.state.storeState.store!,
    ),
    builder: (ctx, snapshot) {
      if (snapshot.hasData != true) return const AppProgressIndicator();

      var statuses = snapshot.data?.docs
          .map((e) => OrderStatus.fromJson(e.data() as Map<String, dynamic>))
          .toList();

      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          summaryCard(
            context,
            value:
                statuses
                    ?.firstWhereOrNull(
                      (element) =>
                          element.name == OrderStatusConstants.pending.name,
                    )
                    ?.totalOrders ??
                0,
            title: 'Pending',
            onTap: () {
              vm.setOrderFilterStatus([OrderStatusConstants.pending.name]);

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => FilteredOrdersScreen(
                    status: OrderStatusConstants.pending.displayName!,
                  ),
                ),
              );
            },
            color: HexColor(OrderStatusConstants.pending.color!),
          ),
          summaryCard(
            context,
            value:
                statuses
                    ?.firstWhereOrNull(
                      (element) =>
                          element.name == OrderStatusConstants.confirmed.name,
                    )
                    ?.totalOrders ??
                0,
            title: 'Confirmed',
            color: HexColor(OrderStatusConstants.confirmed.color!),
            onTap: () {
              vm.setOrderFilterStatus([OrderStatusConstants.confirmed.name]);

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => FilteredOrdersScreen(
                    status: OrderStatusConstants.confirmed.displayName!,
                  ),
                ),
              );
            },
          ),
          summaryCard(
            context,
            value:
                statuses
                    ?.firstWhereOrNull(
                      (element) =>
                          element.name == OrderStatusConstants.cancelled.name,
                    )
                    ?.totalOrders ??
                0,
            title: 'Cancelled',
            color: HexColor(OrderStatusConstants.cancelled.color!),
            onTap: () {
              vm.setOrderFilterStatus([OrderStatusConstants.cancelled.name]);

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => FilteredOrdersScreen(
                    status: OrderStatusConstants.pending.displayName!,
                  ),
                ),
              );
            },
          ),
          summaryCard(
            context,
            value:
                statuses
                    ?.firstWhereOrNull(
                      (element) =>
                          element.name == OrderStatusConstants.complete.name,
                    )
                    ?.totalOrders ??
                0,
            title: 'Completed',
            color: HexColor(OrderStatusConstants.complete.color!),
            onTap: () {
              vm.setOrderFilterStatus([OrderStatusConstants.complete.name]);

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => FilteredOrdersScreen(
                    status: OrderStatusConstants.pending.displayName!,
                  ),
                ),
              );
            },
          ),
        ],
      );
    },
  );

  Container summaryCard(
    context, {
    required int value,
    required String title,
    bool isCurrency = true,
    double fontSize = 28.0,
    Color? color,
    Function()? onTap,
  }) => Container(
    padding: const EdgeInsets.symmetric(vertical: 4),
    width: MediaQuery.of(context).size.width / 2.6,
    height: 96,
    child: CardNeutral(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              value.floor().toString(),
              style: TextStyle(
                fontSize: 28.0,
                color: color ?? Theme.of(context).colorScheme.primary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ),
  );

  ListTile orderTile1(
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
    isThreeLine: true,
    subtitle: Column(
      // mainAxisSize: MainAxizSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LongText('$firstName $lastName'),
        LongText(TextFormatter.toShortDate(dateTime: item.orderDate)),
      ],
    ),
    title: Text(item.trackingNumber ?? ''),
    trailing: Column(
      children: [
        Text(
          TextFormatter.toStringCurrency(
            orderValue,
            displayCurrency: false,
            currencyCode: '',
          ),
          // style: TextStyle(fontSize: 20, color: color),
        ),
        Text(
          '$itemCount Items',
          // style: TextStyle(color: Colors.white),
        ),
      ],
    ),
    // leading: CircleAvatar(
    //   backgroundColor: color,
    //   child: Text(
    //     itemCount.toString() + 'x',
    //     // style: TextStyle(color: Colors.white),
    //   ),
    // ),
    onTap: () async {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => SingleOrderScreen(
            item: item,
            vm: vm,
            pending: pending,
            actionable: actionable,
          ),
        ),
      );
    },
  );

  ListTile orderTile(
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
    subtitle: Text(
      timeago.format(item.orderDate!).substring(0, 1).toUpperCase() +
          timeago.format(item.orderDate!).substring(1),
      //toSimpleDate(dateTime: item.orderDate!),
      style: const TextStyle(fontSize: 12),
    ),
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
                //timeago.format(item.orderDate!),
                TextFormatter.toShortDate(dateTime: item.orderDate),
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
        //SizedBox(height: 6),
        Text(
          item.status != null
              ? item.status!.substring(0, 1).toUpperCase() +
                    item.status!.substring(1)
              : '',
          style: const TextStyle(fontSize: 12),
        ),
        Text(
          TextFormatter.toStringCurrency(
            orderValue,
            displayCurrency: false,
            currencyCode: '',
          ),
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        //SizedBox(height: 2),
        Text(
          '${item.orderItemCount.toInt()} Items',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    ),
    onTap: () async {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => SingleOrderScreen(
            item: item,
            vm: vm,
            pending: pending,
            actionable: actionable,
          ),
        ),
      );
    },
  );

  HexColor setColor(status) {
    return HexColor(
      OrderStatusConstants.orderStatusFlow
          .firstWhere((element) => element.id == status)
          .color!,
    );
  }
}
