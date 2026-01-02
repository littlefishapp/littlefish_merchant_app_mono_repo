import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../tools/converters/iso_date_time_converter.dart';
import '../shared/firebase_document_model.dart';
import '../user/user.dart';

part 'store_user.g.dart';

@JsonSerializable(explicitToJson: true)
@DateTimeConverter()
class StoreUser extends FirebaseDocumentModel {
  StoreUser({
    this.id,
    this.businessId,
    this.displayName,
    this.email,
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.role,
    this.uid,
    this.userName,
    this.profileImageUrl,
    this.bio,
  });

  StoreUser.fromUser(User user, {String this.role = 'owner'}) {
    id = user.id;
    uid = user.userId;
    userName = user.username;
    email = user.email;
    mobileNumber = user.mobileNumber;
    profileImageUrl = user.profileImageUri;
    firstName = user.firstName;
    lastName = user.lastName;
    displayName = user.displayName;
    dateCreated = DateTime.now();
  }

  String? businessId;

  String? id;

  String? uid;

  String? userName;

  String? email;

  String? mobileNumber;

  String? profileImageUrl;

  String? firstName;

  String? lastName;

  String? displayName;

  String? role;

  String? bio;

  DateTime? dateCreated;

  factory StoreUser.fromDocumentSnapshot(
    DocumentSnapshot snapshot, {
    DocumentReference? reference,
  }) => _$StoreUserFromJson(snapshot.data() as Map<String, dynamic>)
    ..documentSnapshot = snapshot
    ..documentReference = reference;

  factory StoreUser.fromJson(Map<String, dynamic> json) =>
      _$StoreUserFromJson(json);

  Map<String, dynamic> toJson() => _$StoreUserToJson(this);
}

@JsonSerializable()
@EpochDateTimeConverter()
class StoreUserInvite {
  String? email, firstName, lastName;
  String? mobileNumber;
  String? storeId, storeName;
  String? role;
  String? inviteCode;
  DateTime? dateSent;
  String? inviterName, inviterEmail, inviterId;

  StoreUserInvite({
    this.email,
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.role,
    this.inviteCode,
    this.dateSent,
  });

  StoreUserInvite.fromStore(store) {
    var ss = store;
    storeId = ss.storeState.store.businessId;
    storeName = ss.storeState.store.displayName;
    inviterEmail = ss.firebaseUser.email;
    inviterId = ss.firebaseUser.uid;
    inviterName = ss.userProfile.displayName;
  }

  factory StoreUserInvite.fromJson(Map<String, dynamic> json) =>
      _$StoreUserInviteFromJson(json);

  Map<String, dynamic> toJson() => _$StoreUserInviteToJson(this);
}

@JsonSerializable()
class RequestVerification {
  bool? verifyEmail, verifyNumber;

  RequestVerification({this.verifyEmail, this.verifyNumber});

  factory RequestVerification.fromJson(Map<String, dynamic> json) =>
      _$RequestVerificationFromJson(json);

  Map<String, dynamic> toJson() => _$RequestVerificationToJson(this);
}

@JsonSerializable()
class OTPRequest {
  String? requestId, emailOTP, numberOTP;
  bool? verifyEmail, verifyNumber;

  OTPRequest({
    this.requestId,
    this.emailOTP,
    this.numberOTP,
    this.verifyEmail,
    this.verifyNumber,
  });

  factory OTPRequest.fromJson(Map<String, dynamic> json) =>
      _$OTPRequestFromJson(json);

  Map<String, dynamic> toJson() => _$OTPRequestToJson(this);
}
