// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/workspaces/workspace_actions.dart';
import 'package:littlefish_merchant/redux/workspaces/workspace_state.dart';

final workspacesReducer = combineReducers<WorkspaceState>([
  TypedReducer<WorkspaceState, SetWorkspaceAction>(onSetWorkspace).call,
  TypedReducer<WorkspaceState, WorkspacesLoadedAction>(onWorkspacesLoaded).call,
  TypedReducer<WorkspaceState, SetWorkspaceLoadingAction>(onSetLoading).call,
  TypedReducer<WorkspaceState, ManageControlExpandedStateAction>(
    onWorkspacesSetMenuExpanded,
  ).call,
  TypedReducer<WorkspaceState, ManageControlSetMenuExpandedStateAction>(
    onWorkspacesSetMenuExpandedState,
  ).call,
]);

WorkspaceState onSetWorkspace(
  WorkspaceState state,
  SetWorkspaceAction action,
) => state.rebuild((b) => b.selectedWorkspace = action.value);

WorkspaceState onSetLoading(
  WorkspaceState state,
  SetWorkspaceLoadingAction action,
) => state.rebuild((b) => b.isLoading = action.value);

WorkspaceState onWorkspacesLoaded(
  WorkspaceState state,
  WorkspacesLoadedAction action,
) => state.rebuild((b) => b.workspaces = action.value);

// TODO(tshief-littlefishapp): Move value out into own redux state
WorkspaceState onWorkspacesSetMenuExpanded(
  WorkspaceState state,
  ManageControlExpandedStateAction action,
) {
  return state.rebuild((b) {
    b.manageControlMenuExpandedStates ??= [false, false, false];
    b.manageControlMenuExpandedStates![action.index] = action.isOpen;
  });
}

// TODO:(tshief-littlefishapp): Move value out into own redux state
WorkspaceState onWorkspacesSetMenuExpandedState(
  WorkspaceState state,
  ManageControlSetMenuExpandedStateAction action,
) => state.rebuild((b) => b.manageControlMenuExpandedStates = action.value);
