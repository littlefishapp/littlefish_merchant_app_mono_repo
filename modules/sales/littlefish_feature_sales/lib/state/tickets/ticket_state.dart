// Package imports:
import 'package:built_value/built_value.dart';
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/sales/tickets/ticket.dart';
import 'package:littlefish_merchant/redux/ui/ui_entity_state.dart';

part 'ticket_state.g.dart';

@JsonSerializable()
abstract class TicketState implements Built<TicketState, TicketStateBuilder> {
  TicketState._();

  factory TicketState() => _$TicketState._(
    hasError: false,
    isLoading: false,
    errorMessage: null,
    tickets: <Ticket>[],
  );

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isLoading;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get hasError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get errorMessage;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get searchText;

  List<Ticket?>? get tickets;
}

abstract class TicketUIState
    implements Built<TicketUIState, TicketUIStateBuilder> {
  factory TicketUIState() => _$TicketUIState._(
    item: UIEntityState<Ticket>(Ticket.create(), isNew: true),
  );

  TicketUIState._();

  UIEntityState<Ticket>? get item;

  bool get isNew => item?.isNew ?? false;
}
