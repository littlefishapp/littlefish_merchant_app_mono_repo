import 'package:json_annotation/json_annotation.dart';

part 'user_points.g.dart';

@JsonSerializable(explicitToJson: true)
class UserScoreCard {
  UserScoreCard({this.events, this.goals, this.levels});

  List<UserScoreLevel>? levels;

  List<UserScoreEvent>? events;

  List<UserScoreGoal>? goals;

  factory UserScoreCard.fromJson(Map<String, dynamic> json) =>
      _$UserScoreCardFromJson(json);

  Map<String, dynamic> toJson() => _$UserScoreCardToJson(this);
}

@JsonSerializable()
class UserScoreLevel {
  UserScoreLevel({
    this.end,
    this.friendlyName,
    this.level,
    this.start,
    this.theme,
  });

  @JsonKey(name: 'Level')
  int? level;

  @JsonKey(name: 'Friendly Name')
  String? friendlyName;

  @JsonKey(name: 'Start')
  int? start;

  @JsonKey(name: 'End')
  int? end;

  @JsonKey(name: 'Theme')
  String? theme;

  @JsonKey(name: 'Color')
  String? color;

  factory UserScoreLevel.fromJson(Map<String, dynamic> json) =>
      _$UserScoreLevelFromJson(json);

  Map<String, dynamic> toJson() => _$UserScoreLevelToJson(this);
}

@JsonSerializable()
class UserScoreEvent {
  UserScoreEvent({this.description, this.eventId, this.value});

  @JsonKey(name: 'eventId')
  String? eventId;

  @JsonKey(name: 'description')
  String? description;

  @JsonKey(name: 'value')
  double? value;

  factory UserScoreEvent.fromJson(Map<String, dynamic> json) =>
      _$UserScoreEventFromJson(json);

  Map<String, dynamic> toJson() => _$UserScoreEventToJson(this);
}

@JsonSerializable()
class UserScoreGoal {
  UserScoreGoal({
    this.description,
    this.eventId,
    this.goalId,
    this.name,
    this.qty,
    this.claimed,
  });

  @JsonKey(name: 'goalId')
  String? goalId;

  @JsonKey(name: 'eventId')
  String? eventId;

  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'description')
  String? description;

  @JsonKey(name: 'qty')
  int? qty;

  @JsonKey(defaultValue: false)
  bool? claimed;

  factory UserScoreGoal.fromJson(Map<String, dynamic> json) =>
      _$UserScoreGoalFromJson(json);

  Map<String, dynamic> toJson() => _$UserScoreGoalToJson(this);
}
