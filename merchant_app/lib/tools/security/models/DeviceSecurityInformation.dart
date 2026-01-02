class DeviceSecurityInformation {
  final String deviceId;
  final String location;
  final bool isEmulator;
  final String deviceModel;
  final String deviceBrand;
  final String deviceBoard;
  final String deviceSoftwareVersion;

  DeviceSecurityInformation({
    required this.deviceId,
    required this.location,
    required this.isEmulator,
    required this.deviceModel,
    required this.deviceBrand,
    required this.deviceBoard,
    required this.deviceSoftwareVersion,
  });

  DeviceSecurityInformation copyWith({
    String? deviceId,
    String? location,
    bool? isEmulator,
    String? deviceModel,
    String? deviceBrand,
    String? deviceBoard,
    String? deviceSoftwareVersion,
  }) {
    return DeviceSecurityInformation(
      deviceId: deviceId ?? this.deviceId,
      location: location ?? this.location,
      isEmulator: isEmulator ?? this.isEmulator,
      deviceModel: deviceModel ?? this.deviceModel,
      deviceBrand: deviceBrand ?? this.deviceBrand,
      deviceBoard: deviceBoard ?? this.deviceBoard,
      deviceSoftwareVersion:
          deviceSoftwareVersion ?? this.deviceSoftwareVersion,
    );
  }
}
