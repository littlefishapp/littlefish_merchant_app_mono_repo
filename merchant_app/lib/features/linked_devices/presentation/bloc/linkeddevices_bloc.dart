import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlefish_core/terminal_management/models/terminal.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/components/linked_devices_helper.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/shared/constants/permission_name_constants.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_payments/managers/terminal_manager.dart';

import '../../../../app/app.dart';
import '../../../../app/injectors/terminal_injector.dart';

part 'linkeddevices_event.dart';
part 'linkeddevices_state.dart';

// TODO(lampian): the linked devices and push sales feature should be in two seperate blocs
class LinkedDevicesBloc extends Bloc<LinkeddevicesEvent, LinkedDevicesState> {
  var isRegistered = false;
  List<Terminal> loadedlList = [];
  Terminal? currentTerminal;
  CheckoutTransaction? newTransaction;
  final take = 20;
  var skip = 0;
  var totalDevices = -1;
  var canEdit = false;
  var canManage = false;
  var canViewCurrentTerminal = false;
  var canViewAllTerminals = false;
  var doPushSaleActive = false;
  var b64Transaction = '';
  var destinationTerminalId = '';

  LinkedDevicesBloc() : super(LinkeddevicesInitial()) {
    on<GetLinkedDevices>((event, emit) async {
      debugPrint('### linked event GetLinkedDevices');
      emit(const LinkeddevicesLoading());
      emit(await getTerminalInfo());
      emit(await getLinkedDevices());
      // if (doPushSaleActive) {
      //   emit(
      //     LinkedDevicesState(
      //       status: LinkedDevicesStatus.pushSale,
      //       linkedDevices: state.linkedDevices,
      //       currentDeviceId: state.currentDeviceId,
      //       searchQuery: state.searchQuery,
      //     ),
      //   );
      // }
    });

    on<FilterLinkedDevices>((event, emit) async {
      debugPrint('### linked event FilterLinkedDevices');
      emit(await getFilterList(event.query));
    });

    on<GetMoreLinkedDevices>((event, emit) async {
      debugPrint('### linked event GetMoreLinkedDevices');
      emit(const LinkeddevicesLoading());
      emit(await getMoreDevices());
      if (doPushSaleActive) {
        emit(
          LinkedDevicesState(
            status: LinkedDevicesStatus.pushSale,
            linkedDevices: state.linkedDevices,
            currentDeviceId: state.currentDeviceId,
            searchQuery: state.searchQuery,
          ),
        );
      }
    });

    on<UpdateTerminalEvent>((event, emit) {
      debugPrint('### linked event UpdateTerminalEvent');
      emit(updateTerminal(event.updatedTerminal));
    });

    on<SchedulePushSaleTerminalEvent>((event, emit) async {
      debugPrint('### linked event SchedulePushSaleTerminalEvent');
      doPushSaleActive = true;
      if (event.transaction != null) {
        newTransaction = event.transaction;
        final bid = AppVariables.businessId;
        newTransaction!.deviceId = '${bid}_${currentTerminal?.deviceId ?? ''}';
        final json = newTransaction!.toJson();
        final encoded = jsonEncode(json);
        final b64 = base64.encode(encoded.codeUnits);
        b64Transaction = b64;
      }
    });

    on<ScheduleDeviceManagement>((event, emit) async {
      debugPrint('### linked event ScheduleDeviceManagement');
      doPushSaleActive = false;
      add(GetLinkedDevices());
    });

    on<DoPushSaleTerminalEvent>((event, emit) async {
      debugPrint('### linked event DoPushSaleTerminalEvent');
      doPushSaleActive = true;
      if (event.terminalID.isNotEmpty) {
        destinationTerminalId = event.terminalID;
      }

      final result = await doPushSale(
        deviceId: destinationTerminalId,
        b64Transaction: b64Transaction,
      );
      emit(result);
    });

    on<CompletePushSaleTerminalEvent>((event, emit) async {
      debugPrint('### linked event CompletePushSaleTerminalEvent');
      doPushSaleActive = false;
      emit(
        LinkedDevicesState(
          status: LinkedDevicesStatus.completeSale,
          linkedDevices: state.linkedDevices,
          currentDeviceId: state.currentDeviceId,
          searchQuery: state.searchQuery,
        ),
      );
    });

    on<HandleErrorPushSaleTerminalEvent>((event, emit) async {
      debugPrint('### linked event HandleErrorPushSaleTerminalEvent');
      doPushSaleActive = true;
      emit(
        LinkedDevicesState(
          status: LinkedDevicesStatus.errorSale,
          linkedDevices: state.linkedDevices,
          currentDeviceId: state.currentDeviceId,
          searchQuery: state.searchQuery,
        ),
      );
    });
  }

