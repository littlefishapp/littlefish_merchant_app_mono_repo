import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/dropdown_form_field.dart';

class TradingHourTile extends StatefulWidget {
  final bool isInitiallySelected;
  final TimeOfDay openingTime;
  final TimeOfDay closingTime;
  final ValueChanged<TimeOfDay?> onOpeningTimeChanged;
  final ValueChanged<TimeOfDay?> onClosingTimeChanged;
  final ValueChanged<bool> onDaySelectedChanged;
  final String dayName;
  final EdgeInsetsGeometry dropDownFieldsPadding;

  const TradingHourTile({
    Key? key,
    required this.dayName,
    required this.onOpeningTimeChanged,
    required this.onClosingTimeChanged,
    required this.onDaySelectedChanged,
    this.openingTime = const TimeOfDay(hour: 8, minute: 0),
    this.closingTime = const TimeOfDay(hour: 16, minute: 0),
    this.isInitiallySelected = false,
    this.dropDownFieldsPadding = const EdgeInsets.only(left: 54),
  }) : super(key: key);

  @override
  State<TradingHourTile> createState() => _TradingHourTileState();
}

class _TradingHourTileState extends State<TradingHourTile> {
  late bool _isSelected;
  late TimeOfDay _openingTime;
  late TimeOfDay _closingTime;
  final GlobalKey _dayNameKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isInitiallySelected;
    _openingTime = widget.openingTime;
    _closingTime = widget.closingTime;
  }

  @override
  Widget build(BuildContext context) {
    final checkedColor = Theme.of(
      context,
    ).extension<AppliedTextIcon>()?.secondary;
    return Column(
      children: [
        CheckboxListTile(
          value: _isSelected,
          title: dayNameText(widget.dayName),
          contentPadding: EdgeInsets.zero,
          activeColor: checkedColor,
          tileColor: Colors.transparent,
          checkColor: Colors.white,
          onChanged: (bool? value) {
            if (value != null) {
              widget.onDaySelectedChanged(value);
              setState(() {
                _isSelected = value;
              });
            }
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
        Visibility(
          visible: _isSelected,
          child: Container(
            padding: widget.dropDownFieldsPadding,
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(child: openingHoursDropDownField()),
                  const SizedBox(width: 16),
                  Expanded(child: closingHoursDropDownField()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget dayNameText(String dayName) {
    return Container(
      key: _dayNameKey,
      child: context.paragraphMedium(
        dayName,
        alignLeft: true,
        color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
        isSemiBold: true,
      ),
    );
  }

  List<DropDownValue> _getTimeDropDownValues() {
    List<DropDownValue> values = [];
    for (int hour = 0; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 15) {
        values.add(
          DropDownValue(
            index: values.length,
            displayValue:
                '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
            value: TimeOfDay(hour: hour, minute: minute),
          ),
        );
      }
    }
    return values;
  }

  Widget openingHoursDropDownField() => buildDropDownField(
    'Opening Time',
    _openingTime,
    widget.onOpeningTimeChanged,
  );

  Widget closingHoursDropDownField() => buildDropDownField(
    'Closing Time',
    _closingTime,
    widget.onClosingTimeChanged,
  );

  Widget buildDropDownField(
    String label,
    TimeOfDay time,
    void Function(TimeOfDay) onChanged,
  ) {
    return DropdownFormField(
      isRequired: true,
      hintText: label,
      labelText: label,
      useOutlineStyling: true,
      key: UniqueKey(),
      values: _getTimeDropDownValues(),
      initialValue: time,
      onSaveValue: (value) {
        if (value is DropDownValue) {
          onChanged(value.value as TimeOfDay);
        }
      },
      onFieldSubmitted: (value) {
        if (value is DropDownValue) {
          onChanged(value.value as TimeOfDay);
        }
      },
      onChanged: (value) {
        if (value is DropDownValue) {
          onChanged(value.value as TimeOfDay);
        }
      },
    );
  }
}
