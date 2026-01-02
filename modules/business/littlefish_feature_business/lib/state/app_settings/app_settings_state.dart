// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:built_value/built_value.dart';
import 'package:flutter/material.dart' as material;
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/reports/models/report.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/expenses/business_expense.dart';
import 'package:littlefish_merchant/models/expenses/expense_payment_categories/get_enabled_expense_payment_categories.dart';
import 'package:littlefish_merchant/models/expenses/expenses_payment_types/get_enabled_expense_payment_types.dart';

// Project imports:
import 'package:littlefish_merchant/models/settings/orders/order_setting.dart';
import 'package:littlefish_merchant/models/settings/payments/payment_type.dart';
import 'package:littlefish_merchant/models/tax/sales_tax.dart';
import 'package:littlefish_merchant/tools/payment_types_helper/soft_pos_helper.dart';
import 'package:littlefish_payments/gateways/pos_payment_gateway.dart';

import '../../models/settings/payments/payment_type_list.dart';
import '../../models/tax/vat_level.dart';

// import 'package:usb_serial/usb_serial.dart';

part 'app_settings_state.g.dart';

@immutable
abstract class AppSettingsState
    implements Built<AppSettingsState, AppSettingsStateBuilder> {
  const AppSettingsState._();

  factory AppSettingsState() => _$AppSettingsState._(
    hasError: false,
    isLoading: false,
    errorMessage: null,
    allowTickets: false,
    paymentTypes: const [],
    loyaltySettings: LoyaltySetting(enabled: false, percentage: 0),
    allowStoreCredit: false,
    userReports: const [],
    reportVersion: 'default',
    homeContentVersion: 'default',
    appTheme: null,
  );

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isLoading;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get hasError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get errorMessage;

  SalesTax? get salesTax;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<SalesTax>? get salesTaxesList;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<VatLevel>? get vatLevelsList;

  OrderSetting? get orderSettings;

  bool? get allowTickets;

  bool? get allowStoreCredit;

  List<Report>? get userReports;

  String? get reportVersion;

  Report? get selectedReport;

  List<PaymentType> get paymentTypes;

  String? get homeContentVersion;

  String? get appFlavor;

  material.ThemeData? get appTheme;

  // TODO(lampian): make provision for pax for backwards compatibility
  bool get isPOSBuild =>
      (appFlavor ?? '').toLowerCase().contains('pos') ||
      (appFlavor ?? '').toLowerCase().contains('pax') ||
      (appFlavor ?? '').toLowerCase().contains('verifone') ||
      (appFlavor ?? '').toLowerCase().contains('ingenico');

  String? get appUseCase;

  String? get appEnvironment;

  String? get appIntegrityCheck;

  String? get sslFingerPrint;

  List<PaymentType> get refundPaymentTypes {
    var refundTypes = <PaymentType>[];
    final ldTypes = getIt.get<PaymentTypeList>();

    if (ldTypes.refundTypes.isEmpty) {
      return [];
    }

    for (final item in ldTypes.refundTypes) {
      final indexFound = paymentTypes.indexWhere(
        (e) => e.name?.toLowerCase() == item.toLowerCase(),
      );

      bool isNotFound = indexFound == -1;
      if (isNotFound) {
        continue;
      }

      if (paymentTypes[indexFound].enabled != true) {
        continue;
      }

      if (paymentTypes[indexFound].isCard) {
        if (isPosWithoutGateway || AppVariables.isMobileWithoutSoftPos) {
          continue;
        }
      }

      refundTypes.add(paymentTypes[indexFound]);
    }
    return refundTypes;
  }

  List<PaymentType> get quickRefundPaymentTypes {
    var refundTypes = <PaymentType>[];
    final ldTypes = getIt.get<PaymentTypeList>();
    bool isSoftPos = SoftPosHelper.hasSoftPosProvider();

    if (ldTypes.refundTypes.isEmpty) {
      return [];
    }

    for (final item in ldTypes.refundTypes) {
      final indexFound = paymentTypes.indexWhere(
        (e) => e.name?.toLowerCase() == item.toLowerCase(),
      );

      bool isNotFound = indexFound == -1;
      if (isNotFound) {
        continue;
      }

      if (paymentTypes[indexFound].enabled != true) {
        continue;
      }

      if (paymentTypes[indexFound].isCard) {
        if (isPosWithoutGateway ||
            isSoftPos ||
            AppVariables.isMobileWithoutSoftPos) {
          // dont add card for softpos quick refunds
          continue;
        }
      }

      refundTypes.add(paymentTypes[indexFound]);
    }

    refundTypes = paymentTypes;
    if (isSoftPos) {
      refundTypes.removeWhere((type) => type.isCard);
    }
    return refundTypes;
  }

  List<PaymentType> get voidPaymentTypes {
    var voidTypes = <PaymentType>[];
    final ldTypes = getIt.get<PaymentTypeList>();

    if (ldTypes.voidTypes.isEmpty) {
      return [];
    }

    for (final item in ldTypes.voidTypes) {
      final indexFound = paymentTypes.indexWhere(
        (e) => e.name?.toLowerCase() == item.toLowerCase(),
      );

      bool isNotFound = indexFound == -1;
      if (isNotFound) {
        continue;
      }

      if (paymentTypes[indexFound].enabled != true) {
        continue;
      }

      if (paymentTypes[indexFound].isCard) {
        if (isPosWithoutGateway || AppVariables.isMobileWithoutSoftPos) {
          continue;
        }
      }

      voidTypes.add(paymentTypes[indexFound]);
    }
    return voidTypes;
  }

  List<PaymentType> get withdrawalPaymentTypes {
    if (isPosWithoutGateway || AppVariables.isMobileWithoutSoftPos) {
      return [];
    }

    return paymentTypes
        .where((type) => type.isCard && type.enabled == true)
        .toList();
  }

  bool get isPosWithoutGateway {
    final core = LittleFishCore.instance;

    return AppVariables.isPOSBuild && !core.isRegistered<POSPaymentGateway>();
  }

  List<PaymentType> get checkoutPaymentTypes {
    if (isPosWithoutGateway || AppVariables.isMobileWithoutSoftPos) {
      return paymentTypes
          .where((type) => !type.isCard && type.enabled == true)
          .toList();
    }

    return paymentTypes.where((type) => type.enabled == true).toList();
  }

  List<PaymentType> get availablePaymentTypes {
    return paymentTypes;
  }

  List<SourceOfFunds> get allExpenseSources => SourceOfFunds.values.toList();

  List<SourceOfFunds> get allowedExpenseSources {
    return getEnabledExpensePaymentTypes();
  }

  List<ExpenseType> get allowedExpenseCategories {
    return getEnabledExpenseCategories();
  }

  // @nullable
  // List<UsbDevice> get usbDeviceList;

  // @nullable
  // UsbDevice get usbPrinter;

  // @nullable
  // UsbDevice get usbScanner;

  LoyaltySetting? get loyaltySettings;

  String? get appVersion;

  String? get buildNumber;

  String? get appName;

  String? get packageName;
}

class LoyaltySetting {
  bool? enabled;

  double? percentage;

  LoyaltySetting({this.enabled, this.percentage});
}
