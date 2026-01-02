// Dart imports:
import 'dart:convert';
import 'dart:developer';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:decimal/decimal.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_discount.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/models/tax/sales_tax.dart';
import 'package:littlefish_merchant/providers/locale_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_state.dart';
import 'package:littlefish_merchant/stores/stores.dart';
import 'package:littlefish_merchant/tools/exceptions/common_exceptions.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

import '../models/sales/checkout/checkout_refund.dart';

LittleFishCore core = LittleFishCore.instance;

LoggerService get logger => LittleFishCore.instance.get<LoggerService>();

class CheckoutService {
  CheckoutService({
    required this.baseUrl,
    required this.businessId,
    required this.token,
    required this.store,
    this.userId,
    this.userName,
  }) {
    client = RestClient(store: store as Store<AppState>?);
  }

  CheckoutService.fromStore(Store<AppState> newStoreValue) {
    store = newStoreValue;
    baseUrl = newStoreValue.state.baseUrl;
    token = newStoreValue.state.token;
    userId = newStoreValue.state.authState.userId;
    userName =
        newStoreValue.state.userState.profile?.firstName ??
        newStoreValue.state.authState.userName;
    businessId = newStoreValue.state.businessId;
    client = RestClient(store: newStoreValue);
  }

  String? baseUrl;
  String? businessId;
  String? token;
  String? userId;
  String? userName;

  late RestClient client;
  Store? store;

  Future<CheckoutTransaction> uploadSale(
    CheckoutTransaction transaction,
  ) async {
    var url = '$baseUrl/Checkout/CreateSale/businessId=$businessId';
    final dataJson = jsonEncode(transaction.toJson());

    try {
      var response = await client.put(
        url: url,
        token: token,
        requestData: transaction.toJson(),
      );

      // final rawJson = jsonEncode(transaction);

      if (response?.statusCode == 200) {
        final result = CheckoutTransaction.fromJson(response!.data);

        return result;
      } else {
        throw ManagedException(
          message:
              'We are not able to process this sale at this time\r\nplease try again later',
        );
      }
    } catch (e) {
      if (e is ManagedException) {
        logger.debug('services.checkout', 'Error: ${e.message} ${e.name}');

        throw ManagedException(
          message: 'Error processing sale, try again later',
          name: 'connection',
        );
      } else {
        logger.debug('services.checkout', 'Error: $e');
        throw ManagedException(
          message: 'Error processing sale, try again later',
          name: 'other',
        );
      }
    }
  }

  Future<CheckoutTransaction> getTransactionById(String? id) async {
    var url =
        '$baseUrl/Checkout/GetTransactionById/businessId=$businessId,transactionId=$id';

    var response = await client.get(url: url, token: token);

    if (response?.statusCode == 200 && response!.data != null) {
      return CheckoutTransaction.fromJson(response.data);
    } else {
      throw ManagedException(
        message:
            'We are not able to fetch this sale at this time\r\nplease try again',
      );
    }
  }

  Future<List<CheckoutTransaction>> getTransactionsByCustomerId(
    String? customerId,
  ) async {
    var url =
        '$baseUrl/Checkout/GetTransactionsByCustomerId/businessId=$businessId,customerId=$customerId';

    var response = await client.get(url: url, token: token);

    if (response?.statusCode == 200) {
      return (response!.data as List)
          .map((e) => CheckoutTransaction.fromJson(e))
          .toList();
    } else {
      throw ManagedException(
        message:
            'We are not able to process this sale at this time\r\nplease try again',
      );
    }
  }

  Future<CheckoutTransaction> pushSale(
    CheckoutState state, {
    bool pushToServer = false,
    CheckoutTransaction? currentTransaction,
    String? deviceId,
  }) async {
    CheckoutTransaction transaction;
    var newInstanceTransaction = buildCheckoutTransactionFromState(
      deviceId: deviceId ?? '',
      pendingSync: pushToServer,
      state: state,
    );
    transaction = newInstanceTransaction;
    if (currentTransaction == null) {
    } else {
      transaction = currentTransaction;
    }

    transaction.deviceId = deviceId;
    transaction.currencyCode = LocaleProvider.instance.currencyCode;
    transaction.countryCode = LocaleProvider.instance.countryCode;
    transaction = await uploadSale(transaction);

    return transaction;
  }

  CheckoutTransaction buildCheckoutTransactionFromState({
    required CheckoutState state,
    required bool pendingSync,
    required String deviceId,
  }) {
    var transaction =
        CheckoutTransaction(
            amountChange: state.amountChange.toDouble(),
            amountTendered: (state.amountTendered ?? Decimal.zero).toDouble(),
            cashbackAmount: state.cashbackAmount?.toDouble(),
            withdrawalAmount: state.withdrawalAmount?.toDouble(),
            tipAmount: state.tipAmount?.toDouble(),
            items: state.items,
            paymentType: state.paymentType,
            totalTax: state.totalSalesTax.toDouble(),
            customerId: state.customer?.id,
            customerName: state.customer?.displayName,
            ticketId: state.ticket?.id,
            ticketName: state.ticket?.reference,
            totalCost: state.totalCost.toDouble(),
            totalDiscount: (state.totalDiscount ?? Decimal.zero).toDouble(),
            totalMarkup: state.markup.toDouble(),
            totalValue:
                (state.salesTax?.taxPricingMode ??
                        TaxPricingMode.alreadyIncluded) ==
                    TaxPricingMode.alreadyIncluded
                ? state.totalValue.toDouble()
                : (state.totalValue + state.totalSalesTax).toDouble(),
            transactionDate: DateTime.now().toUtc(),
            sellerId: userId,
            pendingSync: pendingSync,
            sellerName: userName,
            customerEmail: state.customer?.email,
            customerMobile: state.customer?.mobileNumber,
            taxInclusive:
                (state.salesTax?.taxPricingMode ??
                    TaxPricingMode.alreadyIncluded) ==
                TaxPricingMode.alreadyIncluded,
          )
          ..id = const Uuid().v4()
          ..businessId = businessId
          ..dateCreated = DateTime.now().toUtc();

    transaction.deviceId = deviceId;
    transaction.currencyCode = LocaleProvider.instance.currencyCode;
    transaction.countryCode = LocaleProvider.instance.countryCode;

    return transaction;
  }

