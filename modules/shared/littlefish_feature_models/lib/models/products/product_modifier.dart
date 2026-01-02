// Package imports:
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:littlefish_merchant/models/shared/simple_data_item.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'product_modifier.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class ProductModifier extends BusinessDataItem {
  ProductModifier({
    this.maxSelection,
    this.modifiers,
    this.multiSelect,
    this.isNew = false,
  });

  ProductModifier.create() {
    id = const Uuid().v4();
    multiSelect = false;
    modifiers = [];
    enabled = true;
    deleted = false;
    isNew = true;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? isNew;

  @JsonKey(defaultValue: false, name: 'multipleSelection')
  bool? multiSelect;

  int? maxSelection;

  List<Modifier>? modifiers;

  Modifier addItem() {
    var newItem = Modifier(id: const Uuid().v4());

    if (modifiers == null) {
      modifiers = [newItem];
    } else {
      modifiers!.add(newItem);
    }

    return newItem;
  }

  removeItem(String? id) {
    modifiers?.removeWhere((m) => m.id == id);
  }

  factory ProductModifier.fromJson(Map<String, dynamic> json) =>
      _$ProductModifierFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModifierToJson(this);
}

@JsonSerializable()
class Modifier {
  Modifier({this.id, this.name, this.price});

  String? id, name;

  double? price;

  factory Modifier.fromJson(Map<String, dynamic> json) =>
      _$ModifierFromJson(json);

  Map<String, dynamic> toJson() => _$ModifierToJson(this);
}
