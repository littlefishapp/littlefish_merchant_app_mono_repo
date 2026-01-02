import 'package:littlefish_merchant/common/presentaion/components/buttons/data/data_source/square_button_data_source.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/domain/entity/square_button_entity.dart';

class SquareButtonConfig {
  static final SquareButtonConfig _instance = SquareButtonConfig._internal();
  static late SquareButtonEntity _config;
  static bool _initialized = false;

  SquareButtonConfig._internal() {
    if (!_initialized) {
      _config = SquareButtonDataSource().getConfiguration();
      _initialized = true;
    }
  }

  factory SquareButtonConfig() => _instance;

  SquareButtonEntity get config => _config;

  void reload() {
    _config = SquareButtonDataSource().getConfiguration();
  }
}
