// Package imports:
// removed ignore: depend_on_referenced_packages
import 'dart:convert';

import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/redux/app_settings/app_settings_actions.dart';
import 'package:littlefish_merchant/redux/app_settings/app_settings_state.dart';

final appSettingsReducer = combineReducers<AppSettingsState>([
  TypedReducer<AppSettingsState, AppSettingsSetLoadingAction>(
    onSetLoading,
  ).call,
  TypedReducer<AppSettingsState, AppSettingsLoadedPaymentTypesAction>(
    onSetPaymentTypes,
  ).call,
  TypedReducer<AppSettingsState, AppSettingsSetAllowTicketsAction>(
    onSetAllowTickets,
  ).call,
  TypedReducer<AppSettingsState, AppSettingsSetSalesTaxAction>(
    onSetSalesTax,
  ).call,
  TypedReducer<AppSettingsState, AppSettingsSetFault>(onSetFault).call,
  TypedReducer<AppSettingsState, AppSettingsSetPaymentType>(
    onSetPaymentType,
  ).call,
  TypedReducer<AppSettingsState, AppSettingsSetOrderSettingAction>(
    onSetOrderSettings,
  ).call,
  TypedReducer<AppSettingsState, AppSettingsOrderItemChangedAction>(
    onOrderItemChanged,
  ).call,
  TypedReducer<AppSettingsState, SetPackageInformationAction>(
    onSetPackageInformation,
  ).call,
  TypedReducer<AppSettingsState, SetHomeContentVersionAction>(
    onSetHomeContentVersion,
  ).call,
  TypedReducer<AppSettingsState, SetReportVersionAction>(
    onSetReportsVersion,
  ).call,
  TypedReducer<AppSettingsState, SetAppFlavorAction>(onSetAppFlavor).call,
  TypedReducer<AppSettingsState, SetAppUseCaseAction>(onSetAppUseCase).call,
  TypedReducer<AppSettingsState, SetAppEnvironmentAction>(
    onSetAppEnvironment,
  ).call,
  TypedReducer<AppSettingsState, SetAppIntegrityCheckAction>(
    onSetAppIntegrityCheckAction,
  ).call,
  TypedReducer<AppSettingsState, SetSslFingerPrint>(onSetSslFingerPrint).call,
  TypedReducer<AppSettingsState, AppSettingsSetSalesTaxesListAction>(
    onSetSalesTaxesList,
  ).call,
  TypedReducer<AppSettingsState, AppSettingsSetVatLevelsListAction>(
    onSetVatLevelsList,
  ).call,

  TypedReducer<AppSettingsState, SetThemeAction>(onSetThemeAction).call,
]);

AppSettingsState onSetLoading(
  AppSettingsState state,
  AppSettingsSetLoadingAction action,
) {
  return state.rebuild((b) => b.isLoading = action.value);
}

AppSettingsState onSetSalesTax(
  AppSettingsState state,
  AppSettingsSetSalesTaxAction action,
) {
  return state.rebuild((b) => b.salesTax = action.value);
}

AppSettingsState onSetSalesTaxesList(
  AppSettingsState state,
  AppSettingsSetSalesTaxesListAction action,
) {
  return state.rebuild((b) => b.salesTaxesList = action.taxes);
}

AppSettingsState onSetVatLevelsList(
  AppSettingsState state,
  AppSettingsSetVatLevelsListAction action,
) {
  return state.rebuild((b) => b.vatLevelsList = action.vatLevels);
}

AppSettingsState onSetOrderSettings(
  AppSettingsState state,
  AppSettingsSetOrderSettingAction action,
) => state.rebuild((b) => b.orderSettings = action.value);

AppSettingsState onSetAllowTickets(
  AppSettingsState state,
  AppSettingsSetAllowTicketsAction action,
) => state.rebuild((b) => b.allowTickets = action.value);

AppSettingsState onSetPaymentTypes(
  AppSettingsState state,
  AppSettingsLoadedPaymentTypesAction action,
) {
  return state.rebuild((b) => b.paymentTypes = action.value);
}

