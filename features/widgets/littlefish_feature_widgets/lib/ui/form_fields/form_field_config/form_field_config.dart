import 'package:littlefish_merchant/common/presentaion/components/form_fields/form_field_config/form_field_config_data_source.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/form_field_config/form_field_config_entity.dart';

class FormFieldConfig {
  static final FormFieldConfig _instance = FormFieldConfig._internal();

  late FormFieldConfigEntity _config;
  bool _initialized = false;

  factory FormFieldConfig() => _instance;

  FormFieldConfig._internal() {
    _init();
  }

  void _init() {
    if (!_initialized) {
      _config = FormFieldConfigDataSource().getConfiguration();
      _initialized = true;
    }
  }

  FormFieldConfigEntity get config {
    if (!_initialized) _init();
    return _config;
  }

  /// Call this when you want to refresh from remote config (e.g. after fetch)
  void reload() {
    _config = FormFieldConfigDataSource().getConfiguration();
  }
}
