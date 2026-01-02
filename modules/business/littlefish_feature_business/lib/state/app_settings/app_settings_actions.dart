// removed ignore: depend_on_referenced_packages

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:littlefish_core/reports/models/report.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/settings/orders/order_setting.dart';
import 'package:littlefish_merchant/models/settings/payments/payment_type.dart';
import 'package:littlefish_merchant/models/tax/sales_tax.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/settings_service.dart';

import '../../app/app.dart';
import '../../models/shared/data/address.dart';
import '../../models/store/business_profile.dart';
import '../../models/tax/vat_level.dart';
import '../../services/business_service.dart';
import '../business/business_actions.dart';

// import 'package:usb_serial/usb_serial.dart';

late SettingsService service;
late BusinessService businessService;

ThunkAction<AppState> initialzeSalesTax({bool refresh = false}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      var state = store.state.appSettingsState;

      if (!refresh && state.salesTax != null) {
        return;
      }

      store.dispatch(AppSettingsSetLoadingAction(true));

      await service
          .getSalesTax()
          .then((tax) {
            store.dispatch(AppSettingsSetSalesTaxAction(tax));
            store.dispatch(AppSettingsSetLoadingAction(false));
          })
          .catchError((e) {
            //logger.debug(this,e.toString());
            store.dispatch(AppSettingsSetLoadingAction(false));
            store.dispatch(AppSettingsSetFault(e.toString()));
          });
    });
  };
}

ThunkAction<AppState> initializeTicketSettings({bool refresh = false}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      var state = store.state.appSettingsState;

      if (!refresh && state.allowTickets != null) {
        return;
      }
      if (store.state.hasInternet ?? false) {
        store.dispatch(AppSettingsSetLoadingAction(true));

        await service
            .getTicketPreference()
            .then((settings) {
              store.dispatch(AppSettingsSetAllowTicketsAction(settings.value));
              store.dispatch(AppSettingsSetLoadingAction(false));
            })
            .catchError((e) {
              //logger.debug(this,e.toString());
              store.dispatch(AppSettingsSetLoadingAction(false));
              store.dispatch(AppSettingsSetFault(e.toString()));
            });
      } else {
        store.dispatch(AppSettingsSetAllowTicketsAction(false));
      }
    });
  };
}

ThunkAction<AppState> setSalesTax({bool refresh = false}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(AppSettingsSetLoadingAction(true));

      await service
          .getSalesTax()
          .then((tax) {
            store.dispatch(AppSettingsSetSalesTaxAction(tax));
            store.dispatch(AppSettingsSetLoadingAction(false));
          })
          .catchError((e) {
            store.dispatch(AppSettingsSetLoadingAction(false));
            store.dispatch(AppSettingsSetFault(e.toString()));
          });
    });
  };
}

ThunkAction<AppState> updateSalesTax({
  required SalesTax? item,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);
      store.dispatch(AppSettingsSetLoadingAction(true));

      await service
          .updateSalesTax(setting: item!)
          .then((tax) {
            store.dispatch(AppSettingsSetSalesTaxAction(tax));

            completer?.complete();
          })
          .catchError((e) {
            store.dispatch(AppSettingsSetFault(e.toString()));
            store.dispatch(AppSettingsSetLoadingAction(false));

            completer?.completeError(e);
          });
    });
  };
}

ThunkAction<AppState> updateBusinessTaxDetailsThunk({
  required String? taxNumber,
  required Address? address,
  required bool? vatEnabled,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    try {
      _initializeBusinessService(store);
      store.dispatch(AppSettingsSetLoadingAction(true));
      final BusinessProfile? existingProfile =
          AppVariables.store?.state.businessState.profile;

      if (existingProfile == null) {
        throw Exception("Business profile not found in state.");
      }

      final updatedProfile = BusinessProfile.fromJson(existingProfile.toJson());

      updatedProfile.taxNumber = taxNumber;
      // updatedProfile.address = address;
      updatedProfile.vatBillingAddress = address;
      updatedProfile.vatEnabled = vatEnabled;

      var result = await businessService.updateBusinessProfile(updatedProfile);

      store.dispatch(BusinessProfileLoadedAction(result));

      store.dispatch(AppSettingsSetLoadingAction(false));

      completer?.complete();
    } catch (e) {
      store.dispatch(AppSettingsSetLoadingAction(false));
      completer?.completeError(e);
      store.dispatch(AppSettingsSetFault(e.toString()));
    }
  };
}

