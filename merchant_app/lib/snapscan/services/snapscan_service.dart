import 'dart:convert';
// removed ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';

import '../models/snapscan_payment.dart';

class SnapScanService {
  static String baseUrl = 'https://pos.snapscan.io';
  String merchantId;
  String apiKey;

  SnapScanService(this.merchantId, this.apiKey);

  factory SnapScanService.withCredentials(String merchantId, String apiKey) {
    return SnapScanService(merchantId, apiKey);
  }

  Future<List<SnapScanPayment>> getPayments() async {
    try {
      String endpoint = '$baseUrl/merchant/api/v1/payments';
      final http.Response response = await http.get(
        Uri.parse(endpoint),
        headers: {'Authorization': getAuthentication()},
      );
      if (response.statusCode == 200) {
        final payments = jsonDecode(response.body) as List;
        final paymentsList = payments
            .map((e) => SnapScanPayment.fromJson(e))
            .toList();
        return paymentsList;
      } else {
        throw Exception('Payment initiation failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to initiate payment: $e');
    }
  }

  Future<SnapScanPayment> getPaymentById(int paymendId) async {
    try {
      String endpoint = '$baseUrl/merchant/api/v1/payments/$paymendId';
      final http.Response response = await http.get(
        Uri.parse(endpoint),
        headers: {'Authorization': getAuthentication()},
      );

      if (response.statusCode == 200) {
        return SnapScanPayment.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Payment initiation failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to initiate payment: $e');
    }
  }

  Future<List<SnapScanPayment>?> getPaymentByMerchRef(
    String merchantReference,
  ) async {
    try {
      String endpoint =
          '$baseUrl/merchant/api/v1/payments?merchantReference=$merchantReference';
      final http.Response response = await http.get(
        Uri.parse(endpoint),
        headers: {'Authorization': getAuthentication()},
      );
      if (response.statusCode == 200) {
        final payments = jsonDecode(response.body) as List;
        final paymentsList = payments
            .map((e) => SnapScanPayment.fromJson(e))
            .toList();
        return paymentsList;
      } else {
        throw Exception('Payment initiation failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to initiate payment: $e');
    }
  }

  String getAuthentication() {
    String token = base64Encode(utf8.encode('$apiKey:'));
    return 'Basic $token';
  }

  String generateQRCodeUrl(String? orderId, int? amount) {
    String qrCodeUrl = '$baseUrl/qr/$merchantId';
    if (amount != null) {
      qrCodeUrl += '?amount=$amount';
    }
    if (orderId != null) {
      qrCodeUrl += amount != null ? '&id=$orderId' : '?id=$orderId';
    }
    qrCodeUrl += '&strict=true';
    return qrCodeUrl;
  }

  QrImageView generateQRCodeWidget(String data, {double size = 320}) {
    return QrImageView(data: data, version: QrVersions.auto, size: size);
  }
}
