import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/option_name_input.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/option_tag_input.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/product_attribute_chip.dart';

class AddOption extends StatefulWidget {
  final List<ProductOptionAttribute> allOptionsAndAttributes;
  final ProductOptionAttribute? initialOptionAttribute;
  final List<String> alreadyUsedOptionNames;
  final void Function(
    ProductOptionAttribute optionAttribute,
    String? originalOptionName,
  )
  onUpsert;

  const AddOption({
    super.key,
    required this.allOptionsAndAttributes,
    required this.onUpsert,
    this.initialOptionAttribute,
    this.alreadyUsedOptionNames = const [],
  });

  @override
  State<AddOption> createState() => _AddOptionState();
}

class _AddOptionState extends State<AddOption> {
  late TextEditingController _optionNameController;
  final _formKey = GlobalKey<FormState>();
  String? selectedOptionName;
  String? originalOptionName;
  List<String> optionValues = [];
  List<String> filteredOptionNames = [];
  List<String> filteredOptionValues = [];
  final GlobalKey<OptionTagInputState> _optionTagInputKey =
      GlobalKey<OptionTagInputState>();

  @override
  void initState() {
    super.initState();
    selectedOptionName = widget.initialOptionAttribute?.option;
    originalOptionName = widget.initialOptionAttribute?.option;
    optionValues = List<String>.from(
      widget.initialOptionAttribute?.attributes ?? [],
    );
    _optionNameController = TextEditingController(
      text: selectedOptionName ?? '',
    );
    filteredOptionNames = _getAllOptionNames();
    filteredOptionValues = _getOptionValuesForSelected();
  }

  List<String> _getAllOptionNames() {
    final names = widget.allOptionsAndAttributes
        .map((e) => e.option ?? '')
        .where((e) => e.isNotEmpty)
        .where(
          (e) =>
              !widget.alreadyUsedOptionNames
                  .map((n) => n.toLowerCase())
                  .contains(e.toLowerCase()) ||
              (originalOptionName != null &&
                  e.toLowerCase() == originalOptionName!.toLowerCase()),
        )
        .toSet()
        .toList();
    return names;
  }

  List<String> _getOptionValuesForSelected() {
    final match = widget.allOptionsAndAttributes.firstWhere(
      (e) => e.option == selectedOptionName,
      orElse: () =>
          ProductOptionAttribute(option: selectedOptionName, attributes: []),
    );
    return match.attributes ?? [];
  }

  void _onOptionNameChanged(String value) {
    // Check if the new value matches an existing option name (case-insensitive)
    final isDropdownSelection = filteredOptionNames.any(
      (name) => name.toLowerCase() == value.toLowerCase(),
    );
    final isDifferentDropdownSelection =
        isDropdownSelection &&
        (selectedOptionName == null ||
            selectedOptionName!.toLowerCase() != value.toLowerCase());

    setState(() {
      selectedOptionName = value;
      filteredOptionValues = _getOptionValuesForSelected();
      // If user picked a different dropdown option, clear attributes (do not auto-populate)
      if (isDifferentDropdownSelection) {
        optionValues = [];
      }
    });
  }

  void _onOptionValuesChanged(List<String> values) {
    setState(() {
      optionValues = values;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textIcon = Theme.of(context).extension<AppliedTextIcon>();
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  context.labelMediumBold('Add Option'),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              context.labelSmall('Option Name', isBold: true),
              const SizedBox(height: 6),
              OptionNameInput(
                controller: _optionNameController,
                allOptionNames: filteredOptionNames,
                alreadyUsedOptionNames: widget.alreadyUsedOptionNames,
                originalOptionName: originalOptionName,
                onChanged: _onOptionNameChanged,
              ),
              const SizedBox(height: 18),
              context.labelSmall('Option Values', isBold: true),
              const SizedBox(height: 6),
              OptionTagInput(
                key: _optionTagInputKey,
                allOptions: filteredOptionValues,
                selectedOptions: optionValues,
                onChanged: _onOptionValuesChanged,
                allowFreeText: true,
              ),
              const SizedBox(height: 8),
              context.paragraphSmall(
                'Separate with commas or press Enter',
                color: textIcon?.deEmphasized,
                alignLeft: true,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: optionValues
                    .map(
                      (v) => ProductAttributeChip(
                        attribute: v,
                        showDeleteIcon: true,
                        onDelete: (attribute) {
                          setState(() {
                            optionValues.remove(attribute);
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: ButtonSecondary(
                      text: 'Cancel',
                      onTap: (_) => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ButtonPrimary(
                      text: widget.initialOptionAttribute == null
                          ? 'Add'
                          : 'Update',
                      onTap: (_) {
                        // Submit any unsubmitted text in OptionTagInput
                        _optionTagInputKey.currentState?.submitCurrentText();
                        setState(() {
                          selectedOptionName = _optionNameController.text;
                        });
                        if (_formKey.currentState?.validate() ?? false) {
                          widget.onUpsert(
                            ProductOptionAttribute(
                              option: selectedOptionName,
                              attributes: optionValues,
                            ),
                            originalOptionName,
                          );
                          Navigator.of(context).pop();
                        }
                      },
                      disabled:
                          selectedOptionName == null ||
                          selectedOptionName!.trim().isEmpty ||
                          optionValues.isEmpty,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
