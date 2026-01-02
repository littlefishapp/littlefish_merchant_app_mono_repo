// remove ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core/auth/services/auth_service.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/features/pos/presentation/pages/card_payment.dart';
import 'package:littlefish_merchant/features/sell/domain/helpers/transaction_result_mapper.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/models/settings/accounts/linked_account.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/models/settings/payments/payment_type.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/snapscan/pages/snapscan_pay_page.dart';
import 'package:littlefish_merchant/tools/parsers.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_merchant/ui/customers/pages/customer_edit_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/zapper/pages/zapper_pay_page.dart';
import '../../../injector.dart';
import '../../../models/enums.dart';
import '../../../redux/checkout/checkout_actions.dart';
import '../../../common/presentaion/components/custom_keypad.dart';
import '../../../tools/helpers.dart';
import 'checkout_charge_page.dart';

class CheckoutQuickSale extends StatefulWidget {
  static const String route = 'checkout/quicksale';

  final bool isEmbedded;

  final BuildContext? parentContext;

  const CheckoutQuickSale({
    Key? key,
    this.isEmbedded = false,
    this.parentContext,
  }) : super(key: key);

  @override
  State<CheckoutQuickSale> createState() => _CheckoutQuickSalePageState();
}

class _CheckoutQuickSalePageState extends State<CheckoutQuickSale> {
  NavigatorState? nav;
  bool _isCashPressed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColours =
        Theme.of(context).extension<AppliedSurface>() ?? const AppliedSurface();
    nav ??= Navigator.of(context);
    bool isGuestLogin = false;

