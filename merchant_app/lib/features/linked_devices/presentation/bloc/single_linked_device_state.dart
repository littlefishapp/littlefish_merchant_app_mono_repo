part of 'single_linked_device_bloc.dart';

enum LinkedDeviceMode { view, edit, manage }

enum SingleLinkedDeviceStatus { initial, loading, loaded, error }

// class SingleLinkedDeviceState extends Equatable {
//   final Terminal? terminal;
//   final LinkedDeviceMode mode;
//   final SingleLinkedDeviceStatus status;

//   const SingleLinkedDeviceState({
//     this.terminal,
//     this.mode = LinkedDeviceMode.view,
//     this.status = SingleLinkedDeviceStatus.initial,
//   });

//   SingleLinkedDeviceState copyWith({
//     Terminal? terminal,
//     LinkedDeviceMode? mode,
//     SingleLinkedDeviceStatus? status,
//   }) {
//     return SingleLinkedDeviceState(
//       terminal: terminal ?? this.terminal,
//       mode: mode ?? this.mode,
//       status: status ?? this.status,
//     );
//   }

//   @override
//   List<Object> get props => [mode, status];
// }
abstract class SingleLinkedDeviceState extends Equatable {
  final Terminal? terminal;
  final bool isEnrolled;
  final bool isCurrentDevice;

  const SingleLinkedDeviceState({
    required this.terminal,
    this.isEnrolled = false,
    this.isCurrentDevice = false,
  });

  @override
  List<Object?> get props => [terminal, isEnrolled, isCurrentDevice];
}

class SingleLinkedDeviceStateInitial extends SingleLinkedDeviceState {
  const SingleLinkedDeviceStateInitial() : super(terminal: null);
}

class LoadingState extends SingleLinkedDeviceState {
  const LoadingState({Terminal? terminal}) : super(terminal: terminal);
}

class SoftErrorState extends SingleLinkedDeviceState {
  final String message;
  final String? callerMethod;
  final String? errorCode;
  final Object? error;
  const SoftErrorState({
    required this.message,
    this.callerMethod,
    this.errorCode,
    this.error,
  }) : super(terminal: null);
}

class HardErrorState extends SingleLinkedDeviceState {
  final String message;
  final String? callerMethod;
  final String? errorCode;
  final Object? error;
  const HardErrorState({
    required this.message,
    this.callerMethod,
    this.errorCode,
    this.error,
  }) : super(terminal: null);
}

class ViewState extends SingleLinkedDeviceState {
  const ViewState({
    required Terminal terminal,
    bool isEnrolled = false,
    bool isCurrentDevice = false,
  }) : super(
         terminal: terminal,
         isEnrolled: isEnrolled,
         isCurrentDevice: isCurrentDevice,
       );
}

class SaveSuccessState extends SingleLinkedDeviceState {
  const SaveSuccessState({required Terminal terminal, bool isEnrolled = false})
    : super(terminal: terminal, isEnrolled: isEnrolled);
}

class DeviceLimitState extends SingleLinkedDeviceState {
  final String? message;
  final String? callerMethod;
  final String? errorCode;
  final Object? error;
  const DeviceLimitState({
    this.message,
    this.callerMethod,
    this.errorCode,
    this.error,
  }) : super(terminal: null);
}

class AddProviderState extends SingleLinkedDeviceState {
  final String? message;
  final String? title;
  final String? errorCode;
  final Object? error;
  final Completer<bool> completer;
  const AddProviderState({
    required this.completer,
    this.message,
    this.title,
    this.errorCode,
    this.error,
  }) : super(terminal: null);
}

class EditState extends SingleLinkedDeviceState {
  const EditState({
    required Terminal terminal,
    bool isEnrolled = false,
    bool isCurrentDevice = false,
  }) : super(
         terminal: terminal,
         isEnrolled: isEnrolled,
         isCurrentDevice: isCurrentDevice,
       );
}

class ManageState extends SingleLinkedDeviceState {
  const ManageState({
    required Terminal terminal,
    bool isEnrolled = false,
    bool isCurrentDevice = false,
  }) : super(
         terminal: terminal,
         isEnrolled: isEnrolled,
         isCurrentDevice: isCurrentDevice,
       );
}
