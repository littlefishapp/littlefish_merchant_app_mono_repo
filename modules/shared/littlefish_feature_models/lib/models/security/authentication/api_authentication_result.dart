// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'api_authentication_result.g.dart';

@JsonSerializable()
class ApiAuthenticationResult {
  ApiAuthenticationResult({this.accessToken, this.token, this.message});

  String? accessToken;
  String? token;
  String? message;

  factory ApiAuthenticationResult.fromJson(Map<String, dynamic> json) =>
      _$ApiAuthenticationResultFromJson(json);

  Map<String, dynamic> toJson() => _$ApiAuthenticationResultToJson(this);
}
