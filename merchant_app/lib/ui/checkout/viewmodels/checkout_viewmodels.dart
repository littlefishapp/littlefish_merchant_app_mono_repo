// Flutter imports:
import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/features/pos/data/data_source/pos_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/tools/helpers/product_variant_helper.dart';
import 'package:littlefish_payments/gateways/softpos_payment_gateway.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/sales/checkout/checkout_tip.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_actions.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_discount.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/models/sales/tickets/ticket.dart';
import 'package:littlefish_merchant/models/settings/accounts/linked_account.dart';
import 'package:littlefish_merchant/models/settings/payments/payment_type.dart';
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/models/stock/single_option_attribute.dart';
import 'package:littlefish_merchant/models/stock/stock_variance.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_state.dart';
import 'package:littlefish_merchant/redux/customer/customer_actions.dart';
import 'package:littlefish_merchant/redux/product/product_state.dart';
import 'package:littlefish_merchant/ui/products/discounts/pages/discount_select_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

import 'package:littlefish_merchant/redux/checkout/checkout_actions.dart'
    as checkout;

import '../../../common/presentaion/components/custom_keypad.dart';
import '../../../models/device/interfaces/device_details.dart';
import '../../../models/enums.dart';

class CheckoutVM
    extends StoreCollectionViewModel<CheckoutCartItem, CheckoutState> {
  CheckoutVM.fromStore(Store<AppState> store) : super.fromStore(store);

  late Function onClear;
  late Function onRemoveItems;

  late PosService _paymentService;

  bool? get allowTickets => store?.state.appSettingsState.allowTickets;

  bool canDoCardPayment() {
    return _paymentService.canDoCardPayment();
  }

  bool noCardPaymentProvider() {
    bool isNotPosBuild = !AppVariables.isPOSBuild;
    bool noSoftPosGatewayRegistered = !getIt
        .isRegistered<SoftPOSPaymentGateway>();
    return isNotPosBuild && noSoftPosGatewayRegistered;
  }

  late Function(
    StockProduct product,
    StockVariance? variance,
    double? quantity,
    BuildContext ctx,
    bool onlyAddOneIfNotInCart,
  )
  addToCart;

  late Function(Decimal amount, String description) addCustomSaleToCart;

  late Function(Decimal amount, String description)
  reduceCustomSaleQuantityInCart;

  late Function(List<CheckoutCartItem>? items) addItemsToCart;

  late Function(CheckoutCartItem item) updateItemQuantityInCart;

  late Function(Decimal? value) setAmountTendered;

  late Function(Customer? customer) setCustomer;
  late Function(Ticket ticket) setTicket;

  late Function(PaymentType paymentType) setPaymentType;
  late Function() clearPaymentType;

  late Function(Decimal amount) onSetCustomAmount;

  late Function(CheckoutTransaction amount) onSetTransaction;

  late Function(String description) onSetDescription;

  late Future<StockProduct?> Function(
    StockProduct parentProduct,
    List<SingleOptionAttribute> selectedOptionAttributes,
  )
  getProductVariant;

  late void Function() clearSelectedVariant;

  late bool Function(
    List<ProductOptionAttribute> availableOptionAttributes,
    List<SingleOptionAttribute> selectedOptionAttributes,
  )
  hasSelectedAnAttributeForEachOption;

  late Function(
    BuildContext ctx, {
    bool goToCompletePage,
    CheckoutTransaction? transaction,
    dynamic paymentInformation,
    String destinationTerminalId,
  })
  pushSale;

  late Function(int index) setKeyPadIndex;

  late Function(BuildContext ctx) selectDiscount;

  CheckoutDiscount? discount;

  Customer? customer;

  CheckoutTransaction? currentTransaction;

  double? itemCount;

  int? keypadIndex;

  Decimal? totalValue;

  late bool discountsAllowed;

  Ticket? ticket;

  Decimal? customAmount;

  Decimal? currentCheckoutActionAmount;

  Decimal? cashbackAmount;

  Decimal? withdrawalAmount;

  Decimal? discountAmount;
  Decimal? tipAmount;

  Decimal? totalSaving;

  Decimal? totalSalesTax;

  bool? isCartDiscountApplied;

  bool? isCashbackApplied;

  bool? isWithdrawApplied;

  bool? isTipApplied;

  CheckoutTip? tip;

  ProductState? productState;

  late List<PaymentType> paymentTypes;

  late List<PaymentType> refundPaymentTypes;

  late List<PaymentType> withdrawalPaymentTypes;

  PaymentType? paymentType;

  int? paymentTypeIndex;

  Decimal? amountTendered;

  Decimal? amountShort, amountChange;

  Decimal? checkoutTotal;
  Decimal? totalBeforeTip;

  int? discountTabIndex, tipTabIndex;

  late bool isShort;

  List<LinkedAccount>? linkedAccounts = [];

  StockCategory? _selectedCategory;

  late SortBy sortBy;
  late SortOrder sortOrder;

  StockCategory? get selectedCategory {
    return _selectedCategory;
  }

  set selectedCategory(value) {
    if (_selectedCategory != value) {
      _selectedCategory = value;
      // store.dispatch(SetUserPreference("checkout-ui-vm", this));
    }
  }

  String? customSaleDescription;

  DeviceDetails? deviceDetails;

  late Map<String, List<StockProduct>> productVariants;

  StockProduct? productVariant;

  late bool productVariantIsLoading;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.checkoutState;
    customAmount = state!.customAmount ?? Decimal.zero;
    customSaleDescription = state!.customDescription;
    linkedAccounts = store.state.businessState.enabledLinkedAccounts;
    ticket = state?.ticket;
    //if a discount was provided, it should be present here
    discount = state!.discount;
    discountAmount = state!.discountAmount;
    discountTabIndex = state!.discountTabIndex;
    tipTabIndex = state!.tipTabIndex;
    checkoutTotal = state!.checkoutTotal;
    totalBeforeTip = state!.totalBeforeTip;
    currentCheckoutActionAmount = state!.currentCheckoutActionAmount;
    cashbackAmount = state!.cashbackAmount;
    withdrawalAmount = state!.withdrawalAmount;
    tipAmount = state!.tipAmount;
    tip = state!.tip;
    discountsAllowed =
        (store.state.permissions?.giveDiscounts ?? false) &&
        store.state.enableDiscounts == true;
    isCartDiscountApplied =
        discountsAllowed && isGreaterThanZero(discount?.value);
    isCashbackApplied =
        (store.state.enableCashback ?? false) &&
        isNotZeroOrNullDecimal(cashbackAmount);
    isWithdrawApplied =
        (store.state.enableWithdrawal ?? false) &&
        isNotZeroOrNullDecimal(withdrawalAmount);
    isTipApplied =
        (store.state.enableTips ?? false) && isNotZeroOrNullDecimal(tipAmount);
    onSetTransaction = (input) => currentTransaction = input;

    selectDiscount = (ctx) {
      if (discount != null) {
        //we need to reset the current discount
        store.dispatch(checkout.CheckoutSetDiscountAction(null));
      }

      var page = const DiscountSelectPage(isEmbedded: true);

      showPopupDialog(
        content: page,
        context: ctx,
        borderDismissable: true,
      ).then((discount) {
        if (discount != null) {
          store.dispatch(checkout.CheckoutSetDiscountAction(discount));
        }
      });
    };

    _paymentService = PosService.fromStore(store: store);

    keypadIndex = state!.keypadIndex ?? 0;
    sortBy = state!.sortBy ?? SortBy.createdDate;
    sortOrder = state!.sortOrder ?? SortOrder.ascending;
    items = state!.items;
    isLoading = state!.isLoading ?? false;
    hasError = state!.hasError ?? false;
    productState = store.state.productState;
    itemCount = state!.itemCount.toDouble();
    totalValue = state!.totalValue;
    totalSaving = state!.totalSaving;
    totalSalesTax = state!.totalSalesTax;
    paymentTypes = store.state.appSettingsState.checkoutPaymentTypes;
    refundPaymentTypes = store.state.appSettingsState.quickRefundPaymentTypes;
    withdrawalPaymentTypes =
        store.state.appSettingsState.withdrawalPaymentTypes;
    paymentType = state!.paymentType;
    paymentTypeIndex = state?.paymentType?.displayIndex;
    amountTendered = state!.amountTendered;
    amountShort = state!.amountShort;
    amountChange = state!.amountChange;
    isShort = state!.isShort;
    customer = state!.customer;
    productVariants = productState?.productVariants ?? {};

    onClear = () => store.dispatch(CheckoutClearAction(null));
    onRemoveItems = () => store.dispatch(CheckoutRemoveItemsAction());

    setKeyPadIndex = (index) {
      keypadIndex = index;
      store.dispatch(checkout.CheckoutSetKeyPadIndexAction(keypadIndex));
    };

    addToCart = (product, variance, qty, ctx, onlyAddOneIfNotInCart) async {
      double? finalAmount;

      if (product.isVariable) {
        final amount = await showModalBottomSheet<double>(
          context: ctx,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          builder: (ctx2) => SizedBox(
            height: MediaQuery.of(ctx).size.height * 2 / 3,
            child: CustomKeyPad(
              isLoading: isLoading,
              enableAppBar: false,
              title: 'Amount',
              enableChange: false,
              minChargeAmount: 0,
              confirmButtonText: 'Confirm Amount',
              confirmErrorMessage:
                  'Please enter the cash amount to be paid by the customer.',
              onValueChanged: (_) {},
              onDescriptionChanged: (_) {},
              onSubmit: (double value, String? _) {
                Navigator.of(ctx2).pop(value);
              },
              initialValue: 0,
              parentContext: ctx2,
            ),
          ),
        );

        if (amount != null && amount > 0) {
          finalAmount = amount;

          store.dispatch(
            checkout.addProductToCart(
              product: product,
              variance: variance,
              quantity: qty ?? 1.0,
              variableAmount: amount,
              onlyAddOneIfNotInCart: onlyAddOneIfNotInCart,
            ),
          );
        }
      } else {
        store.dispatch(
          checkout.addProductToCart(
            product: product,
            variance: variance,
            quantity: qty ?? 1.0,
            onlyAddOneIfNotInCart: onlyAddOneIfNotInCart,
          ),
        );
      }

      return finalAmount;
    };

    getProductVariant = (parentProduct, selectedOptionAttributes) async {
      if (productState == null || productState!.products == null) return null;

      try {
        Completer<StockProduct> completer = Completer<StockProduct>();
        store.dispatch(
          selectAndFetchProductVariant(
            parentProduct: parentProduct,
            selectedAttributes: selectedOptionAttributes,
            completer: completer,
          ),
        );

        StockProduct variant = await completer.future;
        return variant;
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        return null;
      }
    };

    hasSelectedAnAttributeForEachOption =
        (
          List<ProductOptionAttribute> availableOptionAttributes,
          List<SingleOptionAttribute> selectedOptionAttributes,
        ) {
          return ProductVariantHelper.hasSelectedAnAttributeForEachOption(
            availableOptionAttributes: availableOptionAttributes,
            selectedOptionAttributes: selectedOptionAttributes,
          );
        };

    clearSelectedVariant = () {
      store.dispatch(const ClearCheckoutProductVariantAction());
    };

    productVariant = state?.productVariant;

    productVariantIsLoading = state?.productVariantIsLoading ?? false;

    onSetCustomAmount = (value) {
      customAmount = value;
      store.dispatch(checkout.CheckoutSetCustomAmount(value));
    };

    onSetDescription = (value) {
      customSaleDescription = value;
      store.dispatch(checkout.CheckoutSetCustomDescription(value));
    };

    setAmountTendered = (value) => store.dispatch(
      CheckoutTypeSetAmountTenderedAction(value ?? Decimal.zero),
    );

    setCustomer = (value) => store.dispatch(CheckoutSetCustomerAction(value));

    setTicket = (value) => store.dispatch(CheckoutSetTicketAction(value));

    addCustomSaleToCart = (amount, desc) =>
        store.dispatch(CheckoutAddCustomSaleAction(amount, desc));

    reduceCustomSaleQuantityInCart = (amount, desc) =>
        store.dispatch(CheckoutReduceCustomSaleQuantityAction(amount, desc));

    addItemsToCart = (items) {
      store.dispatch(CheckoutAddItemsToCart(items));
    };

    setPaymentType = (value) =>
        store.dispatch(CheckoutSetPaymentTypeAction(value));

    clearPaymentType = () => store.dispatch(ClearPaymentTypeAction());

    pushSale =
        (
          ctx, {
          bool goToCompletePage = true,
          transaction,
          paymentInformation,
          destinationTerminalId = '',
        }) {
          state!.ticket;
          store.dispatch(
            checkout.pushSale(
              ctx,
              completer: actionCompleter(ctx, () {}),
              currentTransaction: transaction ?? currentTransaction,
              ticket: state?.ticket,
              customer: customer,
              goToCompletePage: goToCompletePage,
              destinationTerminalId: destinationTerminalId,
            ),
          );
        };

    deviceDetails = store.state.deviceState.deviceDetails;

    onRemove = (item, ctx) => store.dispatch(CheckoutRemoveItemAction(item));
    onAdd = (item, ctx) => store.dispatch(checkout.addItemToCart(item: item));
  }

  payCustomerCredit(Customer customer, double value, BuildContext context) {
    store!.dispatch(
      payCustomerStoreCreditAmount(
        item: customer,
        value: value,
        completer: snackBarCompleter(context, 'Success', shouldPop: true),
      ),
    );
  }

  void clearRefund() => store!.dispatch(const ClearRefund());

  void createQuickRefund() => store!.dispatch(
    CreateQuickRefund(
      store!.state.userProfile?.userId ?? '',
      store!.state.userProfile?.name ?? '',
      store!.state.businessId ?? '',
    ),
  );

  void setQuickRefundAmount(Decimal? value) =>
      store!.dispatch(SetQuickRefundAmount(value));

  void setQuickRefundDescription(String? value) =>
      store!.dispatch(SetQuickRefundDescription(value));

  void setQuickRefundCustomer(Customer? customer) {
    setCustomer(customer);
    store!.dispatch(SetQuickRefundCustomer(customer));
  }
}
