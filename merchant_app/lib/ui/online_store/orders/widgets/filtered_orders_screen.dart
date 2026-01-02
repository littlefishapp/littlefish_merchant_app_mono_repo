// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/hex_color.dart';
import 'package:littlefish_merchant/ui/online_store/common/constants/order_status_contants.dart';
import 'package:littlefish_merchant/ui/online_store/orders/widgets/order_search_widget.dart';
import 'package:littlefish_merchant/ui/online_store/orders/widgets/single_order_screen.dart';
import 'package:littlefish_merchant/ui/online_store/services/littlefish/littlefish_firestore.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import '../../../../features/ecommerce_shared/models/checkout/checkout_order.dart';
import '../../../../tools/textformatter.dart';
import '../../../../common/presentaion/components/common_divider.dart';
import '../../../../common/presentaion/components/app_progress_indicator.dart';
import 'package:timeago/timeago.dart' as timeago;

class FilteredOrdersScreen extends StatefulWidget {
  final bool filterPressed;
  final String status;
  const FilteredOrdersScreen({
    Key? key,
    required this.status,
    this.filterPressed = false,
  }) : super(key: key);

  @override
  FilteredOrdersScreenState createState() => FilteredOrdersScreenState();
}

class FilteredOrdersScreenState extends State<FilteredOrdersScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  ManageStoreVM? _vm;

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
        _vm = vm;
        return _renderShopTabbedUI(context, _vm!);
      },
    );
  }

  AppSimpleAppScaffold _renderShopTabbedUI(context, ManageStoreVM vm) {
    HexColor setColor(status) {
      return HexColor(
        OrderStatusConstants.orderStatusFlow
            .firstWhere((element) => element.id == status)
            .color!,
      );
    }

    return AppSimpleAppScaffold(
      title: widget.status,
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => SafeArea(
                top: false,
                bottom: true,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: const OrderSearchWidget(),
                ),
              ),
            );
          },
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Container(
          //   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          //   child: Text(
          //     "Orders",
          //     style: TextStyle(fontSize: 24),
          //   ),
          // ),
          // Container(
          //   margin: const EdgeInsets.only(
          //     left: 16,
          //     right: 16,
          //     top: 4,
          //     bottom: 8,
          //   ),
          //   child: Text(
          //     S.of(context).manageOrdersDescription,
          //     style: TextStyle(fontSize: 14),
          //   ),
          // ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Object?>>(
              stream: FirestoreService().getOrdersStreamFiltered(
                vm.item!,
                vm.store!.state.searchState.orderSearchParams!,
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
                    .toList();

                if (orders?.isNotEmpty == false) {
                  return Column(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: const Center(
                            child: Text(
                              'No Orders',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: OutlinedButton(
                          child: Text('Refine Filter'.toUpperCase()),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => SafeArea(
                                top: false,
                                bottom: true,
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.75,
                                  child: const OrderSearchWidget(),
                                ),
                              ),
                            ).then((params) {
                              // _runSearch(params);
                            });
                          },
                        ),
                      ),
                    ],
                  );
                }

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
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => SingleOrderScreen(
            item: item,
            vm: _vm,
            pending: pending,
            actionable: actionable,
          ),
        ),
      );
    },
  );
}
