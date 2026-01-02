import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:littlefish_merchant/models/permissions/business_role.dart';
import 'package:littlefish_merchant/models/permissions/business_user_role.dart';
import 'package:littlefish_merchant/models/permissions/permission.dart';
import 'package:littlefish_merchant/models/permissions/permission_and_permission_group.dart';
import 'package:littlefish_merchant/models/permissions/permission_group.dart';
import 'package:quiver/strings.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

class PermissionService {
  PermissionService({
    required this.baseUrl,
    required this.businessId,
    required this.token,
    required this.store,
  }) {
    client = RestClient(store: store as Store<AppState>?);
  }

  PermissionService.fromStore(Store<AppState> storeValue) {
    store = storeValue;
    token = storeValue.state.token;
    baseUrl = storeValue.state.baseUrl;
    businessId = storeValue.state.businessId;

    client = RestClient(store: storeValue);
  }

  String? baseUrl;
  String? businessId;
  String? token;

  Store? store;

  late RestClient client;

  Future<List<Permission>?> getPermissions() async {
    var response = await client.get(
      url: '$baseUrl/Permission/GetPermissions',
      token: token,
    );

    if (response?.statusCode == 200) {
      return (response!.data as List)
          .map((p) => Permission.fromJson(p))
          .toList();
    } else {
      throw Exception('bad response from server, unable to get permissions');
    }
  }

  Future<List<PermissionGroup>?> getPermissionGroups() async {
    var response = await client.get(
      url: '$baseUrl/Permission/GetPermissionGroups',
      token: token,
    );

    if (response?.statusCode == 200) {
      return (response!.data as List)
          .map((p) => PermissionGroup.fromJson(p))
          .toList();
    } else {
      throw Exception(
        'bad response from server, unable to get permission groups',
      );
    }
  }

  Future<PermissionAndPermissionGroup>
  getPermissionsAndPermissionGroups() async {
    var response = await client.get(
      url: '$baseUrl/Permission/GetPermissionsAndPermissionGroups',
      token: token,
    );

    if (response?.statusCode == 200) {
      return PermissionAndPermissionGroup.fromJson(response?.data);
    } else {
      throw Exception(
        'bad response from server, unable to get permissions and permission groups',
      );
    }
  }

  Future<List<BusinessRole>?> getBusinessRoles({
    bool includeSystemRoles = true,
  }) async {
    var response = await client.get(
      url:
          '$baseUrl/Permission/GetRoles/businessId=$businessId,includeSystemRoles=$includeSystemRoles',
      token: token,
    );

    if (response?.statusCode == 200) {
      return (response!.data as List)
          .map((p) => BusinessRole.fromJson(p))
          .toList();
    } else {
      throw Exception('bad response from server, unable to get business roles');
    }
  }

  Future<List<Permission>?> getUserPermissions(String userId) async {
    var response = await client.get(
      url:
          '$baseUrl/Permission/GetUserPermissions/businessId=$businessId,userId=$userId',
      token: token,
    );

    if (response?.statusCode == 200) {
      return (response!.data as List)
          .map((p) => Permission.fromJson(p))
          .toList();
    } else {
      throw Exception(
        'bad response from server, unable to get users permissions',
      );
    }
  }

  Future<List<BusinessRole>?> createBusinessRoles({
    required List<BusinessRole> roles,
  }) async {
    var response = await client.post(
      url: '$baseUrl/Permission/CreateRoles/businessId=$businessId',
      token: token,
      requestData: jsonEncode(roles),
    );

    if (response?.statusCode == 200) {
      return (response!.data as List)
          .map((p) => BusinessRole.fromJson(p))
          .toList();
    } else {
      throw Exception(
        'bad response from server, unable to create business roles',
      );
    }
  }

  Future<List<BusinessRole>?> updateBusinessRoles({
    required List<BusinessRole> roles,
  }) async {
    var response = await client.put(
      url: '$baseUrl/Permission/UpdateRoles/businessId=$businessId',
      token: token,
      requestData: jsonEncode(roles),
    );

    if (response?.statusCode == 200) {
      return (response!.data as List)
          .map((p) => BusinessRole.fromJson(p))
          .toList();
    } else {
      throw Exception(
        'bad response from server, unable to update business roles',
      );
    }
  }

