// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bq_report_dictionary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BqReportDictionary _$BqReportDictionaryFromJson(Map<String, dynamic> json) =>
    BqReportDictionary(
      reportDictionary: (json['reportDictionary'] as Map<String, dynamic>?)
          ?.map((k, e) => MapEntry(k, e as List<dynamic>)),
    );

Map<String, dynamic> _$BqReportDictionaryToJson(BqReportDictionary instance) =>
    <String, dynamic>{'reportDictionary': instance.reportDictionary};
