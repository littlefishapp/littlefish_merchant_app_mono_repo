// removed ignore: depend_on_referenced_packages

import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core/auth/services/auth_service.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/features/pos/presentation/pages/card_payment.dart';
import 'package:littlefish_merchant/features/sell/domain/helpers/transaction_result_mapper.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/ui/business/expenses/widgets/payment_methods_list.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/amount_text.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_actions.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/models/settings/accounts/linked_account.dart';
import 'package:littlefish_merchant/models/settings/payments/payment_type.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../app/theme/applied_system/applied_text_icon.dart';

class CheckoutWithdrawPaymentPage extends StatefulWidget {
  final bool isEmbedded;

  final Decimal withdrawalAmount;

  final BuildContext? parentContext;

  const CheckoutWithdrawPaymentPage({
    Key? key,
    this.isEmbedded = false,
    this.parentContext,
    required this.withdrawalAmount,
  }) : super(key: key);

  @override
  State<CheckoutWithdrawPaymentPage> createState() =>
      _CheckoutWithdrawPaymentPageState();
}

class _CheckoutWithdrawPaymentPageState
    extends State<CheckoutWithdrawPaymentPage> {
  NavigatorState? nav;

  late CheckoutVM vm;

  late PaymentType? paymentType;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    nav ??= Navigator.of(context);

    return StoreConnector<AppState, CheckoutVM>(
      converter: (Store store) {
        return CheckoutVM.fromStore(store as Store<AppState>);
      },
      builder: (BuildContext context, CheckoutVM checkoutVM) {
        vm = checkoutVM;
        paymentType = vm.withdrawalPaymentTypes.firstWhereOrNull(
          (e) => e.isCard,
        );
        if (paymentType != null) {
          vm.setPaymentType(paymentType!);
        }
        return scaffoldMobile(context);
      },
    );
  }

  Widget scaffoldMobile(BuildContext context) => AppSimpleAppScaffold(
    title: 'Complete Cash Withdrawal',
    isEmbedded: widget.isEmbedded,
    displayAppBar: !widget.isEmbedded,
    footerActions: [checkoutButton(context)],
    body: vm.isLoading!
        ? const AppProgressIndicator()
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: layout(context),
          ),
  );

  Widget layout(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: AmountText(textValue: widget.withdrawalAmount.toString()),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: context.labelMediumBold('Payment Method'),
        ),
        Expanded(
          flex: 4,
          child: PaymentMethodsList(
            initialType: paymentType,
            paymentTypes: vm.withdrawalPaymentTypes,
            onTap: (ctx, type) {
              if (mounted) {
                setState(() {
                  paymentType = type;
                  vm.setPaymentType(type);
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget checkoutButton(BuildContext context) => ButtonPrimary(
    text: 'Confirm Payment',
    buttonColor: vm.paymentType == null || vm.isLoading == true
        ? Theme.of(context).extension<AppliedTextIcon>()?.secondary
        : Theme.of(context).extension<AppliedTextIcon>()?.accentAlt,
    onTap: (c) {
      charge(context, vm);
      vm.store?.dispatch(CheckoutSetCurrentActionAmount(Decimal.zero));
    },
  );

  charge(context, CheckoutVM vm) async {
    if (paymentType == null) return;
    var appState = vm.store!.state;
    vm.amountChange = widget.withdrawalAmount;
    var transaction = CheckoutTransaction.fromState(
      appState.checkoutState,
      appState.userProfile!.userId,
      appState.userProfile!.firstName!,
      appState.businessId,
      AppVariables.deviceInfo?.terminalId ?? '',
      AppVariables.deviceInfo?.deviceId ?? '',
    );
    transaction.amountChange = widget.withdrawalAmount.toDouble();
    chargeCardCheck(
      context: context,
      accounts: vm.linkedAccounts,
      transaction: transaction,
      vm: vm,
      type: paymentType!,
    );
  }

  chargeCardCheck({
    required CheckoutVM vm,
    required BuildContext context,
    required PaymentType type,
    required CheckoutTransaction transaction,
    required List<LinkedAccount>? accounts,
  }) async {
    if (type.name?.toLowerCase() != 'card') {
      showWithdrawalDeniedPopup(context);
      return;
    }

    if (vm.canDoCardPayment()) {
      await showPopupDialog(
        context: context,
        content: CardPayment(
          transaction: transaction,
          paymentType: CardTransactionType.withdrawal,
          refund: null,
          backButtonTimeout: 30,
          amount: widget.withdrawalAmount,
          cashBackAmount: vm.cashbackAmount ?? Decimal.zero,
          parentContext: context,
          transactionIsSaving: vm.state?.isLoading ?? false,
          canPrint: platformType == PlatformType.pos,
          saveSale: (result) {
            processResult(
              vm: vm,
              result: result,
              transaction: transaction,
              goToCompletePage: AppVariables.isMobile ? true : false,
            );
          },
        ),
      );
    } else {
      vm.paymentType!.paid = true;
      vm.onSetTransaction(transaction);
      vm.pushSale(widget.parentContext ?? context);
    }
  }

  // TODO(Michael): Make processResult a shared component?
  void processResult({
    required CheckoutVM vm,
    required result,
    required CheckoutTransaction transaction,
    bool goToCompletePage = true,
  }) {
    if (result['proceed']) {
      vm.paymentType!.paid = safeParseBool(result['paid']);
      vm.paymentType!.providerPaymentReference = safeParseString(
        result['providerPaymentReference'],
      );
      vm.onSetTransaction(
        TransactionResultMapper.setTransactionData(
          currentTransaction: transaction,
          resultMap: result,
          deviceDetails: vm.deviceDetails,
        ),
      );
      vm.pushSale(
        widget.parentContext ?? context,
        goToCompletePage: goToCompletePage,
      );
    } else if (vm.paymentType!.name!.toLowerCase() != 'card') {
      showMessageDialog(
        context,
        'Payment cancelled by user',
        LittleFishIcons.info,
      );
    }
  }

  showWithdrawalDeniedPopup(BuildContext context) async {
    return await showMessageDialog(
      context,
      'Withdrawals can only be done with a card payment.',
      LittleFishIcons.info,
    );
  }
}
