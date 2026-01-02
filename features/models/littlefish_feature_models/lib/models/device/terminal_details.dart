import 'package:littlefish_merchant/models/device/interfaces/device_details.dart';
import 'package:littlefish_payments/models/terminal/terminal_data.dart';

class TerminalDetails extends DeviceDetails {
  @override
  String? deviceId;
  @override
  String? deviceModel;
  @override
  String? merchantId;
  @override
  String? merchantName;
  @override
  String? terminalId;

  TerminalDetails(TerminalData data) {
    deviceId = data.terminalId;
    deviceModel = data.modelNumber;
    merchantId = data.merchantId;
    merchantName = data.merchantName;
    terminalId = data.terminalId;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'deviceModel': deviceModel,
      'merchantId': merchantId,
      'merchantName': merchantName,
      'terminalId': terminalId,
    };
  }
}
