// File: landing.dart
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/features/initial_pages/data/data_source/initial_template_data_source.dart';
import 'package:littlefish_merchant/features/initial_pages/data/data_source/landing_data_source.dart';
import 'package:littlefish_merchant/features/initial_pages/presentation/components/landing_component.dart';
import 'package:littlefish_merchant/ui/security/login/viewmodels/login_viewmodel.dart';

class _Landing {
  final LandingDataSource dataSource = LandingDataSource();
  Widget build(final bool isLoading, final LoginVM landingVM) {
    final template = InitialTemplateDataSource()
        .getInitialTemplateConfiguration();

    final config = dataSource.getLandingConfiguration(
      templateKey: template.landing,
    );

    return LandingComponent(
      config: config,
      isLoading: isLoading,
      loginVM: landingVM,
    );
  }
}

Widget landing(final bool isLoading, final LoginVM landingVM) =>
    _Landing().build(isLoading, landingVM);
