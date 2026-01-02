// remove ignore_for_file: use_build_context_synchronously

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/features/sell/presentation/components/more_actions_close_batch.dart';
import 'package:littlefish_merchant/features/sell/presentation/components/more_actions_print_batch.dart';
import 'package:littlefish_merchant/features/sell/presentation/components/more_actions_print_last_batch.dart';
import 'package:littlefish_merchant/features/sell/presentation/components/more_actions_print_last_receipt.dart';
import 'package:littlefish_merchant/features/sell/presentation/components/more_actions_refresh_products.dart';
import 'package:littlefish_merchant/features/sell/presentation/components/more_actions_update_device_parameters.dart';
import 'package:littlefish_merchant/models/assets/app_assets.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/checkout/sell_page.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/ticket_helpers.dart';
import 'package:littlefish_merchant/common/presentaion/components/icon_text_tile.dart';
import 'package:littlefish_payments/models/shared/payment_gateway.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import '../../../app/app.dart';
import '../../../app/theme/applied_system/applied_surface.dart';
import '../../../common/presentaion/components/custom_keypad.dart';
import '../../../models/enums.dart';
import '../../../redux/business/business_selectors.dart';
import '../../../redux/checkout/checkout_actions.dart';
import '../../../redux/customer/customer_actions.dart';
import '../../../shared/constants/permission_name_constants.dart';
import '../../business/expenses/pages/quick_refund_page.dart';
import '../../customers/pages/customer_select_page.dart';
import '../../online_store/shared/routes/custom_route.dart';
import '../../../common/presentaion/components/completers.dart';
import '../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../common/presentaion/pages/popup_forms/customer_credit_amount_popup_form.dart';
import '../pages/checkout_action_page.dart';
import '../viewmodels/checkout_viewmodels.dart';
import 'checkout_sort_sales_actions.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';

LittleFishCore _core = LittleFishCore.instance;
LoggerService _logger = LittleFishCore.instance.get<LoggerService>();

