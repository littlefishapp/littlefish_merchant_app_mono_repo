// Package imports:
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:littlefish_merchant/models/shared/simple_data_item.dart';
import 'package:littlefish_merchant/models/stock/stock_take_item.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'stock_run.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class StockRun extends BusinessDataItem {
  StockRun({this.capturerName, this.items, this.runNumber, this.isNew = false});

  StockRun.create() {
    id = const Uuid().v4();
    enabled = true;
    deleted = false;
    dateCreated = DateTime.now().toUtc();
    items = <StockTakeItem>[];
    isNew = true;
  }

  @JsonKey(defaultValue: false, includeFromJson: true, includeToJson: true)
  bool? isNew;

  String? capturerName;

  int? runNumber;

  @JsonKey(name: 'entries')
  List<StockTakeItem>? items;

  factory StockRun.fromJson(Map<String, dynamic> json) =>
      _$StockRunFromJson(json);

  Map<String, dynamic> toJson() => _$StockRunToJson(this);
}
