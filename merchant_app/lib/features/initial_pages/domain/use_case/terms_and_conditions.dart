// lib/features/initial_pages/presentation/widgets/terms_and_conditions.dart
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/features/initial_pages/data/data_source/terms_and_conditions_data_source.dart';
import 'package:littlefish_merchant/features/initial_pages/presentation/components/terms_and_conditions_component.dart';

class _TermsAndConditions {
  final TermsAndConditionsDataSource _ds = TermsAndConditionsDataSource();

  Widget build({required String template}) {
    final entity = _ds.getConfiguration(templateKey: template);
    return TermsAndConditionsComponent(config: entity);
  }
}

/// Public entry point – same pattern as `welcome(...)`
Widget termsAndConditions({required String template}) =>
    _TermsAndConditions().build(template: template);
