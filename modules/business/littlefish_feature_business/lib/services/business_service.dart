// removed ignore: depend_on_referenced_packages

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:littlefish_core/business/models/business_user.dart';
import 'package:littlefish_merchant/models/security/verification.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';

// Core imports:
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/models/expenses/business_expense.dart';
import 'package:littlefish_merchant/models/online/online_store.dart';

import 'package:littlefish_merchant/models/staff/employee.dart';
import 'package:littlefish_merchant/models/store/business_profile.dart';
import 'package:littlefish_merchant/models/store/business_type.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

import '../models/security/user/business_user_profile.dart';

class BusinessService {
  BusinessService({
    required this.baseUrl,
    required this.token,
    required this.businessId,
    required this.store,
  }) {
    client = RestClient(store: store);
  }

  BusinessService.fromStore(Store<AppState> storeValue) {
    store = storeValue;
    token = storeValue.state.token;
    baseUrl = storeValue.state.baseUrl;
    businessId = storeValue.state.businessId;

    client = RestClient(store: storeValue);
  }
  String? baseUrl;
  String? token;
  String? businessId;
  Store<AppState>? store;

  late RestClient client;

  Future<BusinessProfile?> getBusinessProfile() async {
    var response = await (client.get(
      url: '$baseUrl/Business/GetBusinessProfileById/businessId=$businessId',
      token: token,
    ));

    if (response!.statusCode == 200) {
      if (response.data == null) {
        return null;
      } else {
        return BusinessProfile.fromJson(response.data);
      }
    } else {
      throw Exception('bad response, unable to load profile');
    }
  }

  Future<BusinessProfile> updateBusinessProfile(BusinessProfile profile) async {
    var pr = profile.toJson();
    var response = await client.put(
      url: '$baseUrl/Business/UpdateBusinessProfile',
      token: token,
      requestData: pr,
    );

    if (response?.statusCode == 200) {
      return profile;
    } else {
      throw Exception('bad response, unable to load profile');
    }
  }

  Future<Verification?> getBusinessVerificationStatus(String businessId) async {
    var response = await client.get(
      url: '$baseUrl/Business/GetVerificationStatus/businessId=$businessId',
      token: token,
    );

    if (response?.statusCode == 200) {
      return Verification.fromJson(response!.data);
    } else {
      throw Exception(
        'bad response, unable to get Business Verification Status',
      );
    }
  }

  Future<Verification?> setBusinessVerificationStatus(
    String businessId,
    Verification verificationStatus,
  ) async {
    var response = await client.post(
      url: '$baseUrl/Business/SetVerificationStatus/businessId=$businessId',
      token: token,
      requestData: verificationStatus.toJson(),
    );

    if (response?.statusCode == 200) {
      return Verification.fromJson(response!.data);
    } else {
      throw Exception(
        'bad response, unable to get Business Verification Status',
      );
    }
  }

  Future<OnlineStore> upsertOnlineStore(OnlineStore store) async {
    var response = await client.post(
      url: '$baseUrl/Business/UpsertOnlineStore/businessId=$businessId',
      token: token,
      requestData: store.toJson(),
    );

    if (response?.statusCode == 200) {
      return store;
    } else {
      throw Exception('bad response, unable to create Online Store');
    }
  }

  // Future<OnlineStore> getOnlineStore() async {
  //   var response = await client.get(
  //     url: "$baseUrl/Business/GetOnlineStore/businessId=$businessId",
  //     token: token,
  //   );

  //   if (response?.statusCode == 200) {
  //     if(response == null) return null;
  //     return OnlineStore.fromJson(response.data);
  //   } else
  //     throw new Exception("bad response, unable to retrive your Online Catalog");
  // }

  // Future<BusinessUser> joinBusiness(String inviteCode) async {
  //   var response = await client.post(
  //     url: "$baseUrl/User/LinkUserByInviteCode/inviteCode=$inviteCode",
  //     token: token,
  //   );

  //   if (response?.statusCode == 200) {
  //     {
  //       if (response.data == null)
  //         throw ManagedException(message: "Your user code is not valid");
  //       else
  //         return BusinessUser.fromJson(response.data);
  //     }
  //   } else
  //     throw new Exception("bad response, unable to join business");
  // }

  Future<BusinessProfile?> registerBusiness(BusinessProfile profile) async {
    profile.type!.subTypes = null;

    LittleFishCore.instance.get<LoggerService>().debug(
      'services.business_service',
      'Profile data: ${profile.toJson()}',
    );

    var response = await client.put(
      url: '$baseUrl/Business/CreateBusiness',
      token: token,
      requestData: profile.toJson(),
    );

    if (response?.statusCode == 200) {
      return response!.data == null
          ? null
          : BusinessProfile.fromJson(response.data);
    } else {
      throw Exception('bad response, unable to load profile');
    }
  }

  Future<Response?> createBusinessWithUser(BusinessUserProfile profile) async {
    LittleFishCore.instance.get<LoggerService>().debug(
      'services.business_service',
      'Profile data: ${profile.toJson()}',
    );

    var response = await client.post(
      url: '$baseUrl/Business/CreateBusinessWithUser',
      token: token,
      requestData: profile.toJson(),
    );

    if (response?.statusCode == 200) {
      return response;
    } else {
      throw Exception('bad response, unable to load profile');
    }
  }

