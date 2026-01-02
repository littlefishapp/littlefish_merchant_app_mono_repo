import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core/terminal_management/models/terminal.dart';
import 'package:littlefish_core_utils/error/models/error_codes/app_initialise_error_codes.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/features/pos/presentation/view_model/pos_pay_view_model.dart';
import 'package:littlefish_merchant/models/device/device_email_request.dart';
import 'package:littlefish_merchant/models/settings/accounts/linked_account.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/redux/email/email_actions.dart';
import 'package:littlefish_merchant/tools/extensions/terminal_extension.dart';
import 'package:littlefish_merchant/tools/payment_types_helper/soft_pos_helper.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_payments/managers/terminal_manager.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/features/pos/presentation/pages/card_payment.dart';
import 'package:littlefish_merchant/features/sell/domain/helpers/transaction_result_mapper.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_payments/models/terminal/terminal_enrol_data.dart';
import 'package:quiver/strings.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:littlefish_merchant/handlers/interfaces/permission_handler.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/permissions/business_role.dart';
import 'package:littlefish_merchant/models/permissions/business_user_role.dart';
import 'package:littlefish_merchant/redux/business/business_actions.dart';
import 'package:littlefish_merchant/redux/permission/permission_action.dart';
import 'package:littlefish_merchant/redux/user/user_actions.dart';
import 'package:littlefish_merchant/redux/workspaces/workspace_actions.dart';
import 'package:littlefish_merchant/shared/exceptions/permission_failure_exception.dart';

import '../../models/device/interfaces/device_details.dart';

LittleFishCore core = LittleFishCore.instance;

ThunkAction<AppState> checkDeviceStatus({Completer? completer}) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(SetAuthLoadingAction(true));
      bool checkStatus() {
        return (store.state.deviceState.deviceDetails == null ||
                isBlank(store.state.deviceState.deviceDetails?.merchantId))
            ? false
            : true;
      }

      bool accessGranted = checkStatus();
      int retries = 0;
      const maxRetries = 60;

      while (!accessGranted && retries < maxRetries) {
        await Future.delayed(const Duration(seconds: 5));
        accessGranted = checkStatus();
        retries++;
      }
      store.dispatch(SetAuthLoadingAction(false));
      if (accessGranted) {
        completer?.complete();
      } else {
        completer?.completeError('Failed to load device details');
      }
    });
  };
}

ThunkAction<AppState> loadRolesAndPermissions({Completer? completer}) {
  return (Store<AppState> store) async {
    final LoggerService logger = LittleFishCore.instance.get<LoggerService>();

    try {
      final roleResult = await _getRolesData(store) ?? [];

      for (var result in roleResult) {
        if (result != null) {
          if (result is List<BusinessUserRole>) {
            //NB! this is specific legacy app-logic, do not remove without testing roles!
            if ((store.state.userState.userBusinessRoles ?? []).isEmpty) {
              if (result.length == 1) {
                store.dispatch(UserProfileRolesLoadedAction(result));
                continue;
              }
            }
            store.dispatch(SetUsersBusinessRoles(result));
          } else if (result is List<BusinessRole>) {
            store.dispatch(RoleLoadedAction(result));
          }
        }
      }
    } catch (e) {
      store.dispatch(UserProfileRolesLoadFailure(e.toString()));
      store.dispatch(PermissionStateFailureAction(e.toString()));
      store.dispatch(SetUsersBusinessRolesFailure(e.toString()));
      logger.error(
        'DeviceMiddleware',
        AppInitialiseErrorCodes.roleDataFetchFailed.message,
        error: e,
        stackTrace: StackTrace.current,
      );
    }

    try {
      Completer permissionCompleter = Completer();
      store.dispatch(
        initializePermissionState(
          refresh: true,
          completer: permissionCompleter,
        ),
      );
      await permissionCompleter.future;

      await _handlePermissionsReady(store);
      completer?.complete();
    } catch (e) {
      logger.error(
        'DeviceMiddleware',
        AppInitialiseErrorCodes.permissionInitFailed.message,
        error: e,
        stackTrace: StackTrace.current,
      );
      completer?.completeError(e);
    }
  };
}

