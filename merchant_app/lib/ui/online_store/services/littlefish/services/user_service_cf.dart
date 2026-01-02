// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

import '../../../../../features/ecommerce_shared/models/store/store_user.dart';

class UserServiceCF {
  UserServiceCF({required this.store}) {
    client = RestClient(store: store);
    token = 'Bearer ${store.state.token}';
    baseUrl =
        '${store.state.environmentState.environmentConfig!.cloudFunctionsUrl}userAPI';
  }

  String? baseUrl;

  String? token;

  Store<AppState> store;

  late RestClient client;

  Future<dynamic> deleteUser(String id) async {
    var response = await client.delete(
      url: '$baseUrl/deleteUser?id=$id',
      token: token,
    );

    if (response?.statusCode == 200) {
      return true;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<dynamic> addUserToStore(String inviteCode) async {
    var response = await client.post(
      url: '$baseUrl/addUserToStore?inviteCode=$inviteCode',
      token: token,
    );

    if (response?.statusCode == 200) {
      return true;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<dynamic> resendInvite(StoreUserInvite user) async {
    var response = await client.post(
      url: '$baseUrl/resendInvite',
      token: token,
      requestData: user.toJson(),
    );

    if (response?.statusCode == 200) {
      return true;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<dynamic> deleteInvite(StoreUserInvite user) async {
    var response = await client.post(
      url: '$baseUrl/deleteInvite',
      token: token,
      requestData: user.toJson(),
    );

    if (response?.statusCode == 200) {
      return true;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<dynamic> createUserInvite(StoreUserInvite user) async {
    var response = await client.post(
      url: '$baseUrl/createUserInvite',
      token: token,
      requestData: user.toJson(),
    );

    if (response?.statusCode == 200) {
      return true;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<dynamic> verifyDetailsRequest({
    required bool verifyEmail,
    required bool verifyNumber,
  }) async {
    var response = await client.post(
      url: '$baseUrl/verifyDetailsRequest',
      token: token,
      requestData: RequestVerification(
        verifyEmail: verifyEmail,
        verifyNumber: verifyNumber,
      ).toJson(),
    );

    if (response?.statusCode == 200) {
      return response!.data;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<dynamic> verifyDetails(OTPRequest request) async {
    var response = await client.post(
      url: '$baseUrl/verifyDetails',
      token: token,
      requestData: request.toJson(),
    );

    if (response?.statusCode == 200) {
      return response!.data;
    } else {
      throw Exception(response!.data);
    }
  }
}
