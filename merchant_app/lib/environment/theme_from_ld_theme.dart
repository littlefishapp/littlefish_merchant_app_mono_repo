import 'package:flutter/material.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';

import '../app/theme/design_system/design_system.dart';

LoggerService get logger => LittleFishCore.instance.get<LoggerService>();

const primitiveLabel = '@primitive';
const semanticLabel = '@semantic';
const textIconsLabel = '@appliedTextAndIcons';
const surfaceLabel = '@appliedSurface';
const borderLabel = '@appliedBorder';
const colorLabel = '0xFF';

class FromLDTheme {
  final DesignSystem designSystem;
  var semantics = <String, String>{};
  var primitive = <String, String>{};
  var border = <String, String>{};
  var surface = <String, String>{};
  var textIcons = <String, String>{};

  FromLDTheme({required this.designSystem}) {
    semantics['@semantic/brand/primary'] = designSystem.semantic.brand.primary;
    semantics['@semantic/brand/emphasized'] =
        designSystem.semantic.brand.emphasized;
    semantics['@semantic/brand/deEmphasized1'] =
        designSystem.semantic.brand.deEmphasized;
    semantics['@semantic/brand/deEmphasized2'] =
        designSystem.semantic.brand.deEmphasized2;
    semantics['@semantic/brand/deEmphasized3'] =
        designSystem.semantic.brand.deEmphasized3;

    semantics['@semantic/neutral/primary'] =
        designSystem.semantic.neutral.primary;
    semantics['@semantic/neutral/primaryInverse'] =
        designSystem.semantic.neutral.primaryInverse;
    semantics['@semantic/neutral/secondary'] =
        designSystem.semantic.neutral.secondary;
    semantics['@semantic/neutral/emphasized'] =
        designSystem.semantic.neutral.emphasized;
    semantics['@semantic/neutral/deEmphasized1'] =
        designSystem.semantic.neutral.deEmphasized1;
    semantics['@semantic/neutral/deEmphasized2'] =
        designSystem.semantic.neutral.deEmphasized2;
    semantics['@semantic/neutral/deEmphasized3'] =
        designSystem.semantic.neutral.deEmphasized3;

    semantics['@semantic/informational/primary'] =
        designSystem.semantic.informational.primary;
    semantics['@semantic/informational/primaryInverse'] =
        designSystem.semantic.informational.primaryInverse;
    semantics['@semantic/informational/secondary'] =
        designSystem.semantic.informational.secondary;
    semantics['@semantic/informational/emphasized'] =
        designSystem.semantic.informational.emphasized;
    semantics['@semantic/informational/deEmphasized1'] =
        designSystem.semantic.informational.deEmphasized1;
    semantics['@semantic/informational/deEmphasized2'] =
        designSystem.semantic.informational.deEmphasized2;
    semantics['@semantic/informational/deEmphasized3'] =
        designSystem.semantic.informational.deEmphasized3;

    semantics['@semantic/success/primary'] =
        designSystem.semantic.success.primary;
    semantics['@semantic/success/emphasized'] =
        designSystem.semantic.success.emphasized;
    semantics['@semantic/success/deEmphasized1'] =
        designSystem.semantic.success.deEmphasized;
    semantics['@semantic/success/deEmphasized2'] =
        designSystem.semantic.success.deEmphasized2;
    semantics['@semantic/success/deEmphasized3'] =
        designSystem.semantic.success.deEmphasized3;

    semantics['@semantic/warning/primary'] =
        designSystem.semantic.warning.primary;
    semantics['@semantic/warning/emphasized'] =
        designSystem.semantic.warning.emphasized;
    semantics['@semantic/warning/deEmphasized1'] =
        designSystem.semantic.warning.deEmphasized;
    semantics['@semantic/warning/deEmphasized2'] =
        designSystem.semantic.warning.deEmphasized2;
    semantics['@semantic/warning/deEmphasized3'] =
        designSystem.semantic.warning.deEmphasized3;

    semantics['@semantic/error/primary'] = designSystem.semantic.error.primary;
    semantics['@semantic/error/emphasized'] =
        designSystem.semantic.error.emphasized;
    semantics['@semantic/error/deEmphasized1'] =
        designSystem.semantic.error.deEmphasized;
    semantics['@semantic/error/deEmphasized2'] =
        designSystem.semantic.error.deEmphasized2;
    semantics['@semantic/error/deEmphasized3'] =
        designSystem.semantic.error.deEmphasized3;

    semantics['@semantic/positive/primary'] =
        designSystem.semantic.positive.primary;
    semantics['@semantic/positive/emphasized'] =
        designSystem.semantic.positive.emphasized;
    semantics['@semantic/positive/deEmphasized1'] =
        designSystem.semantic.positive.deEmphasized;
    semantics['@semantic/positive/deEmphasized2'] =
        designSystem.semantic.positive.deEmphasized2;
    semantics['@semantic/positive/deEmphasized3'] =
        designSystem.semantic.positive.deEmphasized3;

    primitive['@primitive/brandPrimitive/brand1'] =
        designSystem.primitive.brandPrimitive.brand1.value;
    primitive['@primitive/brandPrimitive/brand2'] =
        designSystem.primitive.brandPrimitive.brand2.value;
    primitive['@primitive/brandPrimitive/brand3'] =
        designSystem.primitive.brandPrimitive.brand3.value;
    primitive['@primitive/brandPrimitive/brand4'] =
        designSystem.primitive.brandPrimitive.brand4.value;
    primitive['@primitive/brandPrimitive/brand5'] =
        designSystem.primitive.brandPrimitive.brand5.value;
    primitive['@primitive/brandPrimitive/brand6'] =
        designSystem.primitive.brandPrimitive.brand6.value;
    primitive['@primitive/brandPrimitive/brand7'] =
        designSystem.primitive.brandPrimitive.brand7.value;
    primitive['@primitive/brandPrimitive/brand8'] =
        designSystem.primitive.brandPrimitive.brand8.value;
    primitive['@primitive/brandPrimitive/brand9'] =
        designSystem.primitive.brandPrimitive.brand9.value;

    primitive['@primitive/statusPrimitive/status1'] =
        designSystem.primitive.statusPrimitive.status1.value;
    primitive['@primitive/statusPrimitive/status2'] =
        designSystem.primitive.statusPrimitive.status2.value;
    primitive['@primitive/statusPrimitive/status3'] =
        designSystem.primitive.statusPrimitive.status3.value;
    primitive['@primitive/statusPrimitive/status4'] =
        designSystem.primitive.statusPrimitive.status4.value;
    primitive['@primitive/statusPrimitive/status5'] =
        designSystem.primitive.statusPrimitive.status5.value;
    primitive['@primitive/statusPrimitive/status6'] =
        designSystem.primitive.statusPrimitive.status6.value;
    primitive['@primitive/statusPrimitive/status7'] =
        designSystem.primitive.statusPrimitive.status7.value;
    primitive['@primitive/statusPrimitive/status8'] =
        designSystem.primitive.statusPrimitive.status8.value;
    primitive['@primitive/statusPrimitive/status9'] =
        designSystem.primitive.statusPrimitive.status9.value;
    primitive['@primitive/statusPrimitive/status10'] =
        designSystem.primitive.statusPrimitive.status10.value;
    primitive['@primitive/statusPrimitive/status11'] =
        designSystem.primitive.statusPrimitive.status11.value;
    primitive['@primitive/statusPrimitive/status12'] =
        designSystem.primitive.statusPrimitive.status12.value;

    primitive['@primitive/neutralPrimitive/neutral1'] =
        designSystem.primitive.neutralPrimitive.neutral1.value;
    primitive['@primitive/neutralPrimitive/neutral2'] =
        designSystem.primitive.neutralPrimitive.neutral2.value;
    primitive['@primitive/neutralPrimitive/neutral3'] =
        designSystem.primitive.neutralPrimitive.neutral3.value;
    primitive['@primitive/neutralPrimitive/neutral4'] =
        designSystem.primitive.neutralPrimitive.neutral4.value;
    primitive['@primitive/neutralPrimitive/neutral5'] =
        designSystem.primitive.neutralPrimitive.neutral5.value;
    primitive['@primitive/neutralPrimitive/neutral6'] =
        designSystem.primitive.neutralPrimitive.neutral6.value;
    primitive['@primitive/neutralPrimitive/neutral7'] =
        designSystem.primitive.neutralPrimitive.neutral7.value;
    primitive['@primitive/neutralPrimitive/neutral8'] =
        designSystem.primitive.neutralPrimitive.neutral8.value;

    border['@appliedBorder/primary'] = designSystem.appliedBorder.primary;
    border['@appliedBorder/emphasized'] = designSystem.appliedBorder.emphasized;
    border['@appliedBorder/disabled'] = designSystem.appliedBorder.disabled;
    border['@appliedBorder/inversePrimary'] =
        designSystem.appliedBorder.inversePrimary;
    border['@appliedBorder/inverseEmphasized'] =
        designSystem.appliedBorder.inverseEmphasized;
    border['@appliedBorder/inverseDisabled'] =
        designSystem.appliedBorder.inverseDisabled;
    border['@appliedBorder/error'] = designSystem.appliedBorder.error;
    border['@appliedBorder/warning'] = designSystem.appliedBorder.warning;
    border['@appliedBorder/success'] = designSystem.appliedBorder.success;
    border['@appliedBorder/brand'] = designSystem.appliedBorder.brand;

    surface['@appliedSurface/primary'] = designSystem.appliedSurface.primary;
    surface['@appliedSurface/primaryHeader'] =
        designSystem.appliedSurface.primaryHeader;
    surface['@appliedSurface/secondary'] =
        designSystem.appliedSurface.secondary;
    surface['@appliedSurface/contrast'] = designSystem.appliedSurface.contrast;
    surface['@appliedSurface/heavyContrast'] =
        designSystem.appliedSurface.heavyContrast;
    surface['@appliedSurface/inverse'] = designSystem.appliedSurface.inverse;
    surface['@appliedSurface/brand'] = designSystem.appliedSurface.brand;
    surface['@appliedSurface/brandSubtitle'] =
        designSystem.appliedSurface.brandSubtitle;
    surface['@appliedSurface/success'] = designSystem.appliedSurface.success;
    surface['@appliedSurface/successSubtitle'] =
        designSystem.appliedSurface.successSubtitle;
    surface['@appliedSurface/successEmphasized'] =
        designSystem.appliedSurface.successEmphasized;
    surface['@appliedSurface/warning'] = designSystem.appliedSurface.warning;
    surface['@appliedSurface/warningSubtitle'] =
        designSystem.appliedSurface.warningSubtitle;
    surface['@appliedSurface/warningEmphasized'] =
        designSystem.appliedSurface.warningEmphasized;
    surface['@appliedSurface/error'] = designSystem.appliedSurface.error;
    surface['@appliedSurface/errorSubtitle'] =
        designSystem.appliedSurface.errorSubtitle;
    surface['@appliedSurface/errorEmphasized'] =
        designSystem.appliedSurface.errorEmphasized;
    surface['@appliedSurface/positive'] = designSystem.appliedSurface.positive;
    surface['@appliedSurface/positiveSubtitle'] =
        designSystem.appliedSurface.positiveSubtitle;
    surface['@appliedSurface/positveEmphasized'] =
        designSystem.appliedSurface.positiveEmphasized;

    textIcons['@appliedTextAndIcons/primary'] =
        designSystem.appliedTextAndIcons.primary;
    textIcons['@appliedTextAndIcons/primaryHeader'] =
        designSystem.appliedTextAndIcons.primaryHeader;
    textIcons['@appliedTextAndIcons/secondary'] =
        designSystem.appliedTextAndIcons.secondary;
    textIcons['@appliedTextAndIcons/emphasized'] =
        designSystem.appliedTextAndIcons.emphasized;
    textIcons['@appliedTextAndIcons/deEmphasized'] =
        designSystem.appliedTextAndIcons.deEmphasized;
    textIcons['@appliedTextAndIcons/disabled'] =
        designSystem.appliedTextAndIcons.disabled;
    textIcons['@appliedTextAndIcons/inversePrimary'] =
        designSystem.appliedTextAndIcons.inversePrimary;
    textIcons['@appliedTextAndIcons/inverseSecondary'] =
        designSystem.appliedTextAndIcons.inverseSecondary;
    textIcons['@appliedTextAndIcons/inverseEmphasized'] =
        designSystem.appliedTextAndIcons.inverseEmphasized;
    textIcons['@appliedTextAndIcons/inverseDeEmphasized'] =
        designSystem.appliedTextAndIcons.inverseDeEmphasized;
    textIcons['@appliedTextAndIcons/inverseDisabled'] =
        designSystem.appliedTextAndIcons.inverseDisabled;
    textIcons['@appliedTextAndIcons/brand'] =
        designSystem.appliedTextAndIcons.brand;
    textIcons['@appliedTextAndIcons/success'] =
        designSystem.appliedTextAndIcons.success;
    textIcons['@appliedTextAndIcons/successAlt'] =
        designSystem.appliedTextAndIcons.successAlt;
    textIcons['@appliedTextAndIcons/error'] =
        designSystem.appliedTextAndIcons.error;
    textIcons['@appliedTextAndIcons/errorAlt'] =
        designSystem.appliedTextAndIcons.errorAlt;
    textIcons['@appliedTextAndIcons/accent'] =
        designSystem.appliedTextAndIcons.accent;
    textIcons['@appliedTextAndIcons/accentAlt'] =
        designSystem.appliedTextAndIcons.accentAlt;
    textIcons['@appliedTextAndIcons/warning'] =
        designSystem.appliedTextAndIcons.warning;
    textIcons['@appliedTextAndIcons/warningAlt'] =
        designSystem.appliedTextAndIcons.warningAlt;
    textIcons['@appliedTextAndIcons/positive'] =
        designSystem.appliedTextAndIcons.positive;
    textIcons['@appliedTextAndIcons/positiveAlt'] =
        designSystem.appliedTextAndIcons.positiveAlt;
  }

  Color getColor(String itemReceived) {
    var notSet = true;
    var returnColor = Colors.white;
    var iterations = 4;
    var item = itemReceived;
    while (notSet && iterations > 0) {
      iterations--;
      if (item.contains(semanticLabel)) {
        item = semantics[item] ?? '';
      } else if (item.contains(primitiveLabel)) {
        item = primitive[item] ?? '';
      } else if (item.contains(colorLabel)) {
        final value = int.tryParse(item) ?? 0xFFFFFFFF;
        returnColor = Color(value);
        notSet = false;
      } else if (item.contains(textIconsLabel)) {
        item = textIcons[item] ?? '';
      } else if (item.contains(surfaceLabel)) {
        item = surface[item] ?? '';
      } else if (item.contains(borderLabel)) {
        item = border[item] ?? '';
      } else {
        notSet = false;
      }
    }

    return returnColor;
  }
}
