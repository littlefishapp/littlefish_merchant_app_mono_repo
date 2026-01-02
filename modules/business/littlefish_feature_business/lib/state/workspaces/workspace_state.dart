// Package imports:
import 'package:built_value/built_value.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/models/workspaces/workspace.dart';

import '../ui/ui_entity_state.dart';

// Project imports:
part 'workspace_state.g.dart';

@JsonSerializable()
abstract class WorkspaceState
    implements Built<WorkspaceState, WorkspaceStateBuilder> {
  WorkspaceState._();

  factory WorkspaceState() => _$WorkspaceState._(
    selectedWorkspace: null,
    workspaces: <Workspace>[],
    isLoading: false,
  );

  @JsonKey(includeFromJson: false, includeToJson: false)
  Workspace? get selectedWorkspace;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Workspace>? get workspaces;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isLoading;

  // TODO(tshief-littlefishapp): Move value out into own redux state
  @JsonKey(includeFromJson: true, includeToJson: true)
  List<bool>? get manageControlMenuExpandedStates;
}

abstract class WorkspaceUIState
    implements Built<WorkspaceUIState, WorkspaceUIStateBuilder> {
  factory WorkspaceUIState() => _$WorkspaceUIState._();

  WorkspaceUIState._();
  UIEntityState<Workspace>? get item;
  bool get isNew => item?.isNew ?? false;
}
