// Dart imports:
// remove ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core_utils/error/models/error_codes/transaction_error_codes.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/features/sell/domain/helpers/transaction_result_mapper.dart';
import 'package:littlefish_merchant/models/stock/single_option_attribute.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_merchant/tools/helpers/product_variant_helper.dart';
import 'package:littlefish_merchant/ui/business/expenses/pages/refund_page.dart';
import 'package:littlefish_merchant/ui/business/expenses/refund_utilities.dart';
import 'package:littlefish_merchant/ui/sales/pages/void_payment_page.dart';
import 'package:littlefish_payments/managers/terminal_manager.dart';
import 'package:quiver/strings.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_tip.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/online_store/shared/routes/custom_route.dart';
import 'package:littlefish_merchant/ui/sales/pages/refund_complete_page.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/products/product_combo.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_discount.dart'
    as checkout_discount;
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/models/sales/tickets/ticket.dart';
import 'package:littlefish_merchant/models/settings/payments/payment_type.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/models/stock/stock_variance.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/customer/customer_actions.dart';
import 'package:littlefish_merchant/redux/sales/sales_actions.dart';
import 'package:littlefish_merchant/redux/tickets/ticket_actions.dart';
import 'package:littlefish_merchant/services/checkout_service.dart';
import 'package:littlefish_merchant/services/customer_service.dart';
import 'package:littlefish_merchant/stores/stores.dart';
import 'package:littlefish_merchant/tools/exceptions/common_exceptions.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_complete_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import '../../models/sales/checkout/checkout_refund.dart';

late CheckoutService checkoutService;

LittleFishCore core = LittleFishCore.instance;

LoggerService get logger => LittleFishCore.instance.get<LoggerService>();

ThunkAction<AppState> addItemToCart({required CheckoutCartItem item}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(CheckoutAddItemToCart(item));

      //we need to kick-off another async function which would manage the store after the fact on the items in question
      store.dispatch(createCartCombos());
    });
  };
}

ThunkAction<AppState> addProductToCart({
  required StockProduct product,
  required StockVariance? variance,
  double quantity = 1,
  double variableAmount = 0.0,
  bool onlyAddOneIfNotInCart = true,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);
      store.dispatch(
        CheckoutAddProductAction(
          product,
          quantity,
          variance,
          variableAmount: variableAmount,
          onlyAddOneIfNotInCart: onlyAddOneIfNotInCart,
        ),
      );
      if (AppVariables.store!.state.environmentSettings!.enableCheckoutV2 ==
          false) {
        store.dispatch(createCartCombos());
      }
    });
  };
}

ThunkAction<AppState> cancelSale(
  BuildContext context,
  CheckoutTransaction? sale, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(SetSalesLoadingStateAction(true));

      completer?.complete();
      try {
        var result = await checkoutService.cancelSale(sale!.id);
        store.dispatch(SetSalesLoadingStateAction(false));

        if (result != null) {
          store.dispatch(CheckoutSaleCancelledAction(result));
          store.dispatch(CheckoutCancelledSale(result));

          if (isNotBlank(sale.customerId) &&
              sale.paymentType!.name!.toLowerCase() == 'credit') {
            var customer = store.state.customerstate.customers!
                .firstWhereOrNull((element) => element.id == sale.customerId);

            if (customer != null) {
              var entry = customer.customerLedgerEntries!.firstWhereOrNull(
                (element) => element.transactionId == sale.id,
              );

              if (entry != null) {
                store.dispatch(
                  cancelPayCustomerStoreCreditAmount(
                    entry: entry,
                    item: customer,
                    sendToServer: false,
                  ),
                );
              }
            }
          }
        }
      } catch (e) {
        store.dispatch(SetSalesLoadingStateAction(false));

        completer?.completeError(e, StackTrace.current);
      }
    });
  };
}

