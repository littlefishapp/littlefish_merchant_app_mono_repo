class DeviceEmailRequest {
  String totalDevices;
  String deviceLimit;
  String deviceName;
  String deviceId;
  String deviceBrand;
  String merchantId;
  String businessName;

  DeviceEmailRequest({
    required this.totalDevices,
    required this.deviceLimit,
    required this.deviceName,
    required this.deviceBrand,
    required this.deviceId,
    required this.merchantId,
    required this.businessName,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalDevices': totalDevices,
      'deviceLimit': deviceLimit,
      'deviceName': deviceName,
      'deviceId': deviceId,
      'deviceBrand': deviceBrand,
      'merchantId': merchantId,
      'businessName': businessName,
    };
  }

  factory DeviceEmailRequest.fromJson(Map<String, dynamic> json) {
    return DeviceEmailRequest(
      totalDevices: json['totalDevices'] ?? '',
      deviceLimit: json['deviceLimit'] ?? '',
      deviceName: json['deviceName'] ?? '',
      deviceId: json['deviceId'] ?? '',
      merchantId: json['merchantId'] ?? '',
      businessName: json['businessName'] ?? '',
      deviceBrand: json['deviceBrand'] ?? '',
    );
  }

  DeviceEmailRequest copyWith({
    String? totalDevices,
    String? deviceLimit,
    String? deviceName,
    String? deviceId,
    String? merchantId,
    String? businessName,
    String? deviceBrand,
  }) {
    return DeviceEmailRequest(
      totalDevices: totalDevices ?? this.totalDevices,
      deviceLimit: deviceLimit ?? this.deviceLimit,
      deviceName: deviceName ?? this.deviceName,
      deviceId: deviceId ?? this.deviceId,
      merchantId: merchantId ?? this.merchantId,
      businessName: businessName ?? this.businessName,
      deviceBrand: deviceBrand ?? this.deviceBrand,
    );
  }

  factory DeviceEmailRequest.copy(DeviceEmailRequest request) {
    return DeviceEmailRequest(
      totalDevices: request.totalDevices,
      deviceLimit: request.deviceLimit,
      deviceName: request.deviceName,
      deviceId: request.deviceId,
      merchantId: request.merchantId,
      businessName: request.businessName,
      deviceBrand: request.deviceBrand,
    );
  }
}
