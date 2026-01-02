// File: expenses_model.dart

import 'package:littlefish_merchant/models/expenses/expenses_payment_types/expenses_pyment_type_entity.dart';

class ExpensesPaymentTypeModel {
  List<ExpensesPaymentTypeEntity> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((dynamic json) {
      return _fromJson(json as Map<String, dynamic>);
    }).toList();
  }

  ExpensesPaymentTypeEntity _fromJson(Map<String, dynamic> json) {
    return ExpensesPaymentTypeEntity(
      displayIndex: json['displayIndex'] ?? 0,
      enabled: json['enabled'] ?? false,
      id: json['id'] ?? '',
      displayName: json['displayName'] ?? '',
      description: json['description'] ?? '',
    );
  }

  List<Map<String, dynamic>> toJsonList(
    List<ExpensesPaymentTypeEntity> entities,
  ) {
    return entities.map((entity) => _toJson(entity)).toList();
  }

  Map<String, dynamic> _toJson(ExpensesPaymentTypeEntity entity) {
    return {
      'displayIndex': entity.displayIndex,
      'enabled': entity.enabled,
      'id': entity.id,
      'displayName': entity.displayName,
      'description': entity.description,
    };
  }
}
