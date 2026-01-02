// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_points.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserScoreCard _$UserScoreCardFromJson(Map<String, dynamic> json) =>
    UserScoreCard(
      events: (json['events'] as List<dynamic>?)
          ?.map((e) => UserScoreEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      goals: (json['goals'] as List<dynamic>?)
          ?.map((e) => UserScoreGoal.fromJson(e as Map<String, dynamic>))
          .toList(),
      levels: (json['levels'] as List<dynamic>?)
          ?.map((e) => UserScoreLevel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserScoreCardToJson(UserScoreCard instance) =>
    <String, dynamic>{
      'levels': instance.levels?.map((e) => e.toJson()).toList(),
      'events': instance.events?.map((e) => e.toJson()).toList(),
      'goals': instance.goals?.map((e) => e.toJson()).toList(),
    };

UserScoreLevel _$UserScoreLevelFromJson(Map<String, dynamic> json) =>
    UserScoreLevel(
      end: (json['End'] as num?)?.toInt(),
      friendlyName: json['Friendly Name'] as String?,
      level: (json['Level'] as num?)?.toInt(),
      start: (json['Start'] as num?)?.toInt(),
      theme: json['Theme'] as String?,
    )..color = json['Color'] as String?;

Map<String, dynamic> _$UserScoreLevelToJson(UserScoreLevel instance) =>
    <String, dynamic>{
      'Level': instance.level,
      'Friendly Name': instance.friendlyName,
      'Start': instance.start,
      'End': instance.end,
      'Theme': instance.theme,
      'Color': instance.color,
    };

UserScoreEvent _$UserScoreEventFromJson(Map<String, dynamic> json) =>
    UserScoreEvent(
      description: json['description'] as String?,
      eventId: json['eventId'] as String?,
      value: (json['value'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$UserScoreEventToJson(UserScoreEvent instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'description': instance.description,
      'value': instance.value,
    };

UserScoreGoal _$UserScoreGoalFromJson(Map<String, dynamic> json) =>
    UserScoreGoal(
      description: json['description'] as String?,
      eventId: json['eventId'] as String?,
      goalId: json['goalId'] as String?,
      name: json['name'] as String?,
      qty: (json['qty'] as num?)?.toInt(),
      claimed: json['claimed'] as bool? ?? false,
    );

Map<String, dynamic> _$UserScoreGoalToJson(UserScoreGoal instance) =>
    <String, dynamic>{
      'goalId': instance.goalId,
      'eventId': instance.eventId,
      'name': instance.name,
      'description': instance.description,
      'qty': instance.qty,
      'claimed': instance.claimed,
    };