ThunkAction<AppState> getBusinessSalesTaxes({Completer? completer}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(AppSettingsSetLoadingAction(true));

      await service
          .getSalesTaxes()
          .then((taxList) {
            store.dispatch(AppSettingsSetSalesTaxesListAction(taxList));
            store.dispatch(AppSettingsSetLoadingAction(false));
            completer?.complete();
          })
          .catchError((e) {
            store.dispatch(AppSettingsSetFault(e.toString()));
            store.dispatch(AppSettingsSetLoadingAction(false));
            completer?.completeError(e);
          });
    });
  };
}

ThunkAction<AppState> getVatLevelsThunk({Completer? completer}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(AppSettingsSetLoadingAction(true));

      await service
          .getVatLevels()
          .then((vatLevels) {
            store.dispatch(AppSettingsSetVatLevelsListAction(vatLevels));
            store.dispatch(AppSettingsSetLoadingAction(false));
            completer?.complete();
          })
          .catchError((e) {
            store.dispatch(AppSettingsSetFault(e.toString()));
            store.dispatch(AppSettingsSetLoadingAction(false));
            completer?.completeError(e);
          });
    });
  };
}

ThunkAction<AppState> setPaymentTypes() {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        _initializeService(store);

        var state = store.state.appSettingsState;
        var zapperEnabled =
            store.state.environmentState.environmentConfig!.zapperEnabled;
        var snapscanEnabled =
            store.state.environmentState.environmentConfig!.snapscanEnabled;

        if (state.paymentTypes.isNotEmpty) {
          return;
        }

        store.dispatch(AppSettingsSetLoadingAction(true));

        var value = await service.loadPaymentTypes(
          zapperEnabled: zapperEnabled!,
          snapscanEnabled: snapscanEnabled!,
        );

        store.dispatch(AppSettingsLoadedPaymentTypesAction(value));
        store.dispatch(AppSettingsSetLoadingAction(false));
      } catch (e) {
        store.dispatch(AppSettingsSetFault(e.toString()));
        store.dispatch(AppSettingsSetLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> setClientPaymentTypes() {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        _initializeService(store);
        var state = store.state.appSettingsState;
        if (state.paymentTypes.isNotEmpty) {
          return;
        }

        store.dispatch(AppSettingsSetLoadingAction(true));

        var availablePaymentTypes = await service.getAllPaymentTypes();
        List<PaymentType> clientPaymentTypes = sortPaymentTypes(
          availablePaymentTypes,
        );

        store.dispatch(AppSettingsLoadedPaymentTypesAction(clientPaymentTypes));
        store.dispatch(AppSettingsSetLoadingAction(false));
      } catch (e) {
        store.dispatch(AppSettingsSetFault(e.toString()));
        store.dispatch(AppSettingsSetLoadingAction(false));
      }
    });
  };
}

List<PaymentType> sortPaymentTypes(List<PaymentType> availablePaymentTypes) {
  availablePaymentTypes.sort(
    (a, b) => a.displayIndex!.compareTo(b.displayIndex!),
  );
  return availablePaymentTypes;
}

ThunkAction<AppState> setPaymentType({
  required bool? enabled,
  required String? name,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);
      await service
          .setPaymentPreference(name, enabled)
          .then((value) {
            store.dispatch(AppSettingsSetPaymentType(enabled, name));
            completer?.complete();
          })
          .catchError((e) {
            store.dispatch(AppSettingsSetFault(e.toString()));
            completer?.completeError(e);
          });
    });
  };
}

ThunkAction<AppState> setTicketAllowed({
  required bool enabled,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);
      await service
          .setTicketAllowed(enabled)
          .then((value) {
            store.dispatch(AppSettingsSetAllowTicketsAction(enabled));
            completer?.complete();
          })
          .catchError((e) {
            store.dispatch(AppSettingsSetFault(e.toString()));
            completer?.completeError(e);
          });
    });
  };
}

ThunkAction<AppState> updateOrderSettings({required OrderSetting? settings}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(AppSettingsSetLoadingAction(true));

      await service
          .updateOrCreateOrderSetting(settings!)
          .then((value) {
            store.dispatch(AppSettingsSetOrderSettingAction(value));
            store.dispatch(AppSettingsSetLoadingAction(false));
          })
          .catchError((e) {
            store.dispatch(AppSettingsSetFault(e.toString()));
            store.dispatch(AppSettingsSetLoadingAction(false));
          });
    });
  };
}

