import 'package:littlefish_merchant/features/initial_pages/domain/entities/initial_template_entity.dart';

class InitialTemplateModel {
  InitialTemplateEntity fromJson(Map<String, dynamic> json) {
    String parseString(dynamic value, String fallback) {
      if (value is String && value.isNotEmpty) return value;
      return fallback;
    }

    return InitialTemplateEntity(
      landing: parseString(json['landing'], 'default'),
      initial: parseString(json['initial'], 'default'),
      loading: parseString(json['loading'], 'default'),
      login: parseString(json['login'], 'default'),
    );
  }

  Map<String, dynamic> toJson(InitialTemplateEntity entity) {
    return {
      'landing': entity.landing,
      'initial': entity.initial,
      'loading': entity.loading,
      'login': entity.login,
    };
  }
}
