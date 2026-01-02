// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/enums.dart' as enums;
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/reports/report_date_range.dart';
import 'package:littlefish_merchant/ui/analysis/bq_reports/viewmodels/date_range_selector_viewmodel.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';

import '../../../../common/presentaion/components/custom_app_bar.dart';

class DateRangeSelector extends StatefulWidget {
  const DateRangeSelector({Key? key, this.startDate, this.endDate, this.index})
    : super(key: key);

  static const String route = 'bq/reporting/date-selector';

  final DateTime? startDate;
  final DateTime? endDate;
  final int? index;

  @override
  State<DateRangeSelector> createState() => _DateRangeSelectorState();
}

class _DateRangeSelectorState extends State<DateRangeSelector> {
  DateTime? startDate;
  DateTime? endDate;
  int? index;
  Map<String, ReportMode> reportModes = {
    'Today': enums.ReportMode.day,
    'Yesterday': enums.ReportMode.prevDay,
    'This Week': enums.ReportMode.week,
    'Last Week': enums.ReportMode.prevWeek,
    'This Month': enums.ReportMode.month,
    'Last Month': enums.ReportMode.prevMonth,
    'This Year': enums.ReportMode.year,
    'Last Year': enums.ReportMode.prevYear,
  };

  late DateRangeSelectorVM vm;

  _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    vm = DateRangeSelectorVM.fromStore(AppVariables.store!)
      ..onReportLoaded = () {
        _rebuild();
      };

    if (widget.endDate != null) {
      vm.setEndDate(widget.endDate.toString(), null);
    }

    if (widget.startDate != null) {
      vm.setStartDate(widget.startDate.toString(), null);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Date Selector',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      persistentFooterButtons: [
        SizedBox(
          height: 48,
          child: ButtonPrimary(
            text: 'Run Report',
            buttonColor: Theme.of(context).colorScheme.secondary,
            onTap: (ctx) {
              _sendBackData(context, null, vm.mode, false);
            },
          ),
        ),
      ],
      // hasDrawer: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              // shrinkWrap: true,
              // scrollDirection: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                datePicker(
                  dateString: 'Start Date',
                  initialValue: vm.startDate,
                  onChanged: (val, reportMode) {
                    vm.setStartDate(val, null);
                    if (widget.endDate == null) {
                      vm.setEndDate(val, null);
                    }
                  },
                ),
                datePicker(
                  dateString: 'End Date',
                  initialValue: vm.endDate,
                  onChanged: (endDate, reportMode) {
                    vm.setEndDate(endDate, reportMode);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 8),
              Text(
                'Quick Actions'.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
              // crossAxisSpacing: 2,
              mainAxisSpacing: 15,
            ),
            children: reportModes.entries
                .map((e) => presetDateRangeButton(context, e.key, e.value, vm))
                .toList(),
          ),
        ],
      ),
    );
  }

  SizedBox datePicker({
    required String dateString,
    required DateTime initialValue,
    required Function(String date, ReportMode? mode) onChanged,
  }) => SizedBox(
    height: 48,
    width: (MediaQuery.of(context).size.width / 2) - 40,
    // TODO(lampian): implement new date picker
    // child: DateTimePicker(
    //   // style: TextStyle(
    //   // fontSize: 20,
    //   // fontFamily: Theme.of(context).textTheme.displaySmall!.fontFamily,
    //   // ),

    //   type: DateTimePickerType.date,
    //   calendarTitle: "$dateString Selection",
    //   initialDate: initialValue,
    //   initialValue: widget.index == null
    //       ? null
    //       : initialValue.add(new Duration(days: 1)).toString(),
    //   firstDate: DateTime(2000),
    //   lastDate: DateTime(2100),
    //   dateLabelText: dateString,
    //   onChanged: (val) {
    //     // debugPrint(val);
    //     onChanged(val, null);
    //     // debugPrint(vm.endDate);
    //   },
    // ),
  );

  void _sendBackData(
    BuildContext context,
    String? seriesName,
    enums.ReportMode? reportMode,
    bool? isDeleted,
  ) {
    ReportDateRange dateRange = ReportDateRange(
      seriesName: seriesName ?? vm.dateSelectionString,
      seriesNo: widget.index,
      mode: reportMode,
      startDate: vm.startDate.toUtc().toString(),
      endDate: vm.endDate.toUtc().toString(),
      isDeleted: isDeleted,
    );
    Navigator.pop(context, dateRange);
  }

  String currentDate = DateTime.now().toString();

  Widget presetDateRangeButton(
    context,
    String text,
    enums.ReportMode mode,
    DateRangeSelectorVM vm,
  ) {
    return Container(
      height: 48,
      width: (MediaQuery.of(context).size.width / 3),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ButtonPrimary(
        buttonColor: Colors.white,
        textColor: Theme.of(context).colorScheme.secondary,
        text: text,
        onTap: (ctx) {
          vm.setStartDate(currentDate, mode);
          vm.setEndDate(currentDate, mode);
          debugPrint(vm.startDate.toString());
          debugPrint(vm.endDate.toString());
          _sendBackData(context, text, vm.mode, false);
        },
      ),
    );
  }
}
