// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WorkspaceState extends WorkspaceState {
  @override
  final Workspace? selectedWorkspace;
  @override
  final List<Workspace>? workspaces;
  @override
  final bool? isLoading;
  @override
  final List<bool>? manageControlMenuExpandedStates;

  factory _$WorkspaceState([void Function(WorkspaceStateBuilder)? updates]) =>
      (WorkspaceStateBuilder()..update(updates))._build();

  _$WorkspaceState._({
    this.selectedWorkspace,
    this.workspaces,
    this.isLoading,
    this.manageControlMenuExpandedStates,
  }) : super._();
  @override
  WorkspaceState rebuild(void Function(WorkspaceStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkspaceStateBuilder toBuilder() => WorkspaceStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkspaceState &&
        selectedWorkspace == other.selectedWorkspace &&
        workspaces == other.workspaces &&
        isLoading == other.isLoading &&
        manageControlMenuExpandedStates ==
            other.manageControlMenuExpandedStates;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, selectedWorkspace.hashCode);
    _$hash = $jc(_$hash, workspaces.hashCode);
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, manageControlMenuExpandedStates.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WorkspaceState')
          ..add('selectedWorkspace', selectedWorkspace)
          ..add('workspaces', workspaces)
          ..add('isLoading', isLoading)
          ..add(
            'manageControlMenuExpandedStates',
            manageControlMenuExpandedStates,
          ))
        .toString();
  }
}

class WorkspaceStateBuilder
    implements Builder<WorkspaceState, WorkspaceStateBuilder> {
  _$WorkspaceState? _$v;

  Workspace? _selectedWorkspace;
  Workspace? get selectedWorkspace => _$this._selectedWorkspace;
  set selectedWorkspace(Workspace? selectedWorkspace) =>
      _$this._selectedWorkspace = selectedWorkspace;

  List<Workspace>? _workspaces;
  List<Workspace>? get workspaces => _$this._workspaces;
  set workspaces(List<Workspace>? workspaces) =>
      _$this._workspaces = workspaces;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  List<bool>? _manageControlMenuExpandedStates;
  List<bool>? get manageControlMenuExpandedStates =>
      _$this._manageControlMenuExpandedStates;
  set manageControlMenuExpandedStates(
    List<bool>? manageControlMenuExpandedStates,
  ) =>
      _$this._manageControlMenuExpandedStates = manageControlMenuExpandedStates;

  WorkspaceStateBuilder();

  WorkspaceStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _selectedWorkspace = $v.selectedWorkspace;
      _workspaces = $v.workspaces;
      _isLoading = $v.isLoading;
      _manageControlMenuExpandedStates = $v.manageControlMenuExpandedStates;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkspaceState other) {
    _$v = other as _$WorkspaceState;
  }

  @override
  void update(void Function(WorkspaceStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkspaceState build() => _build();

  _$WorkspaceState _build() {
    final _$result =
        _$v ??
        _$WorkspaceState._(
          selectedWorkspace: selectedWorkspace,
          workspaces: workspaces,
          isLoading: isLoading,
          manageControlMenuExpandedStates: manageControlMenuExpandedStates,
        );
    replace(_$result);
    return _$result;
  }
}

class _$WorkspaceUIState extends WorkspaceUIState {
  @override
  final UIEntityState<Workspace>? item;

  factory _$WorkspaceUIState([
    void Function(WorkspaceUIStateBuilder)? updates,
  ]) => (WorkspaceUIStateBuilder()..update(updates))._build();

  _$WorkspaceUIState._({this.item}) : super._();
  @override
  WorkspaceUIState rebuild(void Function(WorkspaceUIStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkspaceUIStateBuilder toBuilder() =>
      WorkspaceUIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkspaceUIState && item == other.item;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, item.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'WorkspaceUIState',
    )..add('item', item)).toString();
  }
}

class WorkspaceUIStateBuilder
    implements Builder<WorkspaceUIState, WorkspaceUIStateBuilder> {
  _$WorkspaceUIState? _$v;

  UIEntityState<Workspace>? _item;
  UIEntityState<Workspace>? get item => _$this._item;
  set item(UIEntityState<Workspace>? item) => _$this._item = item;

  WorkspaceUIStateBuilder();

  WorkspaceUIStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _item = $v.item;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkspaceUIState other) {
    _$v = other as _$WorkspaceUIState;
  }

  @override
  void update(void Function(WorkspaceUIStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkspaceUIState build() => _build();

  _$WorkspaceUIState _build() {
    final _$result = _$v ?? _$WorkspaceUIState._(item: item);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkspaceState _$WorkspaceStateFromJson(Map<String, dynamic> json) =>
    WorkspaceState();

Map<String, dynamic> _$WorkspaceStateToJson(
  WorkspaceState instance,
) => <String, dynamic>{
  'manageControlMenuExpandedStates': instance.manageControlMenuExpandedStates,
};