  Future<List<BusinessType>> getBusinessTypes() async {
    var response = await client.get(
      url: '$baseUrl/Business/GetBusinessTypes',
      token: token,
    );

    if (response?.statusCode == 200) {
      return (response!.data as List)
          .map((i) => BusinessType.fromJson(i))
          .toList();
    } else {
      throw Exception('Something went wrong getting business types');
    }
  }

  Future<List<Employee>> getEmployees() async {
    var response = await client.get(
      url: '$baseUrl/Employee/GetEmployees/businessId=$businessId',
      token: token,
    );

    if (response?.statusCode == 200) {
      var res = (response!.data as List)
          .map((i) => Employee.fromJson(i))
          .toList();
      return res;
    } else {
      throw Exception('Something went wrong getting employees');
    }
  }

  Future<Employee> updateOrSaveEmployee(Employee item) async {
    item.businessId = businessId;

    var emp = item.toJson();
    var response = await client.post(
      url: '$baseUrl/Employee/UpdateOrCreateEmployee/businessId=$businessId',
      token: token,
      requestData: emp,
    );

    if (response?.statusCode == 200) {
      return Employee.fromJson(response!.data);
    } else {
      throw Exception('Something went updating employee');
    }
  }

  Future<bool> removeEmployee(Employee item) async {
    var response = await client.delete(
      url:
          '$baseUrl/Employee/DeleteEmployee/businessId=$businessId,id=${item.newID}',
      token: token,
    );

    if (response?.statusCode == 200) {
      return true;
    } else {
      throw Exception('Something went wrong removing employee');
    }
  }

  Future<List<BusinessUser>> getUsers() async {
    var response = await client.get(
      url: '$baseUrl/User/GetBusinessUsers/businessId=$businessId',
      token: token,
    );

    if (response?.statusCode == 200) {
      return (response!.data as List)
          .map((i) => BusinessUser.fromJson(i))
          .toList();
    } else {
      throw Exception(
        'Unable to retrieve business users. Please check your permissions and try again.',
      );
    }
  }

  Future<BusinessUser> getUserById({
    required String userId,
    bool checkDeletedUsers = false,
  }) async {
    var response = await client.get(
      url:
          '$baseUrl/User/GetUserById?businessId=$businessId&id=$userId&checkDeleted=$checkDeletedUsers',
      token: token,
    );

    if (response?.statusCode == 200 && response?.data != null) {
      return BusinessUser.fromJson(response!.data);
    } else {
      throw Exception('Something went wrong getting business users');
    }
  }

  Future<BusinessUser> addOrUpdateUser(BusinessUser user) async {
    user.businessId = businessId;

    if (user.uid == null || user.uid!.isEmpty) {
      user.role ??= UserRoleType.employee;

      user.dateUpdated = DateTime.now().toUtc();
      user.userNo = 1;
      user.businessNo = 1;

      var response = await client.post(
        url: '$baseUrl/User/CreateUserInvite',
        token: token,
        requestData: user.toJson(),
      );

      if (response?.statusCode == 200) {
        return BusinessUser.fromJson(response!.data);
      } else {
        throw Exception('Something went adding / updating business user');
      }
    } else {
      var response = await client.post(
        url: '$baseUrl/User/UpdateBusinessUser',
        token: token,
        requestData: user.toJson(),
      );

      if (response?.statusCode == 200) {
        return user;
      } else {
        throw Exception('Something went adding / updating business user');
      }
    }
  }

  Future<bool> removeUser(BusinessUser user) async {
    var response = await client.delete(
      url:
          '$baseUrl/User/DeleteUserAccount/businessId=$businessId,uid=${user.uid}',
      token: token,
    );

    if (response?.statusCode == 200) {
      return true;
    } else {
      throw Exception('Something went wrong removing business user');
    }
  }
}

class ExpensesService {
  ExpensesService({
    required this.baseUrl,
    required this.businessId,
    required this.token,
    required this.store,
  }) {
    client = RestClient(store: store as Store<AppState>?);
  }

  ExpensesService.fromStore(Store<AppState> storeValue) {
    store = storeValue;
    businessId = storeValue.state.businessId;
    baseUrl = storeValue.state.baseUrl;
    token = storeValue.state.token;
    client = RestClient(store: storeValue);
  }

  String? baseUrl;
  String? businessId;
  String? token;

  Store? store;
  late RestClient client;

  Future<List<BusinessExpense>> getExpenses() async {
    var response = await client.get(
      url: '$baseUrl/Expenses/GetExpenses/businessId=$businessId',
      token: token,
    );

    if (response?.statusCode == 200) {
      return (response!.data as List)
          .map((c) => BusinessExpense.fromJson(c))
          .toList();
    } else {
      throw Exception('Unable to get expenses, bad server response');
    }
  }

  Future<BusinessExpense> addOrUpdateExpense({
    required BusinessExpense item,
  }) async {
    var response = await client.put(
      url: '$baseUrl/Expenses/CreateOrUpdateExpense/businessId=$businessId',
      token: token,
      requestData: item.toJson(),
    );

    if (response?.statusCode == 200) {
      return BusinessExpense.fromJson(response!.data);
    } else {
      throw Exception('Unable to add or update expense, bad server response');
    }
  }

  Future<bool> removeExpense(BusinessExpense item) async {
    var response = await client.delete(
      url:
          '$baseUrl/Expenses/DeleteExpense/businessId=$businessId,id=${item.id}',
      token: token,
    );

    if (response?.statusCode == 200) {
      return true;
    } else {
      throw Exception('Unable to remove expense, bad server response');
    }
  }
}
