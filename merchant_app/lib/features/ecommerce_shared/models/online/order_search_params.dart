import 'package:quiver/strings.dart';

class OrderSearchParams {
  OrderSearchParams({
    this.customerName,
    this.endDate,
    this.startDate,
    this.statusFilters,
  });

  String? customerName;

  List<String?>? statusFilters;

  DateTime? startDate, endDate;

  bool get hasSearchValues =>
      isNotBlank(customerName) ||
      (statusFilters?.isNotEmpty ?? false) ||
      startDate != null ||
      endDate != null;
}
