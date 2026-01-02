import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/drawers/main_drawer_title.dart/data/data_source/drawer_data_source.dart';
import 'package:littlefish_merchant/common/presentaion/components/drawers/main_drawer_title.dart/domain/entity/drawer_title_entity.dart';
import 'package:littlefish_merchant/common/presentaion/components/drawers/main_drawer_title.dart/presentation/component/drawer_title_component.dart';

class _DrawerTitle {
  static bool _initialized = false;
  static late DrawerTitleEntity _config;

  _DrawerTitle._internal() {
    if (!_initialized) {
      _config = DrawerTitleDataSource().getDrawerTitleConfiguration();
      _initialized = true;
    }
  }

  factory _DrawerTitle() => _DrawerTitle._internal();

  Widget build() => DrawerTitleComponent(config: _config);
}

Widget drawerTitle() => _DrawerTitle().build();
