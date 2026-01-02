// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/security/user/user_device.dart';

part 'user_create_request.g.dart';

@JsonSerializable()
class UserCreateRequest {
  String? userName;
  String? userPassword;

  String? firstName;
  String? lastName;
  String? displayName;

  String? mobileNumber;
  String? email;

  UserDevice? deviceInfo;

  UserCreateRequest({
    this.userName,
    this.userPassword,
    this.firstName,
    this.lastName,
    this.displayName,
    this.mobileNumber,
    this.email,
    this.deviceInfo,
  });

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case User.
  factory UserCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$UserCreateRequestFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$UserCreateRequestToJson(this);
}
