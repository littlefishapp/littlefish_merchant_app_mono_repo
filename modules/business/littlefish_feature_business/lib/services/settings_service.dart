// Package imports:
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/tax/vat_level.dart';
import 'package:littlefish_merchant/tools/payment_types_helper/soft_pos_helper.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:littlefish_merchant/models/assets/app_assets.dart';
import 'package:littlefish_merchant/models/settings/orders/order_setting.dart';
import 'package:littlefish_merchant/models/settings/payments/payment_type.dart';
import 'package:littlefish_merchant/models/store/business_profile.dart';
import 'package:littlefish_merchant/models/store/business_system_value.dart';
import 'package:littlefish_merchant/models/tax/sales_tax.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

import '../models/settings/payments/payment_type_list.dart';

// import 'package:usb_serial/usb_serial.dart';

LittleFishCore core = LittleFishCore.instance;

LoggerService get logger => LittleFishCore.instance.get<LoggerService>();

class SettingsService {
  SettingsService({
    required this.baseUrl,
    required this.businessId,
    required this.token,
    required this.store,
  }) {
    client = RestClient(store: store as Store<AppState>?);
  }

  Store store;

  late RestClient client;

  String? baseUrl, businessId, token;

  Future<SalesTax> getSalesTax() async {
    var response = await client.get(
      url: '$baseUrl/Business/GetBusinessSalesTax/businessId=$businessId',
      token: token,
    );

    if (response?.statusCode == 200) {
      var result = SalesTax.fromJson(response!.data);

      return result;
    } else {
      throw Exception('Bad server response, unable to load sales tax');
    }
  }

  Future<OrderSetting> getOrderSettings() async {
    var response = await client.get(
      url: '$baseUrl/Business/GetBusinessOrdersMode/businessId=$businessId',
      token: token,
    );

    if (response?.statusCode == 200) {
      return OrderSetting.fromJson(response!.data);
    } else {
      throw Exception('Bad server response, unable to get orders mode');
    }
  }

  Future<OrderSetting> updateOrCreateOrderSetting(OrderSetting setting) async {
    var response = await client.put(
      url: '$baseUrl/Business/SetBusinessOrdersMode/businessId=$businessId',
      token: token,
      requestData: setting.toJson(),
    );

    if (response?.statusCode == 200) {
      return OrderSetting.fromJson(response!.data);
    } else {
      throw Exception('Bad server response, unable to set orders mode');
    }
  }

  Future<BusinessSystemValue> setDeviceName(String deviceName) async {
    var response = await client.put(
      url:
          '$baseUrl/Business/SetDeviceName/businessId=$businessId,deviceName=$deviceName',
      token: token,
    );

    if (response?.statusCode == 200) {
      return BusinessSystemValue.fromJson(response!.data);
    } else {
      throw Exception('Bad server response, unable to set device name');
    }
  }

  Future<BusinessSystemValue> getDeviceName() async {
    var response = await client.get(
      url: '$baseUrl/Business/GetDeviceName/businessId=$businessId',
      token: token,
    );

    if (response?.statusCode == 200) {
      return BusinessSystemValue.fromJson(response!.data);
    } else {
      throw Exception('Bad server response, unable to get device name');
    }
  }

  Future<BusinessSystemValue> setPaymentPreference(
    String? paymentType,
    bool? enabled,
  ) async {
    var response = await client.put(
      url:
          '$baseUrl/Business/SetPaymentTypePreference/businessId=$businessId,paymentType=$paymentType,enabled=$enabled',
      token: token,
    );

    if (response?.statusCode == 200) {
      return BusinessSystemValue.fromJson(response!.data);
    } else {
      throw Exception('Bad server response, unable to set payment preference');
    }
  }

  Future<StoreCreditSettings> setStoreCredit(
    StoreCreditSettings settings,
  ) async {
    var response = await client.post(
      url: '$baseUrl/Business/UpsertCreditSettings/businessId=$businessId',
      token: token,
      requestData: settings.toJson(),
    );

    if (response?.statusCode == 200) {
      return StoreCreditSettings.fromJson(response!.data);
    } else {
      throw Exception('Bad server response, unable to set payment preference');
    }
  }