ThunkAction<AppState> createCartCombos() {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      var productState = store.state.productState;
      if (productState.productCombos == null ||
          productState.productCombos!.isEmpty) {
        return;
      }

      var checkoutState = store.state.checkoutState;
      var combos = productState.productCombos!
          .where((c) => c.enabled!)
          .map(
            (ec) => {
              'id': ec.id,
              'items': ec.items!
                  .map(
                    (i) => {
                      'quantity': i.quantity,
                      'productId': i.productId,
                      'varianceId': i.varianceId,
                    },
                  )
                  .toList(),
            },
          )
          .toList();

      //we only take items that are linked to products
      var cart = checkoutState.items!
          .where((p) => p.productId != null)
          .map(
            (i) => {
              'id': i.id,
              'productId': i.productId,
              'varianceId': i.varianceId,
              'quantity': i.quantity,
            },
          )
          .toList();

      for (var c in combos) {
        if ((c['items'] as List).every(
          (ci) => cart.any(
            (i) =>
                i['productId'] == ci['productId'] &&
                (i['quantity'] as double) >= (ci['quantity'] as double),
          ),
        )) {
          var items = [];
          var combos = <ProductCombo?>[];

          for (var ci in (c['items'] as List)) {
            var item = cart.firstWhere(
              (i) =>
                  i['productId'] == ci['productId'] &&
                  (i['quantity'] as double) >= (ci['quantity'] as double),
            );

            items.add(item);
          }

          var combo = productState.getComboById(c['id'] as String?);
          //here we need to push to the next steps
          while (items.isNotEmpty) {
            if (combo!.items!.every(
              (c) => items.any(
                (ci) =>
                    c.productId == ci['productId'] &&
                    c.quantity! <= ci['quantity'],
              ),
            )) {
              combos.add(combo);

              for (var c in combo.items!) {
                for (var ci in items) {
                  if (ci['productId'] == c.productId) {
                    ci['quantity'] -= c.quantity;
                  }
                }
              }
            } else {
              break;
            }
          }

          if (combos.isEmpty) continue;

          var cartItems =
              List<CheckoutCartItem>.from(
                  checkoutState.items!,
                ).where((ci) => items.any((i) => i['id'] == ci.id)).toList()
                ..forEach((ni) {
                  ni.quantity = items.firstWhere(
                    (i) => i['id'] == ni.id,
                  )['quantity'];
                });

          store.dispatch(CheckoutAddCombos(combos, cartItems));

          //now we need to submit to store, to update the shopping cart...
        }
      }

      // i["varianceId"] == ci["varianceId"]
    });
  };
}

//ToDo: add a function for setting cart item quantities

ThunkAction<AppState> pushSale(
  BuildContext context, {
  Completer? completer,
  CheckoutTransaction? currentTransaction,
  Ticket? ticket,
  Customer? customer,
  bool goToCompletePage = true,
  bool isTerminalSale = true,
  String destinationTerminalId = '',
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(CheckoutSetLoadingAction(true));

      var deviceId =
          currentTransaction?.deviceId ??
          store.state.deviceState.deviceDetails?.deviceId ??
          '';

      late CheckoutTransaction transactionToUse;
      if (currentTransaction == null) {
        transactionToUse = checkoutService.buildCheckoutTransactionFromState(
          state: store.state.checkoutState,
          pendingSync: false,
          deviceId: deviceId,
        );
      } else {
        transactionToUse = currentTransaction;
      }
      logger.debug('checkout-actions', '###1 checkoutactions pushSale');
      const pendingSync = true;

      try {
        final checkOutTransactionReturned = await checkoutService.pushSale(
          store.state.checkoutState,
          currentTransaction: transactionToUse,
          deviceId: deviceId,
          pushToServer: pendingSync,
        );

        await onSuccessPushSale(
          completer: completer,
          checkOutTransaction: checkOutTransactionReturned,
          store: store,
          ticket: ticket,
          goToCompletePage: goToCompletePage,
          context: context,
          customer: customer,
          destinationTerminalId: destinationTerminalId,
        );
      } catch (e) {
        await onErrorPushSale(
          completer: completer,
          checkOutTransaction: transactionToUse,
          store: store,
          ticket: ticket,
          goToCompletePage: goToCompletePage,
          context: context,
          customer: customer,
          error: e,
          pendingSync: pendingSync,
          destinationTerminalId: destinationTerminalId,
        );
      }
    });
  };
}

