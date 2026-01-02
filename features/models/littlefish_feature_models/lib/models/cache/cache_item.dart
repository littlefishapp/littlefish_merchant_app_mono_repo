// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/models/products/product_combo.dart';
import 'package:littlefish_merchant/models/products/product_modifier.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/models/staff/employee.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';

// import 'package:usb_serial/usb_serial.dart';

part 'cache_item.g.dart';

abstract class CacheItem {
  String? key;

  DateTime? cacheDate;

  DateTime? expiryDate;
}

abstract class CachedSetting<T> {
  String? key;

  DateTime? cacheDate;

  DateTime? expiryDate;

  T? item;
}

abstract class CachedBusinessItem<T> {
  String? key;

  String? businessId;

  DateTime? cacheDate;

  DateTime? expiryDate;

  T? item;
}

abstract class CachedBusinessList<T> {
  String? key;

  String? businessId;

  DateTime? cacheDate;

  DateTime? expiryDate;

  List<T>? items;
}

abstract class CachedItem<T> {
  String? key;

  DateTime? cacheDate;

  DateTime? expiryDate;

  T? item;

  String? businessId;
}

abstract class CachedList<T> {
  String? key;

  DateTime? cacheDate;

  DateTime? expiryDate;

  List<T>? items;
}

@JsonSerializable()
class CachedDevice extends CacheItem {
  CachedDevice({
    String? key,
    this.deviceId,
    this.manufacturerName,
    this.pid,
    this.productName,
    this.serial,
    this.vid,
  }) {
    this.key = key;
  }

  /// Vendor Id
  int? vid;

  /// Product Id
  int? pid;
  String? productName;
  String? manufacturerName;

  /// The device id is unique to this Usb Device until it is unplugged.
  /// when replugged this ID will be different.
  int? deviceId;

  /// The Serial number from the USB device.
  String? serial;

  factory CachedDevice.fromJson(Map<String, dynamic> json) =>
      _$CachedDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$CachedDeviceToJson(this);
}

@JsonSerializable()
class CachedProducts extends CachedBusinessList<StockProduct> {
  CachedProducts() {
    key = 'products';
  }

  factory CachedProducts.fromJson(Map<String, dynamic> json) =>
      _$CachedProductsFromJson(json);

  Map<String, dynamic> toJson() => _$CachedProductsToJson(this);
}

@JsonSerializable()
class CachedCombos extends CachedBusinessList<ProductCombo> {
  CachedCombos() {
    key = 'combos';
  }

  factory CachedCombos.fromJson(Map<String, dynamic> json) =>
      _$CachedCombosFromJson(json);

  Map<String, dynamic> toJson() => _$CachedCombosToJson(this);
}

@JsonSerializable()
class CachedModifiers extends CachedBusinessList<ProductModifier> {
  CachedModifiers() {
    key = 'modifiers';
  }

  factory CachedModifiers.fromJson(Map<String, dynamic> json) =>
      _$CachedModifiersFromJson(json);

  Map<String, dynamic> toJson() => _$CachedModifiersToJson(this);
}

@JsonSerializable()
class CachedCustomers extends CachedBusinessList<Customer> {
  CachedCustomers() {
    key = 'customers';
  }

  factory CachedCustomers.fromJson(Map<String, dynamic> json) =>
      _$CachedCustomersFromJson(json);

  Map<String, dynamic> toJson() => _$CachedCustomersToJson(this);
}

@JsonSerializable()
class CachedSales extends CachedBusinessList<CheckoutTransaction> {
  CachedSales() {
    key = 'sales';
  }

  factory CachedSales.fromJson(Map<String, dynamic> json) =>
      _$CachedSalesFromJson(json);

  Map<String, dynamic> toJson() => _$CachedSalesToJson(this);
}

@JsonSerializable()
class CachedEmployees extends CachedBusinessList<Employee> {
  CachedEmployees() {
    key = 'employees';
  }

  factory CachedEmployees.fromJson(Map<String, dynamic> json) =>
      _$CachedEmployeesFromJson(json);

  Map<String, dynamic> toJson() => _$CachedEmployeesToJson(this);
}
