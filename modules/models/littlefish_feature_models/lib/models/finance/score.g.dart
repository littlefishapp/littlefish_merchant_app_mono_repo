// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Score _$ScoreFromJson(Map<String, dynamic> json) => Score(
  description: json['description'] as String?,
  value: (json['value'] as num?)?.toDouble(),
  max: (json['max'] as num?)?.toDouble(),
  recommendation: json['recommendation'] as String?,
  showRecommendation: json['showRecommendation'] as bool?,
);

Map<String, dynamic> _$ScoreToJson(Score instance) => <String, dynamic>{
  'description': instance.description,
  'recommendation': instance.recommendation,
  'value': instance.value,
  'max': instance.max,
  'showRecommendation': instance.showRecommendation,
};

SalesScore _$SalesScoreFromJson(Map<String, dynamic> json) => SalesScore(
  max: (json['max'] as num?)?.toDouble(),
  description: json['description'] as String?,
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => Score.fromJson(e as Map<String, dynamic>))
      .toList(),
  score: (json['score'] as num?)?.toDouble(),
);

Map<String, dynamic> _$SalesScoreToJson(SalesScore instance) =>
    <String, dynamic>{
      'items': instance.items,
      'max': instance.max,
      'score': instance.score,
      'description': instance.description,
    };

GrowthScore _$GrowthScoreFromJson(Map<String, dynamic> json) => GrowthScore(
  max: (json['max'] as num?)?.toDouble(),
  description: json['description'] as String?,
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => Score.fromJson(e as Map<String, dynamic>))
      .toList(),
  score: (json['score'] as num?)?.toDouble(),
);

Map<String, dynamic> _$GrowthScoreToJson(GrowthScore instance) =>
    <String, dynamic>{
      'items': instance.items,
      'max': instance.max,
      'score': instance.score,
      'description': instance.description,
    };

SystemUseScore _$SystemUseScoreFromJson(Map<String, dynamic> json) =>
    SystemUseScore(
      max: (json['max'] as num?)?.toDouble(),
      description: json['description'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => Score.fromJson(e as Map<String, dynamic>))
          .toList(),
      score: (json['score'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SystemUseScoreToJson(SystemUseScore instance) =>
    <String, dynamic>{
      'items': instance.items,
      'max': instance.max,
      'score': instance.score,
      'description': instance.description,
    };

Penalties _$PenaltiesFromJson(Map<String, dynamic> json) => Penalties(
  max: (json['max'] as num?)?.toDouble(),
  description: json['description'] as String?,
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => Score.fromJson(e as Map<String, dynamic>))
      .toList(),
  score: (json['score'] as num?)?.toDouble(),
);

Map<String, dynamic> _$PenaltiesToJson(Penalties instance) => <String, dynamic>{
  'items': instance.items,
  'max': instance.max,
  'score': instance.score,
  'description': instance.description,
};

BusinessPerformanceScore _$BusinessPerformanceScoreFromJson(
  Map<String, dynamic> json,
) => BusinessPerformanceScore(
  score: (json['score'] as num?)?.toDouble(),
  loanLimit: (json['loanLimit'] as num?)?.toDouble(),
  max: (json['max'] as num?)?.toDouble(),
  finalScore: (json['finalScore'] as num?)?.toDouble(),
  growth: json['growth'] == null
      ? null
      : GrowthScore.fromJson(json['growth'] as Map<String, dynamic>),
  penalties: json['penalties'] == null
      ? null
      : Penalties.fromJson(json['penalties'] as Map<String, dynamic>),
  sales: json['sales'] == null
      ? null
      : SalesScore.fromJson(json['sales'] as Map<String, dynamic>),
  systemUse: json['systemUse'] == null
      ? null
      : SystemUseScore.fromJson(json['systemUse'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BusinessPerformanceScoreToJson(
  BusinessPerformanceScore instance,
) => <String, dynamic>{
  'sales': instance.sales,
  'growth': instance.growth,
  'systemUse': instance.systemUse,
  'penalties': instance.penalties,
  'score': instance.score,
  'finalScore': instance.finalScore,
  'max': instance.max,
  'loanLimit': instance.loanLimit,
};
