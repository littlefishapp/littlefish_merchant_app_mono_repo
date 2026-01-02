// Dart imports:
import 'dart:developer';

// Flutter imports:
import 'package:littlefish_merchant/models/enums.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/models/sales/tickets/ticket.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/stores/stores.dart';
import 'package:littlefish_merchant/tools/exceptions/common_exceptions.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

class SalesService {
  SalesService.fromStore(Store<AppState> storeValue) {
    store = storeValue;
    token = storeValue.state.token;
    baseUrl = storeValue.state.baseUrl;
    businessId = storeValue.state.businessId;

    client = RestClient(store: storeValue);
  }

  SalesService({this.store, this.baseUrl, this.businessId, this.token});

  Store<AppState>? store;
  String? token;
  String? baseUrl;
  String? businessId;

  late RestClient client;

  Future<List<CheckoutTransaction>> getPagedTransactions({
    int offset = 0,
    int pageSize = 150,
  }) async {
    var url =
        '$baseUrl/Checkout/GetPagedTransactions/businessId=$businessId,offset=$offset,pageSize=$pageSize';

    var response = await client.get(url: url, token: token);

    if (response?.statusCode == 200) {
      return (response!.data as List)
          .map((i) => CheckoutTransaction.fromJson(i))
          .toList();
    } else {
      throw Exception('An error occurred whilst getting transaction list');
    }
  }

  Future<List<CheckoutTransaction>> getPagedFilteredTransactions({
    int offset = 0,
    int pageSize = 50,
    required String textFilter,
  }) async {
    var url =
        '$baseUrl/Checkout/GetPagedFilteredTransactions/businessId=$businessId,offset=$offset,pageSize=$pageSize,textFilter=$textFilter';

    var response = await client.get(url: url, token: token);

    if (response?.statusCode == 200) {
      return (response!.data as List)
          .map((i) => CheckoutTransaction.fromJson(i))
          .toList();
    } else {
      throw Exception('An error occurred whilst getting transaction list');
    }
  }

  Future<List<CheckoutTransaction>> getPagedTransactionsBySalesSubType({
    int offset = 0,
    int pageSize = 50,
    required SalesSubType type,
  }) async {
    var url =
        '$baseUrl/Checkout/GetPagedTransactionsBySalesSubType/businessId=$businessId,offset=$offset,pageSize=$pageSize,type=${type.index}';

    var response = await client.get(url: url, token: token);

    if (response?.statusCode == 200) {
      return (response!.data as List)
          .map((i) => CheckoutTransaction.fromJson(i))
          .toList();
    } else {
      throw Exception('An error occurred whilst getting transaction list');
    }
  }

  Future<List<CheckoutTransaction>> getPagedFilteredTransactionsBySalesSubType({
    int offset = 0,
    int pageSize = 50,
    required SalesSubType type,
    required String textFilter,
  }) async {
    var url =
        '$baseUrl/Checkout/GetPagedFilteredTransactionsBySalesSubType/businessId=$businessId,offset=$offset,pageSize=$pageSize,type=${type.index},textFilter=$textFilter';

    var response = await client.get(url: url, token: token);

    if (response?.statusCode == 200) {
      return (response!.data as List)
          .map((i) => CheckoutTransaction.fromJson(i))
          .toList();
    } else {
      throw Exception('An error occurred whilst getting transaction list');
    }
  }

  Future<List<CheckoutTransaction>> getPagedTransactionsByTerminalId({
    int offset = 0,
    int pageSize = 150,
    required String terminalId,
  }) async {
    var url =
        '$baseUrl/Checkout/GetPagedTransactionsByTerminalId/businessId=$businessId,offset=$offset,pageSize=$pageSize,terminalId=$terminalId';

    var response = await client.get(url: url, token: token);

    if (response?.statusCode == 200) {
      return (response!.data as List)
          .map((i) => CheckoutTransaction.fromJson(i))
          .toList();
    } else {
      throw Exception('An error occurred whilst getting transaction list');
    }
  }

