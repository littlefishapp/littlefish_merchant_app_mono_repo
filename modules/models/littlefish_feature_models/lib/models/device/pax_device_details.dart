import 'package:json_annotation/json_annotation.dart';

import 'interfaces/device_details.dart';

part 'pax_device_details.g.dart';

@JsonSerializable()
class PaxDeviceDetails implements DeviceDetails {
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

  PaxDeviceDetails(
    this.deviceId,
    this.deviceModel,
    this.merchantId,
    this.merchantName,
    this.terminalId,
  );

  factory PaxDeviceDetails.fromJson(Map<String, dynamic> json) =>
      _$PaxDeviceDetailsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PaxDeviceDetailsToJson(this);
}
