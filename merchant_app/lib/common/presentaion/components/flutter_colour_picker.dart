import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:littlefish_merchant/common/presentaion/components/color_hex_label.dart';
import 'package:littlefish_merchant/common/presentaion/components/color_rgb_label.dart';

import 'cards/card_neutral.dart';

class FlutterColourPicker extends StatefulWidget {
  final Color initialColour;
  final void Function(Color) onChanged;
  final TextStyle? labelStyle;
  final bool useFlutterColourLabels, enableAlpha;
  final List<ColorLabelType> labelTypes;

  const FlutterColourPicker({
    Key? key,
    required this.onChanged,
    this.initialColour = Colors.red,
    this.labelStyle,
    this.useFlutterColourLabels = false,
    this.labelTypes = const <ColorLabelType>[],
    this.enableAlpha = false,
  }) : super(key: key);

  @override
  State<FlutterColourPicker> createState() => _FlutterColourPickerState();
}

class _FlutterColourPickerState extends State<FlutterColourPicker> {
  late Color _colour;

  @override
  void initState() {
    _colour = widget.initialColour;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FlutterColourPicker oldWidget) {
    if (widget.initialColour != oldWidget.initialColour) {
      if (mounted) {
        setState(() {
          _colour = widget.initialColour;
        });
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        child: CardNeutral(
          margin: const EdgeInsets.all(8),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              _colourPickerDisplay(),
              Visibility(
                visible: widget.useFlutterColourLabels == false,
                child: _colourValues(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _colourPickerDisplay() {
    return ColorPicker(
      pickerColor: _colour,
      onColorChanged: (newColour) {
        if (mounted) {
          setState(() {
            _colour = newColour;
            widget.onChanged(newColour);
          });
        }
      },
      pickerAreaHeightPercent: 0.8,
      pickerAreaBorderRadius: BorderRadius.circular(8),
      displayThumbColor: true,
      enableAlpha: widget.enableAlpha,
      labelTypes: widget.labelTypes,
    );
  }

  Widget _colourValues() {
    return SizedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [_hexColourField(), _rgbColourFields()],
      ),
    );
  }

  Widget _hexColourField() {
    return Expanded(
      child: ColorHexLabel(
        initialColour: _colour,
        onChanged: (newColour) {
          if (mounted) {
            setState(() {
              _colour = newColour;
            });
          }
        },
        labelStyle: widget.labelStyle,
      ),
    );
  }

  Widget _rgbColourFields() {
    return Expanded(
      child: ColorRGBLabel(
        initialColour: _colour,
        onChanged: (newColour) {
          if (mounted) {
            setState(() {
              _colour = newColour;
            });
          }
        },
        labelStyle: widget.labelStyle,
      ),
    );
  }
}
