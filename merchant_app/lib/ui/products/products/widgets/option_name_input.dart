import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';

class OptionNameInput extends StatefulWidget {
  final TextEditingController controller;
  final List<String> allOptionNames;
  final List<String> alreadyUsedOptionNames;
  final ValueChanged<String> onChanged;
  final String? originalOptionName;

  const OptionNameInput({
    super.key,
    required this.controller,
    required this.allOptionNames,
    required this.onChanged,
    this.alreadyUsedOptionNames = const [],
    this.originalOptionName,
  });

  @override
  State<OptionNameInput> createState() => _OptionNameInputState();
}

class _OptionNameInputState extends State<OptionNameInput> {
  List<String> filteredOptions = [];
  bool showDropdown = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    filteredOptions = widget.allOptionNames;
    widget.controller.addListener(_onTextChanged);
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onTextChanged() {
    final text = widget.controller.text;
    setState(() {
      filteredOptions = widget.allOptionNames
          .where((o) => o.toLowerCase().contains(text.toLowerCase()))
          .toList();
      showDropdown = _focusNode.hasFocus && (filteredOptions.isNotEmpty);
    });
    widget.onChanged(text);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      setState(() {
        filteredOptions = widget.allOptionNames;
        showDropdown = filteredOptions.isNotEmpty;
      });
    } else {
      setState(() {
        showDropdown = false;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
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
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: 'Select or type option name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            errorMaxLines: 2,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Option name cannot be empty';
            }
            // Check for duplicate name, excluding the original name if editing
            final isDuplicate = widget.alreadyUsedOptionNames.any(
              (name) => name.toLowerCase() == value.toLowerCase(),
            );

            // If it's a duplicate and it's not the original name
            if (isDuplicate &&
                (widget.originalOptionName == null ||
                    value.toLowerCase() !=
                        widget.originalOptionName!.toLowerCase())) {
              return 'This option name already exists. Please choose a unique name.';
            }
            return null;
          },
        ),
        if (showDropdown)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
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
                      widget.controller.text = option;
                      widget.onChanged(option);
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