// This is for Sales V1 only (CheckoutTransaction)
class CheckoutMoreSalesActions {
  static Future<void> showMoreActions({
    required BuildContext context,
    required CheckoutVM vm,
  }) async {
    final showReceiveCreditPaymentButton =
        storeCreditSettings(AppVariables.store!.state)?.enabled == true &&
        AppVariables.store!.state.enableStoreCredit == true;
    final allowTickets = vm.allowTickets ?? true;
    final showParkSaleButton = allowTickets && vm.itemCount! > 0;
    final enableWithdrawal = AppVariables.store?.state.enableWithdrawal == true;
    final isGuestLogin = vm.store!.state.userState.isGuestUser == true;
    final allowMoreActionsPrintBatch =
        userHasPermission(allowCloseBatch) &&
        AppVariables.canPerformAction(
          PaymentGatewayAction.printLastBatchReport,
        ) &&
        AppVariables.hasPrinter &&
        userHasPermission(allowRePrintBatch);

    final alllowPrintLastreceipt = AppVariables.enablePrintLastReceipt;

    final enableCloseBatch = AppVariables.enableCloseBatch;

    final allowReprintBatch =
        enableCloseBatch &&
        AppVariables.hasPrinter &&
        userHasPermission(allowRePrintBatch);

    await showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).extension<AppliedSurface>()?.primary,
      barrierColor: Theme.of(
        context,
      ).extension<AppliedSurface>()?.secondary.withOpacity(0.1),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
      // TODO(lampian) we should use this instead of container below
      // showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Container(
                    height: 4.0,
                    width: 74.0,
                    margin: const EdgeInsets.all(8.0),
                  ),
                ),
                if (enableWithdrawal && userHasPermission(allowWithdrawal)) ...[
                  const CashWithdrawalButton(),
                ],
                if (userHasPermission(allowQuickRefund)) ...[
                  const SizedBox(height: 4),
                  RefundSalesButton(vm: vm),
                ],
                const SizedBox(height: 2),
                // ToDO(Michael): We need to check for printing capability
                if (alllowPrintLastreceipt) const MoreActionsPrintLastReceipt(),
                if (userHasPermission(allowQuickItem)) AddQuickItemTile(vm: vm),
                if (showReceiveCreditPaymentButton) ...[
                  const SizedBox(height: 8),
                  ReceiveCreditPaymentButton(vm: vm),
                ],
                if (enableCloseBatch) MoreActionsCloseBatch(),
                if (AppVariables.enableReprintLastBatchReport) ...[
                  const MoreActionsPrintLastBatch(),
                ],
                if (AppVariables.enableReprintBatchReport) ...[
                  const MoreActionsPrintBatch(),
                ],
                if (AppVariables.enableUpdateDeviceParameters)
                  MoreActionsUpdateDeviceParameters(),
                if (showParkSaleButton &&
                    userHasPermission(allowSetAndGetParkedCart)) ...[
                  const SizedBox(height: 8),
                  ParkSaleButton(vm: vm),
                ],
                if (allowTickets &&
                    userHasPermission(allowSetAndGetParkedCart)) ...[
                  RetrieveSaleButton(vm: vm),
                ],
                if (!isGuestLogin) SortButton(vm: vm),
                if (!isGuestLogin) MoreActionsRefreshProducts(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// This is for v1 ChechoutTransaction only
class SortButton extends StatelessWidget {
  final CheckoutVM vm;

  const SortButton({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconTextTile(
      icon: Icon(
        Icons.sort_outlined,
        color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
      ),
      text: context.paragraphMedium('Sort'),
      onTap: () async {
        Navigator.of(context).pop();
        await showModalBottomSheet(
          context: context,
          backgroundColor: Theme.of(
            context,
          ).extension<AppliedSurface>()?.brandSubTitle,
          barrierColor: Theme.of(
            context,
          ).extension<AppliedSurface>()?.secondary.withOpacity(0.1),
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
          ),
          builder: (ctx) => CheckoutSortActions(
            order: vm.sortOrder,
            type: vm.sortBy,
            onUpdateSort: (type, order) {
              vm.store!.dispatch(SetCheckoutSortOptionsAction(type, order));
            },
          ),
        );
      },
    );
  }
}

// This is for v1 ChechoutTransaction only
class ParkSaleButton extends StatelessWidget {
  final CheckoutVM vm;

  const ParkSaleButton({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconTextTile(
      icon: Icon(
        Icons.save,
        color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
      ),
      text: context.paragraphMedium('Park Sale'),
      onTap: () async {
        await captureTicketPageTrigger(vm.items ?? [], context);
      },
    );
  }
}

// This is for v1 ChechoutTransaction only
class RetrieveSaleButton extends StatelessWidget {
  final CheckoutVM vm;

  const RetrieveSaleButton({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconTextTile(
      icon: Icon(
        Icons.list_alt,
        color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
      ),
      text: context.paragraphMedium('Retrieve Sale'),
      onTap: () async {
        await listTicketsPageTrigger(context, vm);
        Navigator.of(context).pop();
      },
    );
  }
}

// This is for v1 ChechoutTransaction only
class ReceiveCreditPaymentButton extends StatelessWidget {
  final CheckoutVM vm;

  const ReceiveCreditPaymentButton({Key? key, required this.vm})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconTextTile(
      icon: Icon(
        Icons.credit_card,
        color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
      ),
      text: context.paragraphMedium('Receive Credit Payment'),
      onTap: () async {
        Navigator.of(context).pop();
        var selectedCustomer = await showPopupDialog(
          context: context,
          content: CustomerSelectPage(onSelected: (con, cust) async {}),
        );

        if (selectedCustomer != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => CustomerCreditAmountPopupForm(
                creditBalance: selectedCustomer.creditBalance ?? 0.00,
                initialValue: 0.0,
                title: 'Pay Amount',
                hintText: 'Enter amount here',
                shouldPop: false,
                onSubmit: (context, value) {
                  var currentCredit = double.parse(
                    (selectedCustomer?.creditBalance ?? 0).toStringAsFixed(2),
                  );
                  if (value + currentCredit > 0) {
                    showMessageDialog(
                      context,
                      'Customer cannot have a positive credit balance \n Please input the exact amount instead ',
                      LittleFishIcons.info,
                    );
                  } else {
                    vm.store!.dispatch(
                      payCustomerStoreCreditAmount(
                        item: selectedCustomer,
                        value: value,
                        completer: actionCompleter(ctx, () {
                          Navigator.of(context).pop();
                          showMessageDialog(
                            context,
                            'Success',
                            LittleFishIcons.info,
                          );
                        }),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        }
      },
    );
  }
}

// This is for v1 ChechoutTransaction only
class RefundSalesButton extends StatelessWidget {
  final CheckoutVM vm;

  const RefundSalesButton({required this.vm, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconTextTile(
      icon: Image.asset(
        AppAssets.currencyExchange,
        color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
      ),
      text: context.paragraphMedium('Refund'),
      onTap: () {
        vm.onClear();
        // final isGuestLogin = vm.store!.state.userState.isGuestUser == true;
        vm.createQuickRefund();
        Navigator.of(context).pop();
        Navigator.of(context).push(
          CustomRoute(
            builder: (BuildContext ctx) => const QuickRefundPage(
              isEmbedded: false,
              sourcePageRoute:
                  SellPage.route, // page to return to after completing refund
            ),
          ),
        );
      },
    );
  }
}

// This is for v1 ChechoutTransaction only
class AddQuickItemTile extends StatelessWidget {
  final CheckoutVM vm;

  const AddQuickItemTile({required this.vm, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconTextTile(
      icon: Icon(
        Icons.local_atm,
        color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
      ),
      text: context.paragraphMedium('Quick Item'),
      onTap: () async {
        customPayment(context: context, vm: vm);
      },
    );
  }

  Future<double?> customPayment({
    required BuildContext context,
    required CheckoutVM vm,
  }) async {
    return showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (ctx) => SafeArea(
        child: SizedBox(
          height: 480,
          child: CustomKeyPad(
            isLoading: vm.isLoading,
            enableAppBar: false,
            title: 'Quick Item',
            enableDescription: true,
            confirmErrorMessage: 'Please enter the amount for the quick item.',
            confirmButtonText: 'Add',
            onValueChanged: (double amount) {},
            onDescriptionChanged: (String description) {},
            onSubmit: (amount, description) {
              vm.addCustomSaleToCart(
                Decimal.parse(amount.toString()),
                description ?? 'Quick Item',
              );
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            initialValue: 0,
            parentContext: ctx,
          ),
        ),
      ),
    );
  }
}

// This is for v1 ChechoutTransaction only
class CashWithdrawalButton extends StatelessWidget {
  const CashWithdrawalButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconTextTile(
      icon: Icon(
        Icons.money,
        color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
      ),
      text: context.paragraphMedium('Cash Withdrawal'),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          CustomRoute(
            maintainState: false,
            builder: (BuildContext context) => const CheckoutActionPage(
              actionType: CheckoutActionType.withdrawal,
            ),
          ),
        );
      },
    );
  }
}
