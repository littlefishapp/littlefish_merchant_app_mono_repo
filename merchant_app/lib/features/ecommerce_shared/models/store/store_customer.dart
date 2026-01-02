import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../../tools/converters/iso_date_time_converter.dart';
import '../shared/firebase_document_model.dart';
import '../user/user.dart';

part 'store_customer.g.dart';

@JsonSerializable()
@EpochDateTimeConverter()
class StoreCustomer extends FirebaseDocumentModel {
  StoreCustomer({
    this.averagePurchaseValue,
    this.businessId,
    this.customerId,
    this.email,
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.note,
    this.ranking,
    this.totalPurchaseCount,
    this.totalPurchases,
    this.uid,
    this.lastPurchaseDate,
    this.deleted,
    this.dateCreated,
    this.emails,
    this.jobTitle,
    this.phones,
    this.prefix,
    this.suffix,
  });

  StoreCustomer.fromContact(contact) {
    displayName = contact.displayName;
    firstName = contact.givenName;
    lastName = contact.familyName;

    suffix = contact.suffix;

    mobileNumber = contact.phones.isEmpty ? null : contact.phones.first.value;

    email = contact.emails.isEmpty ? null : contact.emails.first.value;

    phones = contact.phones
        ?.map((e) => {'label': e.label, 'value': e.value})
        ?.toList();

    emails = contact.emails
        ?.map((e) => {'label': e.label, 'value': e.value})
        ?.toList();

    customerId = const Uuid().v4();
    deleted = false;
    dateCreated = DateTime.now();
  }

  StoreCustomer.fromUser(User user) {
    firstName = user.firstName;
    lastName = user.lastName;
    mobileNumber = user.mobileNumber;
    email = user.email;
    customerId = user.id;
    uid = user.userId;
    deleted = false;
  }

  StoreCustomer.defaults() {
    customerId = const Uuid().v4();
    deleted = false;
  }

  String? displayName;

  String? businessId;

  String? customerId;

  //if this is a user of LF market this will be populated
  String? uid;

  String? note;

  String? email;

  String? prefix;

  String? suffix;

  String? jobTitle;

  List<Map<String, dynamic>>? emails;

  String? mobileNumber;

  List<Map<String, dynamic>>? phones;

  String? firstName;

  @JsonKey(defaultValue: false)
  bool? deleted;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? isSelected;

  String? lastName;

  double? totalPurchases;

  double? totalPurchaseCount;

  DateTime? lastPurchaseDate;

  DateTime? dateCreated;

  double? averagePurchaseValue;

  StoreCustomerRanking? ranking;

  factory StoreCustomer.fromJson(Map<String, dynamic> json) =>
      _$StoreCustomerFromJson(json);

  Map<String, dynamic> toJson() => _$StoreCustomerToJson(this);

  factory StoreCustomer.fromDocumentSnapshot(
    DocumentSnapshot snapshot, {
    DocumentReference? reference,
  }) => _$StoreCustomerFromJson(snapshot.data() as Map<String, dynamic>)
    ..documentSnapshot = snapshot
    ..documentReference = reference;

  @JsonKey(includeFromJson: false, includeToJson: false)
  CollectionReference? get customerListsCollection =>
      documentReference?.collection('customer_lists');
}

enum StoreCustomerRanking { starter, visitor, regular, ambassador }

@JsonSerializable()
@IsoDateTimeConverter()
class CustomerList extends FirebaseDocumentModel {
  DateTime? dateCreated;
  String? id, name, displayName, searchName, description;
  bool? deleted;

  @JsonKey(defaultValue: 0)
  int? totalCustomers;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<CustomerListLink>? selectedCustomers;

  CustomerList({
    this.id,
    this.name,
    this.displayName,
    this.dateCreated,
    this.description,
    this.searchName,
    this.totalCustomers,
    this.deleted,
  });

  CustomerList.defaults() {
    selectedCustomers = <CustomerListLink>[];
    totalCustomers = 0;
    dateCreated = DateTime.now();
    deleted = false;
    id = const Uuid().v4();
  }

  factory CustomerList.fromDocumentSnapshot(
    DocumentSnapshot snapshot, {
    DocumentReference? reference,
  }) => _$CustomerListFromJson(snapshot.data() as Map<String, dynamic>)
    ..documentSnapshot = snapshot
    ..documentReference = reference;

  factory CustomerList.fromJson(Map<String, dynamic> json) =>
      _$CustomerListFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerListToJson(this);

  @JsonKey(includeFromJson: false, includeToJson: false)
  CollectionReference? get customerListsLinkCollection =>
      documentReference?.collection('customer_links');
}

@JsonSerializable()
@IsoDateTimeConverter()
class CustomerListLink extends FirebaseDocumentModel {
  String? customerId, listId, displayName;
  DateTime? dateCreated;

  CustomerListLink({
    this.customerId,
    this.listId,
    this.displayName,
    this.dateCreated,
  });

  CustomerListLink.fromCustomer(StoreCustomer customer, String this.listId) {
    customerId = customer.customerId;
    displayName = '${customer.firstName} ${customer.lastName}';
    dateCreated = DateTime.now();
  }

  factory CustomerListLink.fromDocumentSnapshot(
    DocumentSnapshot snapshot, {
    DocumentReference? reference,
  }) => _$CustomerListLinkFromJson(snapshot.data() as Map<String, dynamic>)
    ..documentSnapshot = snapshot
    ..documentReference = reference;

  factory CustomerListLink.fromJson(Map<String, dynamic> json) =>
      _$CustomerListLinkFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerListLinkToJson(this);

  @JsonKey(includeFromJson: false, includeToJson: false)
  CollectionReference? get customerListsCollection =>
      documentReference?.collection('customer_links');
}
