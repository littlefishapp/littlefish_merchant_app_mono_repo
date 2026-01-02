import 'package:flutter/material.dart';
import 'package:littlefish_merchant/features/initial_pages/data/data_source/welcome_data_source.dart';
import 'package:littlefish_merchant/features/initial_pages/presentation/components/welcome_component.dart';

class _Welcome {
  final WelcomeDataSource dataSource = WelcomeDataSource();
  final String template;

  _Welcome({required this.template});
  Widget build() {
    final entity = dataSource.getWelcomeConfiguration(template);
    return WelcomeComponent(config: entity);
  }
}

Widget welcome({required String template}) =>
    _Welcome(template: template).build();
