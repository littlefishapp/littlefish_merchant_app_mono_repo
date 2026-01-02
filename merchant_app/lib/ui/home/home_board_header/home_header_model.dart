// features/home/data/models/home_header_model.dart

import 'package:littlefish_merchant/ui/home/home_board_header/home_header_entity.dart';

class HomeHeaderModel {
  HomeHeaderEntity fromJson(Map<String, dynamic> json) {
    List<String> toStringList(dynamic value) =>
        (value as List?)?.cast<String>() ?? [];

    List<double> toDoubleList(dynamic value) {
      if (value is List) {
        return value.map((e) => double.tryParse(e.toString()) ?? 0.0).toList();
      }
      return [];
    }

    bool toBool(dynamic value) =>
        value is bool ? value : (value?.toString().toLowerCase() == 'true');

    return HomeHeaderEntity(
      hasDecoratedSurface: toBool(json['hasDecoratedSurface']),
      header1Texts: toStringList(json['header1Texts']),
      header1Weights: toStringList(json['header1Weights']),
      header1Sizes: toStringList(json['header1Sizes']),
      header2Texts: toStringList(json['header2Texts']),
      header2Weights: toStringList(json['header2Weights']),
      header2Sizes: toStringList(json['header2Sizes']),
      useBusinessNameForHeader2: toBool(json['useBusinessNameForHeader2']),
      widgetPadding: toDoubleList(json['widgetPadding']),
      businessTileEnabled: toBool(json['businessTileEnabled']),
      businessTileDashEnabled: toBool(json['businessTileDashEnabled']),
      businessTilePadding: toDoubleList(json['businessTilePadding']),
      businessTileBorderRadius:
          double.tryParse(
            json['businessTileBorderRadius']?.toString() ?? '12',
          ) ??
          12.0,
    );
  }
}
