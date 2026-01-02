// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/models/reports/report_date_range.dart';

import '../../../../common/presentaion/components/icons/delete_icon.dart';

class DateSeriesBar extends StatefulWidget {
  const DateSeriesBar({
    Key? key,
    required this.compareDates,
    this.dateRangeSelectorHandler,
    this.onSeriesDeleted,
  }) : super(key: key);

  final List<ReportDateRange> compareDates;
  final Function? dateRangeSelectorHandler;
  final Function? onSeriesDeleted;

  @override
  State<DateSeriesBar> createState() => _DateSeriesBarState();
}

class _DateSeriesBarState extends State<DateSeriesBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.compareDates.length + 1,
          separatorBuilder: (context, index) {
            return const SizedBox(width: 8);
          },
          itemBuilder: (context, i) {
            return widget.compareDates.length == i
                ? addDateCard(i)
                : dateSelectorCard(i);
          },
        ),
      ),
    );
  }

  InkWell addDateCard(int index) => InkWell(
    splashColor: Colors.grey,
    onTap: () async {
      widget.dateRangeSelectorHandler!(index, false);
    },
    child: Container(
      width: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Icon(Icons.add, color: Colors.white),
    ),
  );

  Stack dateSelectorCard(int index) => Stack(
    children: [
      Container(
        width: 200,
        margin: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        // margin: EdgeInsets.only(left: 15),
        child: MaterialButton(
          child: Text(
            widget.compareDates[index].seriesName!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          onPressed: () async {
            widget.dateRangeSelectorHandler!(index, true);
          },
        ),
      ),
      InkWell(
        onTap: () {
          widget.onSeriesDeleted!(index);
        },
        child: Container(
          width: 24,
          height: 24,
          margin: const EdgeInsets.only(top: 12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Theme.of(context).colorScheme.primary,
            ),
            // radius: 48,
            child: const DeleteIcon(),
          ),
        ),
      ),
    ],
  );
}