Future<void> onErrorPushSale({
  Completer<dynamic>? completer,
  required CheckoutTransaction checkOutTransaction,
  required Store<AppState> store,
  Ticket? ticket,
  required bool goToCompletePage,
  required BuildContext context,
  Customer? customer,
  error,
  required bool pendingSync,
  String destinationTerminalId = '',
}) async {
  if (error is ManagedException &&
      error.name != null &&
      error.name!.isNotEmpty) {
    if (error.name!.contains('connection') && pendingSync) {
      logger.error(
        'onErrorPushSale',
        'An error occurred, whilst saving payment transaction, message: ${error.message}',
        error: error,
        stackTrace: StackTrace.current,
      );

      // TODO(lampian): handle sales update on error

      await updateSaleSyncStatus(
        context,
        pendingSync: pendingSync,
        currentTransaction: checkOutTransaction,
        completer: null,
      );
      await onSuccessPushSale(
        completer: completer,
        checkOutTransaction: checkOutTransaction,
        store: store,
        ticket: ticket,
        goToCompletePage: true,
        context: context,
      );
    }
  } else {
    store.dispatch(CheckoutClearAction(null));
    store.dispatch(CheckoutSetLoadingAction(false));
    completer?.completeError(error, StackTrace.current);
    logger.error(
      'onErrorPushSale',
      'An error occurred',
      error: error,
      stackTrace: StackTrace.current,
    );
  }
}

Future<void> onSuccessPushSale({
  Completer<dynamic>? completer,
  required CheckoutTransaction checkOutTransaction,
  required Store<AppState> store,
  Ticket? ticket,
  required bool goToCompletePage,
  required BuildContext context,
  Customer? customer,
  String destinationTerminalId = '',
}) async {
  completer?.complete();

  if (checkOutTransaction.paymentType!.name!.toLowerCase() == 'credit') {
    var cust = store.state.checkoutState.customer!;
    var custService = CustomerService(
      store: store,
      baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
      token: store.state.authState.token,
      businessId: store.state.currentBusinessId,
    );

    var res = await custService.getCustomerById(cust.id);

    store.dispatch(CustomerChangedAction(res, ChangeType.updated));
  }

  store.dispatch(CheckoutPushSaleCompletedAction(true, checkOutTransaction));

  if (checkOutTransaction.ticketId != null && ticket != null) {
    ticket.completed = true;
    ticket.transactionId = checkOutTransaction.id;
    ticket.transactionDate = checkOutTransaction.transactionDate;

    store.dispatch(editTicket(ticket: ticket));
  }

  if (destinationTerminalId.isNotEmpty) {
    final json = checkOutTransaction.toJson();
    final encoded = jsonEncode(json);
    final b64 = base64.encode(encoded.codeUnits);
    final TerminalManager terminalManager = TerminalManager();
    terminalManager.updateSalesTranasaction(
      destinationTerminalId: destinationTerminalId,
      b64Transaction: b64,
    );
  }

  if (goToCompletePage) {
    if (store.state.isLargeDisplay ?? false) {
      showPopupDialog(
        context: context,
        content: CheckoutCompletePage(
          item: checkOutTransaction,
          customer: customer,
          isWithdrawal: isNotZeroOrNull(checkOutTransaction.withdrawalAmount),
        ),
      ).then((_) => store.dispatch(CheckoutSetLoadingAction(false)));
      return;
    }

    if ((checkOutTransaction.totalRefund ?? 0) > 0) {
      store.dispatch(CheckoutSetLoadingAction(false));
      Navigator.pushReplacement(
        context,
        CustomRoute(
          builder: (BuildContext ctx) => RefundCompletePage(
            item: checkOutTransaction.refunds![0],
            customer: customer,
          ),
        ),
      ); //.then((_) => store.dispatch(CheckoutSetLoadingAction(false)));
      return;
    }

    await Navigator.pushNamedAndRemoveUntil(
      globalNavigatorKey.currentContext!,
      CheckoutCompletePage.route,
      (route) => false,
      arguments: {
        'transaction': checkOutTransaction,
        'customer': customer,
        'isWithdrawal': isNotZeroOrNull(checkOutTransaction.withdrawalAmount),
      },
    ).then((_) => store.dispatch(CheckoutSetLoadingAction(false)));
  }
}

