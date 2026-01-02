import 'dart:io';

import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/tools/security/app_security_validation.dart';
import 'package:littlefish_payments/gateways/softpos_payment_gateway.dart';

class SoftPosHelper {
  static bool isSoftPOSEnabled() {
    ConfigService configService = core.get<ConfigService>();
    final bool isSoftPOSEnabled = configService.getBoolValue(
      key: 'config_soft_pos_enabled',
      defaultValue: false,
    );
    return isSoftPOSEnabled;
  }

  static bool isAndroid() {
    return Platform.isAndroid;
  }

  static bool hasSoftPosProvider() {
    if (core.isRegistered<SoftPOSPaymentGateway>()) {
      return true;
    }
    return false;
  }

  static Future<bool> checkCardEnablement(String? paymentType) async {
    bool deviceCompatible = await isDeviceCompatible();
    return deviceCompatible &&
        hasSoftPosProvider() &&
        paymentType?.toLowerCase() == 'card';
  }

  static Future<bool> isDeviceCompatible() async {
    bool hasNfc = await hasNfcSupport();

    if (isAndroid() && isSoftPOSEnabled() && hasNfc) {
      return true;
    }
    return false;
  }

  static Future<bool> hasNfcSupport() async {
    bool hasNFC = await AppSecurityValidation().hasNfc();
    return hasNFC;
  }

  static String createReference() {
    return (DateTime.now().millisecondsSinceEpoch % 10000000000)
        .toString()
        .padLeft(10, '0');
  }
}