  Future<List<BusinessRole>?> deleteBusinessRoles({
    required List<String> roleIds,
  }) async {
    String url = '$baseUrl/Permission/DeleteRoles';
    url += '?';
    url += 'businessId=$businessId';
    for (String roleId in roleIds) {
      url += '&roleIds=$roleId';
    }
    var response = await client.delete(url: url, token: token);

    if (response?.statusCode == 200) {
      return (response!.data as List)
          .map((p) => BusinessRole.fromJson(p))
          .toList();
    } else {
      throw Exception(
        'bad response from server, unable to delete business role',
      );
    }
  }

  Future<List<BusinessUserRole>?> getBusinessUserRoles({
    required String userId,
    String? localBusinessId,
    String? customToken,
  }) async {
    Response? response;
    if (isBlank(customToken)) {
      response = await client.get(
        url:
            '$baseUrl/Permission/GetUserRolesByUser/businessId=${localBusinessId ?? businessId},userId=$userId',
        token: token,
      );
    } else {
      response = await client.getBasic(
        url:
            '$baseUrl/Permission/GetUserRolesByUser/businessId=${localBusinessId ?? businessId},userId=$userId',
        token: 'Basic $customToken',
      );
    }

    if (response?.statusCode == 200) {
      return (response!.data as List)
          .map((p) => BusinessUserRole.fromJson(p))
          .toList();
    } else {
      throw Exception(
        'bad response from server, unable to get business user roles',
      );
    }
  }

  Future<List<BusinessUserRole>?> createBusinessUserRoles({
    required String userId,
    required List<BusinessUserRole> userRoles,
  }) async {
    var response = await client.post(
      url:
          '$baseUrl/Permission/CreateUserRolesByUser/businessId=$businessId,userId=$userId',
      token: token,
      requestData: jsonEncode(userRoles),
    );

    if (response?.statusCode == 200) {
      return (response!.data as List)
          .map((p) => BusinessUserRole.fromJson(p))
          .toList();
    } else {
      throw Exception(
        'bad response from server, unable to create business user roles',
      );
    }
  }

  Future<List<BusinessUserRole>?> updateBusinessUserRoles({
    required String userId,
    String? businessId,
    required List<BusinessUserRole> userRoles,
  }) async {
    Response? response = await client.put(
      url:
          '$baseUrl/Permission/UpdateUserRolesByUser/businessId=$businessId,userId=$userId',
      token: token,
      requestData: jsonEncode(userRoles),
    );

    if (response?.statusCode == 200) {
      return (response!.data as List)
          .map((p) => BusinessUserRole.fromJson(p))
          .toList();
    } else {
      throw Exception(
        'bad response from server, unable to update business user roles',
      );
    }
  }

  Future<List<BusinessUserRole>?> deleteBusinessUserRoles({
    required String userId,
    required List<String> userRoleIds,
  }) async {
    String url = '$baseUrl/Permission/DeleteUserRolesByUser';
    url += '?';
    url += 'businessId=$businessId&userId=$userId';
    for (String roleId in userRoleIds) {
      url += '&userRoleIds=$roleId';
    }
    var response = await client.delete(
      url: url,
      token: token,
      requestData: {'userRoleIds': jsonEncode(userRoleIds)},
    );

    if (response?.statusCode == 200) {
      return (response!.data as List)
          .map((p) => BusinessUserRole.fromJson(p))
          .toList();
    } else {
      throw Exception(
        'bad response from server, unable to delete business user roles',
      );
    }
  }

  Future<List<BusinessUserRole>?> getBusinessUserRolesByBusiness({
    String? businessId,
  }) async {
    businessId = businessId ?? this.businessId;

    var response = await client.get(
      url:
          '$baseUrl/Permission/GetAllUserRolesByBusiness/businessId=$businessId',
      token: token,
    );

    if (response?.statusCode == 200) {
      return (response!.data as List)
          .map((p) => BusinessUserRole.fromJson(p))
          .toList();
    } else {
      throw Exception(
        'bad response from server, unable to get business user roles',
      );
    }
  }
}