    return StoreConnector<AppState, CheckoutVM>(
      converter: (Store store) {
        var vm = CheckoutVM.fromStore(store as Store<AppState>);
        return vm;
      },
      builder: (BuildContext context, CheckoutVM vm) {
        isGuestLogin = vm.store!.state.userState.isGuestUser == true;
        return vm.isLoading!
            ? const AppProgressIndicator(
                hasScaffold: true,
                backgroundColor: Colors.white,
              )
            : PopScope(
                onPopInvoked: (bool didPop) {
                  vm.onClear();
                  return;
                },
                canPop: true,
                child: CustomKeyPad(
                  isDescriptionRequired: false,
                  isLoading: vm.isLoading,
                  enableAppBar: !widget.isEmbedded,
                  enableProfileAction: false,
                  title: 'Purchase',
                  isFullPage: true,
                  enableDescription: true,
                  confirmButtonText: 'Continue to Payment',
                  confirmErrorMessage:
                      'Please enter an amount for the purchase.',
                  onSubmit: (double value, String? description) async {
                    Decimal val = Decimal.parse(value.toString());
                    await vm.onRemoveItems();
                    vm.store?.dispatch(CheckoutClearDiscountAction());
                    vm.customSaleDescription = description;
                    vm.onSetDescription(description ?? 'Purchase');
                    if (value > 0) {
                      vm.itemCount = 0;
                      if (vm.itemCount == 0 && value != 0) {
                        await vm.addCustomSaleToCart(
                          val,
                          vm.customSaleDescription!,
                        );
                      }
                      vm.checkoutTotal = val;
                      if (vm.paymentType?.name?.toLowerCase() != 'cash') {
                        vm.totalValue = val;
                        vm.checkoutTotal = val;
                        vm.amountTendered = vm.checkoutTotal;
                        vm.setAmountTendered(vm.checkoutTotal);
                      } else {
                        vm.setAmountTendered(Decimal.zero);
                      }
                      if (context.mounted) {
                        Navigator.of(context).push(
                          CustomRoute(
                            builder: (BuildContext context) =>
                                const CheckoutChargePage(),
                          ),
                        );
                      }
                    }
                  },
                  onValueChanged: (double amount) {},
                  onDescriptionChanged: (String description) {},
                  initialValue: (vm.amountTendered ?? Decimal.zero).toDouble(),
                  initialDescriptionValue: isNotNullOrEmpty(vm.items)
                      ? (vm.items?[0].description ?? '')
                      : '',
                ),
              );
      },
    );
  }

  Future<Future<double?>> cashTender(CheckoutVM vm) async =>
      showModalBottomSheet<double>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (ctx) => SizedBox(
          height: 480,
          child: CustomKeyPad(
            isLoading: vm.isLoading,
            enableAppBar: false,
            title: 'Cash Payment',
            enableChange: true,
            confirmButtonText: 'Confirm Payment',
            confirmErrorMessage:
                'Please enter the cash amount to be paid by the customer.',
            onValueChanged: (double amount) {},
            onDescriptionChanged: (String description) {},
            onSubmit: (double value, String? description) async {
              Decimal val = Decimal.parse(value.toString());
              await vm.setAmountTendered(val);
              vm.amountChange = vm.amountTendered! - vm.checkoutTotal!;
              vm.amountShort = vm.checkoutTotal! - vm.amountTendered!;
              _isCashPressed = true;
              if (val >= vm.checkoutTotal!) {
                vm.isShort = false;
              } else {
                vm.isShort = true;
              }
              Navigator.of(ctx).pop();
            },
            initialValue: (vm.amountTendered ?? Decimal.zero).toDouble(),
            minChargeAmount: (vm.checkoutTotal ?? Decimal.zero).toDouble(),
            parentContext: ctx,
          ),
        ),
      );

  Future<void> charge(context, CheckoutVM vm) async {
    var appState = vm.store!.state;

    var transaction = CheckoutTransaction.fromState(
      vm.store!.state.checkoutState,
      appState.userProfile!.userId,
      appState.userProfile!.firstName!,
      appState.businessId,
      AppVariables.deviceInfo?.terminalId ?? '',
      AppVariables.deviceInfo?.deviceId ?? '',
    );

    if (vm.checkoutTotal! <= Decimal.zero) return;

    if (vm.paymentType!.name!.toLowerCase() == 'cash') {
      vm.setAmountTendered(Decimal.zero);
      vm.isShort = true;
      await cashTender(vm);
    }
    if (!_isCashPressed && vm.paymentType!.name!.toLowerCase() == 'cash') {
      return;
    }

    // if (vm.itemCount == 0 && vm.amountTendered! >= 0)
    //   vm.addCustomSaleToCart(
    //       vm.amountTendered ?? 0, vm.customSaleDescripion ?? "");

    if (vm.isShort) {
      showMessageDialog(
        context,
        'The amount paid by your customer is not enough, please check the amount payable',
        LittleFishIcons.info,
      );
    } else if (vm.paymentType == null) {
      showMessageDialog(
        context,
        'Please select a payment type',
        LittleFishIcons.info,
      );
    } else if (vm.paymentType!.name!.toLowerCase() == 'credit') {
      creditCustomerCheck(vm, context);
    } else if (vm.paymentType!.name!.toLowerCase() == 'card') {
      vm.paymentType!.paid = false;
      vm.isLoading = true;
      chargeCardCheck(
        context: context,
        accounts: vm.linkedAccounts,
        transaction: transaction,
        vm: vm,
        type: vm.paymentType!,
      );
    } else {
      vm.paymentType!.paid = false;

      if (vm.linkedAccounts != null &&
          vm.linkedAccounts!.isNotEmpty &&
          vm.linkedAccounts!.any(
            (acc) =>
                enumToString(acc.providerType)!.toLowerCase() ==
                enumToString(vm.paymentType!.provider)!.toLowerCase(),
          )) {
        setPaymentPopup(
          vm.paymentType!,
          transaction,
          widget.parentContext ?? context,
          vm.linkedAccounts,
        )?.then((result) {
          processResult(
            vm: vm,
            transaction: transaction,
            result: result,
            goToCompletePage: AppVariables.isMobile ? true : false,
          );
        });
      } else {
        vm.paymentType!.paid = true;
        vm.pushSale(widget.parentContext ?? context);
      }
    }
  }

  chargeCardCheck({
    required CheckoutVM vm,
    required BuildContext context,
    required PaymentType type,
    required CheckoutTransaction transaction,
    required List<LinkedAccount>? accounts,
  }) async {
    if (type.name?.toLowerCase() != 'card' &&
        isNotZeroOrNull(transaction.cashbackAmount)) {
      await showMessageDialog(
        context,
        'Cashbacks can only be completed using card payment.',
        LittleFishIcons.info,
      );
      return;
    }

    if (vm.canDoCardPayment()) {
      await showPopupDialog(
        context: context,
        content: CardPayment(
          transaction: transaction,
          paymentType: isNotZeroOrNullDecimal(vm.cashbackAmount)
              ? CardTransactionType.purchaseWithCashback
              : CardTransactionType.purchase,
          refund: null,
          backButtonTimeout: 30,
          amount: vm.checkoutTotal ?? Decimal.zero,
          cashBackAmount: vm.cashbackAmount ?? Decimal.zero,
          canPrint: platformType == PlatformType.pos,
          parentContext: context,
          transactionIsSaving: vm.state?.isLoading ?? false,
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
      vm.pushSale(widget.parentContext ?? context);
    }
  }

  creditCustomerCheck(CheckoutVM vm, BuildContext context) async {
    final ModalService modalService = getIt<ModalService>();

    if (vm.customer == null) {
      showMessageDialog(
        context,
        'Please choose a customer for this payment type',
        LittleFishIcons.info,
      );
    } else if (!vm.customer!.userVerified) {
      var res = await modalService.showActionModal(
        context: context,
        title: 'Details Missing',
        description:
            'Customer must either have photo or id number, would you like to add one now?',
      );

      if (res == true) {
        var cc = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) =>
                CustomerEditPage(customer: vm.customer, parentContext: context),
          ),
        );

        if (cc != null) {
          vm.customer = cc;
          vm.setCustomer(cc);
          // if (mounted) setState(() {});
        }
      }
    } else {
      var creditSettings =
          vm.store!.state.businessState.profile!.storeCreditSettings!;

      var availableCredit =
          creditSettings.creditLimit! + vm.customer!.creditBalance!;
      if (availableCredit - (vm.checkoutTotal ?? Decimal.zero).toDouble() < 0) {
        showMessageDialog(
          context,
          'Customer exceeds credit limit by ${TextFormatter.toStringCurrency(availableCredit - (vm.checkoutTotal ?? Decimal.zero).toDouble(), displayCurrency: false, currencyCode: '')}',
          LittleFishIcons.info,
        );
      } else {
        vm.paymentType!.paid = true;
        vm.pushSale(widget.parentContext ?? context);
      }
    }
  }

  Future? setPaymentPopup(
    PaymentType type,
    CheckoutTransaction transaction,
    BuildContext ctx,
    List<LinkedAccount>? accounts,
  ) {
    switch (type.provider) {
      case PaymentProvider.zapper:
        return showPopupDialog(
          context: ctx,
          content: ZapperPayPage(
            transaction,
            accounts!
                .firstWhere((x) => x.providerType == ProviderType.zapper)
                .imageURI,
            parentContext: ctx,
          ),
        );
      case PaymentProvider.snapscan:
        return showPopupDialog(
          context: ctx,
          content: SnapscanPayPage(
            transaction,
            accounts!
                .firstWhere((x) => x.providerType == ProviderType.snapscan)
                .imageURI,
            parentContext: ctx,
          ),
        );
      default:
        return null;
    }
  }

  void processResult({
    required CheckoutVM vm,
    required result,
    required CheckoutTransaction transaction,
    required bool goToCompletePage,
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
}
