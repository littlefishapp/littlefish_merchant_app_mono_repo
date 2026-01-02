import 'applied_border_design_system.dart';
import 'applied_surface_design_system.dart';
import 'applied_text_and_icons_design_system.dart';
import 'applied_theme_design_system.dart';
import 'primitive_design_system.dart';
import 'semantic_design_system.dart';

class DesignSystem {
  final PrimitiveDesignSystem primitive;
  final SemanticDesignSystem semantic;
  final AppliedTextAndIconsDesignSystem appliedTextAndIcons;
  final AppliedSurfaceDesignSystem appliedSurface;
  final AppliedBorderDesignSystem appliedBorder;
  final AppliedThemeDesignSystem appliedTheme;

  const DesignSystem({
    this.primitive = const PrimitiveDesignSystem(),
    this.semantic = const SemanticDesignSystem(),
    this.appliedTextAndIcons = const AppliedTextAndIconsDesignSystem(),
    this.appliedSurface = const AppliedSurfaceDesignSystem(),
    this.appliedBorder = const AppliedBorderDesignSystem(),
    this.appliedTheme = const AppliedThemeDesignSystem(),
  });

  factory DesignSystem.fromJson(Map<String, dynamic> json) {
    final primitive = json['primitive'] == null
        ? const PrimitiveDesignSystem()
        : PrimitiveDesignSystem.fromJson(
            json['primitive'] as Map<String, dynamic>,
          );
    final semantic = json['semantic'] == null
        ? const SemanticDesignSystem()
        : SemanticDesignSystem.fromJson(
            json['semantic'] as Map<String, dynamic>,
          );
    final appliedTextAndIcons = json['appliedTextAndIcons'] == null
        ? const AppliedTextAndIconsDesignSystem()
        : AppliedTextAndIconsDesignSystem.fromJson(
            json['appliedTextAndIcons'] as Map<String, dynamic>,
          );
    final appliedSurface = json['appliedSurface'] == null
        ? const AppliedSurfaceDesignSystem()
        : AppliedSurfaceDesignSystem.fromJson(
            json['appliedSurface'] as Map<String, dynamic>,
          );
    final appliedBorder = json['appliedBorder'] == null
        ? const AppliedBorderDesignSystem()
        : AppliedBorderDesignSystem.fromJson(
            json['appliedBorder'] as Map<String, dynamic>,
          );
    final appliedTheme = json['appliedTheme'] == null
        ? const AppliedThemeDesignSystem()
        : AppliedThemeDesignSystem.fromJson(
            json['appliedTheme'] as Map<String, dynamic>,
          );
    return DesignSystem(
      primitive: primitive,
      semantic: semantic,
      appliedTextAndIcons: appliedTextAndIcons,
      appliedSurface: appliedSurface,
      appliedBorder: appliedBorder,
      appliedTheme: appliedTheme,
    );
  }

  Map<String, dynamic> toJson() => {
    'primitive': primitive.toJson(),
    'semantic': semantic.toJson(),
    'appliedTextAndIcons': appliedTextAndIcons.toJson(),
    'appliedSurface': appliedSurface.toJson(),
    'appliedBorder': appliedBorder.toJson(),
    'appliedTheme': appliedTheme.toJson(),
  };
}
