// Package imports:
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:littlefish_merchant/models/security/user/user_profile.dart';
import 'package:littlefish_merchant/models/shared/data/address.dart';
import 'package:littlefish_merchant/models/shared/simple_data_item.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'employee.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class Employee extends BusinessDataItem {
  Employee({
    this.dateOfBirth,
    this.dateOfEmployment,
    this.email,
    this.firstName,
    this.gender,
    this.id,
    this.identityNumber,
    this.lastName,
    this.primaryMobile,
    this.secondaryMobile,
    this.title,
    this.address,
    this.dateOfTermination,
    this.jobTitle,
    this.isNew = false,
    this.newID,
  });

  Employee.create() {
    id = const Uuid().v4();
    enabled = true;
    deleted = false;
    dateCreated = DateTime.now().toUtc();
    status = 'new';
    isNew = true;
    address = Address();
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? isNew;

  @override
  // removed ignore: overridden_fields
  String? id;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? newID;

  String? title, firstName, lastName;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  String get displayName {
    var displayTitle = (title != null && title!.isNotEmpty) ? '$title. ' : '';

    return "$displayTitle${firstName ?? ""}${(lastName == null || lastName!.isEmpty) ? "" : " $lastName"}";
  }

  String? identityNumber;

  @JsonKey(name: 'doe')
  DateTime? dateOfEmployment;

  @JsonKey(name: 'dob')
  DateTime? dateOfBirth;

  @JsonKey(name: 'dot')
  DateTime? dateOfTermination;

  Gender? gender;

  String? email;

  String? jobTitle;

  String? primaryMobile, secondaryMobile;

  Address? address;

  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json)..newID = json['id'];

  Map<String, dynamic> toJson() => _$EmployeeToJson(this);
}
