// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'bq_bus_details_request.g.dart';

@JsonSerializable()
class BqBusDetailsRequest {
  BqBusDetailsRequest({this.businessId, this.busName, this.userEmail});

  String? businessId;
  String? busName;
  String? userEmail;

  factory BqBusDetailsRequest.fromJson(Map<String, dynamic> json) =>
      _$BqBusDetailsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BqBusDetailsRequestToJson(this);
}
