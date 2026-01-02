// Dart imports:
import 'dart:async';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:littlefish_core/business/models/business_user.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/security/user/user_profile.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

class UserProfileService {
  UserProfileService({
    required this.baseUrl,
    required this.token,
    required this.store,
    this.businessId,
  }) {
    client = RestClient(store: store as Store<AppState>?);
  }

  String? baseUrl;
  String? token;
  String? businessId;

  Store? store;
  late RestClient client;

  UserProfileService.fromStore(Store<AppState> storeValue) {
    store = storeValue;
    baseUrl = storeValue.state.baseUrl;
    businessId = storeValue.state.businessId;
    token = storeValue.state.token;
    client = RestClient(store: storeValue);
  }

  Future<UserProfile?> getUserProfile() async {
    var response = await (client.get(
      url: '$baseUrl/User/GetUserProfile',
      token: token,
    ));

    if (response!.statusCode == 200) {
      if (response.data == null) {
        return null;
      } else {
        return UserProfile.fromJson(response.data);
      }
    } else {
      throw Exception('bad response, unable to load profile');
    }
  }

  Future<bool> deleteUserAccount(String? uid) async {
    var response = await (client.delete(
      url: '$baseUrl/User/DeleteUserAccount/businessId=$businessId,uid=$uid',
      token: token,
    ));

    if (response!.statusCode == 200) {
      return true;
    } else {
      throw Exception('bad response, unable to delete user account');
    }
  }

  Future<UserProfile> updateUserProfile(UserProfile profile) async {
    var response = await client.put(
      url: '$baseUrl/User/UpdateUserProfile',
      token: token,
      requestData: profile.toJson(),
    );

    if (response?.statusCode == 200) {
      return UserProfile.fromJson(response!.data);
    } else {
      throw Exception('bad response, unable to load profile');
    }
  }

  Future<BusinessUser> addStoreUser(
    String username,
    UserProfile profile,
    UserPermissions permissions,
  ) async {
    var response = await client.post(
      url: '$baseUrl/User/AddStoreUser',
      token: token,
      requestData: {
        'businessId': businessId,
        'username': username,
        'profile': profile.toJson(),
        'permissions': permissions.toJson(),
      },
    );

    if (response?.statusCode == 200) {
      return BusinessUser.fromJson(response!.data);
    } else {
      throw Exception(response!.data?.privateMessage?.toString());
    }
  }

  Future<BusinessUser> addBusinessUser(
    String username,
    String password,
    UserProfile profile,
    UserPermissions permissions,
  ) async {
    var response = await client.post(
      url: '$baseUrl/User/AddBusinessUser',
      token: token,
      requestData: {
        'businessId': businessId,
        'username': username,
        'password': password,
        'profile': profile.toJson(),
        'permissions': permissions.toJson(),
      },
    );

    if (response?.statusCode == 200) {
      return BusinessUser.fromJson(response!.data);
    } else {
      throw Exception(
        'Unable to create account, please confirm if email is unique.',
      );
    }
  }

  Future<BusinessUser> addBusinessUserNoPassword(
    String username,
    UserProfile profile,
    UserPermissions permissions,
    String businessRoleId,
  ) async {
    var response = await client.post(
      url: '$baseUrl/User/AddBusinessUserNoPassword',
      token: token,
      requestData: {
        'businessId': businessId,
        'username': username,
        'profile': profile.toJson(),
        'permissions': permissions.toJson(),
        'businessRoleId': businessRoleId.toString().trim(),
      },
    );

    if (response?.statusCode == 200) {
      return BusinessUser.fromJson(response!.data);
    } else {
      throw Exception(
        'Unable to create account, please confirm if email is unique.',
      );
    }
  }

  Future<UserProfile> createUserProfile(UserProfile profile) async {
    var response = await client.put(
      url: '$baseUrl/User/CreateUserProfile',
      token: token,
      requestData: profile.toJson(),
    );

    if (response?.statusCode == 200) {
      return UserProfile.fromJson(response!.data);
    } else {
      throw Exception('bad response, unable to create user-profile');
    }
  }
}
