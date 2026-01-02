// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart' show IterableExtension;
import 'package:json_annotation/json_annotation.dart';

part 'score.g.dart';

@JsonSerializable()
class Score {
  String? description;
  String? recommendation;
  double? value;
  double? max;
  bool? showRecommendation;

  Score({
    this.description,
    this.value,
    this.max,
    this.recommendation,
    this.showRecommendation,
  });

  factory Score.fromJson(Map<String, dynamic> json) => _$ScoreFromJson(json);

  Map<String, dynamic> toJson() => _$ScoreToJson(this);
}

@JsonSerializable()
class SalesScore {
  List<Score>? items;
  double? max;
  double? score;
  String? description;

  SalesScore({this.max, this.description, this.items, this.score});

  factory SalesScore.fromJson(Map<String, dynamic> json) =>
      _$SalesScoreFromJson(json);

  Map<String, dynamic> toJson() => _$SalesScoreToJson(this);
}

@JsonSerializable()
class GrowthScore {
  List<Score>? items;
  double? max;
  double? score;
  String? description;

  GrowthScore({this.max, this.description, this.items, this.score});

  factory GrowthScore.fromJson(Map<String, dynamic> json) =>
      _$GrowthScoreFromJson(json);

  Map<String, dynamic> toJson() => _$GrowthScoreToJson(this);
}

@JsonSerializable()
class SystemUseScore {
  List<Score>? items;
  double? max;
  double? score;
  String? description;

  SystemUseScore({this.max, this.description, this.items, this.score});

  factory SystemUseScore.fromJson(Map<String, dynamic> json) =>
      _$SystemUseScoreFromJson(json);

  Map<String, dynamic> toJson() => _$SystemUseScoreToJson(this);
}

@JsonSerializable()
class Penalties {
  List<Score>? items;
  double? max;
  double? score;
  String? description;

  Penalties({this.max, this.description, this.items, this.score});

  factory Penalties.fromJson(Map<String, dynamic> json) =>
      _$PenaltiesFromJson(json);

  Map<String, dynamic> toJson() => _$PenaltiesToJson(this);
}

@JsonSerializable()
class BusinessPerformanceScore {
  SalesScore? sales;
  GrowthScore? growth;
  SystemUseScore? systemUse;
  Penalties? penalties;
  double? score;
  double? finalScore;
  double? max;
  double? loanLimit;

  BusinessPerformanceScore({
    this.score,
    this.loanLimit,
    this.max,
    this.finalScore,
    this.growth,
    this.penalties,
    this.sales,
    this.systemUse,
  });

  Color? getColor(double? firstScore, double? secondScore) {
    if (firstScore == null ||
        secondScore == null ||
        secondScore == 0 ||
        firstScore > secondScore) {
      return null;
    }
    double percent = (firstScore / secondScore) * 10;

    var value = colorMap.entries
        .firstWhereOrNull((x) => x.key >= percent)
        ?.value;

    return value;
  }

  Color? get mapColor {
    if (finalScore == null) return Colors.red;

    return colorMap.entries
        .firstWhereOrNull((x) => x.key <= finalScore!)
        ?.value;
  }

  Map<double, Color> get colorMap => {
    4: Colors.red,
    5: Colors.orange,
    6: Colors.yellow,
    10: Colors.green,
  };

  factory BusinessPerformanceScore.fromJson(Map<String, dynamic> json) =>
      _$BusinessPerformanceScoreFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessPerformanceScoreToJson(this);
}
