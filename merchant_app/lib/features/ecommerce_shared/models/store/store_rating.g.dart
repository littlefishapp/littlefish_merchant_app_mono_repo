// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreRating _$StoreRatingFromJson(Map<String, dynamic> json) => StoreRating(
  businessId: json['businessId'] as String?,
  comments:
      (json['comments'] as List<dynamic>?)
          ?.map((e) => StoreRatingComment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  rating: (json['rating'] as num?)?.toDouble(),
  review: json['review'] as String?,
  reviewDate: const DateTimeConverter().fromJson(json['reviewDate']),
  userId: json['userId'] as String?,
  userName: json['userName'] as String?,
);

Map<String, dynamic> _$StoreRatingToJson(StoreRating instance) =>
    <String, dynamic>{
      'businessId': instance.businessId,
      'rating': instance.rating,
      'review': instance.review,
      'reviewDate': const DateTimeConverter().toJson(instance.reviewDate),
      'userId': instance.userId,
      'userName': instance.userName,
      'comments': instance.comments?.map((e) => e.toJson()).toList(),
    };

StoreRatingComment _$StoreRatingCommentFromJson(Map<String, dynamic> json) =>
    StoreRatingComment(
      comment: json['comment'] as String?,
      commentDate: const DateTimeConverter().fromJson(json['commentDate']),
      userId: json['userId'] as String?,
      userName: json['userName'] as String?,
    );

Map<String, dynamic> _$StoreRatingCommentToJson(StoreRatingComment instance) =>
    <String, dynamic>{
      'comment': instance.comment,
      'userId': instance.userId,
      'userName': instance.userName,
      'commentDate': const DateTimeConverter().toJson(instance.commentDate),
    };
