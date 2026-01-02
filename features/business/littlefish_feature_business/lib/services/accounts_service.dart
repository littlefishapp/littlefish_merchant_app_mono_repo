// Dart imports:
import 'dart:async';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/settings/accounts/linked_account.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

class AccountsService {
  String? baseUrl;
  String? token;
  String? businessId;
  Store<AppState>? store;
  late RestClient client;

  AccountsService({
    required this.baseUrl,
    required this.token,
    required this.businessId,
    required this.store,
  }) {
    client = RestClient(store: store);
  }

  AccountsService.fromStore(Store<AppState> storeValue) {
    store = storeValue;
    baseUrl = storeValue.state.baseUrl;
    businessId = storeValue.state.businessId;
    token = storeValue.state.token;

    client = RestClient(store: store);
  }

  Future<List<LinkedAccount>?> getLinkedAccounts() async {
    var response = await (client.get(
      url: '$baseUrl/Accounts/GetLinkedAccounts/businessId=$businessId',
      token: token,
    ));

    if (response!.statusCode == 200) {
      if (response.data == null) {
        return null;
      } else {
        return (response.data as List)
            .map((item) => LinkedAccount.fromJson(item))
            .toList();
      }
    } else {
      throw Exception(
        'Unable to retrieve linked accounts. Please check your connection and try again.',
      );
    }
  }

  Future<List<LinkedAccount>?> upsertLinkedAccount(
    LinkedAccount account,
  ) async {
    var accountJSON = account.toJson();

    var response = await (client.put(
      url: '$baseUrl/Accounts/UpsertLinkedAccount/businessId=$businessId',
      requestData: accountJSON,
      token: token,
    ));

    if (response!.statusCode == 200) {
      if (response.data == null) {
        return null;
      } else {
        return (response.data as List)
            .map((item) => LinkedAccount.fromJson(item))
            .toList();
      }
    } else {
      throw Exception(
        'Unable to save linked account. Please verify the account details and try again.',
      );
    }
  }

  Future<List<SalesChannel>?> getSalesChannel() async {
    var response = await (client.get(
      url: '$baseUrl/Accounts/GetSalesChannel/businessId=$businessId',
      token: token,
    ));

    if (response!.statusCode == 200) {
      if (response.data == null) {
        return null;
      } else {
        return (response.data as List)
            .map((item) => SalesChannel.fromJson(item))
            .toList();
      }
    } else {
      throw Exception(
        'Something went wrong, could not retrieve linked accounts.',
      );
    }
  }

  Future<List<SalesChannel>?> upsertSalesChannel(SalesChannel account) async {
    var response = await (client.put(
      url: '$baseUrl/Accounts/UpsertSalesChannel/businessId=$businessId',
      requestData: account.toJson(),
      token: token,
    ));

    if (response!.statusCode == 200) {
      if (response.data == null) {
        return null;
      } else {
        return (response.data as List)
            .map((item) => SalesChannel.fromJson(item))
            .toList();
      }
    } else {
      throw Exception(
        'Unable to save sales channel. Please verify the channel details and try again.',
      );
    }
  }

  Future<bool> deleteLinkedAccount(LinkedAccount account) async {
    var response = await (client.delete(
      url:
          '$baseUrl/Accounts/DeleteLinkedAccount/businessId=$businessId,accountType=${account.providerType!.index}',
      token: token,
    ));

    if (response!.statusCode == 200) {
      if (response.data == null) {
        return false;
      } else {
        return true;
      }
    } else {
      throw Exception(
        'Unable to delete linked account. Please verify the account exists and try again.',
      );
    }
  }

  // Future<bool> deleteSalesChannel(SalesChannel account) async {
  //   var response = await client.delete(
  //       url:
  //           "$baseUrl/Accounts/DeleteSalesChannel/businessId=$businessId,accountType=${account.salesChannelType.index}",
  //       token: token);

  //   if (response!.statusCode == 200) {
  //     if (response.data == null)
  //       return false;
  //     else
  //       return true;
  //   } else {
  //     throw Exception(
  //         'Something went wrong, unable to delete the linked account');
  //   }
  // }
}
