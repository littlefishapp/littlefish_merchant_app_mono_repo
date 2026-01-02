// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_store_license.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

POSStoreLicense _$POSStoreLicenseFromJson(Map<String, dynamic> json) =>
    POSStoreLicense(
      appName: json['app_name'] as String?,
      modules: (json['modules'] as List<dynamic>?)
          ?.map((e) => LicenseModule.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$POSStoreLicenseToJson(POSStoreLicense instance) =>
    <String, dynamic>{
      'app_name': instance.appName,
      'modules': instance.modules,
    };

LicenseModule _$LicenseModuleFromJson(Map<String, dynamic> json) =>
    LicenseModule(
      name: json['name'] as String?,
      premiumActions: (json['premium_actions'] as List<dynamic>?)
          ?.map((e) => LicenseItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      premiumRoutes: (json['premium_routes'] as List<dynamic>?)
          ?.map((e) => LicenseItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LicenseModuleToJson(LicenseModule instance) =>
    <String, dynamic>{
      'name': instance.name,
      'premium_routes': instance.premiumRoutes,
      'premium_actions': instance.premiumActions,
    };

LicenseItem _$LicenseItemFromJson(Map<String, dynamic> json) => LicenseItem(
  enabled: json['enabled'] as bool?,
  name: json['name'] as String?,
);

Map<String, dynamic> _$LicenseItemToJson(LicenseItem instance) =>
    <String, dynamic>{'name': instance.name, 'enabled': instance.enabled};