  Future<bool?> disableStoreCredit(StoreCreditSettings? settings) async {
    var response = await client.post(
      url: '$baseUrl/Business/DisableCreditSettings/businessId=$businessId',
      token: token,
    );

    if (response?.statusCode == 200) {
      return response!.data;
    } else {
      throw Exception('Bad server response, unable to set payment preference');
    }
  }

  Future<BusinessSystemValue> setMerchantValue(
    String key,
    dynamic value,
  ) async {
    var response = await client.put(
      url: '$baseUrl/Business/SetBusinessValue/businessId=$businessId',
      token: token,
      requestData: BusinessSystemValue(
        businessId: businessId,
        id: const Uuid().v4(),
        key: key,
        sectionKey: 'business',
        value: value,
      ).toJson(),
    );

    if (response?.statusCode == 200) {
      return BusinessSystemValue.fromJson(response!.data);
    } else {
      throw Exception('Bad server response, unable to set merchant preference');
    }
  }

  //ToDo: Verify this is the right call and format
  Future<BusinessSystemValue> getMerchantValue(
    String key,
    dynamic value,
  ) async {
    var response = await client.get(
      url:
          '$baseUrl/Business/GetBusinessValue/businessId=$businessId,key=$key,sectionKey=business',
      token: token,
    );

    if (response?.statusCode == 200) {
      return BusinessSystemValue.fromJson(response!.data);
    } else {
      throw Exception('Bad server response, unable to set merchant preference');
    }
  }

  Future<BusinessSystemValue> setTicketAllowed(bool enabled) async {
    var response = await client.put(
      url: '$baseUrl/Business/SetBusinessValue/businessId=$businessId',
      token: token,
      requestData: BusinessSystemValue(
        businessId: businessId,
        id: const Uuid().v4(),
        key: 'ticket',
        sectionKey: 'business',
        value: enabled,
      ).toJson(),
    );

    if (response?.statusCode == 200) {
      return BusinessSystemValue.fromJson(response!.data);
    } else {
      throw Exception('Bad server response, unable to set ticket preference');
    }
  }

  Future<BusinessSystemValue> getTicketPreference() async {
    var response = await client.get(
      url: '$baseUrl/Business/GetTicketPreference/businessId=$businessId',
      token: token,
    );

    if (response?.statusCode == 200) {
      return BusinessSystemValue.fromJson(response!.data);
    } else {
      throw Exception(
        'Bad server response, unable to retrive ticket preference',
      );
    }
  }

  Future<List<BusinessSystemValue>> getPaymentPreferences() async {
    var response = await client.get(
      url: '$baseUrl/Business/GetPaymentTypePreferences/businessId=$businessId',
      token: token,
    );

    if (response?.statusCode == 200) {
      return (response!.data as List)
          .map((bv) => BusinessSystemValue.fromJson(bv))
          .toList();
    } else {
      throw Exception('Bad server response, unable to getPaymentPreferences');
    }
  }

  Future<BusinessSystemValue> setDeviceInterface(
    String deviceType,
    dynamic device,
  ) async {
    var response = await client.put(
      url:
          '$baseUrl/Business/SetDeviceInterface/businessId=$businessId,deviceType=$deviceType',
      token: token,
      requestData: device,
    );

    if (response?.statusCode == 200) {
      return BusinessSystemValue.fromJson(response!.data);
    } else {
      throw Exception('Bad server response, unable to set device interface');
    }
  }

  Future<SalesTax> updateSalesTax({required SalesTax setting}) async {
    var response = await client.put(
      url: '$baseUrl/Business/UpdateBusinessSalesTax/businessId=$businessId',
      token: token,
      requestData: setting.toJson(),
    );

    if (response?.statusCode == 200) {
      return SalesTax.fromJson(response!.data);
    } else {
      throw Exception('Bad server response, unable to update sales tax');
    }
  }

