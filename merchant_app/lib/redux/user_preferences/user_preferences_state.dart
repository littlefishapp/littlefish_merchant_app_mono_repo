// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:built_value/built_value.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_preferences_state.g.dart';

@immutable
abstract class UserPreferencesState
    implements Built<UserPreferencesState, UserPreferencesStateBuilder> {
  const UserPreferencesState._();

  factory UserPreferencesState() => _$UserPreferencesState._(
    hasError: false,
    isLoading: false,
    errorMessage: null,
    preferences: const [],
  );

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isLoading;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get hasError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get errorMessage;

  List<UIStateItem>? get preferences;

  T? getUserPreferenceByKey<T>(String key) {
    if (preferences == null || preferences!.isEmpty) return null;

    return preferences!.firstWhere((pref) => pref.key == key).data;
  }
}

class UIStateItem {
  String key;

  dynamic data;

  UIStateItem(this.key, this.data);
}
