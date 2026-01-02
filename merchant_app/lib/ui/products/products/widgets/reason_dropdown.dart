import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

class ReasonDropdown extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final double initialValue;
  final String? reason;
  final double quantity;
  final List<String>? increaseReasons;
  final List<String>? decreaseReasons;
  final Function(String?) onChanged;

  const ReasonDropdown({
    Key? key,
    required this.formKey,
    required this.initialValue,
    required this.quantity,
    required this.reason,
    this.increaseReasons,
    this.decreaseReasons,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<ReasonDropdown> createState() => ReasonDropdownState();
}

class ReasonDropdownState extends State<ReasonDropdown> {
  @override
  Widget build(BuildContext context) {
    if (widget.initialValue == widget.quantity ||
        (widget.increaseReasons == null && widget.decreaseReasons == null)) {
      return const SizedBox.shrink();
    }

    List<String>? reasons;
    if (widget.quantity > widget.initialValue &&
        widget.increaseReasons != null) {
      reasons = widget.increaseReasons;
    } else if (widget.quantity < widget.initialValue &&
        widget.decreaseReasons != null) {
      reasons = widget.decreaseReasons;
    } else {
      return const SizedBox.shrink();
    }

    return Form(
      key: widget.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DropdownButtonFormField2<String>(
          isExpanded: true,
          value: widget.reason,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 16),
          ),
          hint: context.paragraphSmall(
            ' Select Reason',
            color: Theme.of(context).hintColor,
          ),
          items: reasons!.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: context.paragraphSmall(item),
            );
          }).toList(),
          validator: (value) {
            if (value == null) {
              return 'Please select reason.';
            }
            return null;
          },
          onChanged: widget.onChanged,
          onSaved: widget.onChanged,
        ),
      ),
    );
  }
}
