// Package imports:
import 'package:sembast/sembast.dart' as sembast;

// Project imports:
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/models/sales/tickets/ticket.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/tools/localstorage/local_database.dart';

class ProductStore {
  final String name = 'products';

  storeProducts(List<StockProduct> items) {
    var db = LocalDatabase();

    db.storeDataList(items.map((i) => i.toJson()).toList(), store: name);
  }

  Future<List<StockProduct>> loadProducts() async {
    var db = LocalDatabase();

    var result = await db.getDataList(store: name);

    return result.map((i) => StockProduct.fromJson(i)).toList();
  }

  updateProduct(StockProduct item) {}

  removeProduct(StockProduct item) {}

  Future<void> clear() async {}
}

class SalesStore {
  final String name = 'sales_store';

  storeSales(List<CheckoutTransaction> items) {
    for (var sale in items) {
      updateTransaction(sale);
    }
  }

  Future<void> pushSale(CheckoutTransaction item) async {
    var db = LocalDatabase();

    await db.pushItem(name, item.toJson());
  }

  Future<void> removeSale(CheckoutTransaction item) async {
    var db = LocalDatabase();

    await db.removeItem(
      name,
      filter: sembast.Filter.and([sembast.Filter.equals('id', item.id)]),
    );
  }

  Future<void> removeSaleById(String? id) async {
    var db = LocalDatabase();

    await db.removeItem(
      name,
      filter: sembast.Filter.and([sembast.Filter.equals('id', id)]),
    );
  }

  Future<List<CheckoutTransaction>> getSales() async {
    var db = LocalDatabase();

    var result = await db.getDataList(store: name);

    return result.map((i) => CheckoutTransaction.fromJson(i)).toList();
  }

  Future<int> getPendingTransactionCount({List<String?>? exclusions}) {
    var db = LocalDatabase();

    return db.count(
      store: name,
      filter: exclusions != null && exclusions.isNotEmpty
          ? sembast.Filter.and([
              sembast.Filter.equals('pendingSync', true),
              ...exclusions.map((e) => sembast.Filter.notEquals('id', e)),
            ])
          : sembast.Filter.and([sembast.Filter.equals('pendingSync', true)]),
    );
  }

  Future<int> getTransactionCount({List<String?>? exclusions}) {
    var db = LocalDatabase();

    return db.count(
      store: name,
      filter: exclusions != null && exclusions.isNotEmpty
          ? sembast.Filter.and([
              sembast.Filter.equals('pendingSync', true),
              ...exclusions.map((e) => sembast.Filter.notEquals('id', e)),
            ])
          : null,
    );
  }

  Future<List<CheckoutTransaction>> getPendingTransactionBatch({
    List<String?>? exclusions,
  }) async {
    var db = LocalDatabase();

    var result = await db.find(
      store: name,
      batchSize: 50,
      filter: exclusions != null && exclusions.isNotEmpty
          ? sembast.Filter.and([
              sembast.Filter.equals('pendingSync', true),
              ...exclusions.map((e) => sembast.Filter.notEquals('id', e)),
            ])
          : sembast.Filter.and([sembast.Filter.equals('pendingSync', true)]),
    );

    return result.map((i) => CheckoutTransaction.fromJson(i)).toList();
  }

  Future<bool> updateTransaction(CheckoutTransaction transaction) async {
    var db = LocalDatabase();

    var result = await db.findAndUpdate(
      store: name,
      item: transaction.toJson(),
      filter: sembast.Filter.and([sembast.Filter.equals('id', transaction.id)]),
    );

    return result;
  }

  Future<void> clear() async {
    var db = LocalDatabase();

    await db.clearStore(store: name);
  }
}

class TicketStore {
  final String name = 'ticket_store';

  storeSales(List<Ticket> items) {
    for (var ticket in items) {
      updateTicket(ticket);
    }
  }

  Future<void> pushTicket(Ticket item) async {
    var db = LocalDatabase();

    await db.pushItem(name, item.toJson());
  }

  Future<void> removeTicket(Ticket item) async {
    var db = LocalDatabase();

    await db.removeItem(
      name,
      filter: sembast.Filter.and([sembast.Filter.equals('id', item.id)]),
    );
  }

  Future<void> removeTicketById(String id) async {
    var db = LocalDatabase();

    await db.removeItem(
      name,
      filter: sembast.Filter.and([sembast.Filter.equals('id', id)]),
    );
  }

  Future<List<Ticket>> getTickets() async {
    var db = LocalDatabase();

    var result = await db.find(
      store: name,
      batchSize: 100,
      filter: sembast.Filter.and([sembast.Filter.equals('completed', false)]),
    );

    return result.map((i) => Ticket.fromJson(i)).toList();
  }

  Future<int> getPendingTicketsCount({List<String?>? exclusions}) {
    var db = LocalDatabase();

    return db.count(
      store: name,
      filter: exclusions != null && exclusions.isNotEmpty
          ? sembast.Filter.and([
              sembast.Filter.equals('pendingSync', true),
              ...exclusions.map((e) => sembast.Filter.notEquals('id', e)),
            ])
          : sembast.Filter.and([sembast.Filter.equals('pendingSync', true)]),
    );
  }

  Future<List<Ticket>> getPendingTicketsBatch({
    List<String?>? exclusions,
  }) async {
    var db = LocalDatabase();

    var result = await db.find(
      store: name,
      batchSize: 50,
      filter: exclusions != null && exclusions.isNotEmpty
          ? sembast.Filter.and([
              sembast.Filter.equals('pendingSync', true),
              ...exclusions.map((e) => sembast.Filter.notEquals('id', e)),
            ])
          : sembast.Filter.and([sembast.Filter.equals('pendingSync', true)]),
    );

    return result.map((i) => Ticket.fromJson(i)).toList();
  }

  Future<bool> updateTicket(Ticket ticket) async {
    var db = LocalDatabase();

    var result = await db.findAndUpdate(
      store: name,
      item: ticket.toJson(),
      filter: sembast.Filter.and([sembast.Filter.equals('id', ticket.id)]),
    );

    return result;
  }

  Future<void> clear() async {
    var db = LocalDatabase();

    await db.clearStore(store: name);
  }
}

class OfflineSalesStore {
  final String name = 'offline_sales';

  storeSales(List<CheckoutTransaction> items) {
    var db = LocalDatabase();

    db.storeDataList(items.map((i) => i.toJson()).toList(), store: name);
  }

  pushSale(CheckoutTransaction item) {
    var db = LocalDatabase();

    db.pushItem(name, item.toJson());
  }

  Future<List<CheckoutTransaction>> getSales() async {
    var db = LocalDatabase();

    var result = await db.getDataList(store: name);

    return result.map((i) => CheckoutTransaction.fromJson(i)).toList();
  }

  Future<void> clear() async {
    var db = LocalDatabase();

    await db.clearStore(store: name);
  }
}
