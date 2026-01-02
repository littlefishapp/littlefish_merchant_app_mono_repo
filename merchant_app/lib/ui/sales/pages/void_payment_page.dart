// Flutter imports:
import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core/auth/services/auth_service.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/features/pos/data/data_source/pos_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/enums.dart';

// Project imports:
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/models/settings/payments/payment_type.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_actions.dart';
import 'package:littlefish_merchant/redux/sales/sales_actions.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/business/expenses/widgets/payment_methods_list.dart';
import 'package:littlefish_merchant/ui/customers/widgets/customer_select_tile.dart';
import 'package:littlefish_merchant/ui/sales/pages/void_complete_page.dart';
import 'package:littlefish_merchant/ui/sales/view_models.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/providers/locale_provider.dart';

import '../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../common/presentaion/components/app_progress_indicator.dart';
import '../../../common/presentaion/components/buttons/button_primary.dart';
import '../../../common/presentaion/components/decorated_text.dart';
import '../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../../../features/pos/presentation/pages/card_payment.dart';
import '../../../models/sales/checkout/checkout_refund.dart';

class VoidPaymentMethodPage extends StatefulWidget {
  static const String route = 'sales/void/payment_page';

  final bool isEmbedded;
  final CheckoutTransaction transaction;

  const VoidPaymentMethodPage({
    Key? key,
    required this.transaction,
    this.isEmbedded = false,
  }) : super(key: key);

  @override
  State<VoidPaymentMethodPage> createState() => _VoidPaymentMethodPageState();
}

class _VoidPaymentMethodPageState extends State<VoidPaymentMethodPage> {
  late String _textValue;
  PaymentType? _paymentType;

  final PosService _paymentService = PosService.fromStore(
    store: AppVariables.store,
  );

  late CheckoutTransaction _transaction;

  @override
  void initState() {
    _textValue = widget.transaction.checkoutTotal.toString();
    _transaction = widget.transaction;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SalesVM>(
      converter: (store) => SalesVM.fromStore(store),
      builder: (ctx, vm) {
        return layout(ctx, vm);
      },
    );
  }

