// removed ignore: depend_on_referenced_packages, use_build_context_synchronously

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_core/auth/services/auth_service.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/common/presentaion/components/errors/show_error.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/features/sell/domain/helpers/transaction_result_mapper.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_discount.dart'
    as checkout_discount;
import 'package:littlefish_merchant/models/sales/checkout/checkout_tip.dart';
import 'package:littlefish_merchant/tools/extensions/extensions.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_action_page.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_tips_page.dart';
import 'package:littlefish_merchant/ui/checkout/layouts/library/select_products_page.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/checkout_charge_summary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/components/custom_keypad.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/customer_section_heading.dart';
import 'package:littlefish_merchant/ui/customers/widgets/customer_select_tile.dart';
import 'package:littlefish_merchant/ui/manage_users/widgets/item_list_tile.dart';
import 'package:littlefish_payments/models/shared/payment_result.dart';
import 'package:quiver/strings.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/models/settings/accounts/linked_account.dart';
import 'package:littlefish_merchant/models/settings/payments/payment_type.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/snapscan/pages/snapscan_pay_page.dart';
import 'package:littlefish_merchant/tools/billing/billing_helpers.dart';
import 'package:littlefish_merchant/tools/parsers.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_merchant/ui/customers/pages/customer_select_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/zapper/pages/zapper_pay_page.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/bloc/linkeddevices_bloc.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/pages/linked_devices_page.dart';
import '../../../common/presentaion/components/buttons/button_discard.dart';
import '../../../common/presentaion/components/icons/delete_icon.dart';
import '../../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../../../shared/constants/permission_name_constants.dart';

import '../../../features/pos/presentation/pages/card_payment.dart';
import '../../../injector.dart';
import '../../customers/pages/customer_edit_page.dart';

class CheckoutChargePage extends StatefulWidget {
  static const String route = 'checkout/charge';

  final bool isEmbedded;

  final BuildContext? parentContext;

  const CheckoutChargePage({
    Key? key,
    this.isEmbedded = false,
    this.parentContext,
  }) : super(key: key);

  @override
  State<CheckoutChargePage> createState() => _CheckoutChargePageState();
}

class _CheckoutChargePageState extends State<CheckoutChargePage> {
  NavigatorState? nav;

  final GlobalKey _selectCustomerKey = GlobalKey();
  bool _isCashPressed = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late ScrollController _scrollController;
  bool tempLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    nav ??= Navigator.of(context);

