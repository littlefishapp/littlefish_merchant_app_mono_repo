library littlefishpay_qr_sdk;

import 'snapscan_service.dart';

enum PaymentMethod { snapscan, zapper }

class LittleFishPayQr {
  late SnapScanService snapScanSdk;
  //'191c6877-dd48-4358-b0bd-44064dc678b9'
  SnapScanService initializeSnapScan(String merchantId, String apiKey) {
    snapScanSdk = SnapScanService.withCredentials(merchantId, apiKey);
    return snapScanSdk;
  }
}