ThunkAction<AppState> syncSales({Completer? completer}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        SalesStore salesStore = SalesStore();
        await salesStore.getTransactionCount();

        _initializeService(store);

        logger.debug('SyncSales', 'Sync Sales Invoked');

        var pendingCount = await salesStore.getPendingTransactionCount();

        //nothing to send to the server at this time
        if (pendingCount <= 0) {
          completer?.complete();
          return;
        }

        List<String?> exclusions = [];

        //here we send until there is nothing left to send
        var batch = await salesStore.getPendingTransactionBatch(
          exclusions: exclusions,
        );

        if (!store.state.hasInternet!) {
          completer?.completeError(
            ManagedException(message: 'No Internet Access'),
          );
          return;
        }

        if (batch.isNotEmpty) {
          for (var sale in batch) {
            try {
              final result = await checkoutService.uploadSale(sale);
              salesStore.updateTransaction(result);
              logger.debug(
                'checkout-actions',
                '###1 checkoutactions syncSales upDateTransaction',
              );

              store.dispatch(SaleUploadedAction(result));
            } catch (error) {
              logger.error(
                'syncSales_transaction',
                'An error occurred, whilst pushing sale of value: ${sale.totalValue}',
                error: error,
                stackTrace: StackTrace.current,
              );
            }
          }
        }

        pendingCount = await salesStore.getPendingTransactionCount(
          exclusions: exclusions,
        );

        logger.debug(
          'checkout-actions',
          '###1 checkoutactions syncSales SalesStore exit pending $pendingCount',
        );
        if (completer != null && !completer.isCompleted) {
          completer.complete();
        }
      } catch (e) {
        if (completer != null && !completer.isCompleted) {
          completer.completeError(e);
        }

        logger.error(
          'syncSales',
          'An error occurred during sync sales',
          error: e,
          stackTrace: StackTrace.current,
        );
      }
    });
  };
}

Future<void> updateSaleSyncStatus(
  BuildContext context, {
  required bool pendingSync,
  Completer? completer,
  CheckoutTransaction? currentTransaction,
  Ticket? ticket,
  Customer? customer,
  bool goToCompletePage = true,
}) async {
  SalesStore salesStore = SalesStore();
  if (currentTransaction != null) {
    currentTransaction.pendingSync = pendingSync;
    await salesStore.updateTransaction(currentTransaction);
    logger.debug(
      'checkout-actions',
      '### checkoutactions updateSaleSyncStatus $pendingSync',
    );
  }
  completer?.complete();
}

ThunkAction<AppState> initiateSaleReturnJourneyAction(
  BuildContext context,
  CheckoutTransaction transaction, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        _initializeService(store);
        store.dispatch(SetSalesLoadingStateAction(true));

        final itemInfoList = await fetchAllData(
          store: store,
          transaction: transaction,
        );

        store.dispatch(initialiseCurrentRefund(transaction: transaction));

        if (transaction.customerId != null) {
          store.dispatch(
            getAndSetCustomerByID(customerId: transaction.customerId!),
          );
        }

        if (itemInfoList.length != transaction.itemCount) {
          throw Exception('Failed fetching transaction information.');
        }

        if (context.mounted) {
          Navigator.push(
            context,
            CustomRoute(
              builder: (BuildContext ctx) => RefundPage(
                transaction: transaction,
                itemInfoList: itemInfoList,
              ),
            ),
          );
        }

        store.dispatch(SetSalesLoadingStateAction(false));
        completer?.complete();
      } catch (e) {
        store.dispatch(SetSalesLoadingStateAction(false));
        if (context.mounted) {
          showErrorDialog(
            context,
            TransactionErrorCodes.failedFetchingTransactionInformation,
          );
        }
        completer?.completeError(e);
      }
    });
  };
}

