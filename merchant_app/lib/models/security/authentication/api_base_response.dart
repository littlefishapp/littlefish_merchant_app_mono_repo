// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'api_base_response.g.dart';

@JsonSerializable()
class ApiBaseResponse {
  ApiBaseResponse({required this.success, this.data, this.error});

  bool success;
  String? error;
  dynamic data;

  factory ApiBaseResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiBaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiBaseResponseToJson(this);
}
