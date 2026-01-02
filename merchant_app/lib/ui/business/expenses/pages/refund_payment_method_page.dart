// remove ignore_for_file: use_build_context_synchronously

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core/auth/services/auth_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/features/pos/presentation/pages/card_payment.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_actions.dart';
import 'package:littlefish_merchant/redux/sales/sales_actions.dart';
import 'package:littlefish_merchant/ui/business/expenses/widgets/payment_methods_list.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/amount_text.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/customer_section_heading.dart';
import 'package:littlefish_merchant/ui/customers/widgets/customer_select_tile.dart';
import 'package:littlefish_merchant/ui/sales/view_models.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import '../../../../injector.dart';

class RefundPaymentMethodPage extends StatefulWidget {
  static const String route = 'business/expense/payment_method';

  final bool isEmbedded;
  final String? sourcePageRoute;

  const RefundPaymentMethodPage({
    Key? key,
    this.isEmbedded = false,
    this.sourcePageRoute,
  }) : super(key: key);

  @override
  State<RefundPaymentMethodPage> createState() =>
      _RefundPaymentMethodPageState();
}

class _RefundPaymentMethodPageState extends State<RefundPaymentMethodPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController? _descriptionController;

  GlobalKey<FormState> descKey = GlobalKey<FormState>();

  late LoggerService _logger;

  @override
  void initState() {
    _descriptionController = TextEditingController();
    _logger = LittleFishCore.instance.get<LoggerService>();
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SalesVM>(
      onInit: (store) {
        SalesVM vm = SalesVM.fromStore(store);
        if (vm.originalTransactionUnmodified?.paymentType != null) {
          vm.currentRefund?.paymentType =
              vm.originalTransactionUnmodified?.paymentType;
          vm.store?.dispatch(SetCurrentRefundAction(vm.currentRefund));
        }
      },
      converter: (store) => SalesVM.fromStore(store),
      builder: (ctx, vm) => layout(context, vm),
    );
  }

  layout(ctx, SalesVM vm) => AppSimpleAppScaffold(
    displayAppBar: true,
    isEmbedded: widget.isEmbedded,
    title: 'Refund',
    body: vm.isLoading!
        ? Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: AppProgressIndicator(
              backgroundColor: Theme.of(context).colorScheme.background,
              hasScaffold: false,
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(flex: 2, child: keypadDisplay(context, vm)),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: customerSection(context, vm),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: context.labelMediumBold('Refund Payment Method'),
              ),
              Expanded(
                flex: 4,
                child: PaymentMethodsList(
                  originalTransactionPaymentType:
                      vm.originalTransactionUnmodified?.paymentType,
                  initialType: vm.originalTransactionUnmodified?.paymentType,
                  paymentTypes: vm.refundPaymentTypes,
                  onTap: (context, type) {
                    if (mounted) {
                      setState(() {
                        vm.currentRefund?.paymentType = type;
                        vm.store?.dispatch(
                          SetCurrentRefundAction(vm.currentRefund),
                        );
                      });
                    }
                  },
                ),
              ),
            ],
          ),
    footerActions: [keypadButton(context, vm)],
  );

  keypadDisplay(BuildContext context, SalesVM vm) {
    var amountDisplayText = TextFormatter.toStringCurrency(
      double.parse(vm.currentRefund?.totalRefund.toString() ?? '0'),
      displayCurrency: false,
      currencyCode: '',
    );

    return AmountText(textValue: amountDisplayText);
  }

  Widget customerSection(BuildContext context, SalesVM vm) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: const CustomerSectionHeading(isRequired: true),
        ),
        SelectCustomerTile(
          customer: vm.customer,
          onSetCustomer: (ctx, customer) => vm.setCustomer(customer),
          onClearCustomer: () => vm.clearCustomer(),
        ),
      ],
    );
  }

  keypadButton(BuildContext context, SalesVM vm) {
    bool isDisabled =
        vm.currentRefund?.paymentType == null ||
        vm.customer == null ||
        vm.currentRefund?.totalRefund == 0.0;
    String refundReference =
        vm
            .originalTransactionUnmodified
            ?.paymentType
            ?.providerPaymentReference ??
        vm.originalTransactionUnmodified?.traceID ??
        '';
    return ButtonPrimary(
      upperCase: true,
      buttonColor: Theme.of(context).colorScheme.primary,
      text: 'Confirm Refund',
      disabled: isDisabled,
      onTap: (context) async {
        if (isDisabled) {
          showInvalidDataMessage(context, vm);
          return;
        }

        vm.store?.dispatch(SetSalesLoadingStateAction(true));
        setCurrentRefundDate(vm);
        if (cardPaymentRegistered == CardPaymentRegistered.pos) {
          try {
            if (vm.currentRefund!.paymentType!.name!.toLowerCase() == 'card') {
              var transaction = CheckoutTransaction.fromState(
                vm.store!.state.checkoutState,
                vm.store!.state.userProfile!.userId,
                vm.store!.state.userProfile!.firstName!,
                vm.store!.state.businessId,
                AppVariables.deviceInfo?.terminalId ?? '',
                AppVariables.deviceInfo?.deviceId ?? '',
              );

              await showPopupDialog(
                context: context,
                content: CardPayment(
                  transaction: transaction,
                  paymentType: CardTransactionType.refund,
                  refund: vm.currentRefund,
                  backButtonTimeout: 30,
                  cashBackAmount: Decimal.zero,
                  amount: Decimal.parse(
                    vm.currentRefund?.totalRefund.toString() ?? '0',
                  ),
                  canPrint: platformType == PlatformType.pos,
                  parentContext: context,
                  transactionIsSaving: false,
                  saveSale: (result) {
                    saveAndUpdateState(
                      context,
                      vm,
                      result: result,
                      goToCompletePage: AppVariables.isMobile ? true : false,
                    );
                  },
                  refundReference: refundReference,
                ),
              );
            } else if (vm.currentRefund!.paymentType!.isCash) {
              var result = {
                'proceed': true,
                'paymentType': vm.currentRefund?.paymentType,
                'amount': vm.currentRefund?.totalRefund,
              };
              saveAndUpdateState(context, vm, result: result);
            } else {
              _logger.error(
                'RefundPaymentMethodPage',
                'Unsupported payment type for POS refund: ${vm.currentRefund!.paymentType!.name}',
              );
              throw Exception(
                'Unsupported payment type for POS refund: ${vm.currentRefund!.paymentType!.name}',
              );
            }
          } catch (e) {
            vm.store?.dispatch(SetSalesLoadingStateAction(false));

            _logger.error(
              'RefundPaymentMethodPage',
              'Error processing payment: $e',
            );
            if (context.mounted) {
              await showErrorDialog(
                context,
                'An error occurred while processing the payment. Please try again.',
              );
            }
          } finally {
            vm.store?.dispatch(SetSalesLoadingStateAction(false));
          }
        } else {
          var result = {
            'proceed': true,
            'paymentType': vm.currentRefund?.paymentType,
            'amount': vm.currentRefund?.totalRefund,
          };
          saveAndUpdateState(context, vm, result: result);
        }
      },
    );
  }

  showInvalidDataMessage(BuildContext context, SalesVM vm) {
    bool isPaymentTypeNull = vm.currentRefund?.paymentType == null;
    bool isCustomerNull = vm.customer == null;
    bool isAmountNull = vm.currentRefund?.totalRefund == 0.0;

    String message = 'Please select a customer and payment method to continue.';
    if (isAmountNull) {
      message =
          'Invalid amount to be refunded, the amount must be greater than zero.';
    }
    if (isCustomerNull) {
      message = 'Please select a customer to be refunded.';
    }
    if (isPaymentTypeNull) {
      message = 'Please select a method of payment.';
    }
    showMessageDialog(context, message, LittleFishIcons.info);
  }

  saveAndUpdateState(
    BuildContext ctx,
    SalesVM vm, {
    bool goToCompletePage = true,
    dynamic result,
  }) {
    if (vm.currentRefund == null) return;

    if (result == null) {
      showMessageDialog(
        context,
        'Failed to get payment information. Please try again.',
        LittleFishIcons.error,
        status: StatusType.destructive,
      );
      return;
    }

    if (result['proceed'] == true) {
      vm.store!.dispatch(
        refundSale(
          context,
          vm.currentRefund!,
          paymentInformation: result,
          goToRefundCompletePage: goToCompletePage,
        ),
      );
    }
  }

  setCurrentRefundDate(SalesVM vm) {
    vm.currentRefund?.transactionDate = DateTime.now().toUtc();
    vm.store?.dispatch(SetCurrentRefundAction(vm.currentRefund));
  }

  showErrorDialog(BuildContext context, String message) async {
    await showMessageDialog(context, message, LittleFishIcons.info);
  }
}

class KeyPadItem {
  int? order;
  String? displayText;
  String? value;
  KeyPadItemType? type;

  KeyPadItem({this.order, this.value, this.type, this.displayText});
}

enum KeyPadItemType { normal, clear, backspace, submit }
