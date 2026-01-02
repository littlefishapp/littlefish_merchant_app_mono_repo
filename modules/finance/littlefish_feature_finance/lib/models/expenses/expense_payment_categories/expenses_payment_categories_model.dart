import 'package:littlefish_merchant/models/expenses/expense_payment_categories/expenses_pyment_categories_entity.dart';

class ExpensesCategoryModel {
  List<ExpensesCategoryEntity> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((dynamic json) {
      return _fromJson(json as Map<String, dynamic>);
    }).toList();
  }

  ExpensesCategoryEntity _fromJson(Map<String, dynamic> json) {
    return ExpensesCategoryEntity(
      displayIndex: json['displayIndex'] ?? 0,
      enabled: json['enabled'] ?? false,
      id: json['id'] ?? '',
      displayName: json['displayName'] ?? '',
      description: json['description'] ?? '',
    );
  }

  List<Map<String, dynamic>> toJsonList(List<ExpensesCategoryEntity> entities) {
    return entities.map((entity) => _toJson(entity)).toList();
  }

  Map<String, dynamic> _toJson(ExpensesCategoryEntity entity) {
    return {
      'displayIndex': entity.displayIndex,
      'enabled': entity.enabled,
      'id': entity.id,
      'displayName': entity.displayName,
      'description': entity.description,
    };
  }
}
