part of 'single_linked_device_bloc.dart';

class CheckSoftPosEnrolmentEvent extends SingleLinkedDeviceEvent {
  final Terminal terminal;
  CheckSoftPosEnrolmentEvent(this.terminal);

  @override
  List<Object?> get props => [terminal];
}

abstract class SingleLinkedDeviceEvent extends Equatable {}

class InitializeDeviceEvent extends SingleLinkedDeviceEvent {
  final Terminal terminal;

  InitializeDeviceEvent(this.terminal);

  @override
  List<Object> get props => [terminal];
}

class EditButtonPressedEvent extends SingleLinkedDeviceEvent {
  final Terminal terminal;

  EditButtonPressedEvent(this.terminal);
  @override
  List<Object> get props => [terminal];
}

class RegisterDeviceButtonPressedEvent extends SingleLinkedDeviceEvent {
  final Terminal terminal;
  final bool enabled;
  final bool isCurrentDevice;

  RegisterDeviceButtonPressedEvent(
    this.terminal,
    this.enabled,
    this.isCurrentDevice,
  );
  @override
  List<Object> get props => [terminal, enabled, isCurrentDevice];
}

class DeRegisterDeviceButtonPressedEvent extends SingleLinkedDeviceEvent {
  final Terminal terminal;
  final bool enabled;
  final bool isCurrentDevice;

  DeRegisterDeviceButtonPressedEvent(
    this.terminal,
    this.enabled,
    this.isCurrentDevice,
  );
  @override
  List<Object> get props => [terminal, enabled, isCurrentDevice];
}

class CancelButtonPressedEvent extends SingleLinkedDeviceEvent {
  CancelButtonPressedEvent();

  @override
  List<Object> get props => [];
}

class SaveTerminalDetailsEvent extends SingleLinkedDeviceEvent {
  SaveTerminalDetailsEvent();

  @override
  List<Object?> get props => [];
}

class SetCardEnabledEvent extends SingleLinkedDeviceEvent {
  final bool enabled;

  SetCardEnabledEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class SetDisplayNameEvent extends SingleLinkedDeviceEvent {
  final String displayName;

  SetDisplayNameEvent(this.displayName);

  @override
  List<Object?> get props => [displayName];
}

class SetViewModeEvent extends SingleLinkedDeviceEvent {
  final Terminal terminal;
  SetViewModeEvent(this.terminal);

  @override
  List<Object?> get props => [];
}

class SetStatusEvent extends SingleLinkedDeviceEvent {
  final String status;

  SetStatusEvent(this.status);

  @override
  List<Object?> get props => [status];
}

class RegisterTerminalProviderResponseEvent extends SingleLinkedDeviceEvent {
  final String senderDeviceId;
  final String message;
  final bool success;
  final String deviceId;

  RegisterTerminalProviderResponseEvent({
    required this.senderDeviceId,
    required this.message,
    required this.success,
    required this.deviceId,
  });

  @override
  List<Object> get props => [senderDeviceId, message, success, deviceId];
}
