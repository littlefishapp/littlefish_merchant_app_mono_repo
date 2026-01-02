// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:dio/dio.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';
import 'package:littlefish_merchant/zapper/models/zapper.dart';

import 'package:littlefish_merchant/redux/business/business_selectors.dart'
    as business_selector;

class ZapperService {
  static const ecommerceAPIURL = 'https://ecommerce.zapper.com/api/v1';
  static const baseUrl = 'https://api.zapper.com/business/api/v1';
  static const token = '2364970fff3047f9914c26593e10a10d';

  Store<AppState>? store;
  RestClient? client;
  String? siteId;
  String? merchantId;

  bool isConfigured = false;

  ZapperService({
    required this.client,
    required Store<AppState> this.store,
    this.merchantId,
    this.siteId,
  }) {
    client = RestClient(store: store);

    if (business_selector.hasZapperAccount(store!.state)) {
      var zapperAccount = business_selector.zapperAccount(store!.state)!;

      if (zapperAccount.config != null) {
        Map<String, dynamic> decodedConfig = jsonDecode(zapperAccount.config!);

        if (decodedConfig.containsKey('merchantId')) {
          merchantId = decodedConfig['merchantId'];
        }

        if (decodedConfig.containsKey('siteId')) {
          siteId = decodedConfig['siteId'];
        }

        isConfigured =
            (merchantId != null &&
            merchantId!.isNotEmpty &&
            siteId != null &&
            siteId!.isNotEmpty);
      } else {
        isConfigured = false;
      }
    } else {
      isConfigured = false;
    }
  }

  ZapperService.fromStore(Store<AppState> this.store) {
    client = RestClient(store: store);
    if (business_selector.hasZapperAccount(store!.state)) {
      var zapperAccount = business_selector.zapperAccount(store!.state)!;

      if (zapperAccount.config != null) {
        Map<String, dynamic> decodedConfig = jsonDecode(zapperAccount.config!);

        if (decodedConfig.containsKey('merchantId')) {
          merchantId = decodedConfig['merchantId'];
        }

        if (decodedConfig.containsKey('siteId')) {
          siteId = decodedConfig['siteId'];
        }

        isConfigured =
            (merchantId != null &&
            merchantId!.isNotEmpty &&
            siteId != null &&
            siteId!.isNotEmpty);
      } else {
        isConfigured = false;
      }
    } else {
      isConfigured = false;
    }
  }

  Future<String?> closeInvoice(String? invoiceId) async {
    var targetUrl =
        '$baseUrl/merchants/$merchantId/sites/$siteId/invoices?externalReference=$invoiceId';
    var response = await (client!.delete(
      url: targetUrl,
      token: 'Bearer $token',
    ));

    if (response!.statusCode == 200) {
      if (response.data == null) return null;

      return response.data;
    } else {
      throw Exception('Something went wrong, unable to close invoice');
    }
  }

  Future<String?> createZapperPayment(ZapperInvoice invoice) async {
    invoice.origin = merchantId;
    invoice.siteReference = siteId;
    var targetUrl = '$baseUrl/merchants/$merchantId/sites/$siteId/invoices';

    // Map<String, String> headers = {
    //   'Accept': 'image/svg+xml',
    //   'Authorization': 'Bearer $token',
    // };

    // var options = Options(
    //   maxRedirects: 2,
    //   headers: headers,
    // );

    var response = await (client!.post(
      url: targetUrl,
      requestData: invoice.toJson(),
      // TODO(lampian): fix next
      // passedOptions: options,
    ));

    if (response!.statusCode == 200) {
      if (response.data == null) return null;

      return response.data;
    } else {
      if (response.statusCode == 403) {
        return response.statusCode.toString();
      } else {
        throw Exception('Unable to create Zapper payment, please try again');
      }
    }
  }

  Future<List<ZapperPayment>?> verifyPayment(String? invoiceId) async {
    var targetUrl = '$ecommerceAPIURL/payments?reference=$invoiceId';

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    Options customOptions = Options(headers: headers);

    var response = await client!.get(
      url: targetUrl,
      customHeaders: customOptions,
    );

    if (response!.statusCode == 200) {
      if (response.data == null || (response.data as List).isEmpty) {
        return null;
      }

      return (response.data as List)
          .map((f) => ZapperPayment.fromJson(f))
          .toList();
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Unable to query Zapper payment, please try again');
    }
  }
}
