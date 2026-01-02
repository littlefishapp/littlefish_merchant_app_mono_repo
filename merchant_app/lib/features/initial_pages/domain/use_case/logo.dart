import 'package:flutter/material.dart';
import 'package:littlefish_merchant/features/initial_pages/data/data_source/logo_data_source.dart';
import 'package:littlefish_merchant/features/initial_pages/presentation/components/logo_component.dart';

class _Logo {
  final LogoDataSource dataSource = LogoDataSource();
  final String templateKey;

  _Logo({this.templateKey = ''});

  Widget build() {
    final entity = dataSource.getLogoConfiguration(templateKey);
    return LogoComponent(config: entity);
  }
}

Widget logo({required String templateKey}) =>
    _Logo(templateKey: templateKey).build();
