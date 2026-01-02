import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../../tools/converters/iso_date_time_converter.dart';
import '../shared/firebase_document_model.dart';
import '../user/user.dart';
import 'store.dart';
import 'store_customer.dart';

part 'store_business_customer.g.dart';

@JsonSerializable()
@EpochDateTimeConverter()
class StoreBusinessCustomer extends FirebaseDocumentModel {
  StoreBusinessCustomer({
    this.averagePurchaseValue,
    this.businessId,
    this.email,
    this.mobileNumber,
    this.note,
    this.ranking,
    this.totalPurchaseCount,
    this.totalPurchases,
    this.lastPurchaseDate,
    this.deleted,
    this.dateCreated,
    this.processedBy,
    this.customerId,
  });

  StoreBusinessCustomer.fromBusiness(Store store, {User? user}) {
    displayName = store.displayName;
    mobileNumber =
        store.contactInformation?.mobileNumber ??
        store.contactInformation?.telephoneNumber;
    email = store.contactInformation?.email;
    deleted = false;

    if (user != null) processedBy = StoreCustomer.fromUser(user);
  }

  StoreBusinessCustomer.defaults() {
    customerId = const Uuid().v4();
    deleted = false;
  }

  String? displayName;

  String? businessId, customerId;

  String? note;

  String? email;

  String? mobileNumber;

  @JsonKey(defaultValue: false)
  bool? deleted;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? isSelected;

  double? totalPurchases;

  double? totalPurchaseCount;

  DateTime? lastPurchaseDate;

  DateTime? dateCreated;

  StoreCustomer? processedBy;

  double? averagePurchaseValue;

  StoreCustomerRanking? ranking;

  factory StoreBusinessCustomer.fromJson(Map<String, dynamic> json) =>
      _$StoreBusinessCustomerFromJson(json);

  Map<String, dynamic> toJson() => _$StoreBusinessCustomerToJson(this);

  factory StoreBusinessCustomer.fromDocumentSnapshot(
    DocumentSnapshot snapshot, {
    DocumentReference? reference,
  }) => _$StoreBusinessCustomerFromJson(snapshot.data() as Map<String, dynamic>)
    ..documentSnapshot = snapshot
    ..documentReference = reference;

  // @JsonKey(includeFromJson: false, includeToJson: false)
  // CollectionReference get customerListsCollection =>
  //     this.documentReference?.collection('customer_lists');
}
