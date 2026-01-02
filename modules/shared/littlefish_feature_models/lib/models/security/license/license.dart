// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'license.g.dart';

@JsonSerializable()
class License {
  License({this.module, this.name, this.package});

  String? module;
  String? name;
  String? package;

  factory License.fromJson(Map<String, dynamic> json) =>
      _$LicenseFromJson(json);

  Map<String, dynamic> toJson() => _$LicenseToJson(this);
}
