import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

@IsoDateTimeConverter()
abstract class SimpleDataItem extends ChangeNotifier {
  String? id, name, description, status;
  DateTime? dateCreated;

  SimpleDataItem({
    this.dateCreated,
    this.description,
    this.id,
    this.name,
    this.status,
  });
}

@IsoDateTimeConverter()
abstract class BusinessDataItem {
  String? id, name, description, status, businessId;
  String? displayName;
  String? deviceName;
  DateTime? dateCreated, dateUpdated;
  String? createdBy, updatedBy;
  int? indexNo;
  bool? deleted;
  bool? enabled;
  BusinessDataItem({
    this.businessId,
    this.createdBy,
    this.dateCreated,
    this.dateUpdated,
    this.deleted,
    this.description,
    this.id,
    this.name,
    this.displayName,
    this.status,
    this.updatedBy,
    this.enabled,
    this.indexNo = 0,
  }) {
    deviceName = Platform.localHostname;
  }
}

@IsoDateTimeConverter()
abstract class TimeStampedEntity {
  TimeStampedEntity({
    this.createdBy,
    this.updatedBy,
    this.dateCreated,
    this.dateUpdated,
    this.deleted,
    this.id,
  });

  String? id;

  DateTime? dateCreated, dateUpdated;

  String? createdBy, updatedBy;

  bool? deleted;
}