  Future<List<SalesTax>> getSalesTaxes() async {
    var response = await client.get(
      url: '$baseUrl/Business/GetBusinessSalesTaxes/businessId=$businessId',
      token: token,
    );

    if (response?.statusCode == 200 && response?.data is List) {
      return (response!.data as List)
          .map((item) => SalesTax.fromJson(item))
          .toList();
    } else {
      throw Exception('Bad server response, unable to load sales taxes');
    }
  }

  Future<List<VatLevel>> getVatLevels() async {
    final response = await client.get(
      url: '$baseUrl/Business/GetGlobalTax',
      token: token,
    );

    if (response?.statusCode == 200 && response?.data['vatLevels'] is List) {
      return (response!.data['vatLevels'] as List)
          .map((e) => VatLevel.fromJson(e))
          .toList();
    } else {
      throw Exception('Unable to load VAT levels');
    }
  }

  Future<List<PaymentType>> loadPaymentTypes({
    required bool zapperEnabled,
    required bool snapscanEnabled,
  }) async {
    var response = await client.get(
      url: '$baseUrl/Business/GetPaymentTypePreferences/businessId=$businessId',
      token: token,
    );

    var types = _fallBackPaymentTypes();

    if (!zapperEnabled) {
      types = types.where((x) => x.provider != PaymentProvider.zapper).toList();
    }

    if (!snapscanEnabled) {
      types = types
          .where((x) => x.provider != PaymentProvider.snapscan)
          .toList();
    }

    if (response?.statusCode == 200) {
      if (response!.data == null) return types;

      for (var pt in (response.data as List)) {
        var key = pt['key'] as String?;
        var value = pt['value'] as bool?;

        if (value != null &&
            types.any((t) => t.name!.toLowerCase() == key?.toLowerCase())) {
          var typeIndex = types.indexWhere(
            (t) => t.name!.toLowerCase() == key?.toLowerCase(),
          );

          types[typeIndex].enabled = value;
        }
      }
    } else {
      return types;
    }

    return types;
  }

  Future<List<PaymentType>> getAllPaymentTypes() async {
    var response = await client.get(
      url: '$baseUrl/Business/GetPaymentTypePreferences/businessId=$businessId',
      token: token,
    );

    var types = _fallBackPaymentTypes();
    final ldTypes = getIt.get<PaymentTypeList>();
    if (ldTypes.types.isNotEmpty) {
      types = ldTypes.types;
    }
    for (final item in types) {
      item.icon = getPaymentTypeIcon(item.name ?? '');
    }

    if (response?.statusCode == 200) {
      if (response?.data != null && response!.data is List) {
        final paymentTypeList = getPaymentTypesWithoutPreferences(
          types,
          response.data,
        );
        for (var paymentTypeMap in response.data) {
          if (paymentTypeMap is Map) {
            var name = '';
            if (paymentTypeMap.containsKey('key')) {
              name = paymentTypeMap['key'];
              name = name.toLowerCase();
            }
            var backendTypeEnabled = false;
            if (paymentTypeMap.containsKey('value')) {
              backendTypeEnabled = paymentTypeMap['value'];
            }

            final ldPaymentType = types.firstWhere(
              (e) => e.name?.toLowerCase() == name,
              orElse: () => PaymentType(),
            );
            bool cardEnabled = await SoftPosHelper.checkCardEnablement(
              ldPaymentType.name,
            );
            if (cardEnabled) {
              ldPaymentType.enabled = backendTypeEnabled;
              paymentTypeList.add(ldPaymentType);
            } else if (ldPaymentType.enabled == true) {
              ldPaymentType.enabled = backendTypeEnabled;
              paymentTypeList.add(ldPaymentType);
            }
          }
        }
        return paymentTypeList;
      }
    }
    return types;
  }