  Widget layout(ctx, SalesVM vm) {
    return AppScaffold(
      title: 'Void Sale',
      body: vm.isLoading!
          ? Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: AppProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.background,
                hasScaffold: false,
              ),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox(height: 32),
                  //Amount details
                  amountText(context),
                  const SizedBox(height: 16),
                  customerSection(context, vm),
                  const SizedBox(height: 16),
                  paymentMethodsHeading(context),
                  const SizedBox(height: 16),
                  PaymentMethodsList(
                    initialType: _transaction.paymentType,
                    paymentTypes: vm.voidPaymentTypes,
                    onTap: (context, type) {
                      if (mounted) {
                        setState(() {
                          _paymentType = type;
                          _transaction.paymentType = _paymentType;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
      persistentFooterButtons: [confirmVoidButton(context, vm)],
    );
  }

  confirmVoidButton(BuildContext context, SalesVM vm) => Container(
    height: 56,
    padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
    child: ButtonPrimary(
      upperCase: true,
      text: 'Confirm Void',
      onTap: (context) async {
        makeVoid(context, vm);
      },
    ),
  );

  amountText(BuildContext context) {
    var amountDisplayText = TextFormatter.toStringCurrency(
      double.tryParse(_textValue),
      displayCurrency: false,
    );
    var chargeText = Flexible(
      fit: FlexFit.loose,
      child: SizedBox(
        height: 110,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //amount heading
            Container(
              child: context.paragraphMedium(
                'AMOUNT',
                color: Theme.of(context).colorScheme.primary,
                isBold: true,
              ),
            ),
            const SizedBox(height: 16),
            //amount
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DecoratedText(
                    LocaleProvider.instance.currencyCode,
                    alignment: Alignment.center,
                    fontWeight: FontWeight.w700,
                    fontSize: 32.0,
                    textColor: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  context.headingLarge(
                    amountDisplayText,
                    color: Theme.of(context).colorScheme.secondary,
                    isSemiBold: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return chargeText;
  }

  Widget paymentMethodsHeading(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: context.headingXSmall(
        'Void Payment Method',
        color: Theme.of(context).extension<AppliedTextIcon>()?.emphasized,
        isBold: true,
      ),
    );
  }

  Widget customerSection(BuildContext context, SalesVM vm) {
    return Column(
      children: [
        //Customers
        customerHeading(context),
        const SizedBox(height: 16),
        //Customers button
        SelectCustomerTile(
          customer: vm.customer,
          onClearCustomer: () {
            vm.store?.dispatch(SalesRemoveCustomerAction());
          },
          onSetCustomer: (ctx, customer) {
            vm.setCustomer(customer);
          },
          key: widget.key,
        ),
      ],
    );
  }

  Widget customerHeading(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: context.headingXSmall(
              'Customer',
              color: Theme.of(context).extension<AppliedTextIcon>()?.emphasized,
              isBold: true,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            alignment: Alignment.bottomCenter,
            child: context.labelSmall(
              '(Required)',
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  makeVoid(context, SalesVM vm) async {
    double textValueDouble = double.parse(_textValue);

    if (textValueDouble <= 0) {
      showMessageDialog(
        context,
        'Please enter the amount to be voided.',
        LittleFishIcons.info,
      );
      return;
    }

    if ((_paymentType ?? _transaction.paymentType) == null) {
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

    if (_transaction.paymentType!.name!.toLowerCase() == 'card') {
      vm.store?.dispatch(SetSalesLoadingStateAction(true));

      try {
        if (vm.canDoCardPayment()) {
          await showPopupDialog(
            context: context,
            content: CardPayment(
              transaction: _transaction,
              amount: Decimal.parse(_transaction.checkoutTotal.toString()),
              refund: Refund(
                checkoutTransactionId: _transaction.id ?? '',
                totalRefund: _transaction.checkoutTotal,
              ),
              backButtonTimeout: 30,
              paymentType: CardTransactionType.voided,
              cashBackAmount: Decimal.zero,
              parentContext: context,
              canPrint: platformType == PlatformType.pos,
              transactionIsSaving: vm.state?.isLoading ?? false,
              saveSale: (result) {
                processResult(
                  vm: vm,
                  result: true,
                  context: context,
                  goToCompletePage: AppVariables.isMobile ? true : false,
                  //NB! previous logic below would never be true, as we do not do my pin pad builds or setup the payment provider, as such this is not valid.
                  // cardPaymentRegistered == CardPaymentRegistered.myPinPad,
                );
              },
            ),
          );
        } else {
          processResult(result: true, context: context, vm: vm);
        }
      } catch (e) {
        vm.store?.dispatch(SetSalesLoadingStateAction(false));

        showErrorDialog(context, e);
      } finally {
        vm.store?.dispatch(SetSalesLoadingStateAction(false));
      }
    } else {
      processResult(result: true, context: context, vm: vm);
    }
  }

  processResult({
    required result,
    required BuildContext context,
    required SalesVM vm,
    Completer? completer,
    bool goToCompletePage = true,
  }) async {
    if (result!) {
      _transaction.status = 'cancelled';
      _transaction.paymentType!.paid = true;
      Completer? complete = Completer();
      StoreProvider.of<AppState>(
        context,
      ).dispatch(cancelSale(context, _transaction, completer: complete));

      await complete.future.then(
        (val) => posVoidGoToCompleteScreenFunction(
          context,
          vm,
          goToCompletePage: goToCompletePage,
        ),
      );
    }
  }

  void posVoidGoToCompleteScreenFunction(
    BuildContext context,
    SalesVM vm, {
    bool goToCompletePage = true,
  }) {
    vm.store!.dispatch(getInitialTransactions(forceRefresh: true));
    if (goToCompletePage) {
      Navigator.of(context).pushNamed(
        VoidCompletePage.route,
        arguments: {'transaction': _transaction, 'customer': vm.customer},
      );
    }
  }
}
