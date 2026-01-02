import 'package:json_annotation/json_annotation.dart';

import '../../../../tools/converters/iso_date_time_converter.dart';

part 'receipt_data.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class ReceiptData {
  ReceiptData({
    this.displayCustomer = true,
    this.displayInstagramHandle = true,
    this.displaySeller = true,
    this.displayWhatsappLine = true,
    this.footer,
    this.header,
  });

  String? header;

  String? footer;

  bool displayCustomer;

  bool displaySeller;

  bool displayInstagramHandle;

  bool displayWhatsappLine;

  factory ReceiptData.fromJson(Map<String, dynamic> json) =>
      _$ReceiptDataFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiptDataToJson(this);
}
