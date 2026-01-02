// Dart imports:
import 'dart:async';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/suppliers/supplier.dart';
import 'package:littlefish_merchant/models/suppliers/supplier_invoice.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

class SupplierService {
  SupplierService({
    required this.baseUrl,
    required this.businessId,
    required this.token,
    required this.store,
  }) {
    client = RestClient(store: store as Store<AppState>?);
  }

  String? baseUrl;
  String? businessId;
  String? token;

  Store store;
  late RestClient client;

  Future<List<Supplier>> getSuppliers() async {
    var response = await client.get(
      url: '$baseUrl/Supplier/GetSuppliers/businessId=$businessId',
      token: token,
    );

    if (response?.statusCode == 200) {
      return (response!.data as List).map((c) => Supplier.fromJson(c)).toList();
    } else {
      throw Exception('Unable to get suppliers, bad server response');
    }
  }

  Future<Supplier> addOrUpdateSupplier({required Supplier supplier}) async {
    var response = await client.post(
      url: '$baseUrl/Supplier/UpdateOrCreateSupplier/businessId=$businessId',
      token: token,
      requestData: supplier.toJson(),
    );

    if (response?.statusCode == 200) {
      return Supplier.fromJson(response!.data);
    } else {
      throw Exception('Unable to add or update supplier, bad server response');
    }
  }

  Future<bool> removeSupplier(Supplier supplier) async {
    var response = await client.delete(
      url:
          '$baseUrl/Supplier/DeleteSupplier/businessId=$businessId,id=${supplier.id}',
      token: token,
    );

    if (response?.statusCode == 200) {
      return true;
    } else {
      throw Exception('Unable to remove supplier, bad server response');
    }
  }
}

class InvoiceService {
  InvoiceService({
    required this.baseUrl,
    required this.businessId,
    required this.token,
    required this.store,
  }) {
    client = RestClient(store: store as Store<AppState>?);
  }

  String? baseUrl;
  String? businessId;
  String? token;

  Store store;
  late RestClient client;

  Future<List<SupplierInvoice>> getInvoices() async {
    var response = await client.get(
      url: '$baseUrl/Supplier/GetInvoices/businessId=$businessId',
      token: token,
    );

    if (response?.statusCode == 200) {
      return (response!.data as List)
          .map((c) => SupplierInvoice.fromJson(c))
          .toList();
    } else {
      throw Exception('Unable to get invoices, bad server response');
    }
  }

  Future<SupplierInvoice> addOrUpdateInvoice({
    required SupplierInvoice invoice,
  }) async {
    var response = await client.put(
      url: '$baseUrl/Supplier/CreateOrUpdateInvoice/businessId=$businessId',
      token: token,
      requestData: invoice.toJson(),
    );

    if (response?.statusCode == 200) {
      return SupplierInvoice.fromJson(response!.data);
    } else {
      throw Exception('Unable to add or update invoice, bad server response');
    }
  }

  Future<bool> removeInvoice(SupplierInvoice invoice) async {
    var response = await client.delete(
      url:
          '$baseUrl/Supplier/DeleteInvoice/businessId=$businessId,id=${invoice.id}',
      token: token,
    );

    if (response?.statusCode == 200) {
      return true;
    } else {
      throw Exception('Unable to remove invoice, bad server response');
    }
  }
}
