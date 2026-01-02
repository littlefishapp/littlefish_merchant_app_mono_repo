// Package imports:
import 'package:built_value/built_value.dart';

part 'ui_entity_list_state.g.dart';

abstract class UIEntityListState
    implements Built<UIEntityListState, UIEntityListStateBuilder> {
  factory UIEntityListState() {
    return _$UIEntityListState._();
  }

  UIEntityListState._();
}
