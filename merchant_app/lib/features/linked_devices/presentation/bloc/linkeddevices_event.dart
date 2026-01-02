part of 'linkeddevices_bloc.dart';

class LinkeddevicesEvent extends Equatable {
  const LinkeddevicesEvent();

  @override
  List<Object> get props => [];
}

class GetLinkedDevices extends LinkeddevicesEvent {}

class FilterLinkedDevices extends LinkeddevicesEvent {
  final String query;

  const FilterLinkedDevices(this.query);

  @override
  List<Object> get props => [query];
}

class GetMoreLinkedDevices extends LinkeddevicesEvent {}

class UpdateTerminalEvent extends LinkeddevicesEvent {
  final Terminal updatedTerminal;

  const UpdateTerminalEvent(this.updatedTerminal);

  @override
  List<Object> get props => [updatedTerminal];
}

class SchedulePushSaleTerminalEvent extends LinkeddevicesEvent {
  final CheckoutTransaction? transaction;

  const SchedulePushSaleTerminalEvent(this.transaction);
}

class DoPushSaleTerminalEvent extends LinkeddevicesEvent {
  final String terminalID;

  const DoPushSaleTerminalEvent(this.terminalID);

  @override
  List<Object> get props => [terminalID];
}

class CompletePushSaleTerminalEvent extends LinkeddevicesEvent {}

class HandleErrorPushSaleTerminalEvent extends LinkeddevicesEvent {}

class ScheduleDeviceManagement extends LinkeddevicesEvent {}
