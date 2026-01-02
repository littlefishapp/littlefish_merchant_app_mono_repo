import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/bottom_sheet_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/flutter_colour_picker.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

import '../../../ui/online_store/store_setup_v2/widgets/text_widgets.dart';

class ColourPickerPage extends StatefulWidget {
  final Color initialColour;
  final void Function(Color) onSaveColour;

  const ColourPickerPage({
    Key? key,
    required this.initialColour,
    required this.onSaveColour,
  }) : super(key: key);

  @override
  State<ColourPickerPage> createState() => _ColourPickerPageState();
}

class _ColourPickerPageState extends State<ColourPickerPage> {
  late Color _initialColour;
  late Color _pickedColour;

  @override
  void initState() {
    _initialColour = widget.initialColour;
    _pickedColour = widget.initialColour;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetIndicator(),
          const Align(
            alignment: Alignment.centerLeft,
            child: HeadingText(
              text: 'Select Colour',
              fontSize: 20,
              padding: EdgeInsets.all(8),
            ),
          ),
          FlutterColourPicker(
            initialColour: _pickedColour,
            onChanged: _changeColor,
          ),
          const SizedBox(height: 8),
          cancelAndSaveButtons(),
        ],
      ),
    );
  }

  void _changeColor(Color color) {
    if (mounted) {
      setState(() => _pickedColour = color);
    }
  }

  Widget cancelAndSaveButtons() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(children: [cancelButton(), saveButton()]),
    );
  }

  Widget cancelButton() {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _pickedColour = _initialColour;
            Navigator.of(context).pop();
          },
          child: Center(
            // TODO(lampian): verify color was orange
            child: context.paragraphLarge('Cancel', isBold: true),
          ),
        ),
      ),
    );
  }

  saveButton() {
    return Expanded(
      child: ButtonPrimary(
        text: 'Save Changes',
        upperCase: false,
        buttonColor: Theme.of(context).colorScheme.secondary,
        onTap: (context) async {
          widget.onSaveColour(_pickedColour);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