  Future<LinkedDevicesState> doPushSale({
    required String deviceId,
    required String b64Transaction,
  }) async {
    final TerminalManager terminalManager = core.get<TerminalManager>();
    await terminalManager.pushSalesTranasaction(
      sourceTerminalId: currentTerminal?.id ?? '',
      destinationTerminalId: deviceId,
      b64Transaction: b64Transaction,
    );

    return LinkedDevicesState(
      status: LinkedDevicesStatus.pushingSale,
      linkedDevices: loadedlList,
      currentDeviceId: currentTerminal?.deviceId ?? '',
      searchQuery: '',
    );
  }

  LinkedDevicesState updateTerminal(Terminal updatedTerminal) {
    final updatedList = loadedlList.map((terminal) {
      String terminalId = terminal.id;
      String businessId = terminal.businessId;
      String serialNumber = terminal.serialNumber;
      String backupId = businessId.isNotEmpty && serialNumber.isNotEmpty
          ? '${businessId}_$serialNumber'
          : '';
      String id = terminalId.isNotEmpty ? terminalId : backupId;
      return (id) == updatedTerminal.id ? updatedTerminal : terminal;
    }).toList();

    return LinkedDevicesState(
      status: LinkedDevicesStatus.loaded,
      linkedDevices: updatedList,
      currentDeviceId: currentTerminal?.deviceId ?? '',
      searchQuery: '',
    );
  }

  Future<LinkedDevicesState> getLinkedDevices() async {
    canEdit = userHasPermission(allowEditTerminal);
    canManage = userHasPermission(allowManageTerminal);
    canViewCurrentTerminal = userHasPermission(allowViewCurrentTerminal);
    canViewAllTerminals = userHasPermission(allowViewAllTerminals);

    if (!canViewCurrentTerminal && !canViewAllTerminals) {
      return const LinkedDevicesState(
        status: LinkedDevicesStatus.error,
        linkedDevices: [],
        currentDeviceId: '',
        searchQuery: '',
      );
    }

    resetPagination();
    isRegistered = core.isRegistered<TerminalManager>();
    if (!isRegistered) {
      await TerminalInjector.injectWithNoTerminal();
      isRegistered = core.isRegistered<TerminalManager>();
    }

    if (isRegistered) {
      final businessId = AppVariables.businessId;
      final TerminalManager terminalManager = core.get<TerminalManager>();
      List<Terminal> terminalList = [];
      try {
        terminalList = await terminalManager.getLinkedTerminalsByBusinessId(
          businessId: businessId,
        );
      } on Exception catch (_) {
        return const LinkedDevicesState(
          status: LinkedDevicesStatus.error,
          linkedDevices: [],
          currentDeviceId: '',
          searchQuery: '',
        );
      }
      final myTerminalNotValid =
          currentTerminal == null || currentTerminal!.id.isEmpty;
      if (myTerminalNotValid) {
        final thisTerminal = await terminalManager.getTerminalInfo(
          'Provider',
          businessId,
        );
        currentTerminal = thisTerminal;
      }
      incrementPagination();
      totalDevices = terminalManager.totalDevices;
      final myTerminalValid =
          currentTerminal != null && currentTerminal!.id.isNotEmpty;
      if (myTerminalValid) {
        loadedlList = moveTerminalToFirst(
          terminals: terminalList,
          thisTerminal: currentTerminal!,
        );
      } else {
        loadedlList = terminalList;
      }
      debugPrint('### getLinkedDevices => loadedlList: ${loadedlList.length}');

      List<Terminal> filteredList = List<Terminal>.from(loadedlList);
      loadedlList = _filterTerminalsByPermission(filteredList);

      List<Terminal> cardEnabledInputList = List<Terminal>.from(loadedlList);
      loadedlList = _filterTerminalsByCardEnabled(cardEnabledInputList);

      List<Terminal> onLineInputList = List<Terminal>.from(loadedlList);
      loadedlList = _filterTerminalsByOnline(onLineInputList);

      List<Terminal> onLinesortInputList = List<Terminal>.from(loadedlList);
      loadedlList = sortTerminalsByOnline(onLinesortInputList);

      return LinkedDevicesState(
        status: doPushSaleActive
            ? LinkedDevicesStatus.pushSale
            : LinkedDevicesStatus.loaded,
        linkedDevices: loadedlList,
        currentDeviceId: currentTerminal?.deviceId ?? '',
        searchQuery: '',
      );
    }
    return const LinkedDevicesState(
      status: LinkedDevicesStatus.error,
      linkedDevices: [],
      currentDeviceId: '',
      searchQuery: '',
    );
  }

