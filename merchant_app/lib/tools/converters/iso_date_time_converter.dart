// import 'package:cloud_firestore/cloud_firestore.dart';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class IsoDateTimeConverter implements JsonConverter<DateTime?, dynamic> {
  const IsoDateTimeConverter();
  @override
  DateTime? fromJson(dynamic value) {
    if (value == null) {
      return null;
    } else if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      if (value.contains('.')) {
        value = value.substring(0, value.length - 2);
      }
      var date = DateTime.tryParse(value);
      if (date == null) {
        value = value.substring(0, value.length - 1);
        date = DateTime.tryParse(value);
      }
      var utcDate = DateTime.utc(
        date!.year,
        date.month,
        date.day,
        date.hour,
        date.minute,
        date.second,
        date.millisecond,
        date.microsecond,
      );
      return utcDate.toLocal();
    }
    return value;
  }

  @override
  String? toJson(DateTime? value) => value?.toUtc().toIso8601String();
}

class TimeOfDayConverter implements JsonConverter<TimeOfDay?, String?> {
  const TimeOfDayConverter();
  @override
  TimeOfDay? fromJson(dynamic value) {
    if (value == null) return null;

    var thisValue = value as String;

    //this is not the newly formatted string
    if (!thisValue.contains(':')) return null;

    dynamic values = value.split(':');

    return TimeOfDay(hour: toInt(values[0]), minute: toInt(values[1]));
  }

  int toInt(String? value) {
    var amt = value ?? '0';

    amt = amt.replaceAll(RegExp(r'\s\b|\b\s\t'), '');

    return double.tryParse(amt)!.floor();
  }

  @override
  String? toJson(TimeOfDay? value) =>
      value == null ? null : '${value.hour}:${value.minute}';
}

class EpochDateTimeConverter implements JsonConverter<DateTime?, dynamic> {
  const EpochDateTimeConverter();
  @override
  DateTime? fromJson(dynamic value) {
    if (value == null) return null;

    if (value is Timestamp) {
      var res = value.toDate();
      return res;
    } else if (value is String) {
      if (value.contains('.')) {
        value = value.substring(0, value.length - 2);
      }
      var date = DateTime.tryParse(value);
      if (date == null) {
        value = value.substring(0, value.length - 1);
        date = DateTime.tryParse(value);
      }
      var utcDate = DateTime.utc(
        date!.year,
        date.month,
        date.day,
        date.hour,
        date.minute,
        date.second,
        date.millisecond,
        date.microsecond,
      );
      return utcDate.toLocal();
    } else if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    return value;
  }

  @override
  int? toJson(DateTime? value) => value?.toUtc().millisecondsSinceEpoch;
}

class DateTimeConverter implements JsonConverter<DateTime?, dynamic> {
  const DateTimeConverter();
  @override
  DateTime? fromJson(dynamic value) {
    if (value == null) return null;

    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      if (value.contains('.')) {
        value = value.substring(0, value.length - 2);
      }
      var date = DateTime.tryParse(value);
      if (date == null) {
        value = value.substring(0, value.length - 1);
        date = DateTime.tryParse(value);
      }
      var utcDate = DateTime.utc(
        date!.year,
        date.month,
        date.day,
        date.hour,
        date.minute,
        date.second,
        date.millisecond,
        date.microsecond,
      );
      return utcDate.toLocal();
    }
    return value;
  }

  @override
  DateTime? toJson(DateTime? value) => value;
}