ThunkAction<AppState> getOrderSetttings({bool refresh = false}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      var settings = store.state.appSettingsState.orderSettings;

      if (settings != null && !refresh) return;

      store.dispatch(AppSettingsSetLoadingAction(true));

      await service
          .getOrderSettings()
          .then((value) {
            store.dispatch(AppSettingsSetOrderSettingAction(value));
            store.dispatch(AppSettingsSetLoadingAction(false));
          })
          .catchError((e) {
            store.dispatch(AppSettingsSetFault(e.toString()));
            store.dispatch(AppSettingsSetLoadingAction(false));
          });
    });
  };
}

_initializeService(Store<AppState> store) {
  service = SettingsService(
    store: store,
    baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
    businessId: store.state.currentBusinessId,
    token: store.state.authState.token,
  );
}

_initializeBusinessService(Store<AppState> store) {
  businessService = BusinessService(
    store: store,
    baseUrl: store.state.environmentState.environmentConfig?.baseUrl,
    businessId: store.state.currentBusinessId,
    token: store.state.authState.token,
  );
}

class AppSettingsSetSalesTaxAction {
  SalesTax value;

  AppSettingsSetSalesTaxAction(this.value);
}

class AppSettingsSetSalesTaxesListAction {
  final List<SalesTax> taxes;
  AppSettingsSetSalesTaxesListAction(this.taxes);
}

class AppSettingsSetVatLevelsListAction {
  final List<VatLevel> vatLevels;
  AppSettingsSetVatLevelsListAction(this.vatLevels);
}

class AppSettingsSetFault {
  String value;

  AppSettingsSetFault(this.value);
}

class AppSettingsSetLoadingAction {
  bool value;

  AppSettingsSetLoadingAction(this.value);
}

class AppSettingsSetAllowTicketsAction {
  bool? value;

  AppSettingsSetAllowTicketsAction(this.value);
}

class AppSettingsLoadedPaymentTypesAction {
  List<PaymentType> value;

  AppSettingsLoadedPaymentTypesAction(this.value);
}

class AppSettingsSetOrderSettingAction {
  OrderSetting value;

  AppSettingsSetOrderSettingAction(this.value);
}

class AppSettingsSetPaymentType {
  bool? value;

  String? name;

  AppSettingsSetPaymentType(this.value, this.name);
}

// class AppSettingsSetUsbPrinterAction {
//   UsbDevice value;

//   AppSettingsSetUsbPrinterAction(value);
// }

// class AppSettingsSetUsbScannerAction {
//   UsbDevice value;

//   AppSettingsSetUsbScannerAction(value);
// }

// class AppSettingsSetUsbDeviceList {
//   List<UsbDevice> value;

//   AppSettingsSetUsbDeviceList(value);
// }

class AppSettingsOrderItemChangedAction {
  OrderSettingItem item;

  ChangeType type;

  AppSettingsOrderItemChangedAction(this.item, this.type);
}

class SetPackageInformationAction {
  String? packageName;

  String? appName;

  String? buildNumber;

  String? versionNumber;

  SetPackageInformationAction({
    this.appName,
    this.buildNumber,
    this.packageName,
    this.versionNumber,
  });
}

class SetUserReportsAction {
  List<Report> reports;

  SetUserReportsAction(this.reports);
}

class SetReportVersionAction {
  String version;

  SetReportVersionAction(this.version);
}

class SetSelectedReportAction {
  Report report;

  SetSelectedReportAction(this.report);
}

class SetHomeContentVersionAction {
  String version;

  SetHomeContentVersionAction(this.version);
}

class SetAppFlavorAction {
  String value;

  SetAppFlavorAction(this.value);
}

class SetAppUseCaseAction {
  String value;

  SetAppUseCaseAction(this.value);
}

class SetAppEnvironmentAction {
  String value;

  SetAppEnvironmentAction(this.value);
}

class SetAppIntegrityCheckAction {
  final String? checksum;
  final String? signature;

  SetAppIntegrityCheckAction({this.checksum, this.signature});
}

class SetSslFingerPrint {
  final String? sslFingerPrint;

  SetSslFingerPrint(this.sslFingerPrint);
}

class SetThemeAction {
  ThemeData value;

  SetThemeAction(this.value);
}
