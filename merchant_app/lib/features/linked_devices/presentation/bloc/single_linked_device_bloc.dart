import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/terminal_management/models/terminal.dart';
import 'package:littlefish_core_utils/error/models/error_codes/provider_registration_codes.dart';
import 'package:littlefish_core_utils/error/models/error_codes/terminal_error_codes.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/features/pos/presentation/view_model/pos_pay_view_model.dart';
// import 'package:littlefish_merchant/redux/device/device_actions.dart';
import 'package:littlefish_merchant/shared/constants/permission_name_constants.dart';
import 'package:littlefish_merchant/tools/extensions/terminal_extension.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/tools/helpers/auth_helper.dart';
import 'package:littlefish_merchant/tools/payment_types_helper/soft_pos_helper.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/utils/linked_account_utils.dart';
import 'package:littlefish_payments/managers/terminal_manager.dart';
import 'package:littlefish_payments/models/terminal/terminal_enrol_data.dart';

part 'single_linked_device_event.dart';
part 'single_linked_device_state.dart';

LittleFishCore core = LittleFishCore.instance;

class SingleLinkedDeviceBloc
    extends Bloc<SingleLinkedDeviceEvent, SingleLinkedDeviceState> {
  bool canEdit = false;
  bool canManage = false;
  bool canViewCurrentTerminal = false;
  bool canViewAllTerminals = false;
  late Terminal _originalTerminal; // Store the original terminal for cancel

  SingleLinkedDeviceBloc() : super(const SingleLinkedDeviceStateInitial()) {
    on<InitializeDeviceEvent>((event, emit) async {
      var newState = await _initialiseDeviceEvent(event.terminal);
      emit(newState);
    });
    on<RegisterDeviceButtonPressedEvent>((event, emit) async {
      emit(const LoadingState());
      SingleLinkedDeviceState newState = await enrolDeviceBloc(
        event: event,
        emit: emit,
      );
      emit(newState);
    });

    on<DeRegisterDeviceButtonPressedEvent>((event, emit) async {
      emit(const LoadingState());
      SingleLinkedDeviceState newState = await unenrolDeviceBloc(
        event: event,
        emit: emit,
      );
      emit(newState);
    });
    on<EditButtonPressedEvent>((event, emit) async {
      emit(const LoadingState());
      SingleLinkedDeviceState newState = await _editButtonPressed(
        event.terminal,
        emit,
      );
      emit(newState);
    });
    on<CancelButtonPressedEvent>((event, emit) {
      emit(_cancelButtonPressed());
    });
    on<SaveTerminalDetailsEvent>((event, emit) async {
      await _saveTerminal(event, emit);
    });
    on<RegisterTerminalProviderResponseEvent>((event, emit) async {
      await _setTerminalProviderResponse(event, emit);
    });
    on<SetCardEnabledEvent>((event, emit) {
      emit(_setIsCardEnabled(event.enabled));
    });
    on<SetDisplayNameEvent>((event, emit) {
      emit(_setDisplayNameEvent(event.displayName));
    });
    on<SetViewModeEvent>((event, emit) {
      emit(ViewState(terminal: event.terminal));
    });
    on<SetStatusEvent>((event, emit) {
      emit(_setStatus(event.status));
    });
  }

  Future<SingleLinkedDeviceState> enrolDeviceBloc({
    required Emitter<SingleLinkedDeviceState> emit,
    required RegisterDeviceButtonPressedEvent event,
  }) async {
    emit(const LoadingState());

    var successState = _setIsCardEnabled(
      true,
      terminal: event.terminal,
      isCurrentDevice: event.isCurrentDevice,
    );
    var failureState = _setIsCardEnabled(
      false,
      terminal: event.terminal,
      isCurrentDevice: event.isCurrentDevice,
    );

    // Adding config service and terminal manager instances
    final TerminalManager terminalManager = core.get<TerminalManager>();
    ConfigService configService = core.get<ConfigService>();
    PosPayVM payVM = PosPayVM.fromStore(AppVariables.store);

    try {
      //Checking if has soft pos provider
      if (!SoftPosHelper.hasSoftPosProvider()) {
        emit(
          SoftErrorState(
            callerMethod: 'RegisterTerminalProviderResponseEvent',
            message: ProviderRegistrationCodes
                .generalDeviceRegistrationError
                .message,
            errorCode:
                ProviderRegistrationCodes.generalDeviceRegistrationError.code,
          ),
        );
        return failureState;
      }

      bool hasLinkedAccount =
          await LinkedAccountUtils.hasSoftPosLinkedAccount();
      if (!hasLinkedAccount) {
        emit(
          SoftErrorState(
            callerMethod: 'RegisterTerminalProviderResponseEvent',
            message:
                ProviderRegistrationCodes.deviceRegistrationNoLinkedAccountError(
                  softPosProviderName:
                      AppVariables.store?.state.softPosProviderName ?? '',
                ).message,
            errorCode:
                ProviderRegistrationCodes.deviceRegistrationNoLinkedAccountError(
                  softPosProviderName:
                      AppVariables.store?.state.softPosProviderName ?? '',
                ).code,
          ),
        );
        return failureState;
      }
      // Checking if already enrolled
      bool isEnrolled = await PosPayVM.fromStore(
        AppVariables.store,
      ).isDeviceEnrolled();

      if (isEnrolled) {
        //Here we are checking if the device is already enrolled and linked to this account
        bool linkedCorrect = await payVM.validateDeviceCorrectlyLinked();
        if (linkedCorrect) {
          return successState;
        }
        emit(
          SoftErrorState(
            callerMethod: 'RegisterTerminalProviderResponseEvent',
            message: ProviderRegistrationCodes
                .deviceAlreadyEnrolledWithAnotherAccountError
                .message,
            errorCode: ProviderRegistrationCodes
                .deviceAlreadyEnrolledWithAnotherAccountError
                .code,
          ),
        );
        return failureState;
      }

      // Checking device limit
      int totalDevices = 0;
      try {
        totalDevices = await terminalManager.getTotalRegisteredSoftPosDevices(
          businessId: AppVariables.businessId,
          baseUrl: AppVariables.baseUrl,
        );
      } catch (e) {
        logger.debug(
          this,
          'SingleLinkedDeviceBloc - enrolDeviceBloc - error getting total devices: $e',
        );
        emit(
          SoftErrorState(
            callerMethod: 'RegisterTerminalProviderResponseEvent',
            message: ProviderRegistrationCodes
                .failedGetTotalRegisteredDevices
                .message,
            errorCode:
                ProviderRegistrationCodes.failedGetTotalRegisteredDevices.code,
          ),
        );
        return failureState;
      }

      int deviceLimit = configService.getIntValue(
        key: 'config_soft_pos_device_limit',
        defaultValue: 1,
      );

      if (totalDevices >= deviceLimit) {
        emit(
          SoftErrorState(
            callerMethod: 'RegisterTerminalProviderResponseEvent',
            message: ProviderRegistrationCodes
                .deviceRegistrationExceededDeviceLimitError
                .message,
            errorCode: ProviderRegistrationCodes
                .deviceRegistrationExceededDeviceLimitError
                .code,
          ),
        );
        return failureState;
      }

      // Confirming if they want to register
      Completer<bool> completer = Completer<bool>();

      String enableOrDisableString =
          'Enable ${AppVariables.store?.state.softPosProviderName}\nAre you sure you want to enable ${AppVariables.store?.state.softPosProviderName} on this device? You will be able to make card payments on this device.\n You have ${deviceLimit - totalDevices} of $deviceLimit devices remaining.';
      emit(
        AddProviderState(completer: completer, message: enableOrDisableString),
      );
      bool result = await completer.future;

      if (result == false) {
        return failureState;
      }

      //Enrolling device
      await payVM.updateLinkedAccount();

      TerminalEnrolData enrolData = await payVM.enrollDevice();
      if (!enrolData.success) {
        emit(
          SoftErrorState(
            callerMethod: 'RegisterTerminalProviderResponseEvent',
            message: ProviderRegistrationCodes
                .generalDeviceRegistrationError
                .message,
            errorCode:
                ProviderRegistrationCodes.generalDeviceRegistrationError.code,
          ),
        );
        return failureState;
      }
      event.terminal.cardEnabled = true;
      bool _ = await terminalManager.updateTerminal(terminal: event.terminal);
      try {
        await terminalManager.updateTotalRegisteredSoftPosDevices(
          businessId: event.terminal.businessId,
          baseUrl: AppVariables.baseUrl,
          isAddition: true,
          currentCount: totalDevices,
        );
      } catch (e) {
        emit(
          SoftErrorState(
            callerMethod: 'RegisterTerminalProviderResponseEvent',
            message: ProviderRegistrationCodes
                .failedUpsertTotalRegisteredDevices
                .message,
            errorCode: ProviderRegistrationCodes
                .failedUpsertTotalRegisteredDevices
                .code,
          ),
        );
      }
      return successState;
    } catch (e) {
      logger.debug(
        this,
        'SingleLinkedDeviceBloc - enrolDeviceBloc - error: $e',
      );
      emit(
        SoftErrorState(
          callerMethod: 'enrolDeviceBloc',
          message:
              ProviderRegistrationCodes.generalDeviceRegistrationError.message,
          errorCode:
              ProviderRegistrationCodes.generalDeviceRegistrationError.code,
        ),
      );
      return failureState;
    }
  }

  Future<SingleLinkedDeviceState> unenrolDeviceBloc({
    required Emitter<SingleLinkedDeviceState> emit,
    required DeRegisterDeviceButtonPressedEvent event,
  }) async {
    var successState = _setIsCardEnabled(
      false,
      terminal: event.terminal,
      isCurrentDevice: event.isCurrentDevice,
    );
    var failureState = _setIsCardEnabled(
      true,
      terminal: event.terminal,
      isCurrentDevice: event.isCurrentDevice,
    );

    emit(const LoadingState());
    final TerminalManager terminalManager = core.get<TerminalManager>();
    try {
      //Checking if has soft pos provider
      if (!AppVariables.isSoftPosBuild) {
        emit(
          const SoftErrorState(
            callerMethod: 'RegisterTerminalProviderResponseEvent',
            message: 'Device could not be registered',
            errorCode: 'Device Registration Error',
          ),
        );
        return failureState;
      }

      // Checking if already unenrolled
      bool isEnrolled = await PosPayVM.fromStore(
        AppVariables.store,
      ).isDeviceEnrolled();

      if (!isEnrolled) {
        return successState;
      }

      //Asking user to confirm deregistration
      Completer<bool> completer = Completer<bool>();

      String enableOrDisableString =
          'Disable ${AppVariables.store?.state.softPosProviderName}\nAre you sure you want to disable ${AppVariables.store?.state.softPosProviderName} on this device? You will no longer be able to make card payments on this device.';
      emit(
        AddProviderState(completer: completer, message: enableOrDisableString),
      );
      bool result = await completer.future;

      if (result == false) {
        return failureState;
      }

      //Deregistering device

      PosPayVM payVM = PosPayVM.fromStore(AppVariables.store);
      try {
        bool unenrolled = await payVM.unEnrollDevice();
        if (!unenrolled) {
          emit(
            const SoftErrorState(
              callerMethod: 'RegisterTerminalProviderResponseEvent',
              message: 'Device could not be registered',
              errorCode: 'Device Registration Error',
            ),
          );
          return failureState;
        }
        event.terminal.cardEnabled = false;
        bool _ = await terminalManager.updateTerminal(terminal: event.terminal);
        int totalDevices = 0;
        try {
          totalDevices = await terminalManager.getTotalRegisteredSoftPosDevices(
            businessId: AppVariables.businessId,
            baseUrl: AppVariables.baseUrl,
          );
        } catch (e) {
          logger.debug(
            this,
            'SingleLinkedDeviceBloc - enrolDeviceBloc - error getting total devices: $e',
          );
          emit(
            SoftErrorState(
              callerMethod: 'RegisterTerminalProviderResponseEvent',
              message: ProviderRegistrationCodes
                  .failedGetTotalRegisteredDevices
                  .message,
              errorCode: ProviderRegistrationCodes
                  .failedGetTotalRegisteredDevices
                  .code,
            ),
          );
          return failureState;
        }
        logger.debug(
          this,
          '### SingleLinkedDeviceBloc - unenrolDeviceBloc - totalDevices before update: $totalDevices',
        );
        try {
          await terminalManager.updateTotalRegisteredSoftPosDevices(
            businessId: event.terminal.businessId,
            baseUrl: AppVariables.baseUrl,
            isAddition: false,
            currentCount: totalDevices,
          );
        } catch (e) {
          emit(
            SoftErrorState(
              callerMethod: 'RegisterTerminalProviderResponseEvent',
              message: ProviderRegistrationCodes
                  .failedUpsertTotalRegisteredDevices
                  .message,
              errorCode: ProviderRegistrationCodes
                  .failedUpsertTotalRegisteredDevices
                  .code,
            ),
          );
        }
        return successState;
      } catch (e) {
        return failureState;
      }
    } catch (e) {
      emit(
        SoftErrorState(
          callerMethod: 'enrolDeviceBloc',
          message: 'Error enrolling device',
          errorCode: 'Device Enrol Error',
        ),
      );
      return failureState;
    }
  }

  Future<SingleLinkedDeviceState> _setSoftPosRegistrationStatus(
    CheckSoftPosEnrolmentEvent event,
    LinkedDeviceMode mode,
  ) async {
    //Checking if this terminal is the current device
    final TerminalManager terminalManager = core.get<TerminalManager>();
    Terminal? thisTerminal = await terminalManager.getTerminalInfo(
      '',
      AppVariables.businessId,
    );

    final bool isCurrentDevice =
        thisTerminal.deviceId == event.terminal.deviceId;

    //Checking if device is softpos
    if (AppVariables.isSoftPosBuild) {
      PosPayVM payVM = PosPayVM.fromStore(AppVariables.store);
      bool isEnrolled = await payVM.isDeviceEnrolled();

      bool linkedCorrect = await payVM.validateDeviceCorrectlyLinked();
      if (mode == LinkedDeviceMode.manage) {
        return ManageState(
          terminal: event.terminal,
          isEnrolled: isEnrolled,
          isCurrentDevice: isEnrolled
              ? isCurrentDevice && linkedCorrect
              : isCurrentDevice,
        );
      } else if (mode == LinkedDeviceMode.edit) {
        return EditState(terminal: event.terminal);
      }
      return ViewState(terminal: state.terminal!);
    }
    if (mode == LinkedDeviceMode.edit) {
      return EditState(terminal: event.terminal);
    }
    if (mode == LinkedDeviceMode.manage) {
      return ManageState(
        terminal: event.terminal,
        isEnrolled: thisTerminal.cardEnabled,
        isCurrentDevice: isCurrentDevice,
      );
    }
    return ViewState(terminal: state.terminal!);
  }

  Future<SingleLinkedDeviceState> _initialiseDeviceEvent(
    Terminal terminal,
  ) async {
    canEdit = userHasPermission(allowEditTerminal);
    canManage = userHasPermission(allowManageTerminal);
    canViewCurrentTerminal = userHasPermission(allowViewCurrentTerminal);
    canViewAllTerminals = userHasPermission(allowViewAllTerminals);

    _originalTerminal = terminal.copyWith();

    if (AppVariables.isSoftPosBuild) {
      emit(const LoadingState());
      final TerminalManager terminalManager = core.get<TerminalManager>();
      Terminal? thisTerminal = await terminalManager.getTerminalInfo(
        '',
        AppVariables.businessId,
      );

      final bool isCurrentDevice =
          thisTerminal.deviceId == _originalTerminal.deviceId;
      PosPayVM payVM = PosPayVM.fromStore(AppVariables.store);
      bool isEnrolled = await payVM.isDeviceEnrolled();

      bool linkedCorrect = await payVM.validateDeviceCorrectlyLinked();

      return ViewState(
        terminal: terminal,
        isEnrolled: isEnrolled,
        isCurrentDevice: isCurrentDevice && linkedCorrect,
      );
    }
    return ViewState(
      terminal: terminal,
      isEnrolled: terminal.cardEnabled,
      isCurrentDevice: false,
    );
  }

  SingleLinkedDeviceState _setIsCardEnabled(
    bool enabled, {
    Terminal? terminal,
    bool isCurrentDevice = false,
  }) {
    bool safeisCurrentDevice = state.isCurrentDevice;

    Terminal? safeTerminal = state.terminal ?? terminal;
    if (state.terminal == null) {
      safeisCurrentDevice = isCurrentDevice;
    }

    if (safeTerminal == null) return _terminalNullError('_setIsCardEnabled');
    Terminal updatedTerminal = safeTerminal.copyWith(cardEnabled: enabled);

    return ManageState(
      terminal: updatedTerminal,
      isCurrentDevice: safeisCurrentDevice,
      isEnrolled: enabled,
    );
  }

  SingleLinkedDeviceState _cancelButtonPressed() {
    // Revert to original terminal state
    return ViewState(terminal: _originalTerminal);
  }

  Future<SingleLinkedDeviceState> _editButtonPressed(
    Terminal terminal,
    Emitter<SingleLinkedDeviceState> emit,
  ) async {
    emit(const LoadingState());
    LinkedDeviceMode mode = _getModeByPermissions();

    return await _setSoftPosRegistrationStatus(
      CheckSoftPosEnrolmentEvent(terminal),
      mode,
    );
  }

  LinkedDeviceMode _getModeByPermissions() {
    if (canManage) return LinkedDeviceMode.manage;
    if (canEdit) return LinkedDeviceMode.edit;
    return LinkedDeviceMode.view;
  }

  Future<void> _saveTerminal(
    SaveTerminalDetailsEvent event,
    Emitter<SingleLinkedDeviceState> emit,
  ) async {
    Terminal? terminal = state.terminal?.copyWith();
    if (terminal == null) {
      emit(_terminalNullError('_saveTerminal'));
      return;
    }

    emit(const LoadingState());

    if (terminal.id.isEmpty) {
      String businessId = terminal.businessId.isNotEmpty
          ? terminal.businessId
          : AppVariables.businessId;
      if (businessId.isEmpty || terminal.deviceId.isEmpty) {
        emit(_terminalIdNullError('_saveTerminal'));
        return;
      }
      terminal = terminal.copyWith(id: '${businessId}_${terminal.deviceId}');
      return;
    }

    final TerminalManager terminalManager = core.get<TerminalManager>();

    bool _ = await terminalManager.updateTerminal(terminal: terminal);

    _originalTerminal = terminal
        .copyWith(); // Update original state after saving

    // update terminal in list
    emit(SaveSuccessState(terminal: terminal));
    return;
  }

  Future<void> _setTerminalProviderResponse(
    RegisterTerminalProviderResponseEvent event,
    Emitter<SingleLinkedDeviceState> emit,
  ) async {
    if (!event.success) {
      emit(
        const SoftErrorState(
          callerMethod: 'RegisterTerminalProviderResponseEvent',
          message: 'Device could not be registered',
          errorCode: 'Device Registration Error',
        ),
      );
      emit(EditState(terminal: _originalTerminal));
      return;
    }
    final TerminalManager terminalManager = core.get<TerminalManager>();

    Terminal localTerminal = await terminalManager.getTerminalInfo(
      '',
      AppVariables.businessId,
      autoRegister: false,
    );
    if (localTerminal.id != event.deviceId) {
      return;
    }

    try {
      Terminal updatedTerminal = await terminalManager.getTerminalFromServer(
        deviceId: _originalTerminal.id,
        businessId: _originalTerminal.businessId,
      );

      _originalTerminal = updatedTerminal
          .copyWith(); // Update original state after saving

      // update terminal in list
      emit(SaveSuccessState(terminal: updatedTerminal));
    } catch (e) {
      debugPrint(
        '### SingleLinkedDeviceBloc - RegisterTerminalProviderResponseEvent - error: $e',
      );
      emit(
        const SoftErrorState(
          callerMethod: 'RegisterTerminalProviderResponseEvent',
          message: 'Device could not be registered',
          errorCode: 'Device Registration Error',
        ),
      );
    }
  }

  SingleLinkedDeviceState _terminalNullError(String? callerMethod) {
    return SoftErrorState(
      callerMethod: callerMethod,
      message: TerminalErrorCodes.terminalNull.message,
      errorCode: TerminalErrorCodes.terminalNull.code,
    );
  }

  SingleLinkedDeviceState _terminalIdNullError(String? callerMethod) {
    return SoftErrorState(
      callerMethod: callerMethod,
      message: TerminalErrorCodes.terminalIdNull.message,
      errorCode: TerminalErrorCodes.terminalIdNull.code,
    );
  }

  SingleLinkedDeviceState _setDisplayNameEvent(String deviceName) {
    if (state.terminal == null) {
      return _terminalNullError('_setDisplayNameEvent');
    }

    Terminal updatedTerminal = state.terminal!.copyWith(
      displayName: deviceName,
    );

    if (canManage) {
      return ManageState(terminal: updatedTerminal);
    }
    if (canEdit) {
      return EditState(terminal: updatedTerminal);
    }

    return ViewState(terminal: updatedTerminal);
  }

  SingleLinkedDeviceState _setStatus(String status) {
    if (state.terminal == null) {
      return _terminalNullError('_setStatus');
    }

    Terminal updatedTerminal = state.terminal!.copyWith(status: status);

    if (canManage) {
      return ManageState(terminal: updatedTerminal);
    }
    if (canEdit) {
      return EditState(terminal: updatedTerminal);
    }

    return ViewState(terminal: updatedTerminal);
  }

  bool get canModify => canEdit || canManage;
}
