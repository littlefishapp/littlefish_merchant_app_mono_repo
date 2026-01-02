import 'package:flutter/material.dart';
import 'package:littlefish_merchant/features/initial_pages/data/data_source/initial_template_data_source.dart';
import 'package:littlefish_merchant/features/initial_pages/data/data_source/loading_data_source.dart';
import 'package:littlefish_merchant/features/initial_pages/presentation/components/loading_component.dart';

class _Loading {
  final LoadingDataSource dataSource = LoadingDataSource();
  Widget build(ValueNotifier<String> message) {
    final template = InitialTemplateDataSource()
        .getInitialTemplateConfiguration();

    final entity = dataSource.getLoadingConfiguration(
      templateKey: template.loading,
    );

    return LoadingComponent(config: entity, message: message);
  }
}

Widget loading(ValueNotifier<String> message) => _Loading().build(message);

Widget loadingWithMessage(String message) =>
    _Loading().build(ValueNotifier<String>(message));
