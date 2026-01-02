// lib/features/home/presentation/home_header.dart

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/ui/home/home_board_header/home_header_data_source.dart';
import 'package:littlefish_merchant/ui/home/home_board_header/home_header_component.dart';

class _HomeBoardHeader {
  final HomeHeaderDataSource dataSource = HomeHeaderDataSource();

  Widget build() {
    final entity = dataSource.getConfig();
    return HomeHeaderComponent(config: entity);
  }
}

Widget homeBoardHeader() => _HomeBoardHeader().build();
