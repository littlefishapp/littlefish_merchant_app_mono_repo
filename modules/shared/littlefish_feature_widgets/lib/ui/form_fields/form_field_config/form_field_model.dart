import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/form_field_config/form_field_config_entity.dart';

class FormFieldModel {
  FormFieldConfigEntity fromJson(Map<String, dynamic> json) {
    try {
      return FormFieldConfigEntity(
        hintTextStyle: _parseString(
          json['hintTextStyle'],
          'paragraphSmallRegular',
        ),
      );
    } catch (e, s) {
      final logger = LittleFishCore.instance.get<LoggerService>();
      logger.error(
        this,
        'Failed to parse FormFieldConfigEntity from remote config',
        error: e,
        stackTrace: s,
      );
      return const FormFieldConfigEntity(
        hintTextStyle: 'paragraphSmallRegular',
      ); // Fallback to default
    }
  }

  String _parseString(dynamic value, String defaultValue) {
    if (value is String && value.isNotEmpty) return value;
    return defaultValue;
  }

  Map<String, dynamic> toJson(FormFieldConfigEntity entity) {
    return {'hintTextStyle': entity.hintTextStyle};
  }
}
