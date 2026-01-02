// flutter imports
import 'package:flutter/material.dart';

// project imports
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/date_select_form_field.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';

class DateRangeFilter extends StatelessWidget {
  final void Function(DateTime startDate) onSaveStartDate;
  final void Function(DateTime endDate) onSaveEndDate;
  final String? _title;
  final bool _enableTitle;
  final DateTime? initialStartDate, initialEndDate;
  final DateTime _firstDate, _lastDate;

  DateRangeFilter({
    super.key,
    required this.onSaveStartDate,
    required this.onSaveEndDate,
    String? title,
    bool enableTitle = true,
    DateTime? lastDate,
    this.initialStartDate,
    this.initialEndDate,
    DateTime? firstDate,
  }) : _lastDate =
           lastDate ?? DateTime.now().add(const Duration(days: 12 * 365)),
       _firstDate = firstDate ?? DateTime(2000, 1, 1),
       _title = title,
       _enableTitle = enableTitle,
       assert(
         !enableTitle || title != null,
         'If title is enabled, please provide one.',
       );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_enableTitle) _titleText(context),
        _startDate(context),
        _endDate(context),
      ],
    );
  }

  Widget _titleText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: context.labelLarge(_title!, isBold: true),
      ),
    );
  }

  Widget _startDate(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: DateSelectFormField(
        key: const Key('start-date'),
        isRequired: false,
        onFieldSubmitted: (dateTime) => onSaveStartDate(dateTime),
        onSaveValue: (dateTime) => onSaveStartDate(dateTime),
        hintText: 'Select start date',
        labelText: 'Select start date',
        useOutlineStyling: true,
        firstDate: _firstDate,
        lastDate: _lastDate,
        initialDate: initialStartDate ?? DateTime.now(),
        initialValue: initialStartDate != null
            ? TextFormatter.toShortDate(dateTime: initialStartDate)
            : null,
        prefixIcon: Icons.calendar_month_outlined,
        suffixIcon: Icons.keyboard_arrow_down,
        isDense: true,
        fillColor: Colors.transparent,
        enableBorder: context.inputBorderEnabled().copyWith(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          ),
        ),
        focusBorder: context.inputBorderFocus().copyWith(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          ),
        ),
      ),
    );
  }

  Widget _endDate(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: DateSelectFormField(
        key: const Key('end-date'),
        isRequired: false,
        onFieldSubmitted: (dateTime) => onSaveEndDate(dateTime),
        onSaveValue: (dateTime) => onSaveEndDate(dateTime),
        hintText: 'Select end date',
        labelText: 'Select end date',
        useOutlineStyling: true,
        firstDate: _firstDate,
        lastDate: _lastDate,
        initialDate:
            initialEndDate ?? DateTime.now().add(const Duration(days: 1)),
        initialValue: initialEndDate != null
            ? TextFormatter.toShortDate(dateTime: initialEndDate)
            : null,
        prefixIcon: Icons.calendar_month_outlined,
        suffixIcon: Icons.keyboard_arrow_down,
        isDense: true,
        fillColor: Colors.transparent,
        enableBorder: context.inputBorderEnabled().copyWith(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          ),
        ),
        focusBorder: context.inputBorderFocus().copyWith(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          ),
        ),
      ),
    );
  }
}
