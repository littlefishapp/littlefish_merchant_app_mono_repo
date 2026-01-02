import 'package:collection/collection.dart';
import 'package:littlefish_merchant/models/stock/single_option_attribute.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';

class ProductVariantHelper {
  /// Constructs a variant display name from a parent's name and selected attributes.
  ///
  /// The format is `{parentDisplayName}-{attribute1}/{attribute2}`. The attributes
  /// are sorted according to the order of options in [availableOptionAttributes]
  /// and are converted to lowercase.
  ///
  /// - `parentProductDisplayName`: The display name of the parent product.
  /// - `availableOptionAttributes`: The list of all possible options for the product.
  /// - `selectedOptionAttributes`: The list of attributes the user has currently selected.
  static String constructVariantDisplayName({
    required String parentProductDisplayName,
    required List<ProductOptionAttribute> availableOptionAttributes,
    required List<SingleOptionAttribute> selectedOptionAttributes,
  }) {
    final parentName = parentProductDisplayName.toLowerCase();

    final sortedAttributes = availableOptionAttributes.map((availableOpt) {
      final selectedAttr = selectedOptionAttributes.firstWhereOrNull(
        (selected) => selected.option == availableOpt.option,
      );
      // Return the selected attribute value or an empty string if none is found.
      return selectedAttr?.attribute.toLowerCase() ?? '';
    }).toList();

    return '$parentName-${sortedAttributes.join('/')}';
  }

  /// Checks if a valid attribute has been selected for every available product option.
  ///
  /// Returns `true` if for each option in [availableOptionAttributes], there is a
  /// corresponding selection in [selectedOptionAttributes] where the chosen attribute
  /// is one of the valid choices for that option. This comparison is case-insensitive.
  static bool hasSelectedAnAttributeForEachOption({
    required List<ProductOptionAttribute> availableOptionAttributes,
    required List<SingleOptionAttribute> selectedOptionAttributes,
  }) {
    // If there are no options to choose from, the condition is met.
    if (availableOptionAttributes.isEmpty) {
      return true;
    }

    // Ensure EVERY available option has a valid, selected attribute.
    return availableOptionAttributes.every((availableOption) {
      // Check if ANY selected option is a valid match for the current available option.
      return selectedOptionAttributes.any((selectedOption) {
        // 1. Check if the option names match (case-insensitive).
        final bool isOptionMatch =
            selectedOption.option.toLowerCase() ==
            availableOption.option?.toLowerCase();

        if (!isOptionMatch) return false;

        // 2. If options match, check if the selected attribute is in the list of
        //    available attributes for that option (case-insensitive).
        final bool isAttributeMatch =
            availableOption.attributes?.any(
              (attr) =>
                  attr.toLowerCase() == selectedOption.attribute.toLowerCase(),
            ) ??
            false; // If attributes are null, no match is possible.

        return isAttributeMatch;
      });
    });
  }

  /// For a product with options [Colour, Size] and selected attributes [medium, green],
  /// this method will return "green / medium" (respecting the canonical order).
  ///
  /// - `availableOptionAttributes`: The full list of options from the parent product.
  /// - `selectedOptionAttributes`: The list of attributes the user has currently selected.
  static String getAttributeCombinationString({
    required List<ProductOptionAttribute> availableOptionAttributes,
    required List<SingleOptionAttribute> selectedOptionAttributes,
    String joinString = ' / ',
  }) {
    if (availableOptionAttributes.isEmpty) {
      return '';
    }

    final orderedAttributes = availableOptionAttributes
        .map((availableOpt) {
          final selectedAttr = selectedOptionAttributes.firstWhereOrNull(
            (selected) => selected.option == availableOpt.option,
          );
          // Return the attribute value if found, otherwise null.
          return selectedAttr?.attribute;
        })
        .whereType<String>()
        .toList();

    return orderedAttributes.join(joinString);
  }
}
