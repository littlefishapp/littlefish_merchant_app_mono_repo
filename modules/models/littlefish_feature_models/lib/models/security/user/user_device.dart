// Dart imports:
import 'dart:io';

// Package imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/shared/data_item.dart';

part 'user_device.g.dart';

@JsonSerializable()
class UserDevice extends DataItem {
  String? userId,
      brand,
      device,
      display,
      fingerprint,
      host,
      manufacturer,
      product,
      deviceId,
      platform,
      systemVersion;

  bool? isPhysicalDevice;

  DateTime? accessDate;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<String> features;

  UserDevice({
    this.userId,
    this.brand,
    this.device,
    this.fingerprint,
    this.host,
    this.accessDate,
    this.deviceId,
    this.display,
    this.isPhysicalDevice,
    this.manufacturer,
    this.product,
    this.platform,
    this.systemVersion,
    this.features = const [],
  });

  factory UserDevice.fromAndroidInfo(AndroidDeviceInfo info) {
    return UserDevice(
      accessDate: DateTime.now().toUtc(),
      brand: info.brand,
      device: info.device,
      deviceId: info.id, // info.androidId, // TODO(lampian): check id
      display: info.display,
      fingerprint: info.fingerprint,
      host: info.host,
      isPhysicalDevice: info.isPhysicalDevice,
      manufacturer: info.manufacturer,
      product: info.product,
      platform: 'Android',
      features: info.systemFeatures,
    );
  }

  factory UserDevice.fromIosDeviceInfo(IosDeviceInfo info) {
    return UserDevice(
      platform: 'IOS',
      device: info.model,
      brand: 'Apple',
      accessDate: DateTime.now().toUtc(),
      deviceId: info.identifierForVendor,
      isPhysicalDevice: info.isPhysicalDevice,
      manufacturer: 'Apple',
      host: info.systemName,
      product: info.name,
      systemVersion: info.systemVersion,
      display: info.localizedModel,
      features: [info.utsname.machine],
    );
  }

  factory UserDevice.fromWindows() {
    return UserDevice(
      platform: 'Windows',
      device: Platform.operatingSystem,
      brand: 'Microsoft',
      accessDate: DateTime.now().toUtc(),
      deviceId: Platform.localHostname,
      isPhysicalDevice: true,
      manufacturer: 'Microsoft',
      host: Platform.localHostname,
      product: Platform.localHostname,
      systemVersion: Platform.operatingSystemVersion,
      display: Platform.operatingSystemVersion,
    );
  }

  @override
  bool? validate() {
    return null;
  }

  factory UserDevice.fromJson(Map<String, dynamic> json) =>
      _$UserDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$UserDeviceToJson(this);
}
