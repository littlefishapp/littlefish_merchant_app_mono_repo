// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CachedDevice _$CachedDeviceFromJson(Map<String, dynamic> json) =>
    CachedDevice(
        key: json['key'] as String?,
        deviceId: (json['deviceId'] as num?)?.toInt(),
        manufacturerName: json['manufacturerName'] as String?,
        pid: (json['pid'] as num?)?.toInt(),
        productName: json['productName'] as String?,
        serial: json['serial'] as String?,
        vid: (json['vid'] as num?)?.toInt(),
      )
      ..cacheDate = json['cacheDate'] == null
          ? null
          : DateTime.parse(json['cacheDate'] as String)
      ..expiryDate = json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String);

Map<String, dynamic> _$CachedDeviceToJson(CachedDevice instance) =>
    <String, dynamic>{
      'key': instance.key,
      'cacheDate': instance.cacheDate?.toIso8601String(),
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'vid': instance.vid,
      'pid': instance.pid,
      'productName': instance.productName,
      'manufacturerName': instance.manufacturerName,
      'deviceId': instance.deviceId,
      'serial': instance.serial,
    };

CachedProducts _$CachedProductsFromJson(Map<String, dynamic> json) =>
    CachedProducts()
      ..key = json['key'] as String?
      ..businessId = json['businessId'] as String?
      ..cacheDate = json['cacheDate'] == null
          ? null
          : DateTime.parse(json['cacheDate'] as String)
      ..expiryDate = json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String)
      ..items = (json['items'] as List<dynamic>?)
          ?.map((e) => StockProduct.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$CachedProductsToJson(CachedProducts instance) =>
    <String, dynamic>{
      'key': instance.key,
      'businessId': instance.businessId,
      'cacheDate': instance.cacheDate?.toIso8601String(),
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'items': instance.items,
    };

CachedCombos _$CachedCombosFromJson(Map<String, dynamic> json) => CachedCombos()
  ..key = json['key'] as String?
  ..businessId = json['businessId'] as String?
  ..cacheDate = json['cacheDate'] == null
      ? null
      : DateTime.parse(json['cacheDate'] as String)
  ..expiryDate = json['expiryDate'] == null
      ? null
      : DateTime.parse(json['expiryDate'] as String)
  ..items = (json['items'] as List<dynamic>?)
      ?.map((e) => ProductCombo.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$CachedCombosToJson(CachedCombos instance) =>
    <String, dynamic>{
      'key': instance.key,
      'businessId': instance.businessId,
      'cacheDate': instance.cacheDate?.toIso8601String(),
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'items': instance.items,
    };

CachedModifiers _$CachedModifiersFromJson(Map<String, dynamic> json) =>
    CachedModifiers()
      ..key = json['key'] as String?
      ..businessId = json['businessId'] as String?
      ..cacheDate = json['cacheDate'] == null
          ? null
          : DateTime.parse(json['cacheDate'] as String)
      ..expiryDate = json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String)
      ..items = (json['items'] as List<dynamic>?)
          ?.map((e) => ProductModifier.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$CachedModifiersToJson(CachedModifiers instance) =>
    <String, dynamic>{
      'key': instance.key,
      'businessId': instance.businessId,
      'cacheDate': instance.cacheDate?.toIso8601String(),
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'items': instance.items,
    };

CachedCustomers _$CachedCustomersFromJson(Map<String, dynamic> json) =>
    CachedCustomers()
      ..key = json['key'] as String?
      ..businessId = json['businessId'] as String?
      ..cacheDate = json['cacheDate'] == null
          ? null
          : DateTime.parse(json['cacheDate'] as String)
      ..expiryDate = json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String)
      ..items = (json['items'] as List<dynamic>?)
          ?.map((e) => Customer.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$CachedCustomersToJson(CachedCustomers instance) =>
    <String, dynamic>{
      'key': instance.key,
      'businessId': instance.businessId,
      'cacheDate': instance.cacheDate?.toIso8601String(),
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'items': instance.items,
    };

CachedSales _$CachedSalesFromJson(Map<String, dynamic> json) => CachedSales()
  ..key = json['key'] as String?
  ..businessId = json['businessId'] as String?
  ..cacheDate = json['cacheDate'] == null
      ? null
      : DateTime.parse(json['cacheDate'] as String)
  ..expiryDate = json['expiryDate'] == null
      ? null
      : DateTime.parse(json['expiryDate'] as String)
  ..items = (json['items'] as List<dynamic>?)
      ?.map((e) => CheckoutTransaction.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$CachedSalesToJson(CachedSales instance) =>
    <String, dynamic>{
      'key': instance.key,
      'businessId': instance.businessId,
      'cacheDate': instance.cacheDate?.toIso8601String(),
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'items': instance.items,
    };

CachedEmployees _$CachedEmployeesFromJson(Map<String, dynamic> json) =>
    CachedEmployees()
      ..key = json['key'] as String?
      ..businessId = json['businessId'] as String?
      ..cacheDate = json['cacheDate'] == null
          ? null
          : DateTime.parse(json['cacheDate'] as String)
      ..expiryDate = json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String)
      ..items = (json['items'] as List<dynamic>?)
          ?.map((e) => Employee.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$CachedEmployeesToJson(CachedEmployees instance) =>
    <String, dynamic>{
      'key': instance.key,
      'businessId': instance.businessId,
      'cacheDate': instance.cacheDate?.toIso8601String(),
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'items': instance.items,
    };
