import 'package:flutter/material.dart';
import 'package:littlefish_merchant/features/receipt_common/presentation/components/receipt_mobile_contact_form.dart';
import 'package:littlefish_merchant/features/receipt_common/presentation/components/receipt_sent.dart';
import 'package:littlefish_merchant/features/receipt_common/presentation/viewmodels/order_receipt_vm.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ReceiptMobileContactPage extends StatefulWidget {
  final String? firstName;
  final String? mobileNumber;
  final bool hasSent;
  final bool isLoading;
  final OrderReceiptVM vm;
  final Function(String firstName, String contact) onSubmit;

  const ReceiptMobileContactPage({
    Key? key,
    required this.onSubmit,
    required this.firstName,
    required this.mobileNumber,
    required this.vm,
    required this.hasSent,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<ReceiptMobileContactPage> createState() =>
      _ReceiptMobileContactPageState();
}

class _ReceiptMobileContactPageState extends State<ReceiptMobileContactPage> {
  late bool hasSent;
  late bool isLoading;

  @override
  void initState() {
    hasSent = widget.hasSent;
    isLoading = widget.isLoading;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OrderReceiptVM>(
      converter: (store) => OrderReceiptVM.fromStore(store),
      onDidChange: (previousViewModel, viewModel) {
        if (previousViewModel?.hasSent != viewModel.hasSent) {
          hasSent = viewModel.hasSent;
          setState(() {});
        }
        if (previousViewModel?.isLoading != viewModel.isLoading) {
          isLoading = viewModel.isLoading!;
          setState(() {});
        }
      },
      builder: (BuildContext context, OrderReceiptVM vm) {
        return ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 330,
              child: isLoading == true
                  ? const AppProgressIndicator()
                  : hasSent
                  ? ReceiptSent(vm: widget.vm, receiptType: 'SMS')
                  : ReceiptMobileContactForm(
                      firstName: widget.firstName,
                      mobileNumber: widget.mobileNumber,
                      onSubmit: (String firstName, String contact) {
                        widget.onSubmit(firstName, contact);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
