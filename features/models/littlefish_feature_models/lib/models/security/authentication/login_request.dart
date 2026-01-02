// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/security/user/user_device.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest {
  String? userName;
  String? userPassword;
  String? deviceId;

  UserDevice? deviceInfo;

  LoginRequest({
    this.userName,
    this.userPassword,
    this.deviceId,
    this.deviceInfo,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