  Future<LinkedDevicesState> getMoreDevices() async {
    if (!canViewCurrentTerminal && !canViewAllTerminals) {
      return const LinkedDevicesState(
        status: LinkedDevicesStatus.error,
        linkedDevices: [],
        currentDeviceId: '',
        searchQuery: '',
      );
    }

    if (isRegistered) {
      final businessId = AppVariables.businessId;
      final TerminalManager terminalManager = core.get<TerminalManager>();
      totalDevices = terminalManager.totalDevices;
      debugPrint(
        '### getMoreDevices => skip: $skip take: $take devices $totalDevices',
      );
      if (totalDevices == loadedlList.length) {
        return LinkedDevicesState(
          status: LinkedDevicesStatus.loaded,
          linkedDevices: loadedlList,
          currentDeviceId: currentTerminal?.deviceId ?? '',
          searchQuery: '',
        );
      }
      List<Terminal> terminalList = [];
      try {
        terminalList = await terminalManager.getLinkedTerminalsByBusinessId(
          businessId: businessId,
          skip: skip,
          take: take,
        );
      } catch (_) {
        return const LinkedDevicesState(
          status: LinkedDevicesStatus.error,
          linkedDevices: [],
          currentDeviceId: '',
          searchQuery: '',
        );
      }

      incrementPagination();
      totalDevices = terminalManager.totalDevices;
      final newList = List<Terminal>.from(loadedlList);
      newList.addAll(terminalList);
      final myTerminalValid =
          currentTerminal != null && currentTerminal!.id.isNotEmpty;
      if (myTerminalValid) {
        loadedlList = moveTerminalToFirst(
          terminals: newList,
          thisTerminal: currentTerminal!,
        );
      } else {
        loadedlList = newList;
      }
      debugPrint('### getMoreDevices => loadedlList: ${loadedlList.length}');

      List<Terminal> filteredList = List<Terminal>.from(loadedlList);
      loadedlList = _filterTerminalsByPermission(filteredList);

      List<Terminal> cardEnabledInputList = List<Terminal>.from(loadedlList);
      loadedlList = _filterTerminalsByCardEnabled(cardEnabledInputList);

      List<Terminal> onLineInputList = List<Terminal>.from(loadedlList);
      loadedlList = _filterTerminalsByOnline(onLineInputList);

      List<Terminal> onLinesortInputList = List<Terminal>.from(loadedlList);
      loadedlList = sortTerminalsByOnline(onLinesortInputList);

      return LinkedDevicesState(
        status: LinkedDevicesStatus.loaded,
        linkedDevices: loadedlList,
        currentDeviceId: currentTerminal?.deviceId ?? '',
        searchQuery: '',
      );
    }
    return const LinkedDevicesState(
      status: LinkedDevicesStatus.error,
      linkedDevices: [],
      currentDeviceId: '',
      searchQuery: '',
    );
  }

