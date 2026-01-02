// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:fast_contacts/fast_contacts.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

class CustomerService {
  CustomerService({
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

  late RestClient client;
  Store store;

  Future<List<Customer>> getCustomers() async {
    var response = await client.get(
      url: '$baseUrl/Customer/GetCustomers/businessId=$businessId',
      token: token,
    );

    if (response?.statusCode == 200) {
      return (response!.data as List).map((c) => Customer.fromJson(c)).toList();
    } else {
      throw Exception('Unable to get customers, bad server response');
    }
  }

  Future<Customer> getCustomerById(String? customerId) async {
    var response = await client.get(
      url:
          '$baseUrl/Customer/GetCustomerById/businessId=$businessId,customerId=$customerId',
      token: token,
    );

    if (response?.statusCode == 200) {
      return Customer.fromJson(response!.data);
    } else {
      throw Exception('Unable to get customers, bad server response');
    }
  }

  Future<Customer?> getDeletedCustomerById({String? customerId}) async {
    String queryParams = 'customerId=$customerId';

    var response = await client.get(
      url:
          '$baseUrl/Customer/GetDeletedCustomerById/businessId=$businessId,$queryParams',
      token: token,
    );

    if (response?.statusCode == 200) {
      if (response?.data == null) return null;

      return Customer.fromJson(response!.data);
    } else {
      throw Exception('Unable to get customers, bad server response');
    }
  }

  Future<Customer> addCustomer({required Customer customer}) async {
    var response = await client.post(
      url: '$baseUrl/Customer/AddCustomer/businessId=$businessId',
      token: token,
      requestData: customer.toJson(),
    );

    if (response?.statusCode == 200) {
      return Customer.fromJson(response!.data);
    } else {
      throw Exception('Unable to add customer, bad server response');
    }
  }

  Future<List<Contact>> getContacts() async {
    var lookupResult = await FastContacts.getAllContacts();

    var result = lookupResult.where((o) {
      return (o.displayName.isNotEmpty) && (o.phones.isNotEmpty);
    }).toList();

    result.sort((a, b) {
      return a.displayName
          .substring(0, 1)
          .toLowerCase()
          .compareTo(b.displayName.substring(0, 1).toLowerCase());
    });

    result.removeWhere((c) {
      return (c.phones.isEmpty);
    });

    return result;
  }

  Future<Customer> updateCustomer({required Customer customer}) async {
    var response = await client.put(
      url: '$baseUrl/Customer/UpdateCustomer/businessId=$businessId',
      token: token,
      requestData: customer.toJson(),
    );

    if (response?.statusCode == 200) {
      return Customer.fromJson(response!.data);
    } else {
      throw Exception('Unable to update customer, bad server response');
    }
  }

  Future<dynamic> payCustomerCredit({
    required Customer customer,
    required double amount,
  }) async {
    var response = await client.put(
      url:
          '$baseUrl/Customer/PayCustomerCredit/businessId=$businessId,customerId=${customer.id},amount=$amount',
      token: token,
    );

    if (response?.statusCode == 200) {
      return response!.data;
    } else {
      throw Exception('Unable to update customer, bad server response');
    }
  }

  Future<dynamic> giveCustomerCredit({
    required Customer customer,
    required double amount,
  }) async {
    var response = await client.put(
      url:
          '$baseUrl/Customer/GiveCustomerCredit/businessId=$businessId,customerId=${customer.id},amount=$amount',
      token: token,
    );

    if (response?.statusCode == 200) {
      return response!.data;
    } else {
      throw Exception('Unable to update customer, bad server response');
    }
  }

  Future<dynamic> cancelPayCustomerCredit({
    required Customer customer,
    required String? entryId,
  }) async {
    var response = await client.post(
      url:
          '$baseUrl/Customer/CancelCustomerCredit/businessId=$businessId,customerId=${customer.id},creditEntryId=$entryId',
      token: token,
    );

    if (response?.statusCode == 200) {
      return response!.data;
    } else {
      throw Exception('Unable to update customer, bad server response');
    }
  }

  Future<bool> removeCustomer(Customer customer) async {
    var response = await client.delete(
      url:
          '$baseUrl/Customer/DeleteCustomer/businessId=$businessId,id=${customer.id}',
      token: token,
    );

    if (response?.statusCode == 200) {
      return true;
    } else {
      throw Exception('Unable to remove customer, bad server response');
    }
  }
}
