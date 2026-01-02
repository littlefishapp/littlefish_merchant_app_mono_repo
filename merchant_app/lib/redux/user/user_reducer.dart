// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/redux/user/user_actions.dart';
import 'package:littlefish_merchant/redux/user/user_state.dart';

final userProfileReducer = combineReducers<UserState>([
  TypedReducer<UserState, SetUserStateLoadingAction>(onSetLoading).call,
  TypedReducer<UserState, SetIsGuestUserAction>(onSetIsGuestUser).call,
  TypedReducer<UserState, UserProfileLoadFailure>(onProfileFailure).call,
  TypedReducer<UserState, UserProfileLoadedAction>(onSetUserProfile).call,
  TypedReducer<UserState, SetUserLocationAction>(onSetUserLocation).call,
  TypedReducer<UserState, SignoutAction>(onClearState).call,
  TypedReducer<UserState, SetUserViewingModeAction>(onSetUserViewMode).call,
  TypedReducer<UserState, UserProfileRolesLoadedAction>(
    onSetUserProfileRoles,
  ).call,
  TypedReducer<UserState, UserProfileRolesLoadFailure>(
    onSetProfileRolesFailure,
  ).call,
]);

UserState onClearState(UserState state, SignoutAction action) =>
    state.rebuild((b) {
      b.isLoading = false;
      b.hasError = false;
      b.errorMessage = null;
      b.userBusinessRoles = null;
      b.profile = null;
      b.permissions = null;
    });
UserState onSetIsGuestUser(UserState state, SetIsGuestUserAction action) {
  return state.rebuild((b) {
    b.isGuestUser = action.value;
  });
}

UserState onSetLoading(UserState state, SetUserStateLoadingAction action) {
  return state.rebuild((b) {
    b.isLoading = action.value;
  });
}

UserState onProfileFailure(UserState state, UserProfileLoadFailure action) {
  return state.rebuild((b) {
    b.errorMessage = action.value;
    b.hasError = true;
    b.isLoading = false;
  });
}

UserState onSetUserProfile(UserState state, UserProfileLoadedAction action) {
  return state.rebuild((b) {
    b.errorMessage = null;
    b.hasError = false;
    b.profile = action.value;
    b.isLoading = false;
  });
}

UserState onSetUserLocation(UserState state, SetUserLocationAction action) =>
    state.rebuild((b) => b.location = action.value);

UserState onSetUserViewMode(UserState state, SetUserViewingModeAction action) =>
    state.rebuild((b) {
      b.viewMode = action.value;
      b.canChangeViewMode = action.canChangeView;
    });

UserState onSetUserProfileRoles(
  UserState state,
  UserProfileRolesLoadedAction action,
) => state.rebuild((b) => b.userBusinessRoles = action.value);

UserState onSetProfileRolesFailure(
  UserState state,
  UserProfileRolesLoadFailure action,
) {
  return state.rebuild((b) {
    b.errorMessage = action.value;
    b.hasError = true;
    b.isLoading = false;
  });
}