  Future<LinkedDevicesState> getFilterList(String query) async {
    if (!canViewCurrentTerminal && !canViewAllTerminals) {
      return const LinkedDevicesState(
        status: LinkedDevicesStatus.error,
        linkedDevices: [],
        currentDeviceId: '',
        searchQuery: '',
      );
    }

    List<Terminal> filteredList = loadedlList.where((Terminal element) {
      return element.serialNumber.toLowerCase().contains(query.toLowerCase()) ||
          element.displayName.toLowerCase().contains(query.toLowerCase()) ||
          element.deviceId.toLowerCase().contains(query.toLowerCase()) ||
          element.merchantId.toLowerCase().contains(query.toLowerCase()) ||
          element.family.toLowerCase().contains(query.toLowerCase()) ||
          element.type.toLowerCase().contains(query.toLowerCase());
    }).toList();

    List<Terminal> filteredListCopy = List<Terminal>.from(filteredList);
    filteredList = _filterTerminalsByPermission(filteredListCopy);

    List<Terminal> cardEnabledInputList = List<Terminal>.from(loadedlList);
    loadedlList = _filterTerminalsByCardEnabled(cardEnabledInputList);

    List<Terminal> onLineInputList = List<Terminal>.from(loadedlList);
    loadedlList = _filterTerminalsByOnline(onLineInputList);

    List<Terminal> onLinesortInputList = List<Terminal>.from(loadedlList);
    loadedlList = sortTerminalsByOnline(onLinesortInputList);

    return LinkedDevicesState(
      status: LinkedDevicesStatus.loaded,
      linkedDevices: filteredList,
      currentDeviceId: currentTerminal?.deviceId ?? '',
      searchQuery: query,
    );
  }

  List<Terminal> _filterTerminalsByPermission(List<Terminal> terminals) {
    if (canViewAllTerminals) return terminals;

    if (canViewCurrentTerminal) {
      return currentTerminal == null ? [] : [currentTerminal!];
    }

    if (!canViewCurrentTerminal && !canViewAllTerminals) return [];

    return [];
  }

  List<Terminal> _filterTerminalsByCardEnabled(List<Terminal> terminals) {
    if (doPushSaleActive) {
      return terminals.where((terminal) => terminal.cardEnabled).toList();
    }
    return terminals;
  }

  List<Terminal> _filterTerminalsByOnline(List<Terminal> terminals) {
    final onlinePeriod = LinkedDevicesHelper.onLinePeriod();
    if (onlinePeriod <= 0) {
      return terminals;
    }

    if (doPushSaleActive) {
      return terminals.where((terminal) {
        return LinkedDevicesHelper.isOnline(
          terminal: terminal,
          onLinePeriod: onlinePeriod,
        );
      }).toList();
    }
    return terminals;
  }

  List<Terminal> sortTerminalsByOnline(List<Terminal> terminals) {
    final onlinePeriod = LinkedDevicesHelper.onLinePeriod();
    if (onlinePeriod <= 0 || terminals.length <= 1) {
      return terminals;
    }
    final first = terminals.first;
    final rest = terminals.sublist(1);

    rest.sort((a, b) {
      final aOnline = LinkedDevicesHelper.isOnline(
        terminal: a,
        onLinePeriod: onlinePeriod,
      );
      final bOnline = LinkedDevicesHelper.isOnline(
        terminal: b,
        onLinePeriod: onlinePeriod,
      );

      return (bOnline ? 1 : 0) - (aOnline ? 1 : 0);
    });

    return [first, ...rest];
  }

  Future<LinkedDevicesState> getTerminalInfo() async {
    final businessId = AppVariables.businessId;
    if (core.isRegistered<TerminalManager>()) {
      final TerminalManager terminalManager = core.get<TerminalManager>();
      final terminal = await terminalManager.getTerminalInfo(
        'Provider',
        businessId,
      );
      currentTerminal = terminal;
    }
    return LinkeddevicesInitial();
  }

  List<Terminal> moveTerminalToFirst({
    List<Terminal> terminals = const [],
    required Terminal thisTerminal,
  }) {
    final index = terminals.indexWhere(
      (item) => item.id.contains(thisTerminal.id),
    );

    if (index > 0) {
      final terminal = terminals.removeAt(index);
      terminals.insert(0, terminal);
    }
    return terminals;
  }

  void resetPagination() {
    skip = 0;
  }

  void incrementPagination() {
    skip += take;
  }

  bool allTerminalsRetrieved() {
    if (loadedlList.length >= totalDevices) {
      return true;
    }
    return false;
  }
}
