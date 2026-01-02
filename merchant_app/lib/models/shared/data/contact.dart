// Flutter imports:

// Package imports
import 'package:fast_contacts/fast_contacts.dart' as contact_service;
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'contact.g.dart';

@JsonSerializable()
class Contact {
  String? id;

  String? name;

  String? lastName;

  String? title;

  List<ContactDetail>? contactDetails;

  Contact(this.contactDetails, this.id, this.lastName, this.name, this.title);

  Contact.create() {
    id = const Uuid().v4();
    contactDetails = [];
  }

  Contact.fromContact(contact_service.Contact contact) {
    id = const Uuid().v4();
    name = contact.structuredName?.givenName;
    lastName = contact.structuredName?.familyName;
    title = contact.structuredName?.namePrefix;

    contactDetails = [];
    contact.phones.forEach((p) {
      contactDetails!.add(
        ContactDetail(
          isPrimary: contactDetails!.isEmpty,
          label: p.label,
          value: p.number,
          isEmail: false,
        ),
      );
    });

    contact.emails.forEach((p) {
      contactDetails!.add(
        ContactDetail(
          isPrimary: contactDetails!.isEmpty,
          label: p.label,
          value: p.address,
          isEmail: true,
        ),
      );
    });
  }

  addContact({
    bool isPrimary = false,
    String label = 'mobile',
    required String value,
  }) {
    if (contactDetails == null || contactDetails!.isEmpty) {
      contactDetails = [
        ContactDetail(isPrimary: true, label: label, value: value),
      ];
    } else {
      contactDetails!.add(
        ContactDetail(isPrimary: isPrimary, label: label, value: value),
      );
    }
  }

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);

  Map<String, dynamic> toJson() => _$ContactToJson(this);
}

@JsonSerializable()
class ContactDetail {
  bool? isPrimary;

  String? label;

  String? value;

  bool? isEmail;

  ContactDetail({this.isPrimary, this.label, this.value, this.isEmail});

  factory ContactDetail.fromJson(Map<String, dynamic> json) =>
      _$ContactDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ContactDetailToJson(this);
}
