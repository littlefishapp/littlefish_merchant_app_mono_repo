// File: expenses_data_source.dart
import 'package:flutter/foundation.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/expenses/expenses_payment_types/expenses_pyment_type_entity.dart';
import 'package:littlefish_merchant/models/expenses/expenses_payment_types/expenses_payment_type_model.dart';

class ExpensesPaymentTypeDataSource {
  List<ExpensesPaymentTypeEntity> getAllExpensePaymentTypesConfiguration() {
    final ConfigService configService = core.get<ConfigService>();
    var configMap = configService.getObjectValue(
      key: 'business_expenses_payment_types',
      defaultValue: {},
    );

    if (configMap.isEmpty) {
      // use this default value to test configurations
      configMap = getPaymentTypesDefaultMap('default');
    }

    final List<dynamic> expensesJson = configMap['expenses'] ?? [];
    final ExpensesPaymentTypeModel model = ExpensesPaymentTypeModel();
    final List<ExpensesPaymentTypeEntity> entities = model.fromJsonList(
      expensesJson,
    );
    debugPrint('### ExpensesConfiguration - All');
    return entities;
  }

  List<ExpensesPaymentTypeEntity> getEnabledExpensePaymentTypesConfiguration() {
    final allEntities = getAllExpensePaymentTypesConfiguration();
    final enabledEntities = allEntities
        .where((entity) => entity.enabled)
        .toList();
    debugPrint('### ExpensesConfiguration - Enabled');
    return enabledEntities;
  }
}

/// Do not remove this until testing completed
Map<String, dynamic> getPaymentTypesDefaultMap(String key) {
  if (key == 'nondefault') {
    return {
      'config_info': {
        'created': '02 Oct 2024 14h00',
        'usecase': 'Payment types',
        'change 02 Oct': 'Added EFT payment type',
      },
      'expenses': [
        {
          'displayIndex': 1,
          'enabled': true,
          'id': '3905eb3b-61e0-4d5b-8b9c-c1ed5b34e646',
          'displayName': 'Cash',
          'description': 'xyzzy',
        },
        {
          'displayIndex': 2,
          'enabled': false,
          'id': '87e96ff0-971c-4b7a-8ede-0c82fb2253a1',
          'displayName': 'EFT',
          'description': 'xyzzy',
        },
        {
          'displayIndex': 3,
          'enabled': false,
          'id': '5fe74f41-4bb0-454f-88ca-ff9758cca7d0',
          'displayName': 'Credit',
          'description': 'xyzzy',
        },
        {
          'displayIndex': 4,
          'enabled': false,
          'id': '5307b76a-c236-4a27-af87-73722d4b3608',
          'displayName': 'Mobile Money',
          'description': 'xyzzy',
        },
        {
          'displayIndex': 5,
          'enabled': true,
          'id': '4550c807-cba0-4487-8938-0828d2e97f12',
          'displayName': 'Card',
          'description': 'xyzzy',
        },
        {
          'displayIndex': 6,
          'enabled': true,
          'id': '03080f7e-f59e-42ce-a448-3e0f433ebdc3',
          'displayName': 'Other',
          'description': 'xyzzy',
        },
      ],
    };
  }

  if (key == 'sbsa') {
    return {
      'config_info': {
        'created': '02 Oct 2024 14h00',
        'usecase': 'Payment types',
        'change 02 Oct': 'Added EFT payment type',
      },
      'expenses': [
        {
          'displayIndex': 1,
          'enabled': true,
          'id': '3905eb3b-61e0-4d5b-8b9c-c1ed5b34e646',
          'displayName': 'Cash',
          'description': 'xyzzy',
        },
        {
          'displayIndex': 2,
          'enabled': true,
          'id': '87e96ff0-971c-4b7a-8ede-0c82fb2253a1',
          'displayName': 'EFT',
          'description': 'xyzzy',
        },
        {
          'displayIndex': 3,
          'enabled': false,
          'id': '5fe74f41-4bb0-454f-88ca-ff9758cca7d0',
          'displayName': 'Credit',
          'description': 'xyzzy',
        },
        {
          'displayIndex': 4,
          'enabled': false,
          'id': '5307b76a-c236-4a27-af87-73722d4b3608',
          'displayName': 'Mobile Money',
          'description': 'xyzzy',
        },
        {
          'displayIndex': 5,
          'enabled': true,
          'id': '4550c807-cba0-4487-8938-0828d2e97f12',
          'displayName': 'Card',
          'description': 'xyzzy',
        },
        {
          'displayIndex': 6,
          'enabled': true,
          'id': '03080f7e-f59e-42ce-a448-3e0f433ebdc3',
          'displayName': 'Other',
          'description': 'xyzzy',
        },
      ],
    };
  }

  // Default fallback
  return {
    'config_info': {
      'created': '02 Oct 2024 14h00',
      'usecase': 'Payment types',
      'change 02 Oct': 'Added EFT payment type',
    },
    'expenses': [
      {
        'displayIndex': 1,
        'enabled': true,
        'id': '3905eb3b-61e0-4d5b-8b9c-c1ed5b34e646',
        'displayName': 'Cash',
        'description': 'xyzzy',
      },
      {
        'displayIndex': 2,
        'enabled': true,
        'id': '87e96ff0-971c-4b7a-8ede-0c82fb2253a1',
        'displayName': 'EFT',
        'description': 'xyzzy',
      },
      {
        'displayIndex': 3,
        'enabled': true,
        'id': '5fe74f41-4bb0-454f-88ca-ff9758cca7d0',
        'displayName': 'Credit',
        'description': 'xyzzy',
      },
      {
        'displayIndex': 4,
        'enabled': true,
        'id': '5307b76a-c236-4a27-af87-73722d4b3608',
        'displayName': 'Mobile Money',
        'description': 'xyzzy',
      },
      {
        'displayIndex': 5,
        'enabled': true,
        'id': '4550c807-cba0-4487-8938-0828d2e97f12',
        'displayName': 'Card',
        'description': 'xyzzy',
      },
      {
        'displayIndex': 6,
        'enabled': true,
        'id': '03080f7e-f59e-42ce-a448-3e0f433ebdc3',
        'displayName': 'Other',
        'description': 'xyzzy',
      },
    ],
  };
}