Future<List?> _getRolesData(Store<AppState> store) async {
  final LoggerService logger = LittleFishCore.instance.get<LoggerService>();
  try {
    final futures = [
      permissionService.getBusinessUserRoles(
        userId: store.state.userProfile?.userId ?? '',
      ),
      permissionService.getBusinessRoles(),
      permissionService.getBusinessUserRolesByBusiness(),
    ];

    final results = await Future.wait(futures);

    return results;
  } catch (e) {
    logger.error(
      'DeviceMiddleware',
      AppInitialiseErrorCodes.roleDataFetchFailed.message,
      error: e,
      stackTrace: StackTrace.current,
    );
  }

  return [];
}

Future<void> _handlePermissionsReady(Store<AppState> store) async {
  final LoggerService logger = LittleFishCore.instance.get<LoggerService>();

  try {
    await getIt.get<PermissionHandler>().populatePermissionData();
    store.dispatch(SetUserAccessPermissions(store.state.permissions));
    store.dispatch(fetchWorkspaces());
    store.dispatch(loadDefaultWorkspace());
  } on PermissionFailureException catch (e) {
    logger.error(
      'DeviceMiddleware',
      AppInitialiseErrorCodes.permissionInitFailed.message,
      error: e,
      stackTrace: StackTrace.current,
    );
  }
}

ThunkAction<AppState> registerTerminalProvider({
  required String deviceSenderId,
  required String deviceId,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      final TerminalManager terminalManager = core.get<TerminalManager>();

      Terminal localTerminal = await terminalManager.getTerminalInfo(
        '',
        AppVariables.businessId,
        autoRegister: false,
      );
      if (localTerminal.id != deviceId) {
        debugPrint(
          '### DeviceMiddleware - registerTerminalProvider - terminal ids dont match \n'
          'localTerminal: ${localTerminal.id} \n'
          'deviceId: $deviceId',
        );
        return;
      }
      debugPrint(
        '### DeviceMiddleware - registerTerminalProvider - terminal ids do match \n'
        'localTerminal: ${localTerminal.id} \n'
        'deviceId: $deviceId',
      );

      Terminal terminal = await terminalManager.getTerminalFromServer(
        deviceId: deviceId,
        businessId: AppVariables.businessId,
      );
      if (!SoftPosHelper.hasSoftPosProvider()) {
        terminal.cardEnabled = !terminal.cardEnabled;
        bool _ = await terminalManager.updateTerminal(terminal: terminal);
        return;
      }

      if (terminal.cardEnabled == true) {
        debugPrint(
          '### DeviceMiddleware - registerTerminalProvider - enrol device',
        );
        store.dispatch(
          enrolDevice(
            terminal: terminal.copyWith(),
            deviceSenderId: deviceSenderId,
          ),
        );
      } else {
        debugPrint(
          '### DeviceMiddleware - registerTerminalProvider - unenrol device',
        );
        store.dispatch(
          unenrolDevice(
            terminal: terminal.copyWith(),
            deviceSenderId: deviceSenderId,
          ),
        );
      }
    });
  };
}

