// Package imports:
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'order_setting.g.dart';

@JsonSerializable()
class OrderSetting {
  String? id;

  String? businessId;

  bool? enabled;

  DateTime? dateUpdated;

  DateTime? dateCreated;

  String? createdBy;

  String? updatedBy;

  List<OrderSettingItem>? items;

  OrderSetting(this.enabled, this.items);

  factory OrderSetting.fromJson(Map<String, dynamic> json) =>
      _$OrderSettingFromJson(json);

  Map<String, dynamic> toJson() => _$OrderSettingToJson(this);
}

@JsonSerializable()
class OrderSettingItem {
  String? id;

  String? name;

  OrderSettingItem({this.id, this.name});

  OrderSettingItem.create(this.name) {
    id = const Uuid().v4();
  }

  factory OrderSettingItem.fromJson(Map<String, dynamic> json) =>
      _$OrderSettingItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderSettingItemToJson(this);
}
