// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:

part 'bq_report_dictionary.g.dart';

@JsonSerializable()
class BqReportDictionary {
  BqReportDictionary({this.reportDictionary});

  Map<String, List<dynamic>>? reportDictionary;
}