ThunkAction<AppState> initiateVoidSaleJourneyAction(
  BuildContext context,
  CheckoutTransaction transaction, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        _initializeService(store);
        store.dispatch(SetSalesLoadingStateAction(true));

        if (transaction.customerId != null) {
          Customer? customer = store.state.customerstate.getCustomerById(
            id: transaction.customerId!,
          );
          if (customer != null) {
            store.dispatch(SalesSetCustomerAction(customer));
            store.dispatch(
              setRefundCustomerInfo(
                customerId: customer.id!,
                customerEmail: customer.email ?? '',
                customerMobile: customer.mobileNumber ?? '',
                customerName: customer.displayName ?? '',
              ),
            );
          }
        } else {
          store.dispatch(SalesClearCustomerAction());
          store.dispatch(ClearRefundStateAction());
        }

        Navigator.of(context).push(
          CustomRoute(
            builder: (BuildContext context) =>
                (VoidPaymentMethodPage(transaction: transaction)),
          ),
        );

        store.dispatch(SetSalesLoadingStateAction(false));
        completer?.complete();
      } catch (e) {
        store.dispatch(SetSalesLoadingStateAction(false));
        if (context.mounted) {
          showErrorDialog(context, TransactionErrorCodes.failedToInitiateVoid);
        }
        completer?.completeError(e);
      }
    });
  };
}

ThunkAction<AppState> refundSale(
  BuildContext context,
  Refund refund, {
  Completer? completer,
  dynamic paymentInformation,
  bool goToRefundCompletePage = true,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(SetSalesLoadingStateAction(true));

      try {
        refund = TransactionResultMapper.setRefundData(
          trx: refund,
          resultMap: paymentInformation,
          deviceDetails: store.state.deviceState.deviceDetails,
        );

        //NB!!! Data integrity matters, defaults should always be set no matter what.
        refund.businessId = (refund.businessId ?? '').isEmpty
            ? store.state.currentBusinessId
            : refund.businessId;
        refund.updatedBy = (refund.updatedBy ?? '').isEmpty
            ? store.state.authState.userId
            : refund.updatedBy;
        refund.createdBy = (refund.createdBy ?? '').isEmpty
            ? store.state.authState.userId
            : refund.createdBy;
        refund.dateCreated = refund.dateCreated ?? DateTime.now().toUtc();
        refund.dateUpdated = refund.dateCreated ?? DateTime.now().toUtc();
        refund.deleted = refund.deleted ?? false;
        refund.terminalId = (refund.terminalId ?? '').isEmpty
            ? store.state.deviceState.deviceDetails?.deviceId
            : refund.terminalId;

        var result = await checkoutService.refundSale(
          refund.checkoutTransactionId,
          refund,
        );
        if (result == null) return;

        var transaction = await checkoutService.getTransactionById(
          refund.checkoutTransactionId,
        );

        store.dispatch(RefundSaleAction(transaction, result));

        Customer? customer;
        if (isNotBlank(refund.customerId)) {
          store.dispatch(getAndSetCustomerByID(customerId: refund.customerId!));
          customer = store.state.salesState.customer;
        }

        if (goToRefundCompletePage) {
          Navigator.pushReplacement(
            context,
            CustomRoute(
              builder: (BuildContext ctx) =>
                  RefundCompletePage(item: result, customer: customer),
            ),
          );
        }

        store.dispatch(ClearRefundStateAction());
        store.dispatch(SetSalesLoadingStateAction(false));

        completer?.complete();
        store.dispatch(SetSalesLoadingStateAction(false));
      } catch (e) {
        store.dispatch(SetSalesLoadingStateAction(false));

        completer?.completeError(e, StackTrace.current);
      } finally {
        store.dispatch(SetSalesLoadingStateAction(false));
      }
    });
  };
}