  List<PaymentType> getPaymentTypesWithoutPreferences(
    List<PaymentType> configTypes,
    List<dynamic> preferences,
  ) {
    if (preferences.isEmpty) {
      return configTypes.map((type) => PaymentType.clone(type)).toList();
    }

    final paymentTypesWithoutPreferences = <PaymentType>[];
    List<PaymentType> enabledConfigTypes = configTypes
        .where((type) => type.enabled == true)
        .toList();
    for (PaymentType type in enabledConfigTypes) {
      if (!preferences.any((preference) {
        if (preference is! Map) {
          return false;
        } else {
          return (preference['key'] as String).toLowerCase() ==
              type.name?.toLowerCase();
        }
      })) {
        paymentTypesWithoutPreferences.add(
          PaymentType.clone(type)..enabled = false,
        );
      }
    }
    return paymentTypesWithoutPreferences;
  }

  IconData getPaymentTypeIcon(String name) {
    switch (name) {
      case 'Cash':
        return Icons.local_atm_outlined;
      case 'Card':
        return MdiIcons.creditCard;
      case 'Masterpass':
        return FontAwesomeIcons.qrcode;
      case 'Snapscan':
        return FontAwesomeIcons.qrcode;
      case 'Zapper':
        return FontAwesomeIcons.qrcode;
      case 'mPesa':
        return MdiIcons.cellphone;
      case 'AirtelMoney':
        return MdiIcons.cellphone;
      case 'TigoPesa':
        return MdiIcons.cellphone;
      case 'Credit':
        return MdiIcons.creditCard;
      case 'Other':
        return MdiIcons.more;
      default:
        return MdiIcons.more;
    }
  }

  List<PaymentType> _fallBackPaymentTypes() => [
    PaymentType(
      enabled: true,
      id: const Uuid().v4(),
      name: 'Cash',
      displayIndex: 0,
      provider: PaymentProvider.none,
    )..icon = Icons.local_atm_outlined,
    PaymentType(
      enabled: true,
      id: const Uuid().v4(),
      name: 'Card',
      displayIndex: 1,
      provider: PaymentProvider.none,
    )..icon = MdiIcons.creditCard,
    PaymentType(
      enabled: false,
      id: const Uuid().v4(),
      name: 'Masterpass',
      displayIndex: 2,
      provider: PaymentProvider.none,
    )..icon = FontAwesomeIcons.qrcode,
    PaymentType(
        enabled: false,
        id: const Uuid().v4(),
        name: 'Snapscan',
        displayIndex: 3,
        provider: PaymentProvider.snapscan,
      )
      ..icon = FontAwesomeIcons.qrcode
      ..imageURI = AppAssets.snapscanLogoPng,
    PaymentType(
        enabled: false,
        id: const Uuid().v4(),
        name: 'Zapper',
        displayIndex: 4,
        provider: PaymentProvider.zapper,
      )
      ..icon = FontAwesomeIcons.qrcode
      ..imageURI = AppAssets.zapperPng,
    PaymentType(
      enabled: false,
      id: const Uuid().v4(),
      name: 'mPesa',
      displayIndex: 5,
      provider: PaymentProvider.none,
    )..icon = MdiIcons.cellphone,
    PaymentType(
      enabled: false,
      id: const Uuid().v4(),
      name: 'AirtelMoney',
      displayIndex: 6,
      provider: PaymentProvider.none,
    )..icon = MdiIcons.cellphone,
    PaymentType(
      enabled: false,
      id: const Uuid().v4(),
      name: 'TigoPesa',
      displayIndex: 7,
      provider: PaymentProvider.none,
    )..icon = MdiIcons.cellphone,
    PaymentType(
      enabled: false,
      id: const Uuid().v4(),
      name: 'Credit',
      displayIndex: 8,
      provider: PaymentProvider.none,
    )..icon = MdiIcons.creditCard,
    PaymentType(
      enabled: false,
      id: const Uuid().v4(),
      name: 'Other',
      displayIndex: 9,
      provider: PaymentProvider.none,
    )..icon = MdiIcons.more,
  ];
}
