import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_refund.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_transaction.dart';
import 'package:littlefish_merchant/features/pos/presentation/view_model/order_pos_print_view_model.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_payments/models/shared/payment_gateway.dart';

import '../../../../common/presentaion/components/app_progress_indicator.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';

class OrderPosPrintPage extends StatefulWidget {
  final Order? order;
  final OrderRefund? refund;
  final OrderTransaction transaction;
  final BuildContext? parentContext;
  final bool isLastPrint;
  final bool isRefund;

  const OrderPosPrintPage({
    Key? key,
    this.parentContext,
    this.isLastPrint = false,
    this.order,
    this.refund,
    required this.transaction,
    required this.isRefund,
  }) : super(key: key);

  @override
  State<OrderPosPrintPage> createState() => _OrderPosPrintPageState();
}

class _OrderPosPrintPageState extends State<OrderPosPrintPage> {
  OrderPosPrintVM? vm;
  BuildContext? parentContext;
  Map<String, dynamic>? options;
  Future<PaymentPrintResult>? _printFuture;

  Future<PaymentPrintResult> handlePrint() async {
    if (widget.isLastPrint) {
      return await vm!.lastReceipt();
    }
    if (widget.isRefund) {
      return await vm!.printRefund();
    }
    return await vm!.print();
  }

  @override
  Widget build(BuildContext context) {
    parentContext = widget.parentContext;
    vm ??=
        OrderPosPrintVM.fromStore(
            StoreProvider.of<AppState>(context),
            context: context,
          )
          ..onLoadingChanged = () {
            if (mounted) setState(() {});
          }
          ..setTransaction(widget.transaction)
          ..setRefund(widget.refund)
          ..setOrder(widget.order);

    // Initialize the future only after vm is set up and only once
    _printFuture ??= handlePrint();

    return PopScope(
      child: AppScaffold(
        displayAppBar: false,
        body: FutureBuilder<PaymentPrintResult>(
          future: _printFuture,
          builder:
              (
                BuildContext context,
                AsyncSnapshot<PaymentPrintResult> snapshot,
              ) {
                if (snapshot.hasError) {
                  // Handle any errors that occur during printing
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => showMessageDialog(
                      context,
                      'Print Error: ${snapshot.error}',
                      Icons.cancel,
                    ).then((value) => Navigator.of(context).pop({})),
                  );
                  return const AppProgressIndicator();
                }

                if (snapshot.hasData) {
                  final result = snapshot.data!;

                  if (result.isSuccess) {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) => showMessageDialog(
                        context,
                        'Print Successful',
                        Icons.done,
                      ).then((value) => Navigator.of(context).pop({})),
                    );
                  } else {
                    final message = result.statusDescription;

                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) => showMessageDialog(
                        context,
                        message,
                        Icons.cancel,
                      ).then((value) => Navigator.of(context).pop({})),
                    );
                  }
                }
                return const AppProgressIndicator();
              },
        ),
      ),
    );
  }
}
