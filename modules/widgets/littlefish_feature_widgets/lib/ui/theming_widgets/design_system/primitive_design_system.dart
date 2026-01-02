import 'brand_primitive_design_system.dart';
import 'neutral_primitive_design_system.dart';
import 'status_primitive_design_system.dart';

class PrimitiveDesignSystem {
  final BrandPrimitiveDesignSystem brandPrimitive;
  final StatusPrimitiveDesignSystem statusPrimitive;
  final NeutralPrimitiveDesignSystem neutralPrimitive;

  const PrimitiveDesignSystem({
    this.brandPrimitive = const BrandPrimitiveDesignSystem(),
    this.statusPrimitive = const StatusPrimitiveDesignSystem(),
    this.neutralPrimitive = const NeutralPrimitiveDesignSystem(),
  });

  factory PrimitiveDesignSystem.fromJson(Map<String, dynamic> json) =>
      PrimitiveDesignSystem(
        brandPrimitive: json['brandPrimitive'] == null
            ? const BrandPrimitiveDesignSystem()
            : BrandPrimitiveDesignSystem.fromJson(
                json['brandPrimitive'] as Map<String, dynamic>,
              ),
        statusPrimitive: json['statusPrimitive'] == null
            ? const StatusPrimitiveDesignSystem()
            : StatusPrimitiveDesignSystem.fromJson(
                json['statusPrimitive'] as Map<String, dynamic>,
              ),
        neutralPrimitive: json['neutralPrimitive'] == null
            ? const NeutralPrimitiveDesignSystem()
            : NeutralPrimitiveDesignSystem.fromJson(
                json['neutralPrimitive'] as Map<String, dynamic>,
              ),
      );

  Map<String, dynamic> toJson() => {
    'brandPrimitive': brandPrimitive.toJson(),
    'statusPrimitive': statusPrimitive.toJson(),
    'neutralPrimitive': neutralPrimitive.toJson(),
  };
}
