// remove ignore_for_file: use_build_context_synchronously

// removed ignore: depend_on_referenced_packages
import 'package:decimal/decimal.dart';
import 'package:littlefish_core/auth/services/auth_service.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/features/sell/domain/helpers/transaction_result_mapper.dart';
import 'package:littlefish_merchant/tools/payment_types_helper/soft_pos_helper.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/amount_text.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/customer_section_heading.dart';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/features/pos/presentation/pages/card_payment.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/business/expenses/widgets/payment_methods_list.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_merchant/ui/customers/widgets/customer_select_tile.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import '../../../../injector.dart';

class QuickRefundPaymentMethodPage extends StatefulWidget {
  static const String route = 'business/expense/payment_method';

  final bool isEmbedded;
  final Refund refund;
  final String? sourcePageRoute;

  const QuickRefundPaymentMethodPage({
    Key? key,
    required this.refund,
    this.isEmbedded = false,
    this.sourcePageRoute,
  }) : super(key: key);

  @override
  State<QuickRefundPaymentMethodPage> createState() =>
      _QuickRefundPaymentMethodPageState();
}

class _QuickRefundPaymentMethodPageState
    extends State<QuickRefundPaymentMethodPage> {
  late String _textValue;

  late CheckoutTransaction _transaction;

  @override
  void initState() {
    _textValue = widget.refund.totalRefund.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CheckoutVM>(
      onInit: (store) {
        _transaction = CheckoutTransaction.fromState(
          store.state.checkoutState,
          store.state.userProfile?.userId ?? '',
          store.state.userProfile?.firstName ?? '',
          store.state.businessId,
          AppVariables.deviceInfo?.terminalId ?? '',
          AppVariables.deviceInfo?.deviceId ?? '',
        );
        _updateRefund();
        _transaction.refunds = [widget.refund];

        CheckoutVM vm = CheckoutVM.fromStore(store);
        if (vm.refundPaymentTypes.isNotEmpty &&
            vm.refundPaymentTypes.length == 1) {
          vm.setPaymentType(vm.refundPaymentTypes.first);
        }
      },
      converter: (store) => CheckoutVM.fromStore(store),
      builder: (ctx, vm) {
        return layout(ctx, vm);
      },
    );
  }

  _updateRefund() {
    widget.refund.sellerId = _transaction.sellerId;
    widget.refund.sellerName = _transaction.sellerName;
    widget.refund.currencyCode = _transaction.currencyCode;
    widget.refund.countryCode = _transaction.countryCode;
    widget.refund.deviceName = _transaction.deviceName;
    widget.refund.deviceId = _transaction.deviceId;
  }

  layout(ctx, CheckoutVM vm) => AppScaffold(
    displayAppBar: true,
    title: 'Quick Refund',
    body: vm.isLoading!
        ? Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: AppProgressIndicator(
              backgroundColor: Theme.of(
                context,
              ).extension<AppliedSurface>()?.primary,
              hasScaffold: false,
            ),
          )
        : Column(
            children: <Widget>[
              Expanded(flex: 2, child: AmountText(textValue: _textValue)),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: const CustomerSectionHeading(isRequired: true),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: SelectCustomerTile(
                  customer: vm.customer,
                  onClearCustomer: () {
                    vm.setQuickRefundCustomer(null);
                  },
                  onSetCustomer: (ctx, customer) =>
                      vm.setQuickRefundCustomer(customer),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: paymentMethodsHeading(context),
              ),
              Expanded(
                flex: 4,
                child: PaymentMethodsList(
                  initialType: vm.paymentType,
                  paymentTypes: vm.refundPaymentTypes,
                  onTap: (context, type) {
                    vm.setPaymentType(type);
                  },
                ),
              ),
            ],
          ),
    persistentFooterButtons: [confirmRefundButton(context, vm)],
  );

  confirmRefundButton(BuildContext context, CheckoutVM vm) => ButtonPrimary(
    disabled: !_canEnableRefund(vm),
    text: 'Confirm Refund',
    onTap: (context) async {
      makeRefund(context, vm);
    },
  );

  Widget paymentMethodsHeading(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: context.labelMediumBold('Payment Method'),
    );
  }

  makeRefund(context, CheckoutVM vm) async {
    double textValueDouble = double.parse(_textValue);

    _setTransactionDetails(vm);

    if (textValueDouble <= 0) {
      showMessageDialog(
        context,
        'Please enter the amount to be refunded.',
        LittleFishIcons.info,
      );
      return;
    }

    if (vm.paymentType == null) {
      showMessageDialog(
        context,
        'Please select a payment method.',
        LittleFishIcons.info,
      );
      return;
    }

    if (vm.customer == null) {
      showMessageDialog(
        context,
        'Please select a customer to be refunded',
        LittleFishIcons.info,
      );
      return;
    }

    if (vm.paymentType!.name!.toLowerCase() == 'card') {
      vm.paymentType!.paid = false;
      vm.isLoading = true;

      switch (cardPaymentRegistered) {
        case CardPaymentRegistered.none:
          vm.paymentType!.paid = true;
          vm.pushSale(context);
          break;
        case CardPaymentRegistered.pos:
          await _cardPaymentHandler(vm: vm);
          break;
      }
    } else {
      _updatePaymentInformationRefund(
        vm: vm,
        store: vm.store!,
        result: null,
        paymentType: vm.paymentType!.name!.toLowerCase(),
      );
      vm.paymentType!.paid = true;
      vm.pushSale(context, transaction: vm.currentTransaction);
    }
  }

  bool _canEnableRefund(CheckoutVM vm) {
    double textValueDouble = double.parse(_textValue);

    if (textValueDouble <= 0) return false;
    if (vm.paymentType == null) return false;
    if (vm.customer == null) return false;

    return true;
  }

  _updatePaymentInformationRefund({
    required CheckoutVM vm,
    required Store<AppState> store,
    required dynamic result,
    required String paymentType,
  }) async {
    Refund refund = Refund.copy(widget.refund);
    refund.businessId = _transaction.businessId;
    refund.description = 'quick refund';
    refund.name = 'quick_refund';
    refund.status = 'refunded';
    refund.isQuickRefund = true;
    refund.displayName = 'Quick Refund';
    refund.createdBy = vm.store!.state.userState.profile?.userId;
    refund.updatedBy = vm.store!.state.userState.profile?.userId;
    refund.dateCreated = DateTime.now().toUtc();
    refund.dateUpdated = DateTime.now().toUtc();
    refund.enabled = true;
    refund.deleted = false;
    if (paymentType.toLowerCase() == 'card') {
      _transaction = TransactionResultMapper.setTransactionData(
        currentTransaction: _transaction,
        resultMap: result,
        deviceDetails: store.state.deviceState.deviceDetails,
      );

      refund = TransactionResultMapper.setRefundData(
        trx: refund,
        resultMap: result,
        deviceDetails: store.state.deviceState.deviceDetails,
      );
      _transaction.refunds = [refund];
      await vm.onSetTransaction(_transaction);
    } else if (paymentType.toLowerCase() == 'cash') {
      refund.terminalId =
          store.state.deviceState.deviceDetails?.terminalId ?? '';
      refund.deviceId = store.state.deviceState.deviceDetails?.deviceId ?? '';
      refund.transactionStatus = 'Approved';
      _transaction.terminalId =
          store.state.deviceState.deviceDetails?.terminalId ?? '';
      _transaction.deviceId =
          store.state.deviceState.deviceDetails?.deviceId ?? '';
      _transaction.transactionStatus = 'Approved';
      _transaction.refunds = [refund];
      await vm.onSetTransaction(_transaction);
    }
  }

  chargeCardCheck({
    required CheckoutVM vm,
    required BuildContext context,
    dynamic result,
    bool goToCompletePage = true,
  }) async {
    _updatePaymentInformationRefund(
      vm: vm,
      store: vm.store!,
      result: result,
      paymentType: vm.paymentType!.name!.toLowerCase(),
    );
    vm.paymentType!.paid = true;
    vm.pushSale(
      context,
      goToCompletePage: goToCompletePage,
      transaction: vm.currentTransaction,
    );
  }

  _setTransactionDetails(CheckoutVM vm) {
    widget.refund.paymentType = _transaction.paymentType;
    widget.refund.transactionDate = _transaction.transactionDate;
    widget.refund.paymentType = vm.paymentType;
    widget.refund.checkoutTransactionId = _transaction.id ?? '';
    _transaction.refunds = [widget.refund];
    _transaction.paymentType = vm.paymentType;
    _transaction.totalRefund = widget.refund.totalRefund;
    _transaction.totalRefundCost = widget.refund.totalRefundCost;
    vm.onSetTransaction(_transaction);
  }

  Future<void> _cardPaymentHandler({required CheckoutVM vm}) {
    return showPopupDialog(
      context: context,
      content: CardPayment(
        transaction: _transaction,
        paymentType: CardTransactionType.refund,
        backButtonTimeout: 30,
        cashBackAmount: Decimal.zero,
        amount: Decimal.parse((widget.refund.totalRefund).toString()),
        transactionIsSaving: false,
        canPrint: platformType == PlatformType.pos,
        refund: widget.refund,
        refundReference: SoftPosHelper.createReference(),
        saveSale: (result) {
          chargeCardCheck(
            context: context,
            vm: vm,
            result: result,
            goToCompletePage: AppVariables.isMobile ? true : false,
          );
        },
      ),
    );
  }
}
