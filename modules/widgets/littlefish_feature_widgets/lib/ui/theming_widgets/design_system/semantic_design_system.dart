import 'brand_design_system.dart';
import 'error_design_system.dart';
import 'informational_design_system.dart';
import 'neutral_design_system.dart';
import 'positive_design_system.dart';
import 'success_design_system.dart';
import 'warning_design_system.dart';

class SemanticDesignSystem {
  final BrandDesignSystem brand;
  final NeutralDesignSystem neutral;
  final InformationalDesignSystem informational;
  final SuccessDesignSystem success;
  final WarningDesignSystem warning;
  final ErrorDesignSystem error;
  final PositiveDesignSystem positive;

  const SemanticDesignSystem({
    this.brand = const BrandDesignSystem(),
    this.neutral = const NeutralDesignSystem(),
    this.informational = const InformationalDesignSystem(),
    this.success = const SuccessDesignSystem(),
    this.warning = const WarningDesignSystem(),
    this.error = const ErrorDesignSystem(),
    this.positive = const PositiveDesignSystem(),
  });

  factory SemanticDesignSystem.fromJson(
    Map<String, dynamic> json,
  ) => SemanticDesignSystem(
    brand: json['brand'] == null
        ? const BrandDesignSystem()
        : BrandDesignSystem.fromJson(json['brand'] as Map<String, dynamic>),
    neutral: json['neutral'] == null
        ? const NeutralDesignSystem()
        : NeutralDesignSystem.fromJson(json['neutral'] as Map<String, dynamic>),
    informational: json['informational'] == null
        ? const InformationalDesignSystem()
        : InformationalDesignSystem.fromJson(
            json['informational'] as Map<String, dynamic>,
          ),
    success: json['success'] == null
        ? const SuccessDesignSystem()
        : SuccessDesignSystem.fromJson(json['success'] as Map<String, dynamic>),
    warning: json['warning'] == null
        ? const WarningDesignSystem()
        : WarningDesignSystem.fromJson(json['warning'] as Map<String, dynamic>),
    error: json['error'] == null
        ? const ErrorDesignSystem()
        : ErrorDesignSystem.fromJson(json['error'] as Map<String, dynamic>),
    positive: json['positive'] == null
        ? const PositiveDesignSystem()
        : PositiveDesignSystem.fromJson(
            json['positive'] as Map<String, dynamic>,
          ),
  );

  Map<String, dynamic> toJson() => {
    'brand': brand.toJson(),
    'neutral': neutral.toJson(),
    'informational': informational.toJson(),
    'success': success.toJson(),
    'warning': warning.toJson(),
    'error': error.toJson(),
    'positive': positive.toJson(),
  };
}
