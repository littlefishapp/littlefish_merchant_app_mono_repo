// lib/features/initial_pages/data/models/terms_and_conditions_model.dart

import 'package:littlefish_merchant/features/initial_pages/domain/entities/terms_and_conditions_entity.dart';

class TermsAndConditionsModel extends TermsAndConditionsEntity {
  /// Parses a potentially malformed or missing JSON map into a valid entity
  TermsAndConditionsEntity fromJson(Map<String, dynamic>? json) {
    // If json is null or empty, return safe defaults
    if (json == null || json.isEmpty) {
      return TermsAndConditionsEntity(
        inverseColour: false,
        prefixTexts: [''],
        linkText: '',
        url: '',
        title: 'Terms and Conditions',
        isAsset: false,
      );
    }

    bool parseBool(dynamic value) {
      if (value is bool) return value;
      if (value is String) return value.trim().toLowerCase() == 'true';
      return false; // safe default
    }

    List<String> parseStringList(dynamic value) {
      if (value == null) return [];
      if (value is List) {
        return value
            .map((e) => e?.toString() ?? '')
            .where((s) => s.isNotEmpty)
            .toList();
      }
      // In case someone passes a single string instead of a list
      if (value is String && value.trim().isNotEmpty) {
        return [value.trim()];
      }
      return [];
    }

    String parseString(dynamic value, {required String defaultValue}) {
      if (value == null) return defaultValue;
      final trimmed = value.toString().trim();
      return trimmed.isEmpty ? defaultValue : trimmed;
    }

    return TermsAndConditionsEntity(
      inverseColour: parseBool(json['inverseColour']),
      prefixTexts: parseStringList(json['prefixTexts']),
      linkText: parseString(json['linkText'], defaultValue: ''),
      url: parseString(json['url'], defaultValue: ''),
      title: parseString(json['title'], defaultValue: 'Terms and Conditions'),
      isAsset: parseBool(json['isAsset']),
    );
  }

  /// Converts entity back to JSON (useful for caching or testing)
  Map<String, dynamic> toJson() {
    return {
      'inverseColour': inverseColour
          .toString(), // stored as string to match config format
      'prefixTexts': prefixTexts,
      'linkText': linkText,
      'url': url,
      'title': title,
      'isAsset': isAsset.toString(),
    };
  }
}
