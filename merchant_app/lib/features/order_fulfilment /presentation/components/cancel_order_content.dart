//flutter imports
import 'package:flutter/material.dart';

//project imports
import 'package:littlefish_merchant/app/theme/typography.dart';

class CancelOrderContent extends StatelessWidget {
  final String description;
  final List<String> items;
  final String? initialItem;
  final Function(String?)? onItemSelected;

  const CancelOrderContent({
    Key? key,
    required this.description,
    required this.items,
    this.initialItem,
    this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        context.paragraphMedium(description),
        const SizedBox(height: 20),
        DropdownButtonFormField<String>(
          value: initialItem,
          onChanged: onItemSelected,
          decoration: InputDecoration(
            labelText: 'Cancellation Reason',
            hintText: 'Select reason for order cancellation',
            labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                width: 1,
              ),
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
          ),
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
        ),
      ],
    );
  }
}
