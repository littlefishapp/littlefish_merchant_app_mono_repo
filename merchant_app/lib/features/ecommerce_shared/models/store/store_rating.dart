import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../tools/converters/iso_date_time_converter.dart';
import '../shared/firebase_document_model.dart';

part 'store_rating.g.dart';

@JsonSerializable(explicitToJson: true)
@DateTimeConverter()
class StoreRating extends FirebaseDocumentModel {
  StoreRating({
    this.businessId,
    this.comments,
    this.rating,
    this.review,
    this.reviewDate,
    this.userId,
    this.userName,
  });

  String? businessId;

  double? rating;

  String? review;

  DateTime? reviewDate;

  String? userId;

  String? userName;

  @JsonKey(defaultValue: [])
  List<StoreRatingComment>? comments;

  factory StoreRating.fromDocumentSnapshot(
    DocumentSnapshot snapshot, {
    DocumentReference? reference,
  }) => _$StoreRatingFromJson(snapshot.data() as Map<String, dynamic>)
    ..documentSnapshot = snapshot
    ..documentReference = reference;

  factory StoreRating.fromJson(Map<String, dynamic> json) =>
      _$StoreRatingFromJson(json);

  Map<String, dynamic> toJson() => _$StoreRatingToJson(this);
}

@JsonSerializable()
@DateTimeConverter()
class StoreRatingComment {
  StoreRatingComment({
    this.comment,
    this.commentDate,
    this.userId,
    this.userName,
  });

  String? comment;

  String? userId;

  String? userName;

  DateTime? commentDate;

  factory StoreRatingComment.fromJson(Map<String, dynamic> json) =>
      _$StoreRatingCommentFromJson(json);

  Map<String, dynamic> toJson() => _$StoreRatingCommentToJson(this);
}
