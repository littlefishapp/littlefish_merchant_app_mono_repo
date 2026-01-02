// Package imports:
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:littlefish_merchant/models/promotions/promotion_item.dart';
import 'package:littlefish_merchant/models/shared/simple_data_item.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'promotion.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class Promotion extends BusinessDataItem {
  Promotion({
    this.endDate,
    this.items,
    this.startDate,
    this.totalCost,
    this.totalValue,
  });

  Promotion.createNew() {
    enabled = true;
    deleted = false;
    startDate = DateTime.now().toUtc();
    endDate = startDate!.add(const Duration(days: 7));
    id = const Uuid().v4();
    items = [];
  }

  DateTime? startDate, endDate;

  @JsonKey(name: 'costPrice', defaultValue: 0)
  double? totalCost;

  @JsonKey(name: 'sellingPrice', defaultValue: 0)
  double? totalValue;

  @JsonKey(defaultValue: <PromotionItem>[])
  List<PromotionItem>? items;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isActive {
    if (enabled == null || !enabled!) return false;

    if (startDate == null) return false;

    if (endDate == null) return false;

    if (endDate!.isBefore(DateTime.now())) {
      return false;
    }

    if (DateTime.now().difference(startDate!).inDays < 0) return false;

    if (endDate!.difference(DateTime.now()).inDays < 0) return false;

    return true;
  }

  factory Promotion.fromJson(Map<String, dynamic> json) =>
      _$PromotionFromJson(json);

  Map<String, dynamic> toJson() => _$PromotionToJson(this);
}

enum PromoItemType { product, combo }
