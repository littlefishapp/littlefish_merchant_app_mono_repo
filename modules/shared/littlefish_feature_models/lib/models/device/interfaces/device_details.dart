abstract class DeviceDetails {
  String? get deviceId;
  String? get deviceModel;
  String? get terminalId;
  String? get merchantId;
  String? get merchantName;

  Map<String, dynamic> toJson();
}