ThunkAction<AppState> selectAndFetchProductVariant({
  required StockProduct parentProduct,
  required List<SingleOptionAttribute> selectedAttributes,
  Completer<StockProduct>? completer,
}) {
  return (Store<AppState> store) async {
    try {
      final variantDisplayName =
          ProductVariantHelper.constructVariantDisplayName(
            parentProductDisplayName: parentProduct.displayName ?? '',
            availableOptionAttributes:
                parentProduct.productOptionAttributes ?? [],
            selectedOptionAttributes: selectedAttributes,
          );
      final parentId = parentProduct.id;

      if (parentId == null || variantDisplayName.isEmpty) {
        store.dispatch(const ClearCheckoutProductVariantAction());
        return;
      }

      // Dispatch loading action to show progress indicator in the UI.
      store.dispatch(const SetVariantSelectionLoadingAction(true));

      Completer<StockProduct> productCompleter = Completer<StockProduct>();
      store.dispatch(
        fetchProductVariantByDisplayName(
          parentProductId: parentProduct.id ?? '',
          displayName: variantDisplayName,
          completer: productCompleter,
        ),
      );

      StockProduct fetchedVariant = await productCompleter.future;

      store.dispatch(SetCheckoutProductVariantAction(fetchedVariant));

      completer?.complete(fetchedVariant);
    } catch (e) {
      reportCheckedError(e, trace: StackTrace.current);
      // On error, clear the variant to prevent showing stale or incorrect data.
      store.dispatch(const ClearCheckoutProductVariantAction());
      completer?.completeError(e, StackTrace.current);
    } finally {
      // Always ensure the loading state is turned off.
      store.dispatch(const SetVariantSelectionLoadingAction(false));
    }
  };
}

_initializeService(Store<AppState> store) {
  checkoutService = CheckoutService(
    store: store,
    baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
    businessId: store.state.currentBusinessId,
    token: store.state.authState.token,
    userId: store.state.authState.userId,
    userName:
        store.state.userState.profile?.firstName ??
        store.state.authState.userName,
  );
}

class CardPaymentResponseAction {
  bool? paid;

  CardPaymentResponseAction(this.paid);
}

class CheckoutAddCombos {
  List<ProductCombo?> value;

  List<CheckoutCartItem> cartItems;

  CheckoutAddCombos(this.value, this.cartItems);
}

class CheckoutAddCustomSaleAction {
  String? description;

  Decimal value;

  CheckoutAddCustomSaleAction(this.value, this.description);
}

class CheckoutSetWithdrawalAmountAction {
  Decimal value;

  CheckoutSetWithdrawalAmountAction(this.value);
}

class CheckoutSetCashbackAmountAction {
  Decimal value;

  CheckoutSetCashbackAmountAction(this.value);
}

class CheckoutAddItemsToCart {
  List<CheckoutCartItem>? value;

  CheckoutAddItemsToCart(this.value);
}

class CheckoutAddItemToCart {
  CheckoutCartItem value;

  CheckoutAddItemToCart(this.value);
}

class CheckoutSetCurrentActionAmount {
  Decimal value;

  CheckoutSetCurrentActionAmount(this.value);
}

class CheckoutAddProductAction {
  StockProduct product;

  StockVariance? variance;

  double quantity;

  double? variableAmount;

  bool? onlyAddOneIfNotInCart;

  CheckoutAddProductAction(
    this.product,
    this.quantity,
    this.variance, {
    this.variableAmount,
    this.onlyAddOneIfNotInCart = true,
  });
}

class CheckoutCancelledSale {
  CheckoutTransaction value;

  CheckoutCancelledSale(this.value);
}

class CheckoutSetDiscountTabIndexAction {
  int index;

  CheckoutSetDiscountTabIndexAction(this.index);
}

class CheckoutSetTipTabIndexAction {
  int index;

  CheckoutSetTipTabIndexAction(this.index);
}

class CheckoutSetTipAction {
  CheckoutTip tip;