AppSettingsState onSetFault(
  AppSettingsState state,
  AppSettingsSetFault action,
) => state.rebuild((b) {
  b.errorMessage = action.value;
  b.hasError = true;
});

AppSettingsState onSetPaymentType(
  AppSettingsState state,
  AppSettingsSetPaymentType action,
) => state.rebuild((b) {
  int typeIndex = b.paymentTypes!.indexWhere(
    (p) => p.name!.toLowerCase() == action.name!.toLowerCase(),
  );
  b.paymentTypes = b.paymentTypes!..[typeIndex].enabled = action.value;
});

// AppSettingsState onSetUsbPrinter(
//         AppSettingsState state, AppSettingsSetUsbPrinterAction action) =>
//     state.rebuild((b) => b.usbPrinter = action.value);

// AppSettingsState onSetUsbScanner(
//         AppSettingsState state, AppSettingsSetUsbScannerAction action) =>
//     state.rebuild((b) => b.usbScanner = action.value);

// AppSettingsState onSetUsbDeviceList(
//         AppSettingsState state, AppSettingsSetUsbDeviceList action) =>
//     state.rebuild((b) => b.usbDeviceList = action.value);

AppSettingsState onOrderItemChanged(
  AppSettingsState state,
  AppSettingsOrderItemChangedAction action,
) {
  return state.rebuild((b) {
    if (action.type == ChangeType.removed) {
      b.orderSettings!.items = b.orderSettings!.items!
        ..removeWhere((c) => c.id == action.item.id);
    } else {
      var setting = b.orderSettings!;

      if (setting.items == null || setting.items!.isEmpty) {
        b.orderSettings!.items = [action.item];
      } else {
        var existingIndex = setting.items!.indexWhere(
          (c) => c.id == action.item.id,
        );

        if (existingIndex >= 0) {
          b.orderSettings!.items = b.orderSettings!.items!
            ..[existingIndex] = action.item;
        } else {
          b.orderSettings!.items = b.orderSettings!.items!..add(action.item);
        }
      }
    }
  });
}

AppSettingsState onSetPackageInformation(
  AppSettingsState state,
  SetPackageInformationAction action,
) => state.rebuild((b) {
  b.buildNumber = action.buildNumber;
  b.packageName = action.packageName;
  b.appVersion = action.versionNumber;
  b.appName = action.appName;
});

// AppSettingsState onSetStoreCredit(
//         AppSettingsState state, AppSettingsChangeStoreCreditAction action) =>
//     state.rebuild((b) {
//       b.allowStoreCredit = action.value ?? false;
//     });

AppSettingsState onSetHomeContentVersion(
  AppSettingsState state,
  SetHomeContentVersionAction action,
) => state.rebuild((b) => b.homeContentVersion = action.version);

AppSettingsState onSetReportsVersion(
  AppSettingsState state,
  SetReportVersionAction action,
) => state.rebuild((b) => b.reportVersion = action.version);

AppSettingsState onSetAppFlavor(
  AppSettingsState state,
  SetAppFlavorAction action,
) => state.rebuild((b) => b.appFlavor = action.value);

AppSettingsState onSetAppUseCase(
  AppSettingsState state,
  SetAppUseCaseAction action,
) => state.rebuild((b) => b.appUseCase = action.value);

AppSettingsState onSetAppEnvironment(
  AppSettingsState state,
  SetAppEnvironmentAction action,
) => state.rebuild((b) => b.appEnvironment = action.value);

AppSettingsState onSetAppIntegrityCheckAction(
  AppSettingsState state,
  SetAppIntegrityCheckAction action,
) {
  final map = {'checksum': action.checksum, 'signature': action.signature};
  final jsonString = jsonEncode(map);
  final base64String = base64Encode(utf8.encode(jsonString));
  return state.rebuild((b) => b.appIntegrityCheck = base64String);
}

AppSettingsState onSetSslFingerPrint(
  AppSettingsState state,
  SetSslFingerPrint action,
) => state.rebuild((b) => b.sslFingerPrint = action.sslFingerPrint);

AppSettingsState onSetThemeAction(
  AppSettingsState state,
  SetThemeAction action,
) => state.rebuild((b) => b.appTheme = action.value);
