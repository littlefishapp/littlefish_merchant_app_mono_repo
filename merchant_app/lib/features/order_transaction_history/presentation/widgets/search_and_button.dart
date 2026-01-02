// flutter imports
import 'package:flutter/material.dart';
// project imports
import 'package:littlefish_merchant/common/presentaion/components/form_fields/search_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/square_icon_button_secondary.dart';
import 'package:littlefish_merchant/shared/constants/semantics_constants.dart';

class SearchAndButton extends StatelessWidget {
  final void Function(BuildContext) onButtonPressed;
  final void Function(String)? onTextChanged;
  final void Function(String input)? onFieldSubmitted;
  final EdgeInsetsGeometry padding;
  final TextInputType? keyboardType;
  final bool enableTimer;
  final bool showFilterButton;
  final String? initialSearchValue;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool showSortButton;

  const SearchAndButton({
    super.key,
    required this.onButtonPressed,
    this.onTextChanged,
    this.onFieldSubmitted,
    this.controller,
    this.focusNode,
    this.padding = const EdgeInsets.all(8),
    this.keyboardType,
    this.enableTimer = false,
    this.showFilterButton = true,
    this.initialSearchValue,
    this.showSortButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            Expanded(
              child: SearchTextField(
                onChanged: (text) =>
                    onTextChanged != null ? onTextChanged!(text) : null,
                onClear: () =>
                    onTextChanged != null ? onTextChanged!('') : null,
                keyboardType: keyboardType,
                enableTimer: enableTimer,
                initialValue: initialSearchValue,
                onFieldSubmitted: onFieldSubmitted,
                controller: controller,
                focusNode: focusNode,
              ),
            ),
            const SizedBox(width: 8),
            if (showFilterButton)
              SizedBox(
                height: 51,
                width: 51,
                child: SquareIconButtonSecondary(
                  semanticsIdentifier: SemanticsConstants.kFilter,
                  semanticsLabel: SemanticsConstants.kFilter,
                  icon: Icons.tune_outlined,
                  onPressed: (ctx) => onButtonPressed(ctx),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
