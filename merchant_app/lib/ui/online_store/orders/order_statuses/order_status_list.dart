// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/hex_color.dart';
import 'package:littlefish_merchant/ui/online_store/common/constants/order_status_contants.dart';
import 'package:littlefish_merchant/ui/online_store/orders/charge/order_charge_screen.dart';
import 'package:littlefish_merchant/ui/online_store/orders/order_statuses/order_status_screen.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import '../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../common/presentaion/components/cards/card_neutral.dart';
import '../../../../common/presentaion/components/custom_app_bar.dart';
import '../../../../features/ecommerce_shared/models/checkout/checkout_order.dart';
import '../../../../common/presentaion/components/form_fields/auto_complete_text_field.dart';
import '../../../../common/presentaion/components/common_divider.dart';

class OrderStatusList extends StatefulWidget {
  final Function(OrderStatus item)? onTap;
  final bool canAddNew;
  final bool actionable;
  final bool canPay;
  final CheckoutOrder? order;
  const OrderStatusList({
    Key? key,
    this.onTap,
    this.order,
    this.canAddNew = true,
    this.canPay = false,
    this.actionable = true,
  }) : super(key: key);

  @override
  State<OrderStatusList> createState() => _OrderStatusListState();
}

class _OrderStatusListState extends State<OrderStatusList> {
  GlobalKey<AutoCompleteTextFieldState<OrderStatus>>? filterkey;
  GlobalKey? newItemKey;
  List<OrderStatus>? filteredOrders;
  @override
  void initState() {
    filterkey = GlobalKey<AutoCompleteTextFieldState<OrderStatus>>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVM>(
      converter: (Store store) =>
          ManageStoreVM.fromStore(store as Store<AppState>),
      builder: (BuildContext context, vm) {
        filteredOrders = vm.orderStatuses
            .where((element) => element.isSystemStatus == false)
            .toList();

        return Scaffold(
          appBar: CustomAppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: null,
          ),
          body: SafeArea(child: layout(context, vm)),
        );
      },
    );
  }

  Container layout(context, ManageStoreVM vm) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: const Text('Order Statuses', style: TextStyle(fontSize: 24)),
        ),
        Container(
          margin: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 4,
            bottom: 12,
          ),
          child: const Text('Order Statuses', style: TextStyle(fontSize: 14)),
        ),
        if (widget.actionable) const SizedBox(height: 16),
        if (widget.canPay)
          CardNeutral(
            child: ListTile(
              tileColor: Theme.of(context).colorScheme.background,
              title: const Text('Make Payment'),
              subtitle: const Text('Checkout'),
              trailing: const Icon(
                FontAwesomeIcons.cashRegister,
                color: Colors.green,
              ),
              onTap: () {
                // must be a better way
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) {
                      return OrderChargeScreen(item: widget.order);
                    },
                  ),
                );
              },
            ),
          ),
        if (widget.actionable)
          CardNeutral(
            child: ListTile(
              tileColor: Theme.of(context).colorScheme.background,
              title: Text(OrderStatusConstants.pending.displayName!),
              subtitle: Text(OrderStatusConstants.pending.description!),
              trailing: Icon(
                Icons.timer,
                color: HexColor(OrderStatusConstants.pending.color!),
              ),
            ),
          ),
        if (widget.actionable)
          CardNeutral(
            child: ListTile(
              tileColor: Theme.of(context).colorScheme.background,
              title: Text(OrderStatusConstants.confirmed.displayName!),
              subtitle: Text(OrderStatusConstants.confirmed.description!),
              trailing: Icon(
                Icons.timer,
                color: HexColor(OrderStatusConstants.confirmed.color!),
              ),
              onTap: widget.onTap != null
                  ? () {
                      if (widget.onTap != null) {
                        widget.onTap!(OrderStatusConstants.confirmed);
                      }
                    }
                  : null,
            ),
          ),
        CardNeutral(
          child: ListTile(
            tileColor: Theme.of(context).colorScheme.background,
            title: Text(OrderStatusConstants.complete.displayName!),
            subtitle: Text(OrderStatusConstants.complete.description!),
            trailing: Icon(
              Icons.timer,
              color: HexColor(OrderStatusConstants.complete.color!),
            ),
            onTap: widget.onTap != null
                ? () {
                    if (widget.onTap != null) {
                      widget.onTap!(OrderStatusConstants.complete);
                    }
                  }
                : null,
          ),
        ),
        CardNeutral(
          child: ListTile(
            tileColor: Theme.of(context).colorScheme.background,
            title: Text(OrderStatusConstants.cancelled.displayName!),
            subtitle: Text(OrderStatusConstants.cancelled.description!),
            trailing: Icon(
              Icons.timer,
              color: HexColor(OrderStatusConstants.cancelled.color!),
            ),
            onTap: widget.onTap != null
                ? () {
                    if (widget.onTap != null) {
                      widget.onTap!(OrderStatusConstants.cancelled);
                    }
                  }
                : null,
          ),
        ),
        Expanded(child: orderStatusList(context, vm)),
      ],
    ),
  );

  ListView orderStatusList(BuildContext context, ManageStoreVM vm) =>
      ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: filteredOrders?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          var item = filteredOrders![index];
          return CardNeutral(
            child: StoreOrderStatusListTile(
              actionable: widget.actionable,
              item: item,
              dismissAllowed: true,
              onSwitched: (item) {
                vm.upsertStatus(context, item);
              },
              // selected: vm.selectedItem == item,
              onTap: (item) {
                if (widget.onTap == null) {
                  addStatus(context, vm, cat: item);
                } else {
                  widget.onTap!(item);
                }
              },
              onRemove: (item) {
                vm.deleteStatus(context, item);
              },
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            const CommonDivider(),
      );
}

Future<void> addStatus(
  BuildContext context,
  ManageStoreVM vm, {
  OrderStatus? cat,
}) async {
  if (cat != null) {
    // vm.setSelectedItem(product);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return OrderStatusScreen(vm: vm, item: cat, isNew: false);
        },
      ),
    );
  } else {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return OrderStatusScreen(vm: vm);
        },
      ),
    );
  }
}

class StoreOrderStatusListTile extends StatelessWidget {
  const StoreOrderStatusListTile({
    Key? key,
    required this.item,
    this.onTap,
    this.onSwitched,
    this.dismissAllowed = false,
    this.actionable = true,
    this.onRemove,
    this.selected = false,
  }) : super(key: key);

  final bool selected;
  final bool actionable;

  final OrderStatus item;

  final bool dismissAllowed;

  final Function(OrderStatus item)? onTap;

  final Function(OrderStatus item)? onSwitched;

  final Function(OrderStatus item)? onRemove;

  @override
  Widget build(BuildContext context) {
    return statusTile(context, item);
  }

  ListTile statusTile(BuildContext context, OrderStatus item) => ListTile(
    tileColor: Theme.of(context).colorScheme.background,
    selected: selected,
    title: Text('${item.displayName}'),
    leading: CircleAvatar(
      backgroundColor: HexColor(item.color!),
      child: const Icon(Icons.timer),
    ),
    subtitle: Text(item.description ?? ''),
    trailing: actionable
        ? Switch(
            activeColor: Theme.of(context).extension<AppliedTextIcon>()?.brand,
            value: item.enabled!,
            onChanged: (val) {
              item.enabled = val;
              onSwitched!(item);
            },
          )
        : const SizedBox.shrink(),
    onTap: onTap == null
        ? null
        : () {
            if (onTap != null) onTap!(item);
          },
  );
}

enum ProductViewMode { productsView, stockView }
