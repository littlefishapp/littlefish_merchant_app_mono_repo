import 'package:flutter/material.dart';

import '../../../../app/theme/applied_system/applied_text_icon.dart';

// ignore: must_be_immutable
class ToggleSwitch extends StatefulWidget {
  Color? enabledColor;
  void Function(bool isEnabled)? onChanged;
  bool initiallyEnabled, forceRefresh;

  ToggleSwitch({
    Key? key,
    this.enabledColor,
    this.onChanged,
    this.initiallyEnabled = false,
    this.forceRefresh = true,
  }) : super(key: key);

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  bool isEnabled = false;

  @override
  void initState() {
    isEnabled = widget.initiallyEnabled;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      activeColor: Theme.of(context).extension<AppliedTextIcon>()?.brand,
      // This bool value toggles the switch.
      value: isEnabled,
      //activeColor: widget.enabledColor,
      onChanged: widget.onChanged != null
          ? (bool value) {
              if (widget.forceRefresh) {
                // This is called when the user toggles the switch.
                setState(() {
                  isEnabled = value;
                  widget.onChanged!(value);
                });
              } else {
                widget.onChanged!(value);
              }
            }
          : null,
    );
  }
}
