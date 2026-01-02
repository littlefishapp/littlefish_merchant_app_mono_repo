import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/features/order_common/data/model/customer.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_transaction.dart';
import 'package:littlefish_merchant/features/receipt_common/presentation/pages/receipt_email_contact_page.dart';
import 'package:littlefish_merchant/features/receipt_common/presentation/pages/receipt_mobile_contact_page.dart';
import 'package:littlefish_merchant/features/receipt_common/presentation/redux/order_receipt_actions.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/features/receipt_common/presentation/viewmodels/order_receipt_vm.dart';
import 'package:littlefish_merchant/features/sell/presentation/components/transaction_receipt_buttons.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quiver/strings.dart';

import '../../../../app/theme/applied_system/applied_text_icon.dart';

class ReceiptDisplaySection extends StatefulWidget {
  ///Todo(brandon): Make sure works with updates to order object
  final Customer? customer;
  final Order? order;
  final OrderTransaction? transaction;

  const ReceiptDisplaySection({
    Key? key,
    required this.customer,
    required this.order,
    required this.transaction,
  }) : super(key: key);

  @override
  State<ReceiptDisplaySection> createState() => _ReceiptDisplaySectionState();
}

class _ReceiptDisplaySectionState extends State<ReceiptDisplaySection> {
  late bool hasSent;
  late bool isLoading;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OrderReceiptVM>(
      converter: (store) => OrderReceiptVM.fromStore(store),
      onInit: (store) {
        store.dispatch(
          InitializeReceiptStateAction(
            widget.order,
            widget.transaction,
            widget.customer,
          ),
        );
      },
      onDidChange: (previousViewModel, viewModel) async {
        if (previousViewModel?.customer != viewModel.customer) {
          setState(() {});
        }
        if (viewModel.error != null &&
            isNotBlank(viewModel.error!.message) &&
            viewModel.error != previousViewModel?.error) {
          await showMessageDialog(
            context,
            viewModel.error!.message,
            LittleFishIcons.error,
          ).then((_) async {
            await viewModel.setReceiptError!(null);
          });
        }
      },
      builder: (BuildContext context, OrderReceiptVM vm) {
        return Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: context.headingXSmall(
                  'Send Receipt',
                  alignLeft: true,
                  color: Theme.of(
                    context,
                  ).extension<AppliedTextIcon>()?.emphasized,
                  isBold: true,
                ),
              ),
            ),
            TransactionReceiptButtons(
              showPrintButton:
                  AppVariables.hasPrinter &&
                  cardPaymentRegistered == CardPaymentRegistered.pos,
              onPrintTap: () async {
                await vm.printReceipt!(context);
              },
              onSmsTap: () async {
                await showPopupDialog(
                  height: 330,
                  context: context,
                  content: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: ReceiptMobileContactPage(
                      firstName: vm.customer?.firstName,
                      mobileNumber: vm.customer?.mobileNumber,
                      vm: vm,
                      hasSent: vm.hasSent,
                      isLoading: vm.isLoading!,
                      onSubmit: (firstName, mobile) async {
                        Customer cust = (vm.customer ?? const Customer())
                            .copyWith(
                              firstName: firstName,
                              mobileNumber: mobile,
                            );
                        vm.setCustomer!(cust);
                        await vm.sendSmsReceipt!(cust);
                      },
                    ),
                  ),
                );
              },
              onEmailTap: () async {
                await showPopupDialog(
                  height: 330,
                  context: context,
                  content: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: ReceiptEmailContactPage(
                      firstName: vm.customer?.firstName,
                      email: vm.customer?.email,
                      vm: vm,
                      hasSent: vm.hasSent,
                      isLoading: vm.isLoading!,
                      onSubmit: (firstName, contact) async {
                        Customer cust = (vm.customer ?? const Customer())
                            .copyWith(firstName: firstName, email: contact);
                        await vm.setCustomer!(cust);
                        await vm.sendEmailReceipt!(cust);
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