  Future<CheckoutTransaction?> cancelSale(String? id) async {
    //always remove from local storage, ignore error but attempt the remove
    try {
      var store = SalesStore();

      await store.removeSaleById(id);
    } catch (e) {
      log(
        'unable to remove transaction from local storage',
        error: e,
        stackTrace: StackTrace.current,
      );

      reportCheckedError(e, trace: StackTrace.current);
    }

    var response = await client.delete(
      url: '$baseUrl/Checkout/CancelSale/businessId=$businessId,id=$id',
      token: token,
    );

    if (response?.statusCode == 200) {
      if (response!.data == null) {
        return null;
      } else {
        return CheckoutTransaction.fromJson(response.data);
      }
    } else {
      throw Exception('unable to cancel transaction at this time');
    }
  }

  Future<Refund?> refundSale(String? transactionId, Refund refund) async {
    //always remove from local storage, ignore error but attempt the remove

    var response = await client.put(
      url:
          '$baseUrl/Checkout/CreateRefund/businessId=$businessId,saleId=$transactionId',
      token: token,
      requestData: refund.toJson(),
    );

    if (response?.statusCode == 200) {
      if (response!.data == null) {
        return null;
      } else {
        return Refund.fromJson(response.data);
      }
    } else {
      throw Exception('Unable to perform refund at this time');
    }
  }

  Future<void> emailReceipt(
    String? email,
    String? customerName,
    CheckoutTransaction? transaction,
  ) async {
    if (customerName == null || customerName.isEmpty) {
      throw Exception('Customer Name not provided');
    }

    if (email == null || email.isEmpty) {
      throw Exception('Customer Email not Provided');
    }

    var response = await client.post(
      url:
          '$baseUrl/Notification/SendReceipt/businessId=$businessId,email=$email,firstname=$customerName',
      token: token,
      requestData: transaction?.toJson(),
    );

    if (response?.statusCode == 200) {
      return;
    } else {
      throw Exception('An error occurred whilst emailing receipt');
    }
  }

  Future<void> emailPaymentReceipt(
    String? email,
    String? customerName,
    CheckoutTransaction? transaction,
  ) async {
    if (customerName == null || customerName.isEmpty) {
      throw Exception('Customer Name not provided');
    }

    if (email == null || email.isEmpty) {
      throw Exception('Customer Email not Provided');
    }

    var response = await client.post(
      url:
          '$baseUrl/Notification/SendPaymentReceipt?businessId=$businessId&email=$email&firstname=$customerName',
      token: token,
      requestData: transaction?.toJson(),
    );

    if (response?.statusCode == 200) {
      return;
    } else {
      throw Exception('An error occurred whilst emailing receipt');
    }
  }

  Future<void> emailRefund(
    String? email,
    String? customerName,
    Refund? refund,
  ) async {
    if (customerName == null || customerName.isEmpty) {
      throw Exception('Customer Name not provided');
    }

    if (email == null || email.isEmpty) {
      throw Exception('Customer Email not Provided');
    }

    refund?.businessId ??= businessId;

    var response = await client.post(
      url:
          '$baseUrl/Notification/SendRefund/businessId=$businessId,email=$email,firstname=$customerName',
      token: token,
      requestData: refund?.toJson(),
    );

    if (response?.statusCode == 200) {
      return;
    } else {
      throw Exception('An error occurred whilst emailing receipt');
    }
  }

  Future<List<CheckoutDiscount>> getDiscounts() async {
    var url = '$baseUrl/Checkout/GetDiscounts/businessId=$businessId';

    var response = await client.get(url: url, token: token);

    if (response?.statusCode == 200) {
      {
        return (response!.data as List)
            .map((i) => CheckoutDiscount.fromJson(i))
            .toList();
      }
    } else {
      throw Exception('Error while Sending Receipt to Customer');
    }
  }

  Future<CheckoutDiscount> createOrUpdateDiscount(
    CheckoutDiscount discount,
  ) async {
    var url = '$baseUrl/Checkout/UpdateOrCreateDiscount/businessId=$businessId';

    var response = await client.post(
      url: url,
      requestData: discount.toJson(),
      token: token,
    );

    if (response?.statusCode == 200) {
      return CheckoutDiscount.fromJson(response!.data);
    } else {
      throw Exception(
        'Unable to create / update discount at this time, bad server response',
      );
    }
  }
}
