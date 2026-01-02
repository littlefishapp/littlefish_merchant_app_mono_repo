import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/cards/card_square_flat.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';

import '../../../../common/presentaion/components/labels/info_summary_row.dart';

class OrderFulfillmentDeliveryDetails extends StatefulWidget {
  final Order order;
  final EdgeInsetsGeometry infoRowMargin;
  final TextEditingController deliveryCompanyController;
  final TextEditingController trackingNumberController;
  final DateTime eta;

  const OrderFulfillmentDeliveryDetails({
    super.key,
    required this.order,
    required this.deliveryCompanyController,
    required this.trackingNumberController,
    required this.eta,
    this.infoRowMargin = const EdgeInsets.symmetric(vertical: 4),
  });

  @override
  State<OrderFulfillmentDeliveryDetails> createState() =>
      _OrderFulfillmentDeliveryDetailsState();
}

class _OrderFulfillmentDeliveryDetailsState
    extends State<OrderFulfillmentDeliveryDetails>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late DateTime eta;
  late TextEditingController etaController;

  @override
  void initState() {
    super.initState();
    eta = widget.eta;
    etaController = TextEditingController(text: eta.toString());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
        child: Column(
          children: [
            CardSquareFlat(
              margin: const EdgeInsets.all(0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (widget.order.customer != null) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: context.labelSmall(
                          'Delivery Address',
                          isBold: true,
                        ),
                      ),
                      const SizedBox(height: 10),
                      InfoSummaryRow(
                        leading: 'Delivery Street Address',
                        trailing: widget.order.customer!.shippingAddress.line1,
                        trailingTextStyle: context.styleParagraphMediumSemiBold,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                      ),
                      InfoSummaryRow(
                        leading: 'Site Name',
                        trailing: widget.order.customer!.shippingAddress.line2,
                        trailingTextStyle: context.styleParagraphMediumSemiBold,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                      ),
                      InfoSummaryRow(
                        leading: 'Delivery City',
                        trailing: widget.order.customer!.shippingAddress.city,
                        trailingTextStyle: context.styleParagraphMediumSemiBold,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                      ),
                      InfoSummaryRow(
                        leading: 'Delivery Province',
                        trailing:
                            widget.order.customer!.shippingAddress.province,
                        trailingTextStyle: context.styleParagraphMediumSemiBold,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                      ),
                      InfoSummaryRow(
                        leading: 'Delivery Postal Code',
                        trailing:
                            widget.order.customer!.shippingAddress.zipCode,
                        trailingTextStyle: context.styleParagraphMediumSemiBold,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: context.labelSmall(
                        'Delivery Partner',
                        isBold: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    StringFormField(
                      enabled:
                          widget.order.fulfillmentStatus ==
                              FulfillmentStatus.dispatched
                          ? false
                          : true,
                      controller: widget.deliveryCompanyController,
                      onSaveValue: (e) {},
                      hintText: widget.order.shipperName.isNotEmpty
                          ? widget.order.shipperName
                          : 'Enter delivery company name',
                      labelText: 'Delivery Company',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      useOutlineStyling: true,
                    ),
                    const SizedBox(height: 16),
                    StringFormField(
                      enabled:
                          widget.order.fulfillmentStatus ==
                              FulfillmentStatus.dispatched
                          ? false
                          : true,
                      controller: widget.trackingNumberController,
                      onSaveValue: (e) {},
                      labelText: 'Tracking Number',
                      hintText: widget.order.trackingNumber.isNotEmpty
                          ? widget.order.trackingNumber
                          : 'Enter tracking number',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      useOutlineStyling: true,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        if (widget.order.fulfillmentStatus ==
                            FulfillmentStatus.processing) {
                          _pickDateTime(context);
                        }
                      },
                      child: StringFormField(
                        enabled: false,
                        onSaveValue: (e) {},
                        controller: etaController,
                        labelText: 'ETA',
                        hintText:
                            widget.order.fulfillmentStatus ==
                                FulfillmentStatus.dispatched
                            ? widget.order.estimateDeliverydate.toString()
                            : 'Enter estimated delivery time',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        useOutlineStyling: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDateTime(BuildContext context) async {
    DateTime? pickedDateFinal;
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      pickedDateFinal = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
      );
      setState(() {
        eta = pickedDateFinal!;
        etaController.text = DateFormat('yyyy-MM-dd').format(eta);
        FocusScope.of(context).unfocus();
      });
    }
  }
}
