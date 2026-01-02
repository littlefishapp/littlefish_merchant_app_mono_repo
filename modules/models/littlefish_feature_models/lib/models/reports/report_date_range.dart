// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/enums.dart';

part 'report_date_range.g.dart';

@JsonSerializable()
class ReportDateRange {
  ReportDateRange({
    this.seriesName,
    this.startDate,
    this.endDate,
    this.mode,
    this.seriesNo,
    this.isDeleted,
  });

  String? seriesName;
  String? startDate;
  String? endDate;
  ReportMode? mode;
  int? seriesNo;
  bool? isDeleted;

  factory ReportDateRange.fromJson(Map<String, dynamic> json) =>
      _$ReportDateRangeFromJson(json);

  Map<String, dynamic> toJson() => _$ReportDateRangeToJson(this);
}
