// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/user_preferences/user_preferences_actions.dart';
import 'package:littlefish_merchant/redux/user_preferences/user_preferences_state.dart';

final userPreferenceReducer = combineReducers<UserPreferencesState>([
  TypedReducer<UserPreferencesState, SetUserPreference>(onSetUserPref).call,
  TypedReducer<UserPreferencesState, RemoveUserPreference>(
    onRemoveUserPreference,
  ).call,
]);

UserPreferencesState onSetUserPref(
  UserPreferencesState state,
  SetUserPreference action,
) {
  //logger.debug(this,'recieved set user pref event');

  return state.rebuild((b) {
    var index = state.preferences!.indexWhere((i) => i.key == action.key);
    if (index >= 0) {
      b.preferences = state.preferences?..[index].data = action.value;
    } else {
      b.preferences = b.preferences
        ?..add(UIStateItem(action.key, action.value));
    }
  });
}

UserPreferencesState onRemoveUserPreference(
  UserPreferencesState state,
  RemoveUserPreference action,
) => state.rebuild(
  (b) => b.preferences?..removeWhere((p) => p.key == action.key),
);
