// File: login.dart
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/features/initial_pages/data/data_source/initial_template_data_source.dart';
import 'package:littlefish_merchant/features/initial_pages/data/data_source/login_data_source.dart';
import 'package:littlefish_merchant/features/initial_pages/presentation/components/login_component.dart';
import 'package:littlefish_merchant/ui/security/login/viewmodels/login_viewmodel.dart';

class _Login {
  final LoginDataSource dataSource = LoginDataSource();
  Widget build({
    required void Function(String?, String?) onSubmit,
    required void Function(bool?) onValidate,
    required bool isLoading,
    required LoginVM loginVM,
  }) {
    final template = InitialTemplateDataSource()
        .getInitialTemplateConfiguration();

    final config = dataSource.getLoginConfiguration(keyToUse: template.login);
    return LoginComponent(
      config: config,
      onSubmit: onSubmit,
      onValidate: onValidate,
      isLoading: isLoading,
      loginVM: loginVM,
    );
  }
}

Widget login({
  required void Function(String?, String?) onSubmit,
  required void Function(bool?) onValidate,
  required bool isLoading,
  required LoginVM loginVM,
}) => _Login().build(
  onSubmit: onSubmit,
  onValidate: onValidate,
  isLoading: isLoading,
  loginVM: loginVM,
);