ThunkAction<AppState> enrolDevice({
  required Terminal terminal,
  required String deviceSenderId,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(SetAuthLoadingAction(true));
      PosPayVM payVM = PosPayVM.fromStore(store);

      final TerminalManager terminalManager = core.get<TerminalManager>();
      try {
        bool isEnrolled = await payVM.isDeviceEnrolled();
        debugPrint(
          '### DeviceMiddleware - enrolDevice - isEnrolled: $isEnrolled',
        );
        bool hasEnrolled = false;
        if (!isEnrolled) {
          LinkedAccount? account = await payVM.getLinkedAccount();
          try {
            TerminalEnrolData enrolData = await payVM.enrollDevice();

            terminal.merchantId = enrolData.merchantId;
            terminal.terminalId = enrolData.terminalId;
            terminal.deviceId = enrolData.deviceId;
            terminal.cardEnabled = enrolData.success;
            terminal.isRegistered = enrolData.success;
            terminal.deleted = false;
            terminal.providerId = account?.id ?? '';
            hasEnrolled = enrolData.success;
          } catch (e) {
            debugPrint('### DeviceMiddleware - enrolDevice - error: $e');
            hasEnrolled = false;
          }
          try {
            ConfigService configService = core.get<ConfigService>();

            int registerDevices = await terminalManager
                .getTotalRegisteredSoftPosDevices(
                  businessId: AppVariables.businessId,
                  baseUrl: AppVariables.baseUrl,
                );
            int deviceLimit = configService.getIntValue(
              key: 'config_soft_pos_device_limit',
              defaultValue: 1,
            );
            DeviceEmailRequest request = DeviceEmailRequest(
              deviceId: terminal.deviceId,
              deviceName: terminal.name,
              deviceLimit: deviceLimit.toString(),
              totalDevices: registerDevices.toString(),
              merchantId: terminal.merchantId,
              businessName: store.state.businessState.profile?.name ?? '',
              deviceBrand: terminal.brand,
            );
            Completer<bool> completer = Completer();
            store.dispatch(
              sendDeviceRegisteredEmail(request: request, completer: completer),
            );

            await completer.future;
            debugPrint('### DeviceMiddleware - enrolDevice - email sent');
          } catch (e) {
            logger.error(
              'DeviceMiddleware',
              'Could not send device registered email',
              error: e,
              stackTrace: StackTrace.current,
            );
          }
        } else {
          hasEnrolled = true;
        }
        terminal.cardEnabled = hasEnrolled;

        bool _ = await terminalManager.updateTerminal(terminal: terminal);
        debugPrint('### DeviceMiddleware - enrolDevice - terminal updated');
        return;
        // bool hasSent = await terminalManager.updateTerminalProviderResponse(
        //   destinationTerminalId: deviceSenderId,
        //   sourceTerminalId: terminal.id,
        //   message: message,
        //   success: hasEnrolled,
        // );
      } catch (e) {
        logger.error(
          'DeviceMiddleware',
          'Error in enrolDevice',
          error: e,
          stackTrace: StackTrace.current,
        );
        debugPrint('### DeviceMiddleware - enrolDevice - error: $e');

        terminal.cardEnabled = !terminal.cardEnabled;
        bool _ = await terminalManager.updateTerminal(terminal: terminal);
        return;
      }
    });
  };
}

ThunkAction<AppState> unenrolDevice({
  required Terminal terminal,
  required String deviceSenderId,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(SetAuthLoadingAction(true));
      PosPayVM payVM = PosPayVM.fromStore(store);

      final TerminalManager terminalManager = core.get<TerminalManager>();
      try {
        bool isEnrolled = await payVM.isDeviceEnrolled();
        bool isUnenrolled = false;

        if (isEnrolled) {
          LinkedAccount? account = await payVM.getLinkedAccount();
          try {
            isUnenrolled = await payVM.unEnrollDevice();
            debugPrint(
              '### DeviceMiddleware - unenrolDevice - isUnenrolled: $isUnenrolled',
            );
          } catch (e) {
            logger.error(
              'DeviceMiddleware',
              'Error in unenrolDevice',
              error: e,
              stackTrace: StackTrace.current,
            );
            debugPrint('### DeviceMiddleware - unenrolDevice - error: $e');
            isUnenrolled = false;
          }

          try {
            ConfigService configService = core.get<ConfigService>();

            int registerDevices = await terminalManager
                .getTotalRegisteredSoftPosDevices(
                  businessId: AppVariables.businessId,
                  baseUrl: AppVariables.baseUrl,
                );
            int deviceLimit = configService.getIntValue(
              key: 'config_soft_pos_device_limit',
              defaultValue: 1,
            );
            DeviceEmailRequest request = DeviceEmailRequest(
              deviceId: terminal.deviceId,
              deviceName: terminal.name,
              deviceLimit: deviceLimit.toString(),
              totalDevices: registerDevices.toString(),
              merchantId: terminal.merchantId,
              businessName: store.state.businessState.profile?.name ?? '',
              deviceBrand: terminal.brand,
            );
            Completer<bool> completer = Completer();
            store.dispatch(
              sendDeviceRegisteredEmail(request: request, completer: completer),
            );

            await completer.future;
            debugPrint('### DeviceMiddleware - unenrolDevice - email sent');
          } catch (e) {
            logger.error(
              'DeviceMiddleware',
              'Could not send device registered email',
              error: e,
              stackTrace: StackTrace.current,
            );
          }
        } else {
          isUnenrolled = true;
        }

        terminal.cardEnabled = !isUnenrolled;
        bool _ = await terminalManager.updateTerminal(terminal: terminal);
        debugPrint('### DeviceMiddleware - unenrolDevice - terminal updated');
        return;
        // bool hasSent = await terminalManager.updateTerminalProviderResponse(
        //   destinationTerminalId: deviceSenderId,
        //   sourceTerminalId: terminal.id,
        //   message: message,
        //   success: isUnenrolled,
        // );
      } catch (e) {
        debugPrint('### DeviceMiddleware - unenrolDevice - error: $e');
        logger.error(
          'DeviceMiddleware',
          'Error in unenrolDevice',
          error: e,
          stackTrace: StackTrace.current,
        );
        terminal.cardEnabled = !terminal.cardEnabled;
        bool _ = await terminalManager.updateTerminal(terminal: terminal);
        return;
      }
    });
  };
}

