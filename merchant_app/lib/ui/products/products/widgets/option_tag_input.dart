import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';

class OptionTagInput extends StatefulWidget {
  final List<String> allOptions;
  final List<String> selectedOptions;
  final ValueChanged<List<String>> onChanged;
  final bool allowFreeText;

  const OptionTagInput({
    super.key,
    required this.allOptions,
    required this.selectedOptions,
    required this.onChanged,
    this.allowFreeText = false,
  });

  @override
  OptionTagInputState createState() => OptionTagInputState();
}

class OptionTagInputState extends State<OptionTagInput> {
  final TextEditingController _controller = TextEditingController();
  late FocusNode _focusNode;
  List<String> filteredOptions = [];
  bool showDropdown = false;

  @override
  void initState() {
    super.initState();
    filteredOptions = widget.allOptions;
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      setState(() {
        filteredOptions = widget.allOptions
            .where((o) => !widget.selectedOptions.contains(o))
            .toList();
        showDropdown = filteredOptions.isNotEmpty;
      });
    } else {
      setState(() {
        showDropdown = false;
      });
    }
  }

  void _addOption(String value) {
    final values = value
        .split(',')
        .map((v) => v.trim())
        .where((v) => v.isNotEmpty)
        .toList();
    bool added = false;
    for (final v in values) {
      if (!widget.selectedOptions.contains(v)) {
        widget.onChanged([...widget.selectedOptions, v]);
        added = true;
      }
    }
    if (added) {
      _controller.clear();
      setState(() {});
    }
  }

  /// Call this to submit any text in the field as an option (if not empty)
  void submitCurrentText() {
    if (_controller.text.trim().isNotEmpty) {
      _addOption(_controller.text);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: 'Small, Medium, Large',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
          onChanged: (val) {
            if (val.contains(',')) {
              _addOption(val);
            } else {
              setState(() {
                filteredOptions = widget.allOptions
                    .where(
                      (o) =>
                          o.toLowerCase().contains(val.toLowerCase()) &&
                          !widget.selectedOptions.contains(o),
                    )
                    .toList();
                showDropdown = filteredOptions.isNotEmpty;
              });
            }
          },
          onSubmitted: (val) {
            _addOption(val);
          },
          onEditingComplete: () {
            _addOption(_controller.text);
          },
        ),
        if ((filteredOptions.isNotEmpty && _controller.text.isNotEmpty) ||
            (_focusNode.hasFocus &&
                filteredOptions.isNotEmpty &&
                _controller.text.isEmpty))
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).extension<AppliedSurface>()?.primary,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: filteredOptions.length,
                itemBuilder: (context, index) {
                  final option = filteredOptions[index];
                  return ListTile(
                    title: context.labelSmall(option),
                    onTap: () {
                      _addOption(option);
                      setState(() {
                        showDropdown = false;
                      });
                      _focusNode.unfocus();
                      FocusScope.of(context).unfocus();
                    },
                  );
                },
                separatorBuilder: (context, index) => const CommonDivider(),
              ),
            ),
          ),
      ],
    );
  }
}
