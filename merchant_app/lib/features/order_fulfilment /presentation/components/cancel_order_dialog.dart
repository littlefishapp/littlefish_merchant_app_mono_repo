//flutter imports
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_informational.dart';
//project imports
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';

import '../../../../app/theme/applied_system/applied_text_icon.dart';

class CancelOrderDialog extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<String> items;
  final String? initialItem;
  final String confirmButtonText;
  final String cancelButtonText;
  final Function(String?)? onItemSelected;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final double maxHeight;
  const CancelOrderDialog({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.items,
    this.initialItem,
    required this.confirmButtonText,
    required this.cancelButtonText,
    this.onItemSelected,
    required this.onConfirm,
    required this.onCancel,
    this.maxHeight = 0.7,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final textIconColours =
        Theme.of(context).extension<AppliedTextIcon>() ??
        const AppliedTextIcon();
    final surfaceColors =
        Theme.of(context).extension<AppliedInformational>() ??
        const AppliedInformational();
    final fillColor = surfaceColors.errorSurface;
    final iconColor = surfaceColors.errorBorder;
    final textColor = textIconColours.primary;
    final titleColor = textIconColours.primary;
    final hintColor = textIconColours.deEmphasized;
    final labelColor = textIconColours.secondary;
    final dropDownListWidth = MediaQuery.of(context).size.width * 0.5;

    final enabledBorder = context.inputBorderEnabled();
    final border = context.inputBorderEnabled();
    final focussedBorder = context.inputBorderFocus();
    final disabledBorder = context.inputBorderDisabled();
    final errorBorder = context.inputBorderError();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * maxHeight,
        ),
        child: Material(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: iconColor),
                  ),
                  child: Center(child: Icon(icon, color: iconColor)),
                ),
                const SizedBox(height: 20),
                context.labelSmall(title, isBold: true, color: titleColor),
                const SizedBox(height: 10),
                context.paragraphMedium(description, color: textColor),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: initialItem,
                  onChanged: onItemSelected,
                  decoration: InputDecoration(
                    hintText: 'Reasons',
                    labelStyle: TextStyle(color: labelColor),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintStyle: TextStyle(color: hintColor),
                    border: border,
                    focusedBorder: focussedBorder,
                    enabledBorder: enabledBorder,
                    errorBorder: errorBorder,
                    disabledBorder: disabledBorder,
                    isDense: true,
                  ),
                  icon: Icon(Icons.keyboard_arrow_down, color: textColor),
                  items: items.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: SizedBox(
                        width: dropDownListWidth,
                        // height: 40,
                        child: context.labelSmall(
                          value,
                          color: textColor,
                          alignLeft: true,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                ButtonPrimary(
                  onTap: (_) async {
                    onConfirm();
                  },
                  text: confirmButtonText,
                ),
                ButtonSecondary(
                  onTap: (_) {
                    onCancel();
                  },
                  text: cancelButtonText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