ThunkAction<AppState> pushTerminalSale({
  required CheckoutTransaction transaction,
}) {
  return (Store<AppState> store) async {
    final LoggerService logger = LittleFishCore.instance.get<LoggerService>();
    try {
      CheckoutVM vm = CheckoutVM.fromStore(store);

      CardTransactionType transactionType =
          isNotZeroOrNull(transaction.cashbackAmount)
          ? CardTransactionType.purchaseWithCashback
          : CardTransactionType.purchase;

      if (vm.canDoCardPayment()) {
        await showPopupDialog(
          context: globalNavigatorKey.currentContext!,
          content: CardPayment(
            transaction: transaction,
            amount: Decimal.parse(transaction.checkoutTotal.toString()),
            refund: null,
            backButtonTimeout: 30,
            paymentType: transactionType,
            cashBackAmount: Decimal.parse(
              (transaction.cashbackAmount ?? 0).toString(),
            ),
            parentContext: globalNavigatorKey.currentContext,
            transactionIsSaving: vm.isLoading ?? false,
            saveSale: (result) {
              processResult(
                vm: vm,
                result: result,
                transaction: transaction,
                goToCompletePage: false,
              );
            },
          ),
        );
      } else {
        vm.paymentType!.paid = true;
        vm.pushSale(globalNavigatorKey.currentContext!);
      }
    } catch (e) {
      logger.error(
        'DeviceMiddleware',
        'An unexpected error occurred whilst pushing terminal sale, $e',
        error: e,
        stackTrace: StackTrace.current,
      );
    }
  };
}

void processResult({
  required CheckoutVM vm,
  required result,
  required CheckoutTransaction transaction,
  bool goToCompletePage = true,
}) {
  if (result?['proceed'] == true) {
    vm.paymentType!.paid = safeParseBool(result['paid']);
    vm.paymentType!.providerPaymentReference = safeParseString(
      result['providerPaymentReference'],
    );

    vm.onSetTransaction(
      TransactionResultMapper.setTransactionData(
        currentTransaction: transaction,
        resultMap: result,
        deviceDetails: vm.deviceDetails,
      ),
    );
    var navToCompletePage = result['paid'] ? goToCompletePage : false;

    vm.pushSale(
      globalNavigatorKey.currentContext!,
      goToCompletePage: navToCompletePage,
    );
  } else if (vm.paymentType!.name!.toLowerCase() != 'card') {
    showMessageDialog(
      globalNavigatorKey.currentContext!,
      'Payment cancelled by user',
      LittleFishIcons.info,
    );
  }
}

class SetDeviceDetails {
  DeviceDetails? deviceDetails;

  SetDeviceDetails(this.deviceDetails);
}

class DeviceStateFailureAction {
  String value;

  DeviceStateFailureAction(this.value);
}

class DeviceStateLoadingAction {
  bool value;

  DeviceStateLoadingAction(this.value);
}

class InitializeDeviceDetailsAction {
  String? value;
  InitializeDeviceDetailsAction({this.value});
}
