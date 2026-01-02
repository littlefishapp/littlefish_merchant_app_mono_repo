import 'package:flutter/material.dart';

class PaletteManager {
  static final PaletteManager _instance = PaletteManager._privateConstructor();

  List<Color>? _palette;

  final List<Color> _baseColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    // Add more base colors as needed
  ];

  PaletteManager._privateConstructor();

  static PaletteManager get instance => _instance;

  List<Color> getPalette({List<Color>? customColours}) {
    _palette ??= generatePalette(customColours: customColours);
    return _palette!;
  }

  void refreshPalette({List<Color>? customColours}) {
    // Refresh the palette with new colors
    _palette = generatePalette(customColours: customColours);
  }

  List<Color> generatePalette({List<Color>? customColours}) {
    // Generate colour palette with no adjacent colours matching
    List<Color> palette = [];

    // Ensure custom colours are added first, if provided
    if (customColours != null && customColours.isNotEmpty) {
      for (var colour in customColours) {
        if (!palette.contains(colour)) {
          palette.add(colour);
        }
      }
    }

    // Fill in the rest of the palette from baseColors, avoiding adjacent duplicates
    for (var colour in _baseColors) {
      if (!palette.contains(colour) &&
          (palette.isEmpty || palette.last != colour)) {
        palette.add(colour);
      }
    }

    // Ensure palette has enough unique colors, possibly repeating the sequence
    while (palette.length < _baseColors.length + 2) {
      for (var color in _baseColors) {
        if (palette.length >= _baseColors.length + 2) break;
        if (palette.last != color) {
          palette.add(color);
        }
      }
    }

    return palette;
  }
}
