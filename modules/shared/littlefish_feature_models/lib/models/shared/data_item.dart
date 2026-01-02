import 'package:flutter/foundation.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

@IsoDateTimeConverter()
abstract class DataItem extends ChangeNotifier {
  DataItem({
    this.id,
    this.displayName,
    this.name,
    this.description,
    this.createdBy,
    this.status,
    this.dateCreated,
    this.dateUpdated,
    this.itemSequence,
  });

  String? id, name, displayName, description, createdBy, status;
  DateTime? dateCreated, dateUpdated;
  int? itemSequence;

  bool? validate();
}
