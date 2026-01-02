// flutter imports
// remove ignore_for_file: implementation_imports, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/features/order_fulfilment%20/presentation/components/cancel_order_dialog.dart';
import 'package:littlefish_merchant/features/order_fulfilment%20/presentation/components/confirm_cancel_buttons.dart';
import 'package:littlefish_merchant/features/order_fulfilment%20/presentation/components/order_fulfillment_customer_information.dart';
import 'package:littlefish_merchant/features/order_fulfilment%20/presentation/components/order_fulfillment_delivery_details.dart';
import 'package:littlefish_merchant/features/order_fulfilment%20/presentation/components/order_fulfillment_summary.dart';
import 'package:littlefish_merchant/features/order_fulfilment%20/presentation/components/order_fulfillment_timeline.dart';
import 'package:littlefish_merchant/features/order_fulfilment%20/presentation/pages/order_fulfillment_home_page.dart';
import 'package:littlefish_merchant/features/order_fulfilment%20/presentation/viewmodels/order_fulfillment_details_vm.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/features/order_transaction_history/presentation/redux/order_transaction_utilities.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';

// package imports
import 'package:quiver/strings.dart';
import 'package:redux/src/store.dart';

// project imports
import 'package:littlefish_merchant/common/presentaion/components/app_tabbar.dart';
import 'package:littlefish_merchant/common/presentaion/components/errors/show_error.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_tabbed_scaffold.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';

import '../../../../app/custom_route.dart';

class OrderFulfillmentDetailsPage extends StatefulWidget {
  static const String route = 'order-fulfillment-details-page';
  final Order order;
  const OrderFulfillmentDetailsPage({super.key, required this.order});

  @override
  State<OrderFulfillmentDetailsPage> createState() =>
      _OrderFulfillmentDetailsPageState();
}

