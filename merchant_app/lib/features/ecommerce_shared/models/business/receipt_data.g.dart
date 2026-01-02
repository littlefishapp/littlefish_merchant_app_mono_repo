// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceiptData _$ReceiptDataFromJson(Map<String, dynamic> json) => ReceiptData(
  displayCustomer: json['displayCustomer'] as bool? ?? true,
  displayInstagramHandle: json['displayInstagramHandle'] as bool? ?? true,
  displaySeller: json['displaySeller'] as bool? ?? true,
  displayWhatsappLine: json['displayWhatsappLine'] as bool? ?? true,
  footer: json['footer'] as String?,
  header: json['header'] as String?,
);

Map<String, dynamic> _$ReceiptDataToJson(ReceiptData instance) =>
    <String, dynamic>{
      'header': instance.header,
      'footer': instance.footer,
      'displayCustomer': instance.displayCustomer,
      'displaySeller': instance.displaySeller,
      'displayInstagramHandle': instance.displayInstagramHandle,
      'displayWhatsappLine': instance.displayWhatsappLine,
    };
