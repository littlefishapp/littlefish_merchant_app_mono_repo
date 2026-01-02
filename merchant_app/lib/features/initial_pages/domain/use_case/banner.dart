import 'package:flutter/material.dart';
import 'package:littlefish_merchant/features/initial_pages/data/data_source/banner_data_source.dart';
import 'package:littlefish_merchant/features/initial_pages/presentation/components/banner_component.dart';

class _Banner {
  final BannerDataSource dataSource = BannerDataSource();
  final String templateKey;

  _Banner({required this.templateKey});
  Widget build() {
    final entity = dataSource.getBannerConfiguration(templateKey);
    return BannerComponent(config: entity);
  }
}

Widget banner({required String templateKey}) =>
    _Banner(templateKey: templateKey).build();