  CheckoutSetTipAction(this.tip);
}

class CheckoutClearTipAction {
  CheckoutClearTipAction();
}

class CheckoutClearAction {
  double? lastTransactionNumber;

  CheckoutClearAction(this.lastTransactionNumber);
}

class CheckoutPushSaleAction {}

class CheckoutPushSaleCompletedAction {
  bool success;

  CheckoutTransaction transaction;

  CheckoutPushSaleCompletedAction(this.success, this.transaction);
}

class CheckoutPushTicketAction {
  CheckoutPushTicketAction();
}

class CheckoutReduceCustomSaleQuantityAction {
  String? description;

  Decimal value;

  CheckoutReduceCustomSaleQuantityAction(this.value, this.description);
}

class CheckoutRemoveItemAction {
  CheckoutCartItem value;

  CheckoutRemoveItemAction(this.value);
}

class SetCheckoutSortOptionsAction {
  SortBy type;
  SortOrder order;

  SetCheckoutSortOptionsAction(this.type, this.order);
}

class CheckoutRemoveItemsAction {
  CheckoutRemoveItemsAction();
}

class CheckoutSaleCancelledAction {
  CheckoutTransaction transaction;

  CheckoutSaleCancelledAction(this.transaction);
}

class CheckoutSetCustomAmount {
  Decimal value;

  CheckoutSetCustomAmount(this.value);
}

class CheckoutSetCustomDescription {
  String value;

  CheckoutSetCustomDescription(this.value);
}

class CheckoutSetCustomerAction {
  Customer? value;

  CheckoutSetCustomerAction(this.value);
}

class CheckoutSetDiscountAction {
  checkout_discount.CheckoutDiscount? value;

  CheckoutSetDiscountAction(this.value);
}

class CheckoutClearDiscountAction {
  CheckoutClearDiscountAction();
}

class CheckoutSetFailureAction {
  String value;

  CheckoutSetFailureAction(this.value);
}

class CheckoutSetKeyPadIndexAction {
  int? value;

  CheckoutSetKeyPadIndexAction(this.value);
}

class CheckoutSetLoadingAction {
  bool value;

  CheckoutSetLoadingAction(this.value);
}

class CheckoutSetNewSaleAction {
  CheckoutSetNewSaleAction();
}

class CheckoutSetPaymentTypeAction {
  PaymentType value;

  CheckoutSetPaymentTypeAction(this.value);
}

class ClearPaymentTypeAction {
  ClearPaymentTypeAction();
}

class CheckoutSetTicketAction {
  Ticket value;

  CheckoutSetTicketAction(this.value);
}

class CheckoutTypeSetAmountTenderedAction {
  Decimal value;

  CheckoutTypeSetAmountTenderedAction(this.value);
}

class RefundSaleAction {
  Refund refund;
  CheckoutTransaction value;

  RefundSaleAction(this.value, this.refund);
}

class RefundPushSaleCompletedAction {
  Refund refund;
  CheckoutTransaction value;

  RefundPushSaleCompletedAction(this.value, this.refund);
}

class ResetPaymentTypeAction {
  ResetPaymentTypeAction();
}

class ClearRefund {
  const ClearRefund();
}

class CreateQuickRefund {
  final String userId;
  final String username;
  final String businessId;

  const CreateQuickRefund(this.userId, this.username, this.businessId);
}

class SetQuickRefundAmount {
  final Decimal? value;

  const SetQuickRefundAmount(this.value);
}

class SetQuickRefundDescription {
  final String? value;

  const SetQuickRefundDescription(this.value);
}

class SetQuickRefundCustomer {
  final Customer? value;

  const SetQuickRefundCustomer(this.value);
}

class SetVariantSelectionLoadingAction {
  final bool value;

  const SetVariantSelectionLoadingAction(this.value);
}

class SetCheckoutProductVariantAction {
  StockProduct value;

  SetCheckoutProductVariantAction(this.value);
}

class ClearCheckoutProductVariantAction {
  const ClearCheckoutProductVariantAction();
}