  Future<List<CheckoutTransaction>> getPagedFilteredTransactionsByTerminalId({
    int offset = 0,
    int pageSize = 50,
    required String textFilter,
    required String terminalId,
  }) async {
    var url =
        '$baseUrl/Checkout/GetPagedFilteredTransactionsByTerminalId/businessId=$businessId,offset=$offset,pageSize=$pageSize,textFilter=$textFilter,terminalId=$terminalId';

    var response = await client.get(url: url, token: token);

    if (response?.statusCode == 200) {
      return (response!.data as List)
          .map((i) => CheckoutTransaction.fromJson(i))
          .toList();
    } else {
      throw Exception('An error occurred whilst getting transaction list');
    }
  }

  Future<List<CheckoutTransaction>>
  getPagedTransactionsBySalesSubTypeAndTerminalId({
    int offset = 0,
    int pageSize = 50,
    required SalesSubType type,
    required String terminalId,
  }) async {
    var url =
        '$baseUrl/Checkout/GetPagedTransactionsBySalesSubTypeAndTerminalId/businessId=$businessId,offset=$offset,pageSize=$pageSize,type=${type.index},terminalId=$terminalId';

    var response = await client.get(url: url, token: token);

    if (response?.statusCode == 200) {
      return (response!.data as List)
          .map((i) => CheckoutTransaction.fromJson(i))
          .toList();
    } else {
      throw Exception('An error occurred whilst getting transaction list');
    }
  }

  Future<List<CheckoutTransaction>>
  getPagedFilteredTransactionsBySalesSubTypeAndTerminalId({
    int offset = 0,
    int pageSize = 50,
    required SalesSubType type,
    required String textFilter,
    required String terminalId,
  }) async {
    var url =
        '$baseUrl/Checkout/GetPagedFilteredTransactionsBySalesSubTypeAndTerminalId/businessId=$businessId,offset=$offset,pageSize=$pageSize,type=${type.index},textFilter=$textFilter,terminalId=$terminalId';

    var response = await client.get(url: url, token: token);

    if (response?.statusCode == 200) {
      return (response!.data as List)
          .map((i) => CheckoutTransaction.fromJson(i))
          .toList();
    } else {
      throw Exception('An error occurred whilst getting transaction list');
    }
  }

  Future<List<Ticket>> getTickets() async {
    var url = '$baseUrl/Checkout/GetTickets/businessId=$businessId';

    var response = await client.get(url: url, token: token);

    if (response?.statusCode == 200) {
      return (response!.data as List).map((i) => Ticket.fromJson(i)).toList();
    } else {
      throw Exception('An error occurred whilst getting the ticket list');
    }
  }

  Future<Ticket?> upsertTicket({
    required Ticket ticket,
    bool pushToServer = false,
  }) async {
    if (ticket.id == null) {
      ticket.id = const Uuid().v4();
      ticket.businessId = businessId;
      ticket.dateCreated = DateTime.now().toUtc();
      ticket.isNew = true;
    } else {
      ticket.isNew = false;
    }

    if (pushToServer) {
      var url = '$baseUrl/Checkout/UpsertTicket/businessId=$businessId';

      var response = await client.post(
        url: url,
        token: token,
        requestData: ticket.toJson(),
      );

      if (response?.statusCode == 200) {
        if (response!.data != null) return Ticket.fromJson(response.data);
        return null;
      } else {
        throw Exception('An error occurred whilst saving the ticket');
      }
    } else {
      try {
        //this is a local storage push for client side instant processing
        var store = TicketStore();
        ticket.pendingSync = true;

        if (ticket.isNew!) {
          await store.pushTicket(ticket);
        } else {
          await store.updateTicket(ticket);
        }

        return ticket;
      } catch (e) {
        log(
          'unable to push transaction to local storage',
          error: e,
          stackTrace: StackTrace.current,
        );

        reportCheckedError(e, trace: StackTrace.current);

        throw ManagedException(
          message:
              'We are not able to process this sale at this time\r\nplease try again',
        );
      }
    }
  }

  Future<bool> deleteTicket({required ticketId}) async {
    var url =
        '$baseUrl/Checkout/DeleteTicket/businessId=$businessId,ticketId=$ticketId';

    var response = await client.delete(url: url, token: token);

    if (response?.statusCode == 200) {
      return true;
    } else {
      throw Exception('An error occurred whilst deleting your ticket');
    }
  }
}