class _OrderFulfillmentDetailsPageState
    extends State<OrderFulfillmentDetailsPage> {
  late TextEditingController deliveryCompanyController;
  late TextEditingController trackingNumberController;
  late DateTime eta;
  late dynamic confirmCancelButtonText;

  @override
  void initState() {
    deliveryCompanyController = TextEditingController();
    trackingNumberController = TextEditingController();
    eta = DateTime.now();

    switch (widget.order.fulfilmentMethod) {
      case FulfilmentMethod.collection:
        confirmCancelButtonText =
            OrderTransactionUtilities.getFulfillmentStatusButtonTextForCollection(
              widget.order.fulfillmentStatus,
              toUpperCase: false,
            );
        break;
      case FulfilmentMethod.delivery:
        confirmCancelButtonText =
            OrderTransactionUtilities.getFulfillmentStatusButtonTextForDelivery(
              widget.order.fulfillmentStatus,
              toUpperCase: false,
            );
        break;
      default:
        confirmCancelButtonText =
            OrderTransactionUtilities.getFulfillmentStatusButtonTextForDelivery(
              widget.order.fulfillmentStatus,
              toUpperCase: false,
            );
        break;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OrderFulfillmentDetailsVM>(
      converter: (Store<AppState> store) {
        return OrderFulfillmentDetailsVM.fromStore(store);
      },
      builder: (BuildContext context, OrderFulfillmentDetailsVM vm) {
        return AppScaffold(
          title: 'Order #${widget.order.orderNumber}',
          body: isBlank(widget.order.id)
              ? _noOrderError()
              : _tabs(widget.order),
          persistentFooterButtons: [
            ConfirmCancelButtons(
              showConfirmButton: confirmCancelButtonText['confirmButton'] != ''
                  ? true
                  : false,
              showCancelButton: confirmCancelButtonText['cancelButton'] != ''
                  ? true
                  : false,
              cancelText: confirmCancelButtonText['cancelButton'],
              confirmText: confirmCancelButtonText['confirmButton'],
              onCancel: () {
                _showCancelOrderDialog(
                  context,
                  widget.order.fulfilmentMethod == FulfilmentMethod.delivery
                      ? true
                      : false,
                  vm,
                );
              },
              onConfirm: () async {
                switch (widget.order.fulfillmentStatus) {
                  case FulfillmentStatus.undefined:
                    _updateOrderStatus(FulfillmentStatus.processing, vm);
                    break;
                  case FulfillmentStatus.received:
                    vm.confirmOrder(widget.order.id);
                    _updateOrderStatus(FulfillmentStatus.processing, vm);
                    break;
                  case FulfillmentStatus.processing:
                    vm.markReadyForDeliveryOrCollection(widget.order);
                    _updateOrderStatus(FulfillmentStatus.dispatched, vm);
                    break;
                  case FulfillmentStatus.dispatched:
                    vm.confirmDeliveryOrCollection(widget.order);
                    _updateOrderStatus(FulfillmentStatus.complete, vm);
                    break;
                  default:
                    _updateOrderStatus(FulfillmentStatus.undefined, vm);
                    break;
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _noOrderError() {
    return ShowError(
      message: 'Could not find the order, please try again.',
      iconData: LittleFishIcons.error,
    );
  }

  Widget _tabs(Order order) {
    return AppTabBar(
      intialIndex: 0,
      physics: const BouncingScrollPhysics(),
      scrollable: true,
      resizeToAvoidBottomInset: false,
      tabs: [
        TabBarItem(
          content: OrderFulfillmentSummary(order: widget.order),
          text: 'Order Summary',
        ),
        if (order.fulfilmentMethod == FulfilmentMethod.delivery)
          TabBarItem(
            content: OrderFulfillmentDeliveryDetails(
              order: widget.order,
              deliveryCompanyController: deliveryCompanyController,
              trackingNumberController: trackingNumberController,
              eta: DateTime.now(),
            ),
            text: 'Delivery Details',
          ),
        TabBarItem(
          content: OrderFulfillmentCustomerInformation(order: widget.order),
          text: 'Customer Information',
        ),
        TabBarItem(
          content: OrderFulfillmentTimeline(order: widget.order),
          text: 'Timeline',
        ),
      ],
    );
  }

  void _updateOrderStatus(
    FulfillmentStatus fulfillmentStatus,
    OrderFulfillmentDetailsVM vm,
  ) async {
    if (widget.order.fulfillmentStatus == FulfillmentStatus.processing) {
      Order updatedOrderShipperDetails = widget.order.copyWith(
        shipperName: deliveryCompanyController.text,
        trackingNumber: trackingNumberController.text,
        estimateDeliverydate: eta,
      );
      await vm.updateOrderShipperDetails(updatedOrderShipperDetails);

      Order updatedOrder = widget.order.copyWith(
        fulfillmentStatus: fulfillmentStatus,
        shipperName: deliveryCompanyController.text,
        trackingNumber: trackingNumberController.text,
        estimateDeliverydate: eta,
      );
      await vm.updateOrder(updatedOrder);
      _navigateToHomeScreen();
    } else {
      Order updatedOrder = widget.order.copyWith(
        fulfillmentStatus: fulfillmentStatus,
        estimateDeliverydate: DateTime.now(),
      );
      await vm.updateOrder(updatedOrder);
      _navigateToHomeScreen();
    }
  }

  void _showCancelOrderDialog(
    BuildContext context,
    bool isDelivery,
    OrderFulfillmentDetailsVM vm,
  ) {
    String reason = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CancelOrderDialog(
          icon: LittleFishIcons.warning,
          title:
              isDelivery &&
                  widget.order.fulfillmentStatus == FulfillmentStatus.dispatched
              ? 'Mark Order #${widget.order.orderNumber} as Failed?'
              : 'Cancel Order?',
          description:
              isDelivery &&
                  widget.order.fulfillmentStatus == FulfillmentStatus.dispatched
              ? 'Are you sure you want to mark this order '
                    'as failed? Your customer will be informed '
                    'of this order status chance and instructed '
                    'to contact you to address the failure reason '
                    'and make alternate arrangements.'
              : 'Are you sure you want to cancel this order? '
                    'Your customers will be informed of the '
                    'cancellation and instructed to contact '
                    'you to address the cancellation reason '
                    'and make alternate arrangements.',
          items:
              isDelivery &&
                  widget.order.fulfillmentStatus == FulfillmentStatus.dispatched
              ? const [
                  'Customer unable to pay',
                  'Product(s) damaged in transit',
                  'Customer unreachable',
                  'Customer unavailable',
                  'Other',
                ]
              : const [
                  'One or more items out of stock',
                  'Order size too small',
                  'Order size too large',
                  'Customer requested cancellation',
                  'Other',
                ],
          confirmButtonText:
              isDelivery &&
                  widget.order.fulfillmentStatus == FulfillmentStatus.dispatched
              ? 'Yes, Mark Order As Failed'
              : 'Yes, Cancel Order',
          cancelButtonText:
              isDelivery &&
                  widget.order.fulfillmentStatus == FulfillmentStatus.dispatched
              ? 'No, Keep This Order'
              : 'Do Not Cancel Order',
          onItemSelected: (selectedItem) {
            reason = selectedItem.toString();
          },
          onConfirm: () {
            if (isDelivery) {
              if (widget.order.fulfillmentStatus ==
                  FulfillmentStatus.dispatched) {
                Navigator.of(context).pop();
                vm.markFailedDelivery(widget.order, reason);
                _updateOrderStatus(FulfillmentStatus.failed, vm);
              } else {
                Navigator.of(context).pop();
                vm.cancelOrder(widget.order, reason);
                _updateOrderStatus(FulfillmentStatus.cancelled, vm);
              }
            } else {
              Navigator.of(context).pop();
              vm.cancelOrder(widget.order, reason);
              _updateOrderStatus(FulfillmentStatus.cancelled, vm);
            }
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  _navigateToHomeScreen() {
    Navigator.of(context).pushReplacement(
      CustomRoute(
        builder: (BuildContext context) => const OrderFulfillmentHomePage(),
      ),
    );
  }
}
