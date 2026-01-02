import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/tools/hex_color.dart';

class ColorHexLabel extends StatefulWidget {
  final Color initialColour;
  final void Function(Color)? onChanged;
  final bool enableEditing;
  final bool enableOutlineStyling;
  final EdgeInsetsGeometry margin;
  final TextStyle? labelStyle;

  const ColorHexLabel({
    Key? key,
    this.initialColour = Colors.red,
    this.onChanged,
    this.enableEditing = true,
    this.enableOutlineStyling = true,
    this.margin = const EdgeInsets.all(8),
    this.labelStyle,
  }) : super(key: key);

  @override
  State<ColorHexLabel> createState() => _ColorHexLabelState();
}

class _ColorHexLabelState extends State<ColorHexLabel> {
  late Color _colour;
  late String _hexString;

  @override
  void initState() {
    _colour = widget.initialColour;
    _hexString = HexColor.colorToHex(widget.initialColour);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ColorHexLabel oldWidget) {
    if (widget.initialColour != oldWidget.initialColour) {
      if (mounted) {
        setState(() {
          _colour = widget.initialColour;
          _hexString = HexColor.colorToHex(widget.initialColour);
        });
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(margin: widget.margin, child: _hexTextField());
  }

  _hexTextField() {
    return StringFormField(
      key: const Key('hex-value'),
      initialValue: _hexString,
      isRequired: false,
      enabled: widget.enableEditing,
      useOutlineStyling: widget.enableOutlineStyling,
      onSaveValue: (String? value) {
        if (mounted) {
          setState(() {
            if (_isValidHex(value ?? _hexString)) {
              _hexString = value ?? _hexString;
              _updateColour();
            }
          });
        }
      },
      onChanged: (String value) {
        if (_isValidHex(value)) {
          _hexString = value;
          _colour = HexColor(_hexString);
        }
      },
      onFieldSubmitted: (String value) {
        if (mounted) {
          setState(() {
            if (_isValidHex(value)) {
              _hexString = value;
              _updateColour();
            }
          });
        }
      },
      hintText: 'Hex',
      labelText: 'Hex',
      labelStyle: widget.labelStyle,
    );
  }

  void _updateColour() {
    _colour = HexColor(_hexString);
    if (widget.onChanged != null) widget.onChanged!(_colour);
  }

  bool _isValidHex(String hex) {
    return hex.length == 9;
  }
}
