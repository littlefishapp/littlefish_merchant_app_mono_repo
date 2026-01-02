part of 'linkeddevices_bloc.dart';

enum LinkedDevicesStatus {
  initial,
  loading,
  loaded,
  error,
  pushSale,
  pushingSale,
  completeSale,
  errorSale,
}

class LinkedDevicesState extends Equatable {
  final LinkedDevicesStatus status;
  final List<Terminal> linkedDevices;
  final String currentDeviceId;
  final String searchQuery;

  const LinkedDevicesState({
    this.status = LinkedDevicesStatus.initial,
    this.linkedDevices = const [],
    this.currentDeviceId = '',
    this.searchQuery = '',
  });

  @override
  List<Object> get props => [
    status,
    linkedDevices,
    currentDeviceId,
    searchQuery,
  ];
}

class LinkeddevicesInitial extends LinkedDevicesState {}

class LinkeddevicesLoading extends LinkedDevicesState {
  const LinkeddevicesLoading()
    : super(
        status: LinkedDevicesStatus.loading,
        linkedDevices: const [],
        currentDeviceId: '',
        searchQuery: '',
      );

  @override
  List<Object> get props => [
    status,
    linkedDevices,
    currentDeviceId,
    searchQuery,
  ];
}
