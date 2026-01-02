// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'receipt_data.g.dart';

@JsonSerializable()
class ReceiptData {
  ReceiptData({
    this.displayCustomer = true,
    this.displayInstagramHandle = true,
    this.displaySeller = true,
    this.displayWhatsappLine = true,
    this.displayAddress = true,
    this.displayPhoneNumber = true,
    this.footer,
    this.header,
    this.printLogo,
  });

  String? header;

  String? footer;

  @JsonKey(defaultValue: true)
  bool displayCustomer;

  @JsonKey(defaultValue: true)
  bool displaySeller;

  @JsonKey(defaultValue: true)
  bool displayInstagramHandle;

  @JsonKey(defaultValue: true)
  bool displayWhatsappLine;

  @JsonKey(defaultValue: true)
  bool displayAddress;

  @JsonKey(defaultValue: true)
  bool displayPhoneNumber;

  @JsonKey(defaultValue: true)
  bool? printLogo;

  factory ReceiptData.fromJson(Map<String, dynamic> json) =>
      _$ReceiptDataFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiptDataToJson(this);
}
