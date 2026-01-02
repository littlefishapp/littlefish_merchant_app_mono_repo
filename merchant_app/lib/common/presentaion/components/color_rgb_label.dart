import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/numeric_form_field.dart';

class ColorRGBLabel extends StatefulWidget {
  final Color initialColour;
  final void Function(Color)? onChanged;
  final bool enableEditing;
  final bool enableOutlineStyling;
  final double spaceBetweenValues;
  final EdgeInsetsGeometry margin;
  final TextStyle? labelStyle;

  const ColorRGBLabel({
    Key? key,
    required this.initialColour,
    this.onChanged,
    this.enableEditing = true,
    this.enableOutlineStyling = true,
    this.spaceBetweenValues = 8,
    this.margin = const EdgeInsets.all(8),
    this.labelStyle,
  }) : super(key: key);

  @override
  State<ColorRGBLabel> createState() => _ColorRGBLabelState();
}

class _ColorRGBLabelState extends State<ColorRGBLabel> {
  late Color _colour;
  late int _red;
  late int _green;
  late int _blue;

  @override
  void initState() {
    _colour = widget.initialColour;
    _red = widget.initialColour.red;
    _green = widget.initialColour.green;
    _blue = widget.initialColour.blue;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ColorRGBLabel oldWidget) {
    if (widget.initialColour != oldWidget.initialColour) {
      if (mounted) {
        setState(() {
          _colour = widget.initialColour;
          _red = widget.initialColour.red;
          _green = widget.initialColour.green;
          _blue = widget.initialColour.blue;
        });
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: Row(
        children: [
          Expanded(child: _redTextField()),
          SizedBox(width: widget.spaceBetweenValues),
          Expanded(child: _greenTextField()),
          SizedBox(width: widget.spaceBetweenValues),
          Expanded(child: _blueTextField()),
        ],
      ),
    );
  }

  _redTextField() {
    return NumericFormField(
      key: const Key('red'),
      initialValue: _red,
      enabled: widget.enableEditing,
      isRequired: false,
      isDense: true,
      maxLength: 3,
      maxLengthEnforced: true,
      showTextLengthCounter: false,
      useOutlineStyling: widget.enableOutlineStyling,
      onSaveValue: (int value) {
        if (mounted) {
          setState(() {
            _red = value;
            _updateColour();
          });
        }
      },
      onChanged: (int value) {
        _red = value;
      },
      onFieldSubmitted: (int value) {
        if (mounted) {
          setState(() {
            _red = value;
            _updateColour();
          });
        }
      },
      hintText: 'Red',
      labelText: 'R',
      labelStyle: widget.labelStyle,
    );
  }

  _greenTextField() {
    return NumericFormField(
      key: const Key('green'),
      enabled: widget.enableEditing,
      initialValue: _green,
      isRequired: false,
      isDense: true,
      maxLength: 3,
      maxLengthEnforced: true,
      showTextLengthCounter: false,
      useOutlineStyling: widget.enableOutlineStyling,
      onSaveValue: (int value) {
        if (mounted) {
          setState(() {
            _green = value;
            _updateColour();
          });
        }
      },
      onChanged: (int value) {
        _green = value;
      },
      onFieldSubmitted: (int value) {
        if (mounted) {
          setState(() {
            _green = value;
            _updateColour();
          });
        }
      },
      hintText: 'Green',
      labelText: 'G',
      labelStyle: widget.labelStyle,
    );
  }

  _blueTextField() {
    return NumericFormField(
      key: const Key('blue'),
      enabled: widget.enableEditing,
      initialValue: _blue,
      isRequired: false,
      isDense: true,
      maxLength: 3,
      maxLengthEnforced: true,
      showTextLengthCounter: false,
      useOutlineStyling: widget.enableOutlineStyling,
      onSaveValue: (int value) {
        if (mounted) {
          setState(() {
            _blue = value;
            _updateColour();
          });
        }
      },
      onChanged: (int value) {
        _blue = value;
      },
      onFieldSubmitted: (int value) {
        if (mounted) {
          setState(() {
            _blue = value;
            _updateColour();
          });
        }
      },
      hintText: 'Blue',
      labelText: 'B',
      labelStyle: widget.labelStyle,
    );
  }

  void _updateColour() {
    _red = _limitToValidRange(_red);
    _green = _limitToValidRange(_green);
    _blue = _limitToValidRange(_blue);
    _colour = Color.fromRGBO(_red, _green, _blue, 1);
    if (widget.onChanged != null) widget.onChanged!(_colour);
  }

  int _limitToValidRange(int colourValue) {
    if (colourValue < 0) return 0;
    if (colourValue > 255) return 255;
    return colourValue;
  }
}
