// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'pos_store_license.g.dart';

@JsonSerializable()
class POSStoreLicense {
  @JsonKey(name: 'app_name')
  String? appName;

  List<LicenseModule>? modules;

  POSStoreLicense({this.appName, this.modules});

  factory POSStoreLicense.fromJson(Map<String, dynamic> json) =>
      _$POSStoreLicenseFromJson(json);

  Map<String, dynamic> toJson() => _$POSStoreLicenseToJson(this);
}

@JsonSerializable()
class LicenseModule {
  String? name;

  @JsonKey(name: 'premium_routes')
  List<LicenseItem>? premiumRoutes;

  @JsonKey(name: 'premium_actions')
  List<LicenseItem>? premiumActions;

  LicenseModule({this.name, this.premiumActions, this.premiumRoutes});

  factory LicenseModule.fromJson(Map<String, dynamic> json) =>
      _$LicenseModuleFromJson(json);

  Map<String, dynamic> toJson() => _$LicenseModuleToJson(this);
}

@JsonSerializable()
class LicenseItem {
  String? name;
  bool? enabled;

  LicenseItem({this.enabled, this.name});

  factory LicenseItem.fromJson(Map<String, dynamic> json) =>
      _$LicenseItemFromJson(json);

  Map<String, dynamic> toJson() => _$LicenseItemToJson(this);
}
