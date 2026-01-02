// flutter imports
import 'package:flutter/material.dart';

// project imports
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/controls/control_check_circle.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/order_transaction_history/presentation/redux/order_transaction_utilities.dart';

import '../../../../app/theme/applied_system/applied_text_icon.dart';

class OrderFulfillmentTimeline extends StatefulWidget {
  final Order order;

  const OrderFulfillmentTimeline({Key? key, required this.order})
    : super(key: key);

  @override
  State<OrderFulfillmentTimeline> createState() =>
      _OrderFulfillmentTimelineState();
}

class _OrderFulfillmentTimelineState extends State<OrderFulfillmentTimeline> {
  List<FulfillmentStatus> fulfillmentStatusList = FulfillmentStatus.values;

  @override
  Widget build(BuildContext context) {
    // TODO(lampian): the mechanism for building the timeline feels hacky
    // TODO(lampian): dates are not consistently available and or shown
    final titleColour =
        Theme.of(context).extension<AppliedTextIcon>()?.emphasized ??
        Colors.red;
    final dateColour =
        Theme.of(context).extension<AppliedTextIcon>()?.primary ?? Colors.red;
    final statusInfoFromOrder =
        OrderTransactionUtilities.getFulfillmentStatusForTimeline(
          widget.order.fulfillmentStatus,
        );
    final isFailedOrder = statusInfoFromOrder['fulfillmentStatusText'].contains(
      'failure',
    );
    final isCancelledOrder = statusInfoFromOrder['fulfillmentStatusText']
        .contains('cancelled');
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: Column(
        children: [
          Column(
            children: List.generate(fulfillmentStatusList.length, (index) {
              final statusInfo =
                  OrderTransactionUtilities.getFulfillmentStatusForTimeline(
                    fulfillmentStatusList[index],
                  );

              final isCancelledItem = statusInfo['index'] == 5;
              if (!isCancelledOrder && isCancelledItem) {
                return const SizedBox.shrink();
              }

              final isFailedItem = statusInfo['index'] == 6;
              if (!isFailedOrder && isFailedItem) {
                return const SizedBox.shrink();
              }

              if (statusInfo['index'] == 0) {
                return const SizedBox.shrink();
              }

              var isSelected = index < statusInfoFromOrder['index'] + 1
                  ? true
                  : false;
              final dateValue =
                  OrderTransactionUtilities.getFulfillmentDateForTimeline(
                    status: fulfillmentStatusList[index],
                    orderHistory: widget.order.orderHistory,
                    isSelected: isSelected,
                  );

              var showItem = true;
              if (isCancelledOrder || isFailedOrder) {
                if (dateValue.isEmpty) {
                  showItem = false;
                }
                isSelected = true;
              }
              if (!showItem) {
                return const SizedBox.shrink();
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ControlCheckCircle(isSelected: isSelected),
                  const SizedBox(width: 10.0),
                  orderFulfillmentVertical(
                    context: context,
                    index: index,
                    isSelected: isSelected,
                    length: fulfillmentStatusList.length,
                  ),
                  const SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      context.paragraphMedium(
                        statusInfo['fulfillmentStatusText'],
                        color: titleColour,
                        isBold: true,
                      ),
                      if (widget.order.orderHistory.isNotEmpty)
                        context.labelXSmall(
                          dateValue,
                          //widget.order.orderHistory[0].changeDate.toString(),
                          color: dateColour,
                        ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget orderFulfillmentVertical({
    required BuildContext context,
    required int index,
    required bool isSelected,
    required int length,
  }) {
    final checked =
        Theme.of(context).extension<AppliedTextIcon>()?.positive ?? Colors.red;
    final unChecked =
        Theme.of(context).extension<AppliedTextIcon>()?.secondary ?? Colors.red;
    if (index < fulfillmentStatusList.length) {
      return Container(
        width: 2.0,
        height: 80.0,
        color: isSelected ? checked : unChecked,
      );
    }
    return const SizedBox.shrink();
  }
}
