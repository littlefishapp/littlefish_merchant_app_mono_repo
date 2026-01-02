import 'package:flutter/foundation.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/expenses/expense_payment_categories/expenses_payment_categories_model.dart';
import 'package:littlefish_merchant/models/expenses/expense_payment_categories/expenses_pyment_categories_entity.dart';

class ExpensesCategoryDataSource {
  List<ExpensesCategoryEntity> getAllExpenseCategoriesConfiguration() {
    final ConfigService configService = core.get<ConfigService>();
    var configMap = configService.getObjectValue(
      key: 'business_expenses',
      defaultValue: {},
    );
    if (configMap.isEmpty) {
      // use this default value to test configurations
      configMap = getExpenseCategoriesDefaultMap('default');
    }
    final List<dynamic> categoriesJson = configMap['categories'] ?? [];
    final ExpensesCategoryModel model = ExpensesCategoryModel();
    final List<ExpensesCategoryEntity> entities = model.fromJsonList(
      categoriesJson,
    );
    debugPrint('### ExpenseCategoriesConfiguration - All');
    return entities;
  }

  List<ExpensesCategoryEntity> getEnabledExpenseCategoriesConfiguration() {
    final allEntities = getAllExpenseCategoriesConfiguration();
    final enabledEntities = allEntities
        .where((entity) => entity.enabled)
        .toList();
    debugPrint('### ExpenseCategoriesConfiguration - Enabled');
    return enabledEntities;
  }
}

/// Do not remove this until testing completed
Map<String, dynamic> getExpenseCategoriesDefaultMap(String key) {
  if (key == 'nondefault') {
    return {
      'config_info': {
        'created': '02 Oct 2024 14h00',
        'usecase': 'Expense categories',
        'change 02 Oct': 'Added refund category',
      },
      'categories': [
        {
          'displayIndex': 1,
          'enabled': true,
          'id': 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
          'displayName': 'Invoice',
          'description': 'xyzzy',
        },
        {
          'displayIndex': 2,
          'enabled': false,
          'id': 'b2c3d4e5-f6g7-8901-bcde-f23456789012',
          'displayName': 'Wages',
          'description': 'xyzzy',
        },
        {
          'displayIndex': 3,
          'enabled': false,
          'id': 'c3d4e5f6-g7h8-9012-cdef-345678901234',
          'displayName': 'Bill',
          'description': 'xyzzy',
        },
        {
          'displayIndex': 4,
          'enabled': true,
          'id': 'd4e5f6g7-h8i9-0123-defg-456789012345',
          'displayName': 'General',
          'description': 'xyzzy',
        },
        {
          'displayIndex': 5,
          'enabled': true,
          'id': 'e5f6g7h8-i9j0-1234-efgh-567890123456',
          'displayName': 'Refund',
          'description': 'xyzzy',
        },
      ],
    };
  }
  if (key == 'sbsa') {
    return {
      'config_info': {
        'created': '02 Oct 2024 14h00',
        'usecase': 'Expense categories',
        'change 02 Oct': 'Added refund category',
      },
      'categories': [
        {
          'displayIndex': 1,
          'enabled': true,
          'id': 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
          'displayName': 'Invoice',
          'description': 'xyzzy',
        },
        {
          'displayIndex': 2,
          'enabled': true,
          'id': 'b2c3d4e5-f6g7-8901-bcde-f23456789012',
          'displayName': 'Wages',
          'description': 'xyzzy',
        },
        {
          'displayIndex': 3,
          'enabled': false,
          'id': 'c3d4e5f6-g7h8-9012-cdef-345678901234',
          'displayName': 'Bill',
          'description': 'xyzzy',
        },
        {
          'displayIndex': 4,
          'enabled': true,
          'id': 'd4e5f6g7-h8i9-0123-defg-456789012345',
          'displayName': 'General',
          'description': 'xyzzy',
        },
        {
          'displayIndex': 5,
          'enabled': true,
          'id': 'e5f6g7h8-i9j0-1234-efgh-567890123456',
          'displayName': 'Refund',
          'description': 'xyzzy',
        },
      ],
    };
  }
  // Default fallback
  return {
    'config_info': {
      'created': '02 Oct 2024 14h00',
      'usecase': 'Expense categories',
      'change 02 Oct': 'Added refund category',
    },
    'categories': [
      {
        'displayIndex': 1,
        'enabled': true,
        'id': 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
        'displayName': 'Invoice',
        'description': 'xyzzy',
      },
      {
        'displayIndex': 2,
        'enabled': true,
        'id': 'b2c3d4e5-f6g7-8901-bcde-f23456789012',
        'displayName': 'Wages',
        'description': 'xyzzy',
      },
      {
        'displayIndex': 3,
        'enabled': true,
        'id': 'c3d4e5f6-g7h8-9012-cdef-345678901234',
        'displayName': 'Bill',
        'description': 'xyzzy',
      },
      {
        'displayIndex': 4,
        'enabled': true,
        'id': 'd4e5f6g7-h8i9-0123-defg-456789012345',
        'displayName': 'General',
        'description': 'xyzzy',
      },
      {
        'displayIndex': 5,
        'enabled': false,
        'id': 'e5f6g7h8-i9j0-1234-efgh-567890123456',
        'displayName': 'Refund',
        'description': 'xyzzy',
      },
    ],
  };
}
