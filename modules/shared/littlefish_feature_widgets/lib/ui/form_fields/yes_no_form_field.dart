// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:quiver/strings.dart';

import '../../../../../widgets/app/theme/applied_system/applied_text_icon.dart';

class YesNoFormField extends StatefulWidget {
  final String labelText;

  final String? description;

  final Function(bool? value) onSaved;

  final bool? initialValue;

  final bool isToggle;

  final IconData? prefixIcon;

  final EdgeInsetsGeometry? padding;
  final bool useOutlineStyling;

  const YesNoFormField({
    Key? key,
    required this.labelText,
    required this.onSaved,
    this.description,
    this.isToggle = true,
    this.initialValue = false,
    this.prefixIcon = Icons.public,
    this.padding,
    this.useOutlineStyling = false,
  }) : super(key: key);

  @override
  State<YesNoFormField> createState() => _YesNoFormFieldState();
}

class _YesNoFormFieldState extends State<YesNoFormField> {
  bool? value;

  @override
  void initState() {
    value = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isToggle) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final widthAvailable = constraints.maxWidth;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(widget.prefixIcon ?? Icons.public),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 1.6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        context.paragraphMedium(
                          widget.labelText,
                          alignLeft: true,
                          color: Theme.of(
                            context,
                          ).extension<AppliedTextIcon>()?.secondary,
                        ),
                        if (isNotBlank(widget.description))
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: widthAvailable * 0.6,
                            ),
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              widget.description!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                              style: context.styleBody03x12R!.copyWith(
                                color: Theme.of(
                                  context,
                                ).extension<AppliedTextIcon>()?.deEmphasized,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  //const Spacer(), // Adjust the spacing as needed,
                ],
              ),
              Switch(
                key: widget.key,
                activeColor: Theme.of(
                  context,
                ).extension<AppliedTextIcon>()?.brand,
                value: widget.initialValue ?? value!,
                onChanged: (bool newValue) {
                  if (mounted) {
                    setState(() {
                      value = newValue;
                    });
                  }
                  // Ensure onChanged is triggered
                  widget.onSaved(newValue);
                },
              ),
            ],
          );
        },
      );
    } else {
      return CheckboxListTile(
        title: Text(widget.labelText),
        subtitle: isNotBlank(widget.description)
            ? null
            : LongText(widget.description),
        onChanged: (bool? value) {
          this.value = value;
          widget.onSaved(value);
          if (mounted) {
            setState(() {});
          } else {
            this.value = value;
            widget.onSaved(value);
          }
        },
        value: widget.initialValue ?? value,
        activeColor: Theme.of(context).colorScheme.primary,
      );
    }
  }
}
