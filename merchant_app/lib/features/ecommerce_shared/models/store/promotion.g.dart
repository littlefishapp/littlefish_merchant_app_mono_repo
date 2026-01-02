// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromoCountItem _$PromoCountItemFromJson(Map<String, dynamic> json) =>
    PromoCountItem(
      currentCount: (json['currentCount'] as num?)?.toInt() ?? 0,
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$PromoCountItemToJson(PromoCountItem instance) =>
    <String, dynamic>{
      'currentCount': instance.currentCount,
      'totalCount': instance.totalCount,
      'id': instance.id,
    };

Promotion _$PromotionFromJson(Map<String, dynamic> json) =>
    Promotion(
        dateRun: const EpochDateTimeConverter().fromJson(json['dateRun']),
        id: json['id'] as String?,
        message: json['message'] as String?,
        title: json['title'] as String?,
        type: _$JsonConverterFromJson<String, PromotionType?>(
          json['type'],
          const PromotionTypeConverter().fromJson,
        ),
        createdBy: json['createdBy'] as String?,
        duration: (json['duration'] as num?)?.toInt(),
        imageUrl: json['imageUrl'] as String?,
        startDate: const EpochDateTimeConverter().fromJson(json['startDate']),
        endDate: const EpochDateTimeConverter().fromJson(json['endDate']),
        isSponsored: json['isSponsored'] as bool? ?? true,
        imageAddress: json['imageAddress'] as String?,
        audience: json['audience'] == null
            ? null
            : Audience.fromJson(json['audience'] as Map<String, dynamic>),
        data: json['data'] == null
            ? null
            : PromotionData.fromJson(json['data'] as Map<String, dynamic>),
        storeInfo: json['storeInfo'] == null
            ? null
            : StoreInfo.fromJson(json['storeInfo'] as Map<String, dynamic>),
        isCancelled: json['isCancelled'] as bool?,
        deleted: json['deleted'] as bool?,
        commStream: json['commStream'] == null
            ? null
            : CommunicationStream.fromJson(
                json['commStream'] as Map<String, dynamic>,
              ),
      )
      ..likes =
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          []
      ..totalLikes = (json['totalLikes'] as num?)?.toInt() ?? 0
      ..postViews = (json['postViews'] as num?)?.toInt() ?? 0
      ..comments =
          (json['comments'] as List<dynamic>?)
              ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          []
      ..totalComments = (json['totalComments'] as num?)?.toInt() ?? 0
      ..totalClicks = (json['totalClicks'] as num?)?.toInt() ?? 0;

Map<String, dynamic> _$PromotionToJson(Promotion instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'message': instance.message,
  'dateRun': const EpochDateTimeConverter().toJson(instance.dateRun),
  'createdBy': instance.createdBy,
  'imageUrl': instance.imageUrl,
  'imageAddress': instance.imageAddress,
  'duration': instance.duration,
  'startDate': const EpochDateTimeConverter().toJson(instance.startDate),
  'endDate': const EpochDateTimeConverter().toJson(instance.endDate),
  'audience': instance.audience?.toJson(),
  'data': instance.data?.toJson(),
  'type': const PromotionTypeConverter().toJson(instance.type),
  'isCancelled': instance.isCancelled,
  'deleted': instance.deleted,
  'storeInfo': instance.storeInfo?.toJson(),
  'commStream': instance.commStream?.toJson(),
  'likes': instance.likes,
  'totalLikes': instance.totalLikes,
  'postViews': instance.postViews,
  'comments': instance.comments?.map((e) => e.toJson()).toList(),
  'totalComments': instance.totalComments,
  'totalClicks': instance.totalClicks,
  'isSponsored': instance.isSponsored,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

PromotionData _$PromotionDataFromJson(Map<String, dynamic> json) =>
    PromotionData(
      itemId: json['itemId'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$PromotionDataToJson(PromotionData instance) =>
    <String, dynamic>{'itemId': instance.itemId, 'name': instance.name};

StoreInfo _$StoreInfoFromJson(Map<String, dynamic> json) => StoreInfo(
  logoUrl: json['logoUrl'] as String?,
  logoAddress: json['logoAddress'] as String?,
  coverUrl: json['coverUrl'] as String?,
  coverAddress: json['coverAddress'] as String?,
  primaryAddress: json['primaryAddress'] == null
      ? null
      : StoreAddress.fromJson(json['primaryAddress'] as Map<String, dynamic>),
  storeId: json['storeId'] as String?,
  storeName: json['storeName'] as String?,
);

Map<String, dynamic> _$StoreInfoToJson(StoreInfo instance) => <String, dynamic>{
  'storeId': instance.storeId,
  'storeName': instance.storeName,
  'logoUrl': instance.logoUrl,
  'logoAddress': instance.logoAddress,
  'coverUrl': instance.coverUrl,
  'coverAddress': instance.coverAddress,
  'primaryAddress': instance.primaryAddress?.toJson(),
};

Audience _$AudienceFromJson(Map<String, dynamic> json) => Audience(
  audienceType: _$JsonConverterFromJson<String, AudienceType?>(
    json['audienceType'],
    const AudienceTypeConverter().fromJson,
  ),
  users: (json['users'] as List<dynamic>?)
      ?.map((e) => PromotionUser.fromJson(e as Map<String, dynamic>))
      .toList(),
  topic: json['topic'] as String?,
  customerListId: json['customerListId'] as String?,
  customerListName: json['customerListName'] as String?,
  topicEasyName: json['topicEasyName'] as String?,
);

Map<String, dynamic> _$AudienceToJson(Audience instance) => <String, dynamic>{
  'audienceType': const AudienceTypeConverter().toJson(instance.audienceType),
  'users': instance.users?.map((e) => e.toJson()).toList(),
  'topic': instance.topic,
  'topicEasyName': instance.topicEasyName,
  'customerListName': instance.customerListName,
  'customerListId': instance.customerListId,
};

PromotionUser _$PromotionUserFromJson(Map<String, dynamic> json) =>
    PromotionUser(
      displayName: json['displayName'] as String?,
      email: json['email'] as String?,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$PromotionUserToJson(PromotionUser instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'email': instance.email,
      'id': instance.id,
    };

PromotionReport _$PromotionReportFromJson(Map<String, dynamic> json) =>
    PromotionReport(
      dateReported: const EpochDateTimeConverter().fromJson(
        json['dateReported'],
      ),
      id: json['id'] as String?,
      promotionId: json['promotionId'] as String?,
      reportedBy: json['reportedBy'] == null
          ? null
          : PromotionUser.fromJson(json['reportedBy'] as Map<String, dynamic>),
      storeInfo: json['storeInfo'] == null
          ? null
          : StoreInfo.fromJson(json['storeInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PromotionReportToJson(
  PromotionReport instance,
) => <String, dynamic>{
  'reportedBy': instance.reportedBy?.toJson(),
  'dateReported': const EpochDateTimeConverter().toJson(instance.dateReported),
  'promotionId': instance.promotionId,
  'id': instance.id,
  'storeInfo': instance.storeInfo?.toJson(),
};

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
  userId: json['userId'] as String?,
  id: json['id'] as String?,
  comment: json['comment'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  dateCreated: const EpochDateTimeConverter().fromJson(json['dateCreated']),
);

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
  'userId': instance.userId,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'id': instance.id,
  'comment': instance.comment,
  'dateCreated': const EpochDateTimeConverter().toJson(instance.dateCreated),
};
