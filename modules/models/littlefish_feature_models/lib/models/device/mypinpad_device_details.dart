import 'package:json_annotation/json_annotation.dart';

import 'interfaces/device_details.dart';

part 'mypinpad_device_details.g.dart';

@JsonSerializable()
class MyPinPadDeviceDetails implements DeviceDetails {
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

  MyPinPadDeviceDetails(
    this.merchantId,
    this.terminalId, {
    this.merchantName,
    this.deviceModel,
    this.deviceId,
  });

  factory MyPinPadDeviceDetails.fromJson(Map<String, dynamic> json) =>
      _$MyPinPadDeviceDetailsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MyPinPadDeviceDetailsToJson(this);
}