    return StoreConnector<AppState, CheckoutVM>(
      onInit: (store) {
        CheckoutVM vm = CheckoutVM.fromStore(store);
        if (vm.paymentTypes.isNotEmpty && vm.paymentTypes.length == 1) {
          vm.setPaymentType(vm.paymentTypes.first);
        }
      },
      onDidChange: (previousViewModel, viewModel) {},
      converter: (Store store) {
        return CheckoutVM.fromStore(store as Store<AppState>);
      },
      builder: (BuildContext context, CheckoutVM vm) {
        return scaffold(context, vm);
      },
    );
  }

  Widget scaffold(context, CheckoutVM vm) {
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    final showSideNav =
        isTablet || (AppVariables.store!.state.enableSideNavDrawer ?? false);
    return AppScaffold(
      onBackPressed: () async {
        await vm.setCustomer(null);
        await vm.clearPaymentType();
        Navigator.of(context).pop();
        return;
      },
      title: 'Complete Sale',
      enableProfileAction: !showSideNav,
      hasDrawer: false,
      displayNavDrawer: false,
      actions: [
        if (userHasPermission(allowDiscardBasket) &&
            !(vm.store!.state.userState.isGuestUser == true))
          ButtonDiscard(
            isIconButton: true,
            enablePopPage: true,
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
            onDiscard: (vm.isLoading ?? false)
                ? null
                : (ctx) {
                    vm.onClear();
                    Navigator.pushAndRemoveUntil<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const SelectProductsPage(),
                      ),
                      ModalRoute.withName('/'),
                    );
                  },
          ),
      ],
      persistentFooterButtons: vm.isLoading == true
          ? null
          : [checkoutButton(context, vm)],
      body: vm.isLoading! || tempLoading
          ? const AppProgressIndicator()
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: layout(context, vm),
            ),
    );
  }

  Widget layout(BuildContext context, CheckoutVM vm) => SizedBox(
    child: ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      controller: _scrollController,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: CheckoutChargeSummary(
            checkoutTotal: (vm.checkoutTotal ?? Decimal.zero).toDouble(),
            enableCashback: vm.isCashbackApplied ?? false,
            cashbackAmount: (vm.cashbackAmount ?? Decimal.zero).toDouble(),
            enableDiscounts: vm.isCartDiscountApplied ?? false,
            discount: vm.discount?.value ?? 0,
            discountType:
                vm.discount?.type ?? checkout_discount.DiscountType.fixedAmount,
            enableTips: vm.isTipApplied ?? false,
            tipAmount: vm.tip?.value ?? 0,
            tipType: vm.tip?.type ?? TipType.fixedAmount,
            enableSubtotal: vm.totalValue != vm.checkoutTotal,
            subtotal: (vm.totalValue ?? Decimal.zero).toDouble(),
          ),
        ),
        Visibility(
          visible:
              AppVariables.store?.state.enableCashback == true ||
              AppVariables.store?.state.enableTips == true,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                if (AppVariables.store?.state.enableTips == true &&
                    userHasPermission(allowTip))
                  tipButton(context, vm),
                if (AppVariables.store?.state.enableCashback == true &&
                    userHasPermission(allowCashback))
                  cashbackButton(vm),
              ],
            ),
          ),
        ),
        if (!(vm.store!.state.userState.isGuestUser == true)) ...[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: const CustomerSectionHeading(isRequired: false),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: SelectCustomerTile(
              customer: vm.customer,
              onSetCustomer: (ctx, customer) => vm.setCustomer(customer),
              onClearCustomer: () => vm.setCustomer(null),
            ),
          ),
        ],
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: context.labelMediumBold('Payment Method'),
        ),
        const SizedBox(height: 6),
        SizedBox(
          child:
              isNotZeroOrNullDecimal(vm.cashbackAmount) ||
                  vm.store!.state.userState.isGuestUser == true
              ? paymentList(context, onlyCardPayment(vm), vm)
              : paymentList(context, vm.paymentTypes, vm),
        ),
        Form(
          key: formKey,
          child: Visibility(
            visible: vm.paymentType?.name?.toLowerCase() == 'other',
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: StringFormField(
                onSaveValue: (value) {
                  vm.paymentType!.providerPaymentReference = value ?? '';
                },
                onChanged: (value) {
                  vm.paymentType!.providerPaymentReference = value;
                },
                onFieldSubmitted: (value) {
                  vm.paymentType!.providerPaymentReference = value;
                },
                useOutlineStyling: true,
                hintText: 'Enter reason for other payment type',
                labelText: 'Description',
              ),
            ),
          ),
        ),
      ],
    ),
  );

  tipButton(BuildContext ctx, CheckoutVM vm) {
    return Expanded(
      child: ButtonSecondary(
        text: vm.isTipApplied != true ? 'Add Tip' : 'Edit Tip',
        onTap: (context) async {
          await Navigator.of(
            ctx,
          ).push(CustomRoute(builder: ((context) => const CheckoutTipsPage())));

          if (vm.paymentType != null &&
              vm.paymentType!.name?.toLowerCase() != 'cash') {
            vm.setPaymentType(vm.paymentType!);
          }
        },
      ),
    );
  }

  cashbackButton(CheckoutVM vm) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: ButtonSecondary(
          onTap: (context) async {
            if (vm.itemCount == 0 || vm.totalValue == 0) {
              showMessageDialog(
                context,
                'Cart is empty. Please add items to the cart in order to apply a cashback.',
                LittleFishIcons.info,
              );
              return;
            }

            await Navigator.of(context).push(
              CustomRoute(
                builder: (context) => const CheckoutActionPage(
                  actionType: CheckoutActionType.cashback,
                ),
              ),
            );

            if (vm.paymentType != null &&
                vm.paymentType!.name?.toLowerCase() != 'cash') {
              vm.setPaymentType(vm.paymentType!);
            }
          },
          text: !isNotZeroOrNullDecimal(vm.cashbackAmount)
              ? 'Add Cashback'
              : 'Edit Cashback',
        ),
      ),
    );
  }

  List<PaymentType> onlyCardPayment(CheckoutVM vm) {
    return vm.paymentTypes.where((element) => element.isCard).toList();
  }

  customerCard(BuildContext context, CheckoutVM vm) => ListTile(
    tileColor: Theme.of(context).colorScheme.background,
    key: _selectCustomerKey,
    onTap: () {
      if (vm.customer == null) {
        selectCustomer(context, vm);
      } else {
        vm.setCustomer(null);
      }
    },
    trailing: vm.customer == null
        ? const Icon(Icons.search)
        : const DeleteIcon(),
    title: Text(
      vm.customer == null ? 'Select Customer' : vm.customer!.displayName!,
    ),
    subtitle: null,
  );

  selectCustomer(BuildContext context, CheckoutVM vm) async {
    if (EnvironmentProvider.instance.isLargeDisplay!) {
      await showPopupDialog(
        context: context,
        content: CustomerSelectPage(
          canAddNew: true,
          onSelected: (BuildContext context, Customer customer) {
            vm.setCustomer(customer);
          },
          isDialog: true,
        ),
      );
    } else {
      await Navigator.of(context).push(
        CustomRoute(
          builder: (BuildContext context) => CustomerSelectPage(
            canAddNew: true,
            onSelected: (BuildContext context, Customer customer) {
              vm.setCustomer(customer);
            },
          ),
        ),
      );
    }
  }

  checkoutButton(BuildContext context, CheckoutVM vm) => ButtonPrimary(
    text: 'Confirm Payment',
    upperCase: false,
    disabled: vm.paymentType == null,
    onTap: (c) => charge(context, vm),
  );

  cashTender(CheckoutVM vm) async => showModalBottomSheet<double>(
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
        onValueChanged: (double amount) {},
        enableChange: true,
        minChargeAmount: roundedDouble(
          (vm.checkoutTotal ?? Decimal.zero).toDouble(),
        ),
        confirmButtonText: 'Confirm Payment',
        confirmErrorMessage:
            'Please enter the cash amount to be paid by the customer.',
        onDescriptionChanged: (String description) {},
        onSubmit: (double value, String? description) async {
          await vm.setAmountTendered(Decimal.parse(value.toString()));
          _isCashPressed = true;
          vm.amountTendered = Decimal.parse(value.toString());

          Navigator.of(ctx).pop();
        },
        initialValue: 0,
        parentContext: ctx,
      ),
    ),
  );

  charge(context, CheckoutVM vm) async {
    var appState = vm.store!.state;

    var transaction = CheckoutTransaction.fromState(
      vm.store!.state.checkoutState,
      appState.userProfile!.userId,
      appState.userProfile!.firstName!,
      appState.businessId,
      AppVariables.deviceInfo?.terminalId ?? '',
      AppVariables.deviceInfo?.deviceId ?? '',
    );

    transaction.terminalId = vm.deviceDetails?.terminalId ?? '';
    transaction.deviceId = vm.deviceDetails?.deviceId ?? '';
    vm.onSetTransaction(transaction);

    if (vm.checkoutTotal! <= Decimal.zero) {
      showMessageDialog(
        context,
        'The amount due must be greater than zero.',
        LittleFishIcons.info,
      );
      return;
    }

    if (vm.paymentType == null) {
      showMessageDialog(
        context,
        'Please select a payment method and try again.',
        LittleFishIcons.info,
      );
      return;
    }

    if (vm.paymentType!.name!.toLowerCase() == 'cash') {
      await cashTender(vm);
      vm.amountChange = (vm.amountTendered! - vm.checkoutTotal!).truncate(
        scale: 2,
      );
      vm.amountShort = (vm.checkoutTotal! - vm.amountTendered!).truncate(
        scale: 2,
      );
      if (vm.amountTendered! >= vm.checkoutTotal!) vm.isShort = false;
    }
    if (!_isCashPressed && vm.paymentType!.name!.toLowerCase() == 'cash') {
      return;
    }

    if (vm.isShort &&
        vm.paymentType!.name!.toLowerCase() != 'card' &&
        vm.paymentType!.name!.toLowerCase() != 'snapscan') {
      showMessageDialog(
        context,
        'The amount paid by your customer is not enough, please check the amount payable',
        LittleFishIcons.info,
      );
    } else if (vm.paymentType!.name!.toLowerCase() == 'other' &&
        isBlank(vm.paymentType!.providerPaymentReference)) {
      if (!(formKey.currentState?.validate() ?? false)) {
        await showMessageDialog(
          context,
          'Please enter a description for other payment type',
          LittleFishIcons.info,
        );
        _scrollToBottom();
        return;
      }
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
      transaction.amountTendered = (vm.amountTendered ?? Decimal.zero)
          .toDouble();
      transaction.amountChange = (vm.amountChange ?? Decimal.zero).toDouble();
      vm.paymentType!.paid = false;

      if (vm.linkedAccounts != null &&
          vm.linkedAccounts!.isNotEmpty &&
          vm.linkedAccounts!.any(
            (acc) =>
                enumToString(acc.providerType)!.toLowerCase() ==
                enumToString(vm.paymentType!.provider)!.toLowerCase(),
          )) {
        var result = await _setPaymentPopup(
          vm.paymentType!,
          transaction,
          widget.parentContext ?? context,
          vm.linkedAccounts,
        );

        processResult(vm: vm, transaction: transaction, result: result);
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

    CardTransactionType paymentType = isNotZeroOrNullDecimal(vm.cashbackAmount)
        ? CardTransactionType.purchaseWithCashback
        : CardTransactionType.purchase;

    if (vm.noCardPaymentProvider()) {
      if (vm.currentTransaction != null) {
        context.read<LinkedDevicesBloc>().add(GetLinkedDevices());
        context.read<LinkedDevicesBloc>().add(
          SchedulePushSaleTerminalEvent(vm.currentTransaction!),
        );
        await Navigator.of(context).pushNamed(LinkedDevicesPage.route);
      }

      return;
    }

    if (vm.canDoCardPayment()) {
      final paymentresult = await showPopupDialog(
        context: context,
        content: CardPayment(
          transaction: transaction,
          amount: Decimal.parse((transaction.checkoutTotal ?? 0).toString()),
          refund: null,
          backButtonTimeout: 30,
          paymentType: paymentType,
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
              //NB! previous logic below would never be true, as we do not do my pin pad builds or setup the payment provider, as such this is not valid.
              // cardPaymentRegistered == CardPaymentRegistered.myPinPad,
            );
          },
          onError: (paymentResult) => processErrorResult(
            transaction: transaction,
            paymentResult: paymentResult,
          ),
          // onError: (result) async {
          // if (SoftPosHelper.checkCardEnablement('card')) {
          //   BuildContext? ctx = globalNavigatorKey.currentContext;
          //   Navigator.of(ctx ?? context).push(
          //     CustomRoute(
          //       builder: (BuildContext context) => CheckoutChargePage(
          //         parentContext: ctx,
          //       ),
          //     ),
          //   );
          // }
          // },
        ),
      );
      debugPrint('### chargeCardCheck - paymentresult: $paymentresult');
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
      bool? res = await modalService.showActionModal(
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

  double roundedDouble(double value, {int decimalPlaces = 2}) {
    String roundedStr = value.toStringAsFixed(decimalPlaces);
    return double.parse(roundedStr);
  }

  _setPaymentPopup(
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

  void sortAndAutoSelectPaymentType(List<PaymentType> types, CheckoutVM vm) {
    types.sort((a, b) {
      if (a.name == 'Card') return -1;
      if (b.name == 'Card') return 1;
      return 0;
    });

    if (types.length == 1) {
      PaymentType onlyType = types.first;
      if (vm.paymentType != onlyType) {
        vm.paymentTypeIndex = onlyType.displayIndex;
        vm.setPaymentType(onlyType);
        vm.setAmountTendered(vm.checkoutTotal);
      }
    }
  }

  Widget paymentList(
    BuildContext context,
    List<PaymentType> types,
    CheckoutVM vm,
  ) {
    if (types.isEmpty) {
      String details = '';
      if (isNotZeroOrNullDecimal(vm.cashbackAmount) ||
          isNotZeroOrNullDecimal(vm.withdrawalAmount)) {
        details =
            'Cashback can only be processed using card payment method.\n\n';
      }
      if (AppVariables.isMobileWithoutSoftPos) {
        details += 'Your device does not support card payments.';
      }
      return Expanded(
        child: ShowError(
          message: 'No payment methods available',
          details: details,
          detailsPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 8,
          ),
        ),
      );
    }

    sortAndAutoSelectPaymentType(types, vm);

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: types.length,
      shrinkWrap: true,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (BuildContext context, int index) {
        return _paymentListItems(
          index: types[index].displayIndex,
          selectedIcon: types[index].iconData,
          unselectedIcon: types[index].iconData,
          type: types[index],
          vm: vm,
        );
      },
    );
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _paymentListItems({
    required IconData? unselectedIcon,
    required IconData? selectedIcon,
    required int? index,
    required PaymentType type,
    required CheckoutVM vm,
  }) {
    return ItemListTile(
      leading: ListLeadingIconTile(
        icon: vm.paymentTypeIndex == index ? selectedIcon : unselectedIcon,
        iconColor: vm.paymentTypeIndex == index
            ? Theme.of(context).extension<AppliedTextIcon>()?.brand
            : null,
      ),
      title: type.name ?? '',
      onTap: () async {
        if (isNotPremium(type.name)) {
          showPopupDialog(
            defaultPadding: false,
            context: context,
            content: billingNavigationHelper(isModal: true),
          );
        } else {
          vm.paymentTypeIndex = index;
          vm.setPaymentType(PaymentType.clone(type));
          vm.setAmountTendered(vm.checkoutTotal);
        }
      },
      trailingIcon: Radio(
        activeColor: Theme.of(context).extension<AppliedTextIcon>()?.brand,
        focusColor: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
        value: true,
        groupValue:
            vm.paymentType?.name?.toLowerCase() == type.name?.toLowerCase()
            ? true
            : false,
        onChanged: (qe) {
          vm.paymentTypeIndex = index;
          vm.setPaymentType(type);
          vm.setAmountTendered(vm.checkoutTotal);
        },
      ),
    );
  }

  void processResult({
    required CheckoutVM vm,
    required result,
    required CheckoutTransaction transaction,
    bool goToCompletePage = true,
  }) {
    if (result?['proceed'] == true) {
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
      var navToCompletePage = result['paid'] ? goToCompletePage : false;
      BuildContext? ctx = globalNavigatorKey.currentContext;

      vm.pushSale(
        ctx ?? widget.parentContext ?? context,
        goToCompletePage: navToCompletePage,
      );
    } else if (vm.paymentType!.name!.toLowerCase() != 'card') {
      showMessageDialog(
        context,
        'Payment cancelled by user',
        LittleFishIcons.info,
      );
    }
  }

  void processErrorResult({
    required CheckoutTransaction transaction,
    required PaymentResult? paymentResult,
  }) {
    debugPrint('### signalr notused! processErrorResult - paymentResult');
    final newTransAction = CheckoutTransaction(
      amountChange: transaction.amountChange,
      amountTendered: transaction.amountTendered,
      cashbackAmount: transaction.cashbackAmount,
      items: transaction.items,
      paymentType: transaction.paymentType,
      sellerId: transaction.sellerId,
      sellerName: transaction.sellerName,
      totalTax: transaction.totalTax,
      totalValue: transaction.totalValue,
      countryCode: transaction.countryCode,
      currencyCode: transaction.currencyCode,
      deviceId: transaction.deviceId,
      customerEmail: transaction.customerEmail,
      customerId: transaction.customerId,
      customerName: transaction.customerName,
      customerMobile: transaction.customerMobile,
      id: transaction.id,
      isOnline: transaction.isOnline,
      pendingSync: transaction.pendingSync,
      refunds: transaction.refunds,
      taxInclusive: transaction.taxInclusive,
      ticketId: transaction.ticketId,
      ticketName: transaction.ticketName,
      tipAmount: transaction.tipAmount,
      totalCost: transaction.totalCost,
      totalDiscount: transaction.totalDiscount,
      totalMarkup: transaction.totalMarkup,
      totalRefund: transaction.totalRefund,
      totalRefundCost: transaction.totalRefundCost,
      transactionDate: transaction.transactionDate,
      transactionNumber: transaction.transactionNumber,
      withdrawalAmount: transaction.withdrawalAmount,
      additionalInfo: {
        'status': paymentResult?.status ?? '',
        'statusCode': paymentResult?.statusCode ?? '',
        'statusDescription': paymentResult?.statusDescription ?? '',
        'statusMessage': paymentResult?.statusMessage ?? '',
        'transactionStatus': paymentResult?.transactionStatus ?? '',
      },
    );
  }
}
